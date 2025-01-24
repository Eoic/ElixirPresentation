Use `start.sh` to start the presentation client and the remote controller services. The script accepts multiple optional arguments:
* `--no-install` - will not install NPM depenencies and PM2 service manager (default: `true`).
* `--no-build` - will not build the static files (default: `true`).

Presentation client: http://127.0.0.1:9000.
Presentation remote: http://127.0.0.1:9001.

Both servers are accessible over the local network. Check `ufw` rules if they are unreachable.
