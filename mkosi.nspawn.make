#!/bin/sh -e

echo '[Files]'

for _ in \
    "Bind=$HOME/Desktop" \
    "Bind=$HOME/Downloads" \
    "Bind=$HOME/Repos" \
    "BindReadOnly=$HOME/.bashrc" \
    "BindReadOnly=$HOME/.local/bin" \
    "BindReadOnly=$HOME/.profile" \
    "BindReadOnly=$HOME/.tmux.conf" \
    "BindReadOnly=$HOME/.vim" \
    "BindReadOnly=$HOME/.vimrc" \
    "BindReadOnly=$HOME/Documents"
do
    if [ -e "$( echo "$_" | cut -d= -f2 )" ]
    then
        echo "$_"
    fi
done

echo ''
echo '[Exec]'
echo 'PrivateUsers=no'
