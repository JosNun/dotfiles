# Dotfiles

My collection of personal dotfiles. Mostly to aid me in bootstrapping a new 
project, but if you find something useful, great!

## Prerequisites
  - `stow` (Available in most package managers)

## Usage
```sh
  # Clone the repo 
  git clone https://github.com/josnun/dotfile 
  
  # OR, if you don't have get, you can curl or wget it as well
  # curl clone https://github.com/josnun/dotfile 
  # wget clone https://github.com/josnun/dotfile 

  # Change to the cloned directory
  cd ~/dotfiles
  
  # use Stow to set up the symlinks for the appropriate packages
  stow nvim
  stow fish
  # ...

```
