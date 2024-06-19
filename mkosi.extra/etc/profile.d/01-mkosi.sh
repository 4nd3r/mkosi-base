export DISPLAY=:0

_pulse_server="/run/user/$( id -u )/pulse/native"

if [ -S "$_pulse_server" ]
then
    export PULSE_SERVER="unix:$_pulse_server"
    set -- 'PULSE_SERVER'
fi

systemctl --user import-environment DISPLAY "$@"
