docker-firefox-java6
==============

Firefox over Docker via VNC including the necessary Java plugins to support working with a bunch of old Java/Web based management interfaces, such as old Dell DRAC, or Brocade FC switches.  This is the product of not being able to access old Dell 1950 servers using current browsers.   This Docker image provides an easy way to spin up a browser with full support.

This Dockerfile is based on the work found here:
https://github.com/creack/docker-firefox
https://github.com/jvdneste/docker-novnc
https://github.com/ktelep/docker-firefox-java

How to execute:

1.  Build the docker image


    docker build -t "docker-firefox-java6:latest" .


2.  Start the container


    docker run --rm --net=host -d --name docker-firefox-java6 --hostname docker-firefox-java6 docker-firefox-java6:latest


3.  Connect to Firefox using your VNC client of choice on port 5900 


You may wish to add a -v <localpath>:<containerpath> if you want to use Virtual Media or the like to mount ISOs for loading Operating Systems/etc. on servers.


