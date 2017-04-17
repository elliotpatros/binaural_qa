#!/bin/sh

for i in {1002..1060}
do
    IF="ftp://ftp.ircam.fr/pub/IRCAM/equipes/salles/listen/archive/SUBJECTS/IRC_$i.zip"
    OF="./HRTFs/IRC_$i.zip"
    echo "downloading $IF to $OF"
    curl $IF --progress-bar --output $OF
    if [ -f $OF ]
    then 
        echo "expanding $OF"
        unzip -q $OF -d "./HRTFs/IRC_$i/"
        rm $OF
    else
        echo "couldn't find $IF"
    fi
done
