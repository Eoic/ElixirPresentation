#!/bin/bash
install=false

for arg in "$@"; do
    case $arg in
        --install)
            install=true
            ;;
        *)
            echo "Unknown argument: $arg"
            ;;
    esac
done

if $install; then
    npm install --prefix ./slides
    npm install --prefix ./slides/server
    npm install -g pm2
else
    echo "Skipping install..."
fi

pm2 delete all
npm run --prefix ./slides start
