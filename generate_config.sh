#!/bin/sh

# config file name
export CONFIGNAME='hpb.conf'


# check whether config exists
if [ -f $CONFIGNAME ]
then
  echo "There is a existing config! Aborted!"
  echo "If you want to generate a new config, delete or move the old one first."
  exit 1
fi


# creating a config from sample
cp ${CONFIGNAME}.sample $CONFIGNAME
chmod 640 $CONFIGNAME


# generating the keys
export JANUSKEY=$(openssl rand -base64 48)
sed -i "s|JANUSKEY|${JANUSKEY}|g" $CONFIGNAME

export HASHKEY=$(openssl rand -hex 16)
sed -i "s|HASHKEY|${HASHKEY}|g" $CONFIGNAME

export BLOCKKEY=$(openssl rand -hex 16)
sed -i "s|BLOCKKEY|${BLOCKKEY}|g" $CONFIGNAME

export TURNAPIKEY=$(openssl rand -base64 48)
sed -i "s|TURNAPIKEY|${TURNAPIKEY}|g" $CONFIGNAME


# creating a nextcloud.conf
cp signaling/nextcloud.conf.sample signaling/nextcloud.conf
chmod 644 signaling/nextcloud.conf


# exiting the script
echo "Config created at ${CONFIGNAME}! You have to edit it, because we need a FQDN which must be set manually"
echo "If you want to see the generated keys, use: cat ${CONFIGNAME}"
exit 0
