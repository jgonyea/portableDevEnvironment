#!/usr/bin/env bash

source ~/.lastDriveLetter
WDL=$(pwd | cut -c2)
WDLupper=${WDL^^}
PA="/$WDL/PortableApps"


if [ "$WDL" = "$LASTDRIVE" ] && [ "$1" != "--force" ]; then
    exit
fi

echo "=== Drive letter changed or check forced ==="

echo " |- Updating drive letter from $LASTDRIVE to $WDL =="
sed -i "s,LASTDRIVE=$LASTDRIVE,LASTDRIVE=$WDL," ~/.lastDriveLetter
source ~/.lastDriveLetter

echo " |- Fixing bash_aliases == "
sed -i "s,/./,/$LASTDRIVE/," /$WDL/Documents/.bash_aliases

echo " |- Fixing XAMPP Launcher Paths =="
sed -i "s,Editor=.\:,Editor=$LASTDRIVE\:," /$WDL/xampp/xampp-control.ini
sed -i "s,Browser=.\:,Browser=$LASTDRIVE\:," /$WDL/xampp/xampp-control.ini

if [ -d $PA/NetBeansPortable/Data/Config ]; then
    echo " |- Fixing Netbeans paths =="
    find $PA/NetBeansPortable/Data/Config -type f -name "*.properties" -exec sed -i 's;.\:\\;\'"$WDLupper"'\:\\;g' {} \;
    find $PA/NetBeansPortable/Data/Config -type f -name "*.properties" -exec sed -i 's;\/.\:\/;\/'"$WDLupper"'\:\/;g' {} \;
fi
if [ -d $PA/NetBeansPortable/Data/Cache ]; then
    echo " |- Invalidating Netbeans' Cache folder =="
    rm -rf $PA/NetBeansPortable/Data/Cache
fi

echo "=== Finished updating paths ==="


source ~/.bash_profile