#!/usr/bin/env php
<?php
# @author Zeus Intuivo <zeus@intuivo.com>
#


		$sort_order = " | sort -nr";
		$sort_max_count = " | sort -tr";
if ((DIRECTORY_SEPARATOR)=="\\") { //windows
	$said = @exec('set TERM=msys');

	//Sort distinguish


		# Define sort use for windows
		$said = @exec('echo 1 | sort -r');
		// die($said); //assert 1 as return
		if ($said=="1") { //using gnu sort
			//
			// echo "gnu sort";
			//
			$sort_order = " | sort -nr";
			$sort_max_count = " | sort -tr";
		} else {  //using windows sort
			//
			// echo "windows sort";
			//
			$sort_order = " | sort /r";
			$sort_max_count = " | sort /r";
		}

	//List 
	$said = shell_exec('git log --pretty=format:%an | gawk '."'".'{ ++c[$1]; } END { for(cc in c) printf "%6d %s\n",c[cc],cc; }'."'".$sort_order);
	#git shortlog -sne
	echo $said ."\n";

	echo "========= TOTAL COUNT =======\n";
	$said = exec('git log --pretty=format:%an | gawk '."'".'{ ++c[$3]; } END { for(cc in c) printf "%6d %s\n",c[cc],cc; }'."'".$sort_max_count);
	echo $said ."\n";

} else { //linux
	$said = @exec('export TERM=msys;');
	#git shortlog -sne
	$said = shell_exec('git log --pretty=format:%an | gawk '."'".'{ ++c[$1]; } END { for(cc in c) printf "%6d %s\n",c[cc],cc; }'."'".$sort_order);

	echo $said ."\n";
	echo "========= TOTAL COUNT =======\n";

	$said = exec('git log --pretty=format:%an | gawk '."'".'{ ++c[$3]; } END { for(cc in c) printf "%6d %s\n",c[cc],cc; }'."'".$sort_max_count);
	echo $said ."\n";

}

