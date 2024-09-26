#!/bin/bash
pm2 delete all

no_build=false
no_install=false

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

if $no_build; then
    echo "Skipping build..."
else
    npm run --prefix ./slides/elixir build
fi

if $no_install; then
    echo "Skipping install..."
else
    npm ci --prefix ./slides/elixir
    npm ci --prefix ./slides/elixir/server
fi

npm run --prefix ./slides/elixir pm-start
npm run --prefix ./slides/elixir/server pm-start
