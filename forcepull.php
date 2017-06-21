#!/usr/bin/env php
<?php
# @author Zeus Intuivo <zeus@intuivo.com>
#

$currentbranch = exec('git rev-parse --abbrev-ref HEAD');
echo "Force Reseting Pull to  ".$currentbranch."\n" ;
echo "git fetch --all \n";
echo "\n";
//downloads the latest from remote without trying to merge or rebase anything.
$said = exec('git fetch --all');

//resets the master branch to what you just fetched.
//The --hard option changes all the files in your working tree to match the files in origin/master
echo 'git reset --hard origin/'.$currentbranch." \n";
echo "\n";
$said = exec('git reset --hard origin/'.$currentbranch);
echo $said . "\n\n";
echo "Project Participation: \n";
$said = shell_exec('projectparticipation');
echo $said . "\n\n";
