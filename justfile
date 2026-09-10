# List available recipes
default:
    @just --list

# Format and auto-fix all Nix files
fmt:
    nix-format

# Build the 02 Docker image and load it
build-02:
    nix-build ./02-creating-container-images
    docker load -i result

# Run the 03 wrapped package
run-03:
    nix run ./03-creating-and-using-wrapped-packages

# Run the 04 Linux VM (on macOS this is darwin.linux-builder)
run-04:
    nix run ./04-creating-a-linux-vm

# Enter the 05 devenv shell (starts Postgres and Redis in the background)
shell-05:
    cd {{ justfile_directory() }}/05-using-devenv && devenv up -d && devenv shell

# Start 05 processes in the background
up-05:
    cd {{ justfile_directory() }}/05-using-devenv && devenv up -d
