## signaling-dockerized
Whats better than the original High-Performance for Nextcloud Spreed (Talk)? Its a completly working, up-to-date and secure docker-compose stack, which can be deployed in less than 5 minutes on a docker host!  

**DISCLAIMER:** This is *not* a rewrite or something of the original Nextcloud Spreed High-Performance Backend from Struktur AG ([GitHub](https://github.com/strukturag/nextcloud-spreed-signaling)). This version/docker-compose stack is just a setup of those software and its dependencies in docker.

### Setup
Basically you need a working and of course secured docker host with bash, git and docker-compose installed on it.
You need a dns entry (e.g. signaling.yourdomain.de) with a AAAA Record to your docker host (maybe also an A record for support of legacy clients).

In the "normal" way, the stack will be deployed without a own rervse proxy. You can enter a name of a network in your `hpb.conf` for connecting to a own reverse proxy.

But if you insist, the stack is also able to ship a own caddy reverse proxy. In this case, the stack will listen on port 80/tcp and 443/tcp, so make sure, that they are not blocked by another software on your docker host.  

On your docker host you have to do the following:
```
signaling:~# cd /opt/
signaling:/opt# git clone https://codeberg.org/wh0ami/signaling-dockerized.git
Cloning into 'signaling-dockerized'...
...
signaling:/opt# cd signaling-dockerized/
# Only execute the following command, if you want to use the shipped caddy reverse proxy - otherwise skip the next command!
signaling:/opt/signaling-dockerized# ln -s extras/docker-compose.override.yml docker-compose.override.yml
signaling:/opt/signaling-dockerized# ./generate_config.sh
Config created at hpb.conf! You have to edit it, because we need a network and a FQDN which must be set manually
If you want to see the generated keys, use: cat hpb.conf
signaling:/opt/signaling-dockerized# vi hpb.conf # enter your domain name and network mentioned above in this file
signaling:/opt/signaling-dockerized# vi signaling/nextcloud.conf # configure your nextcloud instance like mentioned in the comments of this file
signaling:/opt/signaling-dockerized# bash fixPermissions.sh
signaling:/opt/signaling-dockerized# docker-compose up -d --build
...
```
The last step can take a few minutes, because the docker images will be built locally on your docker host. It mainly depends on the network and computing performance of your docker host.

If you use a own revese proxy, dont forget to configure it - the singaling container will listen to your requests at `http://signaling:8080`.

Now you should be already done. You can enter your instance url and your secret now in your nextcloud instance and can start using Nextcloud Spreed/Talk. 


**Hint:** the shipped caddy reverse proxy obtains and manages the TLS certificate automatically from Lets Encrypt - this can take a few seconds or maybe minutes. But normally caddy is very fast and reliable.  
  
In your nextcloud, you have to configure your signaling server in the nextcloud talk settings like this:
![screenshots/nextcloud-setup.png](https://codeberg.org/wh0ami/signaling-dockerized/raw/branch/main/screenshots/nextcloud-setup.png)  

---

### Logging and Status
The status of your container could be displayed with `docker-compose ps`.  
You can access the logs using `docker-compose logs`. Optionally you can also add a container name behind this command to see only the logs for a specific container. Further tips you can see with `docker-compose logs --help`.

### Updating
You can update your stack with the `update.sh` script. It will pull this repository, the docker images, re-built the other docker images locally, recreate the containers and delete old ("dangling") images.  

With the parameter `-n` you can run the script in a non-interactive mode - this will run the deletion of the old images with a force flag, so that you wont be asked whether you want delete those old images or not.  

Further, you can also pass the `-d` parameter if you just want to prepare an update. With this parameter there will be no container recreation (`docker-compose up -d`).  

### Uninstalling
Just do the following:
```
signaling:~# cd /opt/signaling-dockerized/
signaling:/opt/signaling-dockerized# docker-compose down -v --rmi all --remove-orphans
...
signaling:/opt/signaling-dockerized# cd ~
signaling:~# rm -rf /opt/signaling-dockerized/
```
Maybe you also want to delete the container images - `docker image prune -a` will help you doing this. And you may also want to use `docker volume prune` and `docker system prune`, but BE CAREFUL: this could also delete stuff from other containers, e.g. unused volumes or something.

### "Why shouldnt i use the docker-compose stack from the original nextcloud-spreed-signaling maintainer?"
In my opinion it is clearly unsafe and outdated. Just take a look in the Dockerfiles and you will see what i am talking about. Further more, nearly all processes in the containers are running as root and there are no security improvements like dropped capabilities or read only.  
Additionally to that, the standard stack does not contain a reverse proxy, so you have to configure and to get the TLS certificates by yourself.  
Another point is, that the standard stack exposes all ports of the services running in the docker containers, but none of them are required to be exposed. Since docker takes control over your iptables, you even cannot even restrict this behaviour. All containers are in the same network and can communicate which each other, which is also not required and a potential security risk.  
  
My personal goal is, to do it better and to provide an good alternative to this kind of security-gore.  

If you are anybody of the original nextcloud-spreed-signaling maintainers, you maybe you dont like this part of the README. Consider this as friendly criticism and take better care of your stack. Thank you!  

### ToDo
- testing and bugfixing
- adding resource limits to docker-compose.yml
- using a stable nextcloud-spreed-signaling release (not before v0.2.1)
