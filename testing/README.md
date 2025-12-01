# Chezmoi Dotfiles Testing

This directory contains Docker-based testing infrastructure for validating the chezmoi dotfiles installation across multiple Linux distributions.

## Overview

The testing setup allows you to verify that your dotfiles and package installation scripts work correctly on:

- **Ubuntu** (apt package manager)
- **Arch Linux** (pacman package manager)
- **Fedora** (dnf package manager)
- **Alpine** (with Homebrew for cross-platform testing)

## Prerequisites

- Docker
- Docker Compose
- Make (optional, but recommended)

## Quick Start

### Test All Distributions

```bash
# Using Make (recommended)
cd testing
make all

# Using docker-compose directly
docker-compose up
```

### Test Specific Distribution

```bash
# Using Make
make ubuntu
make arch
make fedora
make alpine

# Using docker-compose
docker-compose up ubuntu
docker-compose up arch
docker-compose up fedora
docker-compose up alpine
```

## Available Make Commands

```bash
make help              # Show all available commands
make all               # Test all distributions
make build             # Build all Docker images
make rebuild           # Rebuild all images from scratch (no cache)
make clean             # Remove all containers and images
make ubuntu            # Test on Ubuntu
make arch              # Test on Arch Linux
make fedora            # Test on Fedora
make alpine            # Test on Alpine with Homebrew
make shell-ubuntu      # Clean shell without dotfiles
make setup-shell-ubuntu # Shell with dotfiles applied
# (same shell-* and setup-shell-* patterns for arch, fedora, alpine)
```

## Interactive Debugging

You have two options for interactive shells:

### Option 1: Clean Shell (without dotfiles)

Opens a fresh shell without applying dotfiles. Useful for testing the environment or manually running chezmoi commands:

```bash
make shell-ubuntu
make shell-arch
make shell-fedora
make shell-alpine

# Inside the shell, manually apply dotfiles if needed:
chezmoi init --source=/dotfiles
chezmoi apply --source=/dotfiles
```

### Option 2: Shell with Dotfiles Applied

Automatically applies your dotfiles and then drops you into a shell with all packages installed:

```bash
make setup-shell-ubuntu
make setup-shell-arch
make setup-shell-fedora
make setup-shell-alpine

# All your packages will already be installed!
```

**Note:** The difference is that `shell-*` gives you a clean environment, while `setup-shell-*` runs the full dotfiles installation first.

## How It Works

### 1. Dockerfile Structure

Each `Dockerfile.*` follows this pattern:

1. Start from a minimal base image
2. Install basic dependencies (curl, git, sudo)
3. Create a non-root test user
4. Install chezmoi
5. Set up the test entrypoint script

### 2. Test Entrypoint

The `test-entrypoint.sh` script:

1. Initializes chezmoi from the mounted dotfiles directory
2. Applies the dotfiles (which triggers package installation)
3. Verifies that all expected packages are installed
4. Reports success or failure with detailed output

### 3. Volume Mounting

The parent directory (your dotfiles repo) is mounted as `/dotfiles` in the container, allowing the test to use your actual dotfiles configuration without copying files into the image.

## Understanding Test Output

### Successful Test

```
========================================
Testing Chezmoi Dotfiles Installation
========================================

>>> Initializing chezmoi from /dotfiles
✓ Chezmoi initialized successfully

>>> Applying dotfiles (this will install packages)
=== Installing Essential Development Packages ===
...
✓ Dotfiles applied successfully

>>> Verifying installed packages
  ✓ zsh installed (zsh available)
  ✓ git installed (git available)
  ✓ neovim installed (nvim available)
  ...

========================================
✓ All packages verified successfully!
========================================
```

### Failed Test

If packages fail to install, you'll see:

```
>>> Verifying installed packages
  ✓ zsh installed (zsh available)
  ✗ lazygit NOT installed (lazygit not found)
  ...

========================================
⚠ 1 package(s) failed verification
========================================
```

## Customizing Package Lists

To add or remove packages from the installation:

1. Edit `../.chezmoi.toml.tmpl`
2. Add packages to the `data.packages.essential` array
3. Add package name mappings in `data.package_mappings.*` if needed
4. Update `test-entrypoint.sh` to verify the new packages

## Troubleshooting

### Docker Build Fails

```bash
# Rebuild from scratch
make rebuild

# Or manually
docker-compose build --no-cache
```

### Tests Hang or Time Out

Some package installations (especially on Alpine with Homebrew) can take a long time. Be patient, or check logs:

```bash
docker-compose logs -f ubuntu
```

### Permission Errors

The containers run as a non-root `testuser` with sudo access. If you encounter permission issues, check:

1. The `sudo` setup in the Dockerfile
2. Whether the package manager requires root access

### Package Not Found

If a package isn't found in a distribution's repository:

1. Check the package name mappings in `.chezmoi.toml.tmpl`
2. Verify the package exists in that distro's repos
3. Consider adding special installation logic in `run_once_install-packages.sh.tmpl`

## Architecture

```
testing/
├── Dockerfile.ubuntu       # Ubuntu/Debian test environment
├── Dockerfile.arch         # Arch Linux test environment
├── Dockerfile.fedora       # Fedora test environment
├── Dockerfile.alpine       # Alpine + Homebrew test environment
├── docker-compose.yml      # Orchestrates all test containers
├── Makefile                # Convenient test commands
├── test-entrypoint.sh      # Test script run in each container
└── README.md               # This file

Parent directory:
├── .chezmoi.toml.tmpl              # Package list and configuration
├── run_once_install-packages.sh.tmpl  # Installation script
└── [other dotfiles]
```

## CI/CD Integration

You can integrate this into your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
name: Test Dotfiles
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Test dotfiles
        run: |
          cd testing
          make all
```

## Known Limitations

1. **Alpine/Homebrew**: Building the Alpine image takes significantly longer due to Homebrew installation
2. **Network Dependencies**: Some packages (like lazygit on Ubuntu) require internet access for installation
3. **Architecture**: Tests run on amd64/x86_64 architecture only

## Contributing

When adding new package managers or distributions:

1. Create a new `Dockerfile.[distro]`
2. Add the service to `docker-compose.yml`
3. Add a Make target for the new distro
4. Update package mappings in `.chezmoi.toml.tmpl`
5. Test thoroughly!

## License

Same as the parent dotfiles repository.
