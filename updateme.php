#!/usr/bin/env php
<?php
# @author Zeus Intuivo <zeus@intuivo.com>
#
$updatemecurrentbranch = exec('git rev-parse --abbrev-ref HEAD');

# Before Loading anything Check Arguments Passed
# Get argv
$BRANCH="develop";

# detect operating system
$uname = strtolower(php_uname());
if (strpos($uname, "darwin") !== false) {
    // It's OSX
    $prefix = "";
} else if (strpos($uname, "win") !== false) {
    // It's windows
    $prefix = "";
} else if (strpos($uname, "linux") !== false) {
    // It's Linux
    $prefix = "./";
} else {
    // It's something your script won't run on
}

# read arguments from stdin, command line
if (!isset($argv) || !isset($argv[1])  ) {
	$msg = "Updating branch $updatemecurrentbranch with $BRANCH branch. Adding and commiting beforehand.";
} else {
	$argv[0] = "update ";
	$msg = implode(" ", $argv);
}

#add
echo "\n";
echo "\033[38;5;27m === Add .  ===\n \033[38;5;214m";
echo "\n";
$said = exec('git add . ');
echo $said ."\n";
echo "\n";

#unstage
echo "\n";
echo "\033[38;5;27m === UnStaging .  ===\n \033[38;5;214m";
echo "\n";
$command="
if command -v unstage_exception_list >/dev/null 2>&1; then
  (
    if [[ \"$(uname)\" == \"Darwin\" ]] ; then
      # Do something under Mac OS X platform
      unstage_exception_list ;

    elif [[ \"$(expr substr $(uname -s) 1 5)\" == \"Linux\" ]] ; then
      # Do something under GNU/Linux platform
      ./unstage_exception_list ;

    elif [[ \"$(expr substr $(uname -s) 1 10)\" == \"MINGW32_NT\" ]] ; then
      # Do something under Windows NT platform
      unstage_exception_list ;
      # nothing here
    fi
  )
fi
";
$said = exec($command);
echo $said ."\n";
echo "\n";


#status
echo"\n";
echo "\033[38;5;27m === Status ===\n \033[38;5;214m";
echo"\n";

$command="
if command -v gsb >/dev/null 2>&1; then
  gsb
elif command -v status >/dev/null 2>&1; then
  status
else
  git status;
fi
";
$said = exec($command);
echo $said ."\n";
echo "\n";

#commit
echo "\n";
echo "\033[38;5;27m === commit -m ".'"'. $msg . '"'. "   ===\n \033[38;5;214m";
echo "\n";
$said = exec('git commit -m "'.$msg .'"' );
echo $said ."\n";
echo "\n";


#pull
echo "\n";
echo "\033[38;5;27m === Pull  ===\n \033[38;5;214m";
echo "\n";
$said = exec($prefix . 'pull');
echo $said ."\n";
echo "\n";

#push
echo "\n";
echo "\033[38;5;27m === Push origin $updatemecurrentbranch  ===\n \033[38;5;214m";
echo "\n";
$said = exec('git push origin '.$updatemecurrentbranch);
echo $said ."\n";
echo "\n";

#BRANCH FROM ..master or develop or etc
echo "\n";
echo "\033[38;5;27m === $BRANCH  ===\n \033[38;5;214m";
echo "\n";
$said = exec($prefix . "branch ".$BRANCH);
echo $said ."\n";
echo "\n";

#pull
echo "\n";
echo "\033[38;5;27m === Pull $BRANCH ===\n \033[38;5;214m";
echo "\n";
$said = exec($prefix . "pull");
echo $said ."\n";
echo "\n";

#branch
echo "\n";
echo "\033[38;5;27m === Branch back $updatemecurrentbranch  ===\n \033[38;5;214m";
echo "\n";
$said = exec($prefix . "branch ".$updatemecurrentbranch);
echo $said ."\n";
echo "\n";

#merge
echo "\n";
echo "\033[38;5;27m === Merge $BRANCH Here  ===\n \033[38;5;214m";
echo "\n";
$said = exec($prefix . "merge ".$BRANCH);
echo "\n";

if (substr_count($said, "conflicts") > 0) {
	echo "\033[38;5;197m $said \n";
	$said = exec($prefix . 'nur "<<<<<"');
    echo "\n";

} else {
	echo $said ."\n";
    echo "\n";

}

#status
echo"\n";
echo "\033[38;5;27m === Status ===\n \033[38;5;214m";
echo"\n";

$command="
if command -v gsb >/dev/null 2>&1; then
  gsb
elif command -v status >/dev/null 2>&1; then
  status
else
  git status;
fi
";
$said = exec($command);
echo $said ."\n";
echo "\n";
