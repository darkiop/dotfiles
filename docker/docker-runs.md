docker run -d \
--name debian \
--hostname debian \
-v /var/run/docker.sock:/var/run/docker.sock \
darkiop/debian:latest

sudo mkdir -p /volume2/docker/iobroker-test-jscontroller-1.5/opt-iobroker
sudo mkdir -p /volume2/docker/iobroker-test-jscontroller-1.5/root

docker run -d \
--name=iobroker-test-jscontroller-1-5 \
--hostname=iobroker-test-jscontroller-1 \
--env="LANG=de_DE.UTF-8" \
--env="LANGUAGE=de_DE:de" \
--env="LC_ALL=de_DE.UTF-8" \
--env="TZ=Europe/Berlin" \
--env="PACKAGES=powerline dnsutils vim byobu ranger htop cifs-utils net-tools html2text fping curl speedtest-cli unzip nmap toilet jq" \
--env="AVAHI=false" \
--volume="/volume2/docker/iobroker-test-jscontroller-1.5/opt-iobroker:/opt/iobroker:rw" \
--volume="/volume2/docker/iobroker-test-jscontroller-1.5/root:/root:rw" \
--network=mac0 \
--ip=192.168.1.87 \
--dns=192.168.1.43 \
--restart=no \
buanet/iobroker:beta


sudo mkdir -p /volume2/docker/iobroker-test-jscontroller-2.0/opt-iobroker
sudo mkdir -p /volume2/docker/iobroker-test-jscontroller-2.0/root

docker run -d \
--name=iobroker-test-jscontroller-2-0 \
--hostname=iobroker-test-jscontroller-2 \
--env="LANG=de_DE.UTF-8" \
--env="LANGUAGE=de_DE:de" \
--env="LC_ALL=de_DE.UTF-8" \
--env="TZ=Europe/Berlin" \
--env="PACKAGES=powerline dnsutils vim byobu ranger htop cifs-utils net-tools html2text fping curl speedtest-cli unzip nmap toilet jq" \
--env="AVAHI=false" \
--volume="/volume2/docker/iobroker-test-jscontroller-2.0/opt-iobroker:/opt/iobroker:rw" \
--volume="/volume2/docker/iobroker-test-jscontroller-2.0/root:/root:rw" \
--network=mac0 \
--ip=192.168.1.88 \
--dns=192.168.1.43 \
--restart=no \
buanet/iobroker:beta
