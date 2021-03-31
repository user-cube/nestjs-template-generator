#!/bin/bash

function install(){
    if [ ! -d "$DIR" ]; then
        mkdir -p ~/bin
    fi
    cp nestjs_generator.sh ~/bin/nestjs_gen
    chmod +x ~/bin/nestjs_gen
}

while getopts "p" arg; do
    case $arg in
        p)
            echo 'PATH="$HOME/bin:$PATH"' >> ~/antigen.zsh
            ;;
        \?)
            exit 0;
            ;;
    esac
done

install