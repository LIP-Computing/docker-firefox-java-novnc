docker-firefox-java6
==============

Firefox over Docker via VNC including the necessary Java plugins to support working with a bunch of old Java/Web based management interfaces, such as old Dell DRAC, HP iLO or switches. This project provides an easy way to spin up a browser with full support.

This Dockerfile is based on the work found here: \
https://github.com/creack/docker-firefox \
https://github.com/jvdneste/docker-novnc \
https://github.com/ktelep/docker-firefox-java

How to test:

1.  Build the docker images

    docker build -t firefox_java6_x11vnc -f Dockerfile.firefox_java6_x11vnc .

    docker build -t novnc_openbox -f Dockerfile.novnc_openbox .

2.  Start container

    docker run --rm -d --net=host --name firefox_java6_x11vnc --hostname firefox_java6_x11vnc firefox_java6_x11vnc:latest

    docker run --rm --net=host -e VNC_PORT=5901 --name novnc_openbox --hostname novnc_openbox novnc_openbox:latest

3.  Check logs with

    docker logs firefox_java6_x11vnc:latest

    docker logs novnc_openbox:latest

You may wish to add a -v <localpath>:<containerpath> if you want to use Virtual Media or the like to mount ISOs for loading Operating Systems/etc. on servers.


How to build and upload the docker images:

1.  Review required environment variables and build configurations in docker-compose.devel.yml

2.  Generate the imagens and test

    docker-compose -f docker-compose.devel.yml up -d

3.  If working as expected, push the images into configured docker registry

    docker-compose push

4.  Clean the workspace in the end

    docker-compose down --rmi all -v --remove-orphans


How to execute:

1.  Update required environment variables in docker-compose.override.yml (for example VNC_PORT)

2.  Start the services

2.1 Start the container that provides VNC with firefox for desired java version

    docker-compose up -d firefox_java6_x11vnc

2.2 Optionally start novnc container to provide a web client for VNC

    docker-compose up -d novnc_openbox

3.  Connect to Firefox using your VNC client of choice on port 5900 or any other available, as announced in the logs of VNC server

    docker-compose logs firefox_java6_x11vnc

4.  Alternatively use novnc client accessing in your browser to the following url (ignore certificate security)

    https://localhost:6080/vnc.html?host=localhost&port=6080

5.  In the end, to stop and clean all built images (excluding pulled source images), run the following command

    docker-compose down --rmi all -v --remove-orphans

