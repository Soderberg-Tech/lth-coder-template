# LTH Docker

Create a workspace by pressing the button below!

[![Open in Coder](https://coder.soderberg.tech/open-in-coder.svg)](https://coder.soderberg.tech/templates/LTH/workspace)

## Configure X11 capabilities

1. Install a X Server on your device, [X410](https://x410.dev/) is recommended.

2. Open VS Code and add two entries to the ***coder.sshConfig*** setting (restart VS Code afterwards):
   - `ForwardX11 yes`
   - `ForwardX11Trusted yes`

> You might need to input the following into a terminal on Windows: `setx DISPLAY "127.0.0.1:0.0"` if the X11 display can't be found.

## Architecture

This template provisions the following resources:

- Docker image (built by Docker socket and kept locally)
- Docker volume (persistent on `/home/{User}`)

This means, when the workspace restarts, any tools or files outside of the home directory are not persisted. To pre-bake tools into the workspace (e.g. `python3`), modify the container image.
