#!/bin/bash

ARGC=$#
HOME_PATH=~/.run

RED='\033[0;31m'
NONE='\033[0m'

if [ ! -d $HOME_PATH ]; then
	mkdir $HOME_PATH
fi

if (( $ARGC == 1 )); then
	project_path=$(realpath $(pwd)/$1)
	exec_path=$HOME_PATH/$(echo $project_path | tr / -)
	
	if [ ! -f $project_path/CMakeLists.txt ]; then
		echo -e "${RED}is not directory or does not contain CMakeLists.txt.${NONE}"
		exit 1
	fi
	
	first_line=$(head -n 1 $project_path/CMakeLists.txt)
	exec_name=${first_line//[# ]/}
	
	if [ ! -d $exec_path ]; then
		mkdir $exec_path
	fi
	
	cd $exec_path
	
	if [ ! -f $exec_path/date.txt ]; then
		touch date.txt
	fi
	
	last_modify=$(date -r $project_path/CMakeLists.txt +"%Y-%m-%d %H:%M:%S")
	
	if [ ! -f $exec_path/Makefile ] || [ ! "$(< $exec_path/date.txt)" = "$last_modify" ]; then
		echo $last_modify > date.txt
		cmake $project_path
		if (( $? != 0 )); then
			exit 1
		fi
	fi
	
	make
	if (( $? != 0 )); then
		exit 1
	fi
	
	if [ ! -f $exec_path/$exec_name ]; then
		echo -e "${RED}Target not found. Specify the name of the executable in the first line of CMakeLists.txt via '# <binary-name>'.${NONE}"
		exit 1
	fi
	
	$exec_path/$exec_name
else
	echo "Usage: sdrun <cmakelists-dir>"
	echo "Note: Specify the name of the executable in the first line of CMakeLists.txt via '# <binary-name>'."
fi

