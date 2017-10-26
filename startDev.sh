#!/usr/bin/env bash
echo "Starting up Environment"
# Find current working drive letter
WDL=$(pwd | cut -c2)
WDLupper=${WDL^^}


# Fix drive letters in apps.
echo "Fixing drive letters to match current detected drive letter ($WDL)"
echo "Fixing shell paths"
sed -i "s,\/.\/xampp,\/$WDL\/xampp,g" /$WDL/Documents/.bash_profile
sed -i "s,\/.\/PortableApps,\/$WDL\/PortableApps,g" /$WDL/Documents/.bash_profile

source /$WDL/Documents/.bash_profile

echo "Fixing XAMPP Launcher Paths"
sed -i "s,Editor=.\:,Editor=$WDL\:," /$WDL/xampp/xampp-control.ini
sed -i "s,Browser=.\:,Browser=$WDL\:," /$WDL/xampp/xampp-control.ini


echo "Fixing Netbeans paths"
find /$WDL/PortableApps/NetBeansPortable/Data/Config -type f -name "*.properties" -exec sed -i 's;.\:\\;\'"$WDLupper"'\:\\;g' {} \;
find /$WDL/PortableApps/NetBeansPortable/Data/Config -type f -name "*.properties" -exec sed -i 's;\/.\:\/;\/'"$WDLupper"'\:\/;g' {} \;

# Start apps.
echo "Starting Apache, Papercut, XAMPP Launch, and Netbeans"
/$WDL/xampp/apache/bin/httpd.exe&
/$WDL/xampp/papercut/Papercut.exe&
/$WDL/PortableApps/XAMPP/XAMPPLauncher.exe&
/$WDL/PortableApps/NetbeansPortable/NetBeansPHPPortable.exe&
echo "Apps loaded, this may take a little while..."


echo "Environment Started"
