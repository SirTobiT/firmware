#!/bin/bash
#replace $2 with $3 in directory $1 recursively
function replace {
	find $1 -type f -print0 | xargs -0 sed -i "s;$2;$3;g"
}

#copy template $3 to sitecode $4 and replace SITECODE with $4, NAME with $5, and WEBSITE with $6
function makesite {
	DIR=assembled/$3/$4
	rm -rf $DIR
	mkdir -p assembled/$3
	cp -r templates/$3 $DIR
	replace $DIR SITECODE "$4"
	NAME=$(echo $5 | sed 's/:/ /g')
	replace $DIR NAME "$NAME"
	replace $DIR WEBSITE "$6"
	replace $DIR RELBRANCH "$1"
}

function sites {
	rm -rf assembled
	while read L
	do
		makesite $L
	done < sites
	echo --- sites assembled ---
}

#build image for autoupdater branch $2, gluon branch $3, target $1, template $4, site $5
function image {
		PREP=$(cat $HOME_DIR/.prepared)
		rm $HOME_DIR/.prepared
		ARGS="GLUON_SITEDIR=$HOME_DIR/assembled/$3/$4 GLUON_IMAGEDIR=$HOME_DIR/images/$3/$4 GLUON_MODULEDIR=$HOME_DIR/modules GLUON_BRANCH=$1"
		if [ "$PREP" != "$3" ]
		then
			git fetch --all
			git reset --hard $2
			make update $ARGS || end 1
			make clean $ARGS GLUON_TARGET=ar71xx-generic
			$HOME_DIR/assembled/$3/$4/prepare.sh
		fi
		for TARGET in $TARGETS
		do
			if make -j12 $ARGS GLUON_TARGET=$TARGET
			then
				echo build successful
			else
				make V=s $ARGS GLUON_TARGET=$TARGET
				end 1
			fi
		done
		echo $3 > $HOME_DIR/.prepared
		mkdir $HOME_DIR/images/$3/$4/site
		cp -r $HOME_DIR/assembled/$3/$4/* $HOME_DIR/images/$3/$4/site
		make manifest $ARGS
}

function images {
	if [ -z "$@" ]; then export TARGETS="ar71xx-generic ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest x86-xen_domu x86-64"; else export TARGETS="$@"; fi
	cd $GLUON_DIR
	while read L
	do
		image $L
	done < $HOME_DIR/sites
	cd $HOME_DIR
	mv images{,-$(date +%s)}
	mv modules{,-$(date +%s)}
}

function all {
	sites
	images $1
}

function init {
	rm -rf gluon.bak
	mv gluon{.bak} 2>/dev/null
	git clone https://github.com/freifunk-gluon/gluon $GLUON_DIR
}

function ci {
	if [ ! -d "GLUON_DIR" ]; then
		init
	fi
	all
}

function end {
	rm -f $LOCK
	exit $1
}

HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GLUON_DIR="$HOME_DIR/gluon"
LOCK=/tmp/eulenfw_build.sh.running
if [[ -f $LOCK ]] ; then
	echo already running, exiting. if you are sure, delete $LOCK
	exit
fi
touch $LOCK
$@
end
