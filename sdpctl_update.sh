#!/bin/bash

################################################################################
#Create by: Danielbosc
#Date Created: 2023.08.28
#Date Updated: 2023.08.30

#Purpose: Install or update Appgate SDP sdpctl for macOS if not up to date.

#Change Log 2023.08.26 - Created Script, Deleted script, dont use "rm sdpctl*" in directory with this script in it :)
#Change Log 2023.08.28 - Re-created Script
#Change Log 2023.08.29 - Added user interaction to install if out of date
#Change Log 2023.08.30 - Added rm to remove downloaded file from tmp dir
#Change Log 2023.10.04 - Added latest version to update echo
################################################################################

cd "/tmp"

#Query github for the latest verion of sdpctl by using the tag_name field then delete following spaces
sdpctlLatest=$(curl -s https://api.github.com/repos/appgate/sdpctl/releases/latest | jq -r .tag_name | sed -e 's/\ *$//g')

#Query currently installed verion of sdpctl by matching date/version then delete following spaces
sdpctlVer=$(sdpctl --version / | grep -m 10 -o -G "[0-9][0-9][0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]" | sed -e 's/\ *$//g')

#Create name of the for latest version of mac sdpctl
latestVerFile="sdpctl_${sdpctlLatest}_darwin_all.tar.gz"

#echo The latest version is $sdpctlLatest
#echo Your current version is $sdpctlVer

if [[ "$sdpctlVer"  !=  "$sdpctlLatest" ]]; #Compare Installed and latest version
    then
        echo OH Hosed! You need to update or install a newer version, your current version is: $sdpctlVer , the latest version is: $sdpctlLatest  # If you are not up to date it i will ask you to install
        read -p "Do you want to upgrade or install sdpctl? [yn]" answer #Ask user to update
            if [[ $answer = y ]] ; 
                then #Update Process
                    wget https://github.com/appgate/sdpctl/releases/download/${sdpctlLatest}/${latestVerFile}
                    gunzip -c ${latestVerFile} | tar xopf -
                    mv -f "/tmp/sdpctl" "/usr/local/bin/"
                    chmod 0744 "/usr/local/bin/sdpctl"
                    echo WOO HOO! The update is complete the current `sdpctl --version`
                    rm "/tmp/${latestVerFile}"
        fi
    else
        echo OH Yeah! You are on the latest version: $sdpctlLatest # Congrats you are not a slacker
fi

exit 0
