#!/usr/bin/env bash

if is-macos; then
  if ! is-executable brew; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  brew update
  brew upgrade

  # Install packages

  apps=(
    coreutils
    ffmpeg
    findutils
    fish
    git
    git-extras
    gnu-sed
    gnu-tar
    grep
    htop
    httpie
    jq
    nano
    peco
    screen
    shellcheck
    siege
    ssh-copy-id
    tree
    unar
    watch
    wget
    zlib  # for pyenv to be able to build python versions
  )

  brew install "${apps[@]}"

  brew cleanup

  export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
  set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

  export DOTFILES_BREW_PREFIX_GNU_SED=`brew --prefix gnu-sed`
  set-config "DOTFILES_BREW_PREFIX_GNU_SED" "$DOTFILES_BREW_PREFIX_GNU_SED" "$DOTFILES_CACHE"

  export DOTFILES_BREW_PREFIX_GNU_TAR=`brew --prefix gnu-tar`
  set-config "DOTFILES_BREW_PREFIX_GNU_TAR" "$DOTFILES_BREW_PREFIX_GNU_TAR" "$DOTFILES_CACHE"

  export DOTFILES_BREW_PREFIX_GNU_GREP=`brew --prefix grep`
  set-config "DOTFILES_BREW_PREFIX_GNU_GREP" "$DOTFILES_BREW_PREFIX_GNU_GREP" "$DOTFILES_CACHE"

  export DOTFILES_BREW_PREFIX=`brew --prefix`
  set-config "DOTFILES_BREW_PREFIX" "$DOTFILES_BREW_PREFIX" "$DOTFILES_CACHE"

fi

if is-ubuntu; then

  apps_to_remove=(
    thunderbird
  )

  for app in "${apps_to_remove[@]}"; do
    sudo apt-get remove --purge --assume-yes "${app}"
  done

  apps=(
    build-essential
    ca-certificates
    coreutils
    curl
    findutils
    fish
    git
    git-extras
    grep
    htop
    httpie
    jq
    nano
    net-tools
    peco
    screen
    sed
    shellcheck
    siege
    tar
    tree
    unar
    wget

    # These packages are for pyenv to be able to build python versions
    libbz2-dev
    libffi-dev
    liblzma-dev
    libncurses5-dev
    libncursesw5-dev
    libreadline-dev
    libsqlite3-dev
    libssl-dev
    llvm
    make
    python-openssl
    tk-dev
    xz-utils
    zlib1g-dev
  )

  sudo apt-get update

  for app in "${apps[@]}"; do
    sudo apt-get --assume-yes install "${app}"
  done
fi

# pyenv
if ! [ -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
fi
export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

# Poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
