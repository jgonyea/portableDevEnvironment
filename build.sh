#!/usr/bin/env bash

# title: 		build.sh
# description: 	Generates a portable web dev environment for the PortableApps Suite.
# author: 		Jeremy Gonyea
# 				menu from Nathan Davieau
# usage: 		./build.sh
#==============================================================================

# Validates that path can be found.
function testPath {
	echo " "
	[ -d $1 ] && echo "Dir found at $1"
	[ ! -d $1 ] && echo "$1 NOT found." && echo "Verify all prerequisites and/or manually create this folder." && exit

}

# Checks current Git Version
function testGit {
	gitVer=$(git --version | awk '{print $3}' | cut -c1)
	gitSubVer=$(git --version | awk '{print $3}' | cut -c3-4)

	# String to int conversions
	gitVer=$(($gitVer+0))
	gitSubVer=$(($gitSubVer+0))

	# Targets git versions less than 2.20.x
	if [ $gitVer -eq 2 ] && [ "$gitSubVer" -lt 20 ]; then
		echo "Old version of GitPortable detected, and will now update."
		read -p "After the update completes, please re-run this build script.  Press any key to continue."
		curl -L -o GitPortable_2.20.1.1_online.paf.exe https://github.com/jgonyea/GitPortable/releases/download/v2.20.1.1_online/GitPortable_2.20.1.1_for_Windows_online.paf.exe
		cmd "/C GitPortable_2.20.1.1_online.paf.exe"
		exit
	fi;
	echo "GitPortable appears up to date."
}

# Function to confirm environment prerequisites.
function initEnv {
	echo "Checking build environment"
	# Find current working drive letter
	WDL=$(pwd | cut -c2)
  PA="/$WDL/PortableApps"
	WTEMP="/$WDL/tmp/pa-build"
  BUILD_DIR=$(pwd)

	echo "This will install applications onto the drive $WDL."
	read -p "Press Ctrl+C to stop now.  Otherwise, press any other key." -n1 -s



	# Check prereq's
	testGit
	testPath /$WDL/Documents
	testPath $PA
  testPath $PA/7-ZipPortable
	testPath /tmp
	mkdir -p $WTEMP
	testPath "$WTEMP"
	mkdir -p /$WDL/Documents/Projects
	testPath /$WDL/Documents/Projects
	echo "All preq's found!  Beginning build process in"
	echo " |- 3..."
	sleep 1
	echo " |- 2..."
	sleep 1
	echo " |- 1..."
	sleep 1
	clear
}

# Forces certain choices to always be enabled for menu.
function setRequiredOptions {
	choices[0]="*"
	choices[1]="*"
	choices[2]="*"
	choices[5]="*"
}

# Menu function.
function MENU {
    echo "Menu Options"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

# Cleanup temporary files
function CLEANUP {
	# Cleanup
	###################################
	echo "Cleanup"
	echo "Deleting $WTEMP"
  rm -rf $WTEMP
	echo "Completing PATH setup for portable environment"
	printf '\nexport PATH="$PATH"' >> /$WDL/Documents/.bash_profile
}

# Confirm environment prerequisites.
initEnv


# Menu options
options[0]="Git Portable Config"
options[1]="XAMPP v7.2.11"
options[2]="Composer"
options[3]="PHP Code Sniffer"
options[4]="NodeJS v10.15.3"
options[5]="Ruby v2.3.3"
options[6]="NetBeansPHP v8.1 (w/ JRE 8)"
options[7]="Microsoft VSCode"
setRequiredOptions


# Selection based installations
function BUILD {
    if [[ ${choices[0]} ]]; then
    # Git Portable
		###################################
		echo "Configure Git Bash"
		sed -i 's;Git\\cmd\\git-gui.exe;Git\\git-bash.exe;' $PA/GitPortable/App/AppInfo/Launcher/GitPortable.ini
		sed -i 's;WorkingDirectory=%PAL:DataDir%\\home;WorkingDirectory=%PAL:Drive%\\Documents\\Projects;' $PA/GitPortable/App/AppInfo/Launcher/GitPortable.ini
		sed -i 's;HOME=%PAL:DataDir%\\home;HOME=%PAL:Drive%\\Documents\nCOMPOSER_HOME=%PAL:Drive%\\Documents\\.composer;' $PA/GitPortable/App/AppInfo/Launcher/GitPortable.ini

		# Bash aliases setup
		###################################
		printf "\nif [ -f ~/fixLetters.sh ]; then\n\t~/fixLetters.sh\nfi" >> /$WDL/Documents/.bash_profile
		printf "\nif [ -f ~/.bash_aliases ]; then\n\t. ~/.bash_aliases\nfi" >> /$WDL/Documents/.bash_profile
		printf "\nsource ~/.lastDriveLetter\n" >> /$WDL/Documents/.bash_profile
		printf "LASTDRIVE=$WDL" > /$WDL/Documents/.lastDriveLetter
		curl -L -o /$WDL/Documents/fixLetters.sh https://raw.githubusercontent.com/jgonyea/portableDevEnvironment/develop/fixLetters.sh
		printf '\nalias ll="clear && pwd && ls -la"' >> /$WDL/Documents/.bash_aliases

		echo "Git Bash configuration complete.  Next git-bash execution will use the new HOME of /$WDL/Documents"
    fi

    if [[ ${choices[1]} ]]; then
		# XAMPP Launcher Portable
		###################################
		echo "XAMPP"
		cd $WTEMP/
		mkdir -p "/$WDL/xampp"
		testPath "/$WDL/xampp"
		mkdir -p "/$WDL/Documents/Projects/public_html"
		testPath "/$WDL/Documents/Projects/public_html"
		curl -L -o "$WTEMP/xampp.paf.exe" https://downloads.sourceforge.net/portableapps/XAMPP_1.7.paf.exe?download
		curl -L -o "$WTEMP/xampp-7.2.11.0.zip" https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.2.11/xampp-portable-win32-7.2.11-0-VC15.zip/download
		unzip -o "$WTEMP/xampp-7.2.11.0.zip" -d "/$WDL/"
		curl -L -o "/$WDL/xampp/php/ext/php_xdebug-2.6.1-7.2-vc15.dll" http://xdebug.org/files/php_xdebug-2.6.1-7.2-vc15.dll
		printf "\n\n[XDebug]\nxdebug.remote_autostart = 1\nxdebug.profiler_append = 0\nxdebug.profiler_enable = 0\nxdebug.profiler_enable_trigger = 0\nxdebug.remote_enable = 1\nxdebug.remote_handler = "dbgp"\nxdebug.remote_host = "127.0.0.1"\nxdebug.remote_port = 9000\nzend_extension = php_xdebug-2.6.1-7.2-vc15.dll" >> /$WDL/xampp/php/php.ini
		sed -i 's;/xampp/htdocs;/Documents/Projects/public_html;g' /$WDL/xampp/apache/conf/httpd.conf
		echo "Running XAMPP Launcher Installer"
		$WTEMP/xampp.paf.exe
		printf "\nPATH=\"/"'$LASTDRIVE'"/xampp/bin:/"'$LASTDRIVE'"/xampp/php:/"'$LASTDRIVE'"/xampp/mysql/bin:"'$PATH"' >> /$WDL/Documents/.bash_profile
    fi

    if [[ ${choices[2]} ]]; then
		## Composer
		###################################
		echo "Installing Composer globally"
		cd $WTEMP/
		mkdir -p "/$WDL/xampp/globalcomposer"
		testPath "/$WDL/xampp/globalcomposer"
		mkdir -p "/$WDL/xampp/bin"
		testPath "/$WDL/xampp/bin"
		curl -sS https://getcomposer.org/installer | "/$WDL/xampp/php/php" -- --install-dir="/$WDL/xampp/bin" --filename=composer
    fi

    if [[ ${choices[3]} ]]; then
		## Codesniffer
		###################################
		echo "Installing Codesniffer"
		cd /$WDL/xampp/globalcomposer
		printf '{\n\t"require-dev": {\n\t\t"squizlabs/php_codesniffer": "2.9.1",\n\t\t"phpdocumentor/phpdocumentor": "2.*"\n\t},\n\t"config": {\n\t\t"bin-dir": "/xampp/bin/"\n\t}\n}\n' > /$WDL/xampp/globalcomposer/composer.json
		/$WDL/xampp/php/php /$WDL/xampp/bin/composer install
		printf "\nalias phpcs=\"/$WDL/xampp/bin/phpcs --colors\"" >> /$WDL/Documents/.bash_aliases
		printf "\nalias phpcbf=\"/$WDL/xampp/bin/phpcbf --colors\"" >> /$WDL/Documents/.bash_aliases
    fi

    if [[ ${choices[4]} ]]; then
		# NodeJS Portable
		###################################
		echo "NodeJS"
		cd $WTEMP/
		curl -L -o "$WTEMP/nodeJSPortable-10.15.3_online.paf.exe" https://github.com/jgonyea/nodejs-portable/releases/download/10.15.3/NodeJSPortable_10.15.3_online.paf.exe
		echo "Running NodeJS Installer"
		$WTEMP/nodeJSPortable-10.15.3_online.paf.exe

		printf "\nPATH=\"/$WDL/PortableApps/NodeJSPortable/App/node:"'$PATH\"' >> /$WDL/Documents/.bash_profile
    fi

    if [[ ${choices[5]} ]]; then
		# Ruby
		###################################
		echo "Ruby"
		cd $WTEMP/
		mkdir $WTEMP/ruby
		testPath $WTEMP/ruby
		curl -L -o "$WTEMP/ruby/ruby-2.3.3.7z" https://dl.bintray.com/oneclick/rubyinstaller/ruby-2.3.3-x64-mingw32.7z
		cd $WTEMP/ruby
		$PA/7-ZipPortable/App/7-Zip64/7zG.exe x $WTEMP/ruby/ruby-2.3.3.7z
		mv $WTEMP/ruby/ruby-2.3.3-x64-mingw32 /$WDL/xampp/ruby
		/$WDL/xampp/ruby/bin/gem install bundler
		printf "\nPATH=\"/"'$LASTDRIVE'"/xampp/ruby/bin/:"'$PATH\"' >> /$WDL/Documents/.bash_profile
    fi

    if [[ ${choices[6]} ]]; then
		# NetBeans Portable
		###################################
		echo "NetBeans Dependencies: Java Portable"
		cd $WTEMP/
		curl -L -o jPortable_online.paf.exe https://download3.portableapps.com/portableapps/Java/jPortable_8_Update_181_online.paf.exe
		curl -L -o jPortable64_online.paf.exe https://download3.portableapps.com/portableapps/Java64/jPortable64_8_Update_181_online.paf.exe
		$WTEMP/jPortable_online.paf.exe
		$WTEMP/jPortable64_online.paf.exe

		echo "NetBeans"
		cd $WTEMP/
		mkdir $PA/NetBeansPortable
		testPath $PA/NetBeansPortable
		curl -L -o "$WTEMP/netbeans.zip" https://github.com/garethflowers/netbeans-portable/releases/download/v8.1/NetBeansPHPPortable_8.1.zip
		unzip -o "$WTEMP/netbeans.zip" -d "$PA/NetBeansPortable"
		printf "\nalias netbeans=\"/$WDL/PortableApps/NetBeansPortable/NetBeansPHPPortable.exe&\"" >> /$WDL/Documents/.bash_aliases
    fi

    if [[ ${choices[7]} ]]; then
		# Microsoft VSCode
		###################################
		echo "Microsoft VSCode"
		curl -L -o "$WTEMP/VSCodePortable_Latest_v1.0.1_online.paf.exe" https://github.com/garethflowers/vscode-portable/releases/download/latest-v1.0.1/VSCodePortable_Latest_v1.0.1_online.paf.exe
		$WTEMP/VSCodePortable_Latest_v1.0.1_online.paf.exe
		printf "\nalias vscode=\"/$WDL/PortableApps/VSCodePortable/VSCodePortable.exe&\"" >> /$WDL/Documents/.bash_aliases
    fi
}


# Clear screen for menu
clear

# Menu loop
while MENU && echo "Select optional items to install/ configure.  Starred items are required" && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    #setRequiredOptions
	clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi

done

# Perform all selected actions from menu.
BUILD
CLEANUP

echo "===================================================="
echo "Close this window and open GitPortable from the PortableApps menu."
