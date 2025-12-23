# Makefile for testing chezmoi dotfiles across multiple distributions
#
# This Makefile provides convenient commands to test the dotfiles installation
# on different Linux distributions using Docker.

.PHONY: help all build test clean ubuntu arch fedora alpine rebuild shell-ubuntu shell-arch shell-fedora shell-alpine setup-shell-ubuntu setup-shell-arch setup-shell-fedora setup-shell-alpine

# Default target: show help
help:
	@echo "Chezmoi Dotfiles Testing"
	@echo "========================"
	@echo ""
	@echo "Usage:"
	@echo "  make all            - Test all distributions"
	@echo "  make ubuntu         - Test on Ubuntu"
	@echo "  make arch           - Test on Arch Linux"
	@echo "  make fedora         - Test on Fedora"
	@echo "  make alpine         - Test on Alpine (with Homebrew)"
	@echo "  make build          - Build all Docker images"
	@echo "  make rebuild        - Rebuild all images from scratch"
	@echo "  make clean          - Remove all containers and images"
	@echo ""
	@echo "Interactive shells:"
	@echo "  make shell-*        - Clean shell without dotfiles (e.g., make shell-ubuntu)"
	@echo "  make setup-shell-*  - Shell with dotfiles applied (e.g., make setup-shell-ubuntu)"
	@echo ""

# Test all distributions
all: test

# Build all Docker images
build:
	@echo "Building all Docker images..."
	docker-compose build

# Rebuild all images from scratch (no cache)
rebuild:
	@echo "Rebuilding all Docker images from scratch..."
	docker-compose build --no-cache

# Test all distributions
test:
	@echo "Testing all distributions..."
	@echo ""
	@FAILED=""; \
	PASSED=""; \
	for dist in ubuntu arch fedora alpine; do \
		echo "========================================"; \
		echo "Testing $$dist..."; \
		echo "========================================"; \
		if docker-compose up --build --exit-code-from $$dist $$dist 2>&1; then \
			echo "✓ $$dist: PASSED"; \
			PASSED="$$PASSED $$dist"; \
		else \
			echo "✗ $$dist: FAILED"; \
			FAILED="$$FAILED $$dist"; \
		fi; \
		docker-compose down 2>/dev/null || true; \
		echo ""; \
	done; \
	echo "========================================"; \
	echo "Test Summary"; \
	echo "========================================"; \
	if [ -n "$$PASSED" ]; then \
		echo "✓ Passed:$$PASSED"; \
	fi; \
	if [ -n "$$FAILED" ]; then \
		echo "✗ Failed:$$FAILED"; \
		exit 1; \
	else \
		echo "All tests passed!"; \
	fi

# Test Ubuntu
ubuntu:
	@echo "Testing on Ubuntu..."
	@docker-compose up --build ubuntu
	@$(MAKE) --no-print-directory clean-containers

# Test Arch Linux
arch:
	@echo "Testing on Arch Linux..."
	@docker-compose up --build arch
	@$(MAKE) --no-print-directory clean-containers

# Test Fedora
fedora:
	@echo "Testing on Fedora..."
	@docker-compose up --build fedora
	@$(MAKE) --no-print-directory clean-containers

# Test Alpine with Homebrew
alpine:
	@echo "Testing on Alpine (with Homebrew)..."
	@docker-compose up --build alpine
	@$(MAKE) --no-print-directory clean-containers

# Interactive shells for debugging
shell-ubuntu:
	@echo "Opening interactive shell in Ubuntu container..."
	@docker-compose run --rm --entrypoint /bin/bash ubuntu

shell-arch:
	@echo "Opening interactive shell in Arch container..."
	@docker-compose run --rm --entrypoint /bin/bash arch

shell-fedora:
	@echo "Opening interactive shell in Fedora container..."
	@docker-compose run --rm --entrypoint /bin/bash fedora

shell-alpine:
	@echo "Opening interactive shell in Alpine container..."
	@docker-compose run --rm --entrypoint /bin/bash alpine

# Interactive shells with dotfiles applied
setup-shell-ubuntu:
	@echo "Setting up dotfiles and opening shell in Ubuntu container..."
	@docker-compose run --rm --entrypoint /bin/bash ubuntu -c "chezmoi init --source=/dotfiles && chezmoi apply --source=/dotfiles && exec /bin/bash"

setup-shell-arch:
	@echo "Setting up dotfiles and opening shell in Arch container..."
	@docker-compose run --rm --entrypoint /bin/bash arch -c "chezmoi init --source=/dotfiles && chezmoi apply --source=/dotfiles && exec /bin/bash"

setup-shell-fedora:
	@echo "Setting up dotfiles and opening shell in Fedora container..."
	@docker-compose run --rm --entrypoint /bin/bash fedora -c "chezmoi init --source=/dotfiles && chezmoi apply --source=/dotfiles && exec /bin/bash"

setup-shell-alpine:
	@echo "Setting up dotfiles and opening shell in Alpine container..."
	@docker-compose run --rm --entrypoint /bin/bash alpine -c "chezmoi init --source=/dotfiles && chezmoi apply --source=/dotfiles && exec /bin/bash"

# Clean up containers
clean-containers:
	@echo "Cleaning up containers..."
	@docker-compose down 2>/dev/null || true

# Clean up everything (containers and images)
clean:
	@echo "Cleaning up containers and images..."
	@docker-compose down --rmi all --volumes 2>/dev/null || true
	@echo "Cleanup complete!"

# Run tests in parallel (faster but less readable output)
test-parallel:
	@echo "Testing all distributions in parallel..."
	@docker-compose up -d
	@docker-compose logs -f
	@$(MAKE) --no-print-directory clean-containers
