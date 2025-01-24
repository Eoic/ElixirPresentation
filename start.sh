#!/bin/bash
build=false
install=false

for arg in "$@"; do
    case $arg in
        --build)
            build=true
            ;;
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

if $build; then
    npm run --prefix ./slides build
else
    echo "Skipping build..."
fi

npm run --prefix ./slides pm-start
npm run --prefix ./slides/server pm-start
