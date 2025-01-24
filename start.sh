#!/bin/bash
no_build=true
no_install=true

for arg in "$@"; do
    case $arg in
        --no-build)
            no_build=true
            ;;
        --no-install)
            no_install=true
            ;;
        *)
            echo "Unknown argument: $arg"
            ;;
    esac
done

if $no_install; then
    echo "Skipping install..."
else
    npm ci --prefix ./slides
    npm ci --prefix ./slides/server
    npm install --global pm2
fi

pm2 delete all

if $no_build; then
    echo "Skipping build..."
else
    npm run --prefix ./slides build
fi

npm run --prefix ./slides pm-start
npm run --prefix ./slides/server pm-start
