#!/usr/bin/sh

DATE=$(date '+%Y%m%d%H%M%S');

NEXT_COMMIT_ID=`./get_commit_id.pl`;

CURRENT_COMMIT_ID=`./get_current_commit_id.pl`;

COMMIT_MESSAGE=;

YAMLNAME=`./get_val_from_name.pl YAML_NAME`;

CONTAINER_NAME=`./get_container_name.pl`;

CONTAINER_VOLUME_DIR='/usr/share/dockrl92';

VISITS_FILE='visits.dockrl92';

TOTAL=$(docker exec -i $CONTAINER_NAME sh -c "cat $CONTAINER_VOLUME_DIR/$VISITS_FILE");


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
    sed -i "s/$CURRENT_COMMIT_ID/$NEXT_COMMIT_ID/" public/service-worker.js;

    # change version in .yml
    sed -i "s/version: '$CURRENT_COMMIT_ID'/version: '$NEXT_COMMIT_ID'/" $YAMLNAME;

    # echo "$NEXT_COMMIT_ID $COMMIT_MESSAGE $(date '+%Y%m%d%H%M%S')";
        echo "Committing Message"
    git commit -am "$NEXT_COMMIT_ID $COMMIT_MESSAGE $(date '+%Y%m%d%H%M%S') $CURRENT_COMMIT_ID";

    echo "$!"

    # also push to repo automatically.
    echo "Push/update Git Lab Repo"
    ./r

    echo "$!";

    # also run hypnotoad hot deployment

    if [ -f ./h ]; then
        echo "hypnotoad hot deployment"
        ./h
    else
        echo "./h not found";
    fi

    echo "$!";

    echo "/$CURRENT_COMMIT_ID/$NEXT_COMMIT_ID/";

    echo "$NEXT_COMMIT_ID|$DATE" > ./version.dockrl92
fi

echo "";

echo "Latest Version number from dockrl92.yml ";
grep -r 'version' ./dockrl92.yml;
echo "";

echo "Latest Version number from service-worker.js ";
grep -r 'version' ./public/service-worker.js;
echo "";

echo "Latest version number from the actual version.'app' file ";
cat ./version.dockrl92;
echo "";

echo "Total Visits: (From $CONTAINER_VOLUME_DIR/$VISITS_FILE)";
echo "$TOTAL";
echo "";

echo "Total Commits";
git rev-list --count --all; 
echo "";

