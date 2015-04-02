# April Fools' proxy
This is a squid2 + apache2 box to replace all images on any website with a bunch of funny effects.
I have used it on April Fools' Day at my workplace.

I have built a 4-node CoreOS cluster + a load balancer in front of them (see `haproxy.cfg`), but you can scale it as you want.

## Inspiration & credits for the basic idea

* http://www.ex-parrot.com/pete/upside-down-ternet.html
* http://prank-o-matic.com/

## Effects
* **rewrite.pl**: upside-down, wave, monochromize, etc.
* **ascii.pl**: turn images into ASCII art
* **tourette.pl**: convert images to animgif with blinking phrases
* **watermark.pl**: insert the face picture of my boss to all images

##Demo

[![Demo](http://img.youtube.com/vi/PJeTTJ2p-9c/0.jpg)](http://www.youtube.com/watch?v=PJeTTJ2p-9c)


## Usage

### Network requirements for the prank

I have set up a transparent proxy in the office, so everyone's traffic went through my proxy cluster.
Basically, you just have to set up a NAT redirection from `LAN -> *:80` to `proxymachine:8080`.
It depends on your environment, you can find easily a lot of howtos on the Internet.

If you want to use the load balancer, just pull a basic haproxy image and bind mount the config file to the container and that's it!

### CoreOS

I have used 4 CoreOS nodes so I can scale it up easily, as we have a lot of coworkers with a high web traffic.
I used PXE booted CoreOS with a basic `pxe-cloud-config.yml` with custom services, you can see the service definitions in the repo as well.
From pushing the power button to have an operating proxy, it takes about 2-3 minutes. Automagically!


### The docker part

The docker container can be downloaded from the official Docker Hub:
https://registry.hub.docker.com/u/dmegyesi/aprilfoolsproxy/

`docker pull dmegyesi/aprilfoolsproxy`


To start the service, listening on *docker_host_machine:8080*:

`docker run --name aprilfoolsproxy -d -i -t -p 8080:3128 dmegyesi/aprilfoolsproxy`

### If you want to build it on your own

`docker build -t dmegyesi/aprilfoolsproxy .`

### If you want to replace the effect

1. modify the `url_rewrite_program` parameter in `/etc/squid/squid.conf`
 * please note the container doesn't have vim or other editors; however, you can use sed, see Dockerfile for reference
2. reload/restart squid process

The default script is `rewrite.pl`.
