#!/usr/bin/env bash

echo "The script must be executed under root, so it will ask you for password."

if command -v apt 2>/dev/null; then
  downl=apt
elif command -v dnf 2>/dev/null; then
  downl=dnf
elif command -v yum 2>/dev/null; then
  downl=yum
fi

usrdir=`pwd | rev | cut -d'/' -f 1 | rev`

if [ "$usrdir" != "rubygame" ]; then
  echo "You're not in rubygame project. Please, go there and try again."
else
  echo "Installing dependencies. This will take a while..."
  sudo $downl update
  if [ "$downl" == "dnf" ]; then
    sudo $downl groupinstall --assumeyes "Development Tools"
    sudo $downl install --assumeyes mpg123-devel mesa-libGL-devel openal-devel
    sudo $downl install --assumeyes pango-devel SDL2_ttf-devel libsndfile-devel
    sudo $downl install --assumeyes gcc-c++ redhat-rpm-config
    echo "Installing ruby..."
    sudo $downl install --assumeyes ruby-devel rubygems
  elif [ "$downl" == "apt" ]; then
    sudo $downl install -y build-essential libsdl2-dev libsdl2-ttf-dev
    sudo $downl install -y libpango1.0-dev libgl1-mesa-dev libopenal-dev
    sudo $downl install -y libsndfile-dev libmpg123-dev libgmp-dev
    echo "Installing ruby..."
    sudo $downl install -y ruby-dev
  fi
  echo "Installing gems..."
  sudo gem install bundler
  bundle install
  sudo chmod +x rubygame
  echo "Downloading files..."
  sh downloadme.sh
  echo "Everything is done! You can now run the game with \"$ ./rubygame\"."
  echo "Any questions about this \"project\" send to fpostoleh@gmail.com"
fi
