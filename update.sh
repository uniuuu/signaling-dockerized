#!/bin/bash

# check whether the user is root
if [ "$(id -u)" -ne "0" ]; then
	echo "You need to be root"
	exit 1
fi


# setting the right umask
umask 0022


# checking parameters
while (($#)); do
	case "${1}" in
		--skip-start)
		SKIP_START=y
		;;
		--help|-h)
		echo -e './update.sh [--skip-start, -h|--help]\n             --skip-start         -   Do not start the docker-compose stack after the update
		'
		exit 1
	esac
	shift
done


# get latest repo
echo "Pulling current repo from Codeberg..."
git pull
echo -e "Done!\n\n"

# prefetching container images
docker-compose image pull

# re-building containers
docker-compose build --no-cache

# re-creating containers
docker-compose up -d

# remove dangling images
docker image prune
