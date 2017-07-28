set -eux

# cd into the project root
cd $1

ARCH=$(uname -m)

pacman --verbose --noconfirm -Su
pacman --verbose --noconfirm --needed -S mingw-w64-$ARCH-cmake mingw-w64-$ARCH-perl mingw-w64-$ARCH-diffutils\
	mingw-w64-$ARCH-unibilium mingw-w64-$ARCH-python2-pip mingw-w64-$ARCH-python3-pip gperf\
	mingw-w64-$ARCH-lua51-lpeg mingw-w64-$ARCH-lua51-bitop

# Setup python
#pip2 install neovim
#pip3 install neovim
#python2 -c "import neovim; print(str(neovim))"
#python -c "import neovim; print(str(neovim))"

# Build dependencies
mkdir .deps
cd .deps
cmake -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DUSE_BUNDLED_LUAROCKS=NO ../third-party
make VERBOSE=1
cd ..

# Build Neovim
mkdir build
cd build
cmake -G "MSYS Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUSTED_OUTPUT_TYPE=nvim -DGPERF_PRG="/C/msys64/usr/bin/gperf.exe" ..
make VERBOSE=1
bin/nvim --version

# Functional tests
make functionaltest VERBOSE=1

# Build artifacts
cpack -G ZIP -C RelWithDebInfo
#if defined APPVEYOR_REPO_TAG_NAME cpack -G NSIS -C RelWithDebInfo
