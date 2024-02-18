#!/bin/bash

enableTerminal=false

while getopts "n:i:e:ht" opt; do
    case $opt in
        n)
            name=$OPTARG
            ;;
        i)
            icon=$OPTARG
            ;;
        e)
            exe=$OPTARG
            ;;
        t)
            enableTerminal=true
            ;;
        h)
            echo "Usage: $0 -n <name> -e <path/to/exec> [-i <path/to/icon>] [-t]" >&2
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ -z "$name" ] || [ -z "$exe" ]; then
    echo "Missing a required option! Please refer to help." >&2
    exit 1
fi

cd ~/.local/share/applications

touch "$name.desktop"

cat <<EOT >> "$name.desktop"
[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Exec=$exe
Icon=$icon
Terminal=$enableTerminal
EOT
