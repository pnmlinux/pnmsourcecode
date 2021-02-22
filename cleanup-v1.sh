#!/bin/bash

mv .git/config config

rm -rf .git

sh ./setup-git*

mv config .git/config

git add --all .

git commit -m "monthly cleanup"

git push origin master --force

echo "################################################################"
echo "###################    cleanup  Done      ######################"
echo "################################################################"
