:: These are native MinGW builds, but they use the toolchain inside
:: MSYS2, this allows using all the dependencies and tools available
:: in MSYS2. But we cannot build inside the MSYS2 shell, because luarocks
:: does not work in there.
echo on
if "%CONFIGURATION%" == "MINGW_32" (
  set ARCH=i686
  set BITS=32
) else (
  set ARCH=x86_64
  set BITS=64
)

:: Sanitize the PATH
:: - We cannot have sh.exe in the PATH (cmake w/mingw32-make)
:: - Avoid using the wrong versions of python/perl/cmake/cpack
set PATH=C:\Program Files\Git\cmd;C:\Python35;C:\Python27;C:\msys64\mingw%BITS%\bin;C:\Windows\System32;C:\Windows;

:: Install dependencies
C:\msys64\usr\bin\bash -lc "pacman --verbose --noconfirm -Su" || goto :error
C:\msys64\usr\bin\bash -lc "pacman --verbose --noconfirm --needed -S mingw-w64-%ARCH%-cmake mingw-w64-%ARCH%-perl mingw-w64-%ARCH%-diffutils mingw-w64-%ARCH%-unibilium gperf" || goto :error

:: Setup python
:: - use AppVeyor system python instead of msys, see python-greenlet/greenlet#20
:: - the python executable is python.exe for both v2 and v3, rename as python3.exe
:: - install the neovim python module (used in the tests)
move c:\Python35\python.exe c:\Python35\python3.exe
python  -m pip install neovim || goto :error
python  -c "import neovim; print(str(neovim))" || goto :error
python3 -m pip install neovim || goto :error
python3 -c "import neovim; print(str(neovim))" || goto :error

:: Build third-party dependencies
mkdir .deps
cd .deps
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo ..\third-party\ || goto :error
mingw32-make VERBOSE=1 || goto :error
cd ..

:: Build Neovim
mkdir build
cd build
cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUSTED_OUTPUT_TYPE=nvim -DGPERF_PRG="C:\msys64\usr\bin\gperf.exe" .. || goto :error
mingw32-make VERBOSE=1 || goto :error
bin\nvim --version || goto :error

:: Functional tests
mingw32-make functionaltest VERBOSE=1 || goto :error

:: Build artifacts
cpack -G ZIP -C RelWithDebInfo
if defined APPVEYOR_REPO_TAG_NAME cpack -G NSIS -C RelWithDebInfo

goto :EOF
:error
exit /b %errorlevel%
