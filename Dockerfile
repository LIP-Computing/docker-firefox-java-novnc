# Firefox over VNC
#
# VERSION               0.1
# DOCKER-VERSION        0.2

from	f69m/ubuntu32:14.04

ENV SERVERNUM 1

# make sure the package repository is up to date
run \
  echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list \
    && apt-get update

# add java oracle repository
#run     apt-get install -y python-software-properties
#RUN     add-apt-repository ppa:webupd8team/java
#run	apt-get update

# Install java versions
#RUN     apt-get install oracle-java6-installer
#RUN     apt-get install oracle-java7-installer
#RUN     apt-get install oracle-java8-installer

# Install vnc, xvfb in order to create a 'fake' display and firefox
#run	apt-get install -y x11vnc xvfb openbox

RUN \
  apt-get update \
    && apt-get install -y \
# X Server
      xvfb \
# VNC Server
      x11vnc \
# Window manager
      i3 \
# NoVNC with dependencies
      wget tar net-tools python-numpy novnc \
  # must switch to a release tag once the ssl-only arg included
    && wget -O- https://github.com/novnc/noVNC/archive/v0.4.tar.gz | tar zxv -C / \
    && mv /noVNC-0.4 /noVNC \
    #&& wget -O- https://github.com/novnc/websockify/archive/v0.2.0.tar.gz | tar zxv -C /noVNC/utils/ \
    #&& mv /noVNC/utils/websockify-0.2.0 /noVNC/utils/websockify \
# Clean up the apt cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

#RUN \
#  apt-get update \
#    && apt-get install -y \
#      vim wget byobu libgtk-3.0 libwebkitgtk-3.0

# Install the specific tzdata-java we need
run \
  apt-get update \
    && apt-get -y install wget \
    && wget --no-check-certificate https://launchpad.net/ubuntu/+archive/primary/+files/tzdata-java_2016j-0ubuntu0.14.04_all.deb \
    && dpkg -i tzdata-java_2016j-0ubuntu0.14.04_all.deb \
    && apt-get install -y tzdata \
    && apt-get clean

# Install Firefox and Java Plugins
run \
  apt-get install -y firefox icedtea-6-plugin icedtea-netx openjdk-6-jre openjdk-6-jre-headless tzdata-java \
    && mkdir ~/.vnc

# Autostart firefox (might not be the best way to do it, but it does the trick)
#run     bash -c 'echo "exec openbox-session &" >> ~/.xinitrc'
#run     bash -c 'echo "firefox" >> ~/.xinitrc'
#run     bash -c 'chmod 755 ~/.xinitrc'

# Entry point
#x11vnc -forever -create

# Run noVNC
CMD \
# X Server
  cd /root \
    && rm -f /tmp/.X1-lock \
    && setcap -r `which i3status` \
    && xvfb-run -f /root/.xvfbauth -n $SERVERNUM -s '-screen 0 1600x900x16' i3 & \
# Firefox
  firefox & \
# VNC Server
  if [ -z $VNC_PASSWD ]; then \
    # no password
    x11vnc -auth /root/.xvfbauth -display :$SERVERNUM -xkb -forever & \
  else \
    # set password from VNC_PASSWD env variable
    mkdir -p ~/.x11vnc \
      && sleep 3 \
      && x11vnc -storepasswd $VNC_PASSWD /root/.x11vnc/passwd \
      && x11vnc -auth /root/.xvfbauth -display :$SERVERNUM -xkb -forever -rfbauth /root/.x11vnc/passwd & \
  fi \
# NoVNC
    && openssl req -new -x509 -days 36500 -nodes -batch -out /root/noVNC.pem -keyout /root/noVNC.pem \
    && ln -sf /noVNC/vnc.html /noVNC/index.html \
    && /noVNC/utils/launch.sh --vnc localhost:5901 --cert /root/noVNC.pem
