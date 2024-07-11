#!/usr/bin/sh

# colors 
RED='\033[0;31m'
NOCOLOR='\033[0m' # No Color

DATE=$(date '+%Y%m%d%H%M%S');

NEXT_COMMIT_ID=`./get_commit_id.pl`;

CURRENT_COMMIT_ID=`./get_current_commit_id.pl`;

COMMIT_MESSAGE=;

YAML_NAME=`./get_val_from_name.pl YAML_NAME`;

VISITS_FILE='sites.visits';

VERSION_FILE='sites.version';

if [ "$1" = '' ]; then

    # do not commit
        # just show status/log/etc.

    COMMIT_MESSAGE=$(date '+%Y%m%d%H%M%S');

    echo "Showing last commit from log"
    git log -1

    echo "Show Status"
    git status

else
    # if $1 is not empty, commit

    COMMIT_MESSAGE="$1";

    # update service-worker.js
    # sed -i 's/036/037/' public/service-worker.js
    sed -i "s/$CURRENT_COMMIT_ID/$NEXT_COMMIT_ID/" ./public/service-worker.js;

    # change version in .yml
    sed -i "s/version: '$CURRENT_COMMIT_ID'/version: '$NEXT_COMMIT_ID'/" $YAML_NAME;

    # echo "$NEXT_COMMIT_ID $COMMIT_MESSAGE $(date '+%Y%m%d%H%M%S')";
        echo "Committing Message"
    git commit -am "$NEXT_COMMIT_ID $COMMIT_MESSAGE $(date '+%Y%m%d%H%M%S') $CURRENT_COMMIT_ID";

    echo "$!"

    # also push to repo automatically.
    echo "Push/update Git Lab Repo"
    if [ -f "./r" ]; then 
        ./r
    else 
        echo "Repo executable file ./r not found";
    fi

    echo "$!";

    # also run hypnotoad hot deployment

    if [ -f ./h ]; then
        echo "hypnotoad hot deployment"
        ./h
    else
        echo -e " ${RED}Hypnotoad file ./h not found${NOCOLOR}";
    fi

    echo "$!";

    echo "/$CURRENT_COMMIT_ID/$NEXT_COMMIT_ID/";

    echo "$NEXT_COMMIT_ID|$DATE" > ./$VERSION_FILE
fi

echo "";

echo "Latest Version number from .yml ";
grep -r 'version' ./$YAML_NAME;
echo "";

echo "Latest Version number from service-worker.js ";
grep -r 'version' ./public/service-worker.js;
echo "";

echo "Total Commits";
git rev-list --count --all; 
echo "";

