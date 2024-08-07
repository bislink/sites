#!/usr/bin/sh

# colors 
NoColor='\033[0m'
Black='\033[0;30m'
DarkGray='\033[1;30m'
Red='\033[0;31m'
LightRed='\033[1;31m'
Green='\033[0;32m'
LightGreen='\033[1;32m'
BrownOrange='\033[0;33m'
Yellow='\033[1;33m'
Blue='\033[0;34m'
LightBlue='\033[1;34m'
Purple='\033[0;35m'
LightPurple='\033[1;35m'
Cyan='\033[0;36m'
LightCyan='\033[1;36m'
LightGray='\033[0;37m'
White='\033[1;37m'

echo ""
echo "${Cyan}Welcome to sites $NoColor"
echo ""

DATE=$(date '+%Y%m%d-%H%M%S-%Z');

NEXT_COMMIT_ID=`./get_commit_id.pl`;

CURRENT_COMMIT_ID=`./get_current_commit_id.pl`;

COMMIT_MESSAGE=;

YAML_NAME=`./get_val_from_name.pl YAML_NAME`;

VISITS_FILE='sites.visits';

VERSION_FILE='sites.version';



if [ "$1" = '' ]; then

    # do not commit
        # just show status/log/etc.

    COMMIT_MESSAGE=$DATE;

    echo "Showing oneliners from last 9 commits/log"
    git log -9 --oneline

    echo "Show Status"
    git status

    echo ""
    echo "DATE"
    echo $DATE
    echo ""

else
    # if $1 is not empty, commit

    COMMIT_MESSAGE="$1";

    # update service-worker.js
    echo "Update service worker"
    sed -i "s/$CURRENT_COMMIT_ID/$NEXT_COMMIT_ID/" ./public/service-worker.js;
    echo ""

    # change version in .yml
    echo "Change version in $YAML_NAME file"
    sed -i "s/version: '$CURRENT_COMMIT_ID'/version: '$NEXT_COMMIT_ID'/" $YAML_NAME;
    echo ""

    echo "/$CURRENT_COMMIT_ID/$NEXT_COMMIT_ID/";

    echo "Write Next commit ID and Date to $VERSION_FILE";
    echo "$NEXT_COMMIT_ID|$DATE" > ./$VERSION_FILE
    echo ""

    echo "Committing Message"
    git commit -am "$NEXT_COMMIT_ID $COMMIT_MESSAGE $DATE";
    echo ""

    echo "Show error if any"
    echo "$!"
    echo ""

    # also push to repo automatically.
    echo "Push/update Git Lab Repo"
    if [ -f "./r" ]; then 
        ./r
    else 
        echo "${Red}Repo executable, ./r, was not found${NoColor}";
    fi
    echo ""

    echo "Show error if any"
    echo "$!";
    echo ""

    # also run hypnotoad hot deployment

    if [ -f ./h ]; then
        echo "hypnotoad hot deployment"
        ./h
    else
        echo " ${Red}Hypnotoad executable, ./h, was not found${NoColor}";
    fi
    echo ""

    echo "Show error if any"
    echo "$!";
    echo ""

fi


echo "SOME FINALS"
echo ""

echo "Latest Version number from .yml ";
grep -r 'version' ./$YAML_NAME;
echo "";

echo "Latest Version number from service-worker.js ";
grep -r 'version' ./public/service-worker.js;
echo "";

echo "Total Commits";
git rev-list --count --all; 
echo "";

