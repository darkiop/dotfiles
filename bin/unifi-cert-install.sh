#!/bin/bash
#
# Installiert SSL Zertifikate für den unifi-controller (docker). Zuvor müssen diese über den DSM (Synology) exportiert werden.

echo "Installiere Zertifikat für den unifi-controller ..."
echo "Der Export des Zertifikates vom Synology DSM muss unter /var/lib/unifi/cert-import liegen (3 Dateien)"
echo "Achtung: Ein Passwort muss vergeben werden!"

cd /var/lib/unifi/cert-import

openssl pkcs12 -export -in cert.pem -inkey privkey.pem -out unifi.p12 -name unifi -CAfile fullchain.pem -caname root
keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore /var/lib/unifi/keystore -srckeystore unifi.p12 -srcstoretype PKCS12 -alias unifi

#EOF
