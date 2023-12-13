# sdrun
run c/c++ from sdcard in termux

## Installation
```
pkg update & pkg upgrade;
pkg install git clang cmake make;
git clone https://github.com/osartur/sdrun;
chmod +x sdrun/sdrun.sh;
mv sdrun/sdrun.sh ~/../usr/bin/sdrun;
rm -rf sdrun/
```

## Usage
```
sdrun <cmake-dir> [bin-args]
```
Note: specify the name of the executable in the first line of CMakeLists.txt via '# <binary-name>'