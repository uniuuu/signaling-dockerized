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
                --non-interactive|-n)
                NON_INTERACTIVE=y
                ;;
                --dont-apply|-d)
                NO_APPLY=y
                ;;
		--help|-h)
		echo -e './update.sh [-h|--help, -n|--non-interactive, -d|--dont-apply]\n             --non-interactive    -  Always delete dangling images, do not ask\n             --dont-apply         -  Do not recreate the containers
		'
		exit 1
	esac
	shift
done


# get latest repo
echo "Pulling current repo from Codeberg..."
git pull
echo -e "Done!\n\n"

# prefetching container images from remote
docker-compose pull

# re-building containers
docker-compose build --no-cache

# re-creating containers
[[ "$NO_APPLY" == y ]] || docker-compose up -d

# remove dangling images
[[ "$NON_INTERACTIVE" == "y" ]] && docker image prune -f || docker image prune
