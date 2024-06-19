#!/bin/sh -e

_action="$1"
_name="$2"
_profile="$3"

_output_dst='mkosi.output'
_image_src="$_output_dst/$_name.tar"
_nspawn_src="$_output_dst/$_name.nspawn"
_nspawn_dst="/etc/systemd/nspawn/$_name.nspawn"
_service_src="$_output_dst/$_name.service"
_service_dst="/etc/systemd/system/systemd-nspawn@$_name.service.d/service.conf"

export _UID="$( id -u )"
export _USER="$USER"
export _GID="$( id -g )"
export _GROUP="$( id -gn )"
export _HOME="$HOME"

_nspawn()
{
    echo '[Files]'

    for _ in \
        "Bind=$_HOME/Desktop" \
        "Bind=$_HOME/Downloads" \
        "Bind=$_HOME/Repos" \
        'Bind=/dev/dri' \
        "BindReadOnly=$_HOME/.bashrc" \
        "BindReadOnly=$_HOME/.local/bin" \
        "BindReadOnly=$_HOME/.profile" \
        "BindReadOnly=$_HOME/.tmux.conf" \
        "BindReadOnly=$_HOME/.vim" \
        "BindReadOnly=$_HOME/.vimrc" \
        "BindReadOnly=$_HOME/Documents" \
        'BindReadOnly=/run/pcscd/pcscd.comm' \
        "BindReadOnly=/run/user/$_UID/pipewire-0" \
        "BindReadOnly=/run/user/$_UID/pulse/native" \
        'BindReadOnly=/tmp/.X11-unix'
    do
        if [ -e "$( echo "$_" | cut -d= -f2 )" ]
        then
            echo "$_"
        fi
    done

    echo ''
    echo '[Exec]'
    echo 'PrivateUsers=no'
}

_service()
{
    echo '[Service]'
    echo "ExecStartPost=-/usr/bin/find /dev -maxdepth 1 -regex '/dev/\\(hidraw\\|video\\)[0-9]+' -exec machinectl bind $_name {} --mkdir \\;"
    echo 'Restart=on-failure'
    echo 'RestartSec=3'
    echo 'DevicePolicy=auto'
    echo 'DeviceAllow='
}

if [ -n "$*" ]
then
    mkdir -p "$_output_dst"
fi

case "$_action" in
    image)
        mkosi --image-id "$_name" --profile "$_profile" -f
    ;;
    nspawn)
        _nspawn > "$_nspawn_src"
    ;;
    service)
        _service > "$_service_src"
    ;;
    install)
        if [ "$_UID" != '0' ]; then echo 'got root?' >&2; exit 1; fi
        importctl -m import-tar "$_image_src" "$_name"
        install -D -m 644 "$_nspawn_src" "$_nspawn_dst"
        install -D -m 644 "$_service_src" "$_service_dst"
        systemctl daemon-reload
        machinectl start "$_name"
    ;;
    uninstall)
        if [ "$_UID" != '0' ]; then echo 'got root?' >&2; exit 1; fi
        if machinectl status "$_name" > /dev/null 2>&1; then machinectl terminate "$_name"; sleep 3; fi
        if machinectl image-status "$_name" > /dev/null 2>&1; then machinectl remove "$_name"; fi
        rm -f "$_nspawn_dst" "$_service_dst"
        for _ in "$( dirname "$_nspawn_dst" )" "$( dirname "$_service_dst" )"; do if [ -d "$_" ]; then rmdir --ignore-fail-on-non-empty "$_"; fi; done
        systemctl daemon-reload
    ;;
esac
