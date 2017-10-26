#!/usr/bin/env bash

# Generates a portable web dev environment for the PortableApps Suite.
# by Jeremy Gonyea
# Last Updated 20170912

function testPath {
	[ -d $1 ] && echo "Dir found at $1"
	[ ! -d $1 ] && echo "$1 NOT found." && echo "Verify all prerequisites and/or manually create this folder." && exit

}


echo "Checking build environment"
# Find current working drive letter
WDL=$(pwd | cut -c2)
echo "This will install applications onto the drive $WDL."
read -p "Press Ctrl+C now to stop.  Otherwise, press any other key." -n1 -s

PA="/$WDL/PortableApps"
WTEMP="/$WDL/tmp/pa-build"

# Check prereq's
testPath /$WDL/Documents
testPath $PA
testPath $PA/7-ZipPortable
testPath $PA/CommonFiles/Java
testPath $PA/CommonFiles/Java64
mkdir -p $WTEMP
testPath "$WTEMP"
mkdir -p /$WDL/Documents/Projects
testPath /$WDL/Documents/Projects
echo "All preq's found!  Beginning build."


# Git Portable
###################################
echo "Git"
#curl -L -o "$WTEMP/gitPortable-2.13.0.paf.exe" https://github.com/sheabunge/GitPortable/releases/download/v2.13.0-devtest.1/GitPortable_2.13.0_Development_Test_1.paf.exe
#"$WTEMP/gitPortable-2.13.0.paf.exe"
sed -i 's;Git\\cmd\\git-gui.exe;Git\\git-bash.exe;' $PA/GitPortable/App/AppInfo/Launcher/GitPortable.ini
sed -i 's;WorkingDirectory=%PAL:DataDir%\\home;WorkingDirectory=%PAL:Drive%\\Documents\\Projects;' $PA/GitPortable/App/AppInfo/Launcher/GitPortable.ini
sed -i 's;HOME=%PAL:DataDir%\\home;HOME=%PAL:Drive%\\Documents\nCOMPOSER_HOME=%PAL:Drive%\\xampp\\globalcomposer;' $PA/GitPortable/App/AppInfo/Launcher/GitPortable.ini


# XAMPP Launcher Portable
echo "XAMPP"
cd $WTEMP/
mkdir -p "/$WDL/xampp"
testPath "/$WDL/xampp"
curl -L -o "$WTEMP/xampp.paf.exe" https://downloads.sourceforge.net/portableapps/XAMPP_1.6.paf.exe?download
curl -L -o "$WTEMP/xampp-7.1.8.0.zip" https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.1.8/xampp-portable-win32-7.1.8-0-VC14.zip/download
unzip -o "$WTEMP/xampp-7.1.8.0.zip" -d "/$WDL/"
curl -L -o "/$WDL/xampp/php/ext/php_xdebug-2.5.4-7.1-vc14.dll" http://xdebug.org/files/php_xdebug-2.5.4-7.1-vc14.dll
printf "\nzend_extension = php_xdebug-2.5.4-7.1-vc14.dll\n" >> /$WDL/xampp/php/php.ini
echo "Running XAMPP Launcher Installer"
$WTEMP/xampp.paf.exe


## Composer
echo "Composer"
cd $WTEMP/
mkdir -p "/$WDL/xampp/globalcomposer"
testPath "/$WDL/xampp/globalcomposer"
mkdir "/$WDL/xampp/bin"
testPath "/$WDL/xampp/bin"
printf '{\n\t"require-dev": {\n\t\t"squizlabs/php_codesniffer": "*",\n\t\t"phpdocumentor/phpdocumentor": "2.*"\n\t},\n\t"config": {\n\t\t"bin-dir": "/xampp/bin/"\n\t}\n}\n' > /$WDL/xampp/globalcomposer/composer.json
curl -sS https://getcomposer.org/installer | "/$WDL/xampp/php/php" -- --install-dir="/$WDL/xampp/bin" --filename=composer


## Codesniffer
echo "Codesniffer"
cd $WTEMP/


# NodeJS Portable
echo "NodeJS"
cd $WTEMP/
curl -L -o "$WTEMP/nodeJSPortable-5-7-0.paf.exe" https://github.com/garethflowers/nodejs-portable/releases/download/v5.7.0/NodeJSPortable_5.7.0.paf.exe
curl -L -o "$WTEMP/nodeJS-6.11.3.zip" https://nodejs.org/dist/v6.11.3/node-v6.11.3-win-x64.zip
echo "Running NodeJS Installer"
"$WTEMP/nodeJSPortable-5-7-0.paf.exe"
echo "Upgrading NodeJS 5.7 -> 6.11"
unzip -o "$WTEMP/nodeJS-6.11.3.zip" -d $WTEMP
mv $WTEMP/node-v6.11.3-win-x64/node.exe $PA/NodeJSPortable/App/NodeJS
mv $PA/NodeJSPortable/App/DefaultData /$WDL/PortableApps/NodeJSPortable/App/DefaultDataOld
mkdir $PA/NodeJSPortable/App/DefaultData
testPath $PA/NodeJSPortable/App/DefaultData
mv $WTEMP/node-v6.11.3-win-x64/* $PA/NodeJSPortable/App/DefaultData


# Ruby
echo "Ruby"
cd $WTEMP/
mkdir $WTEMP/ruby
testPath $WTEMP/ruby
curl -L -o "$WTEMP/ruby/ruby-2.3.3.7z" https://dl.bintray.com/oneclick/rubyinstaller/ruby-2.3.3-x64-mingw32.7z
cd $WTEMP/ruby
$PA/7-ZipPortable/App/7-Zip64/7zG.exe x $WTEMP/ruby/ruby-2.3.3.7z
mv $WTEMP/ruby/ruby-2.3.3-x64-mingw32 /$WDL/xampp/ruby


# NetBeans Portable
echo "NetBeans"
cd $WTEMP/
mkdir $PA/NetBeansPortable
testPath $PA/NetBeansPortable
curl -L -o "$WTEMP/netbeans.zip" https://github.com/garethflowers/netbeans-portable/releases/download/v8.1/NetBeansPHPPortable_8.1.zip
unzip -o "$WTEMP/netbeans.zip" -d "$PA/NetBeansPortable"



# LocalSMTP
echo "Papercut SMTP Test Server"
mkdir /$WDL/xampp/papercut
testPath /$WDL/xampp/papercut
curl -L -o "$WTEMP/papercut.zip" https://github.com/ChangemakerStudios/Papercut/releases/download/5.0.9/Papercut.5.0.9.zip
unzip -o "$WTEMP/papercut.zip" -d "/$WDL/xampp/papercut"


# PATH and bash aliases
git clone https://github.com/jgonyea/portableDevEnvironment.git $WTEMP/pde
cat $WTEMP/pde/bash_profile >> /$WDL/Documents/.bash_profile
mv $WTEMP/pde/startDev.sh /$WDL/Documents/


# Cleanup
echo "Cleanup"
echo "Deleting $WTEMP"
rm -rf $WTEMP
