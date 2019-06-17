# https://docs.docker.com/compose/compose-file/compose-file-v2/

---
version: "2"
services:
  iobroker:
    image: buanet/iobroker:latest
    container_name: iobroker-master
    volumes:
      - /volume1/docker/iobroker-master:/opt/iobroker
      - /volume1/docker/iobroker-master/home_root:/root
    restart: unless-stopped
    networks:
      - mac0
      app_net:
        ipv4_address: 192.168.1.82
    dns: 192.168.1.43
