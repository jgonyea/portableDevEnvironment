# Portable Dev Environment for PortableApps Suite

Generates a portable web dev environment for the PortableApps Suite.

## What's Inside

The following are installed and configured for running off a usb drive:

* XAMPP (with php 7.2 and xdebug)
* Composer
* PHPCS
* NodeJS
* Ruby
* Netbeans
* Microsoft VS Code

## Prerequisites

* [PA Suite](https://portableapps.com/download)
* [Git Portable](https://github.com/sheabunge/GitPortable)
  * Used to run this build script and pass PATH environment variables to apps
* [7-Zip Portable](https://portableapps.com/apps/utilities/7-zip_portable)
  * Used to extract 7z files used in this build script

## Recommended, but not required

* [Firefox Portable](https://portableapps.com/apps/internet/firefox_portable)
* [Notepad++ Portable](https://portableapps.com/apps/development/notepadpp_portable)
* [WinSCP Portable](https://portableapps.com/apps/internet/winscp_portable)

## Build Process

Use Git Portable to clone the existing repo to the drive you wish to install the development environment

`git clone https://github.com/jgonyea/portableDevEnvironment.git /f/Documents/portableDevEnvironment`

From the **Repository** menu, open git-bash.  Run `./build.sh`, and there will be a confirmation for which letter is detected as the target.

Close git-bash after building.  Subsequent bash sessions will include all the proper PATH locations.

This cloned repository is not needed afterwards, and the folder can be discarded.

## Running the Environment

1. Open Git Portable from the PortableApps menu.
2. In the git bash window, typing in `~/fixLetters.sh --force` will force a device letter recheck and update.  The script will auto-detect your drive letter and update it in all the places it can with the new paths.

## Notes

* On its first run, git-bash may complain about a couple of mkdir permissions.  This can be ignored.  Subsequent launches will not present this error.
* Opening Netbeans or VSCode from the PA menu instead of the git bash window may cause the PATH variable to not have all the portable information.  You should open it from the git-bash window by typing in `netbeans` or `vscode`, and pressing enter.
