#!/bin/bash

USID=oracle
typeset -u yn

if [ $LOGNAME != "$USID" ]
then
        echo "Unix id must be ${USID}"
        exit
fi

ls -ld /c08/db/tech_st

echo  "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "rm -fr /c08/db/tech_st"

echo -e "Are You Sure to Remove Application Homes :

Continue [y/n]:\c"; read yn

test "$yn" = "Y" || { echo -e "\nNot executing $cmd"; exit; }

ls -ld /c08/db/tech_st
rm -fr /c08/db/tech_st
ls -ld /c08/db/tech_st
