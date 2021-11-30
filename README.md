# DroneLink Desktop app
This repository provides the Linux Desktop application developed for the **Industry 4.0 Hackathon** included in the 5G National Plan. 


## How to use
This project was implemented in flutter so you will have to download flutter first:
### Install flutter
```bash
$ git clone https://github.com/flutter/flutter.git -b stable
```
#### Update path in your ~/.bashrc file
```bash
 export PATH="$PATH:`pwd`/flutter/bin"
```
$ sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```
### Enable desktop support
```bash
$ flutter config --enable-linux-desktop 
```
### Setup flutter 
```bash
$ flutter channel master
$ flutter pub get
$ flutter run -d linux
```
