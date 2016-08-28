:: Ensure GYP(libuv) is using VS 2015
set GYP_MSVS_VERSION=2015

:: The default cpack in the PATH is not CMake
set PATH=C:\Program Files (x86)\CMake\bin\cpack.exe;%PATH%

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
:: For gperf
C:\msys64\usr\bin\bash -lc "pacman --verbose --noconfirm -Su" || goto :error
C:\msys64\usr\bin\bash -lc "pacman --verbose --noconfirm --needed -S gperf" || goto :error

mkdir .deps
cd .deps
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release ..\third-party\ || goto :error
nmake VERBOSE=1 || goto :error
cd ..

mkdir build
cd build
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUSTED_OUTPUT_TYPE=gtest -DGPERF_PRG="C:\msys64\usr\bin\gperf.exe" .. || goto error
nmake VERBOSE=1 || goto :error
bin\nvim --version || goto :error

:: Functional tests
nmake functionaltest VERBOSE=1 || goto :error

:: Build artifacts
cpack -G ZIP -C Release

goto :EOF
:error
exit /b %errorlevel%
