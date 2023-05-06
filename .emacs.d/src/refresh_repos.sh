#!/bin/bash

##############################
# Set these vars
REPODIR="./"
##############################

# Build Repo List
cd ${REPODIR}
rm repo-list.txt
find . -type d -name .git -not -path "./archived-repos-stash/*" | sed -e 's#/.git##' | sed -e 's#^./##g' > repo-list.txt

##############################
# Refresh selected repos
##############################
while read REPO; do
    BRANCH=`git -C ${REPODIR}${REPO} status|awk -F " " '{print $3}'|head -n 1`
    if [[ $BRANCH == "master" ]]; then
        echo "${REPODIR}${REPO}:    UPDATING ${BRANCH}"
        git -C $REPODIR/$REPO pull origin $BRANCH
    elif [[ $BRANCH == "" ]]; then
        echo "${REPODIR}${REPO}:  NOT A GIT REPO"
    else
        echo "${REPODIR}${REPO}:    UPDATING master FIRST, THEN ${BRANCH}"
        git -C $REPODIR/$REPO checkout master &&
        git -C $REPODIR/$REPO pull origin master
        git -C $REPODIR/$REPO checkout $BRANCH &&
        git -C $REPODIR/$REPO pull origin $BRANCH
    fi
echo
done < repo-list.txt
