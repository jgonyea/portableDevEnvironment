# Portable Dev Environment for PortableApps Suite
Generates a portable web dev environment for the PortableApps Suite.

## What's Included
The following are installed and configured for running off a usb drive:
* XAMPP (with php 7.1 and xdebug)
* Composer
* PHPCS
* NodeJS (6.11.3)
* Ruby (2.3.3)
* Netbeans (8.1)
* Papercut Local SMTP server (see notes below about running Papercut)


## Prerequisites
* [PA Suite](https://portableapps.com/download)
* [Git Portable](https://github.com/sheabunge/GitPortable)
* [7-Zip Portable](https://portableapps.com/apps/utilities/7-zip_portable)
* [Java and Java64 Portable](https://portableapps.com/apps/utilities/java_portable)


## Recommended, but not required
* [Firefox Portable](https://portableapps.com/apps/internet/firefox_portable)
* [Notepad++ Portable](https://portableapps.com/apps/development/notepadpp_portable)
* [WinSCP Portable](https://portableapps.com/apps/internet/winscp_portable)

## Build Process
Clone this repository to the drive you wish to install the development environment

`git clone https://github.com/jgonyea/portableDevEnvironment.git /f/Documents/dev`

where `f` is the drive letter.

In git-bash, browse to the folder and run build.sh.  There will be a confirmation for which letter is detected as the target.

The cloned repository is not needed afterwards, and the folder can be discarded.

## Running the Environment
1. Open Git Portable from the PortableApps menu.  
2. In the git bash window, type in `./startDev.sh`

The script will auto-detect your drive letter (necessary if it's changed since last time), update it in all the places, and then open Netbeans, XAMPP, and Papercut with the new paths.

## Todo
* Verify nodejs install location is reasonable.

## Notes
* Papercut isn't technically a portable app, and it will leave a couple inconsequential files behind on the host machine.
* On its first run, Git Portable may complain about a couple of mkdir permissions.  This can be ignored.  Subsequent launches will not present this error
* Opening Netbeans from the PA menu instead of the git bash window may cause the PATH variable to not have all the portable information. If 