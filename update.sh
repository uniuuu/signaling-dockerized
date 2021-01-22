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

# get update.sh checksum
SHA_1=$(sha256sum update.sh)

# get latest repo
echo -e "\e[32mPulling latest commits from Codeberg...\e[0m"
git pull
echo -e "\e[32mDone!\e[0m\n\n"

# check update.sh for updates
echo -e "\e[32mChecking for newer update script...\e[0m"
SHA_2=$(sha256sum update.sh)
if [[ ${SHA_1} != ${SHA_2} ]]; then
  echo "update.sh changed, please run this script again, exiting."
  chmod 700 update.sh
  exit 2
fi
echo -e "\e[32mDone!\e[0m\n\n"


# check whether HPB was configured
if [[ ! -f hpb.conf ]]; then
  echo -e "\e[31mNo hpb.conf - please run generate-config.sh first!\e[0m"
  exit 1
fi


# prefetching container images from remote
echo -e "\e[32mFetching new images, if any...\e[0m"
docker-compose pull
echo -e "\e[32mDone!\e[0m\n\n"

# re-building containers
echo -e "\e[32mRebuilding containers...\e[0m"
docker-compose build --no-cache
echo -e "\e[32mDone!\e[0m\n\n"

# re-creating containers
if [[ "$NO_APPLY" != y ]]
then
	echo -e "\e[32mRecreating containers...\e[0m"
	docker-compose up -d
	echo -e "\e[32mDone!\e[0m\n\n"
fi


# remove dangling images
echo -e "\e[32mRemoving old container images...\e[0m"
[[ "$NON_INTERACTIVE" == "y" ]] && docker image prune -f || docker image prune
echo -e "\e[32mDone!\e[0m\n\n"


# end
echo -e "\e[32mUpdate finished!\e[0m"
exit 0
