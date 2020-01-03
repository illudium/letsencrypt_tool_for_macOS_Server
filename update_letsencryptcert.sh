#!/bin/sh

## update_letsencryptcert.sh

## This very loosely based on & uses content from 
## https://github.com/physcip/letsencrypt-mac/blob/master/hooks.sh

## IMPORTANT: This tool is designed specifically to work with certbot as installed via MacPorts,
## See https://www.macports.org/ports.php?by=name&substr=certbot

## You need to customized DOMAIN_DEFAULT below

DOMAIN_DEFAUT=fqdn.ofSite.com
PEM_FOLDER="/opt/local/etc/letsencrypt/live/${DOMAIN_DEFAUT}/" 
LOG_FOLDER="/var/log/letsencrypt/" 
DATE=$(date +"%d-%m-%y")
LOG_FILE="${LOG_FOLDER}/get_cert_${DATE}.log" 
 
# Generate a passphrase - UNCOMMENT(ED) THE NEXT LINE AFTER THE TEST RUN WORKS
PASS=$(openssl rand -base64 45 | tr -d /=+ | cut -c -30)

# Custom routine that I added, move the former p12 file
if [ -f "${PEM_FOLDER}letsencrypt_sslcert.p12.old" ]; then 
 rm "${PEM_FOLDER}letsencrypt_sslcert.p12.old"
fi

if [ -f "${PEM_FOLDER}letsencrypt_sslcert.p12" ]; then
 mv "${PEM_FOLDER}letsencrypt_sslcert.p12" "${PEM_FOLDER}letsencrypt_sslcert.p12.old"
fi

# Transform the pem files into a OS X Valid p12 file - UNCOMMENT(ED) THE NEXT LINE AFTER THE TEST RUN WORKS
sudo openssl pkcs12 -export -inkey "${PEM_FOLDER}privkey.pem" -in "${PEM_FOLDER}cert.pem" -certfile "${PEM_FOLDER}fullchain.pem" -out "${PEM_FOLDER}letsencrypt_sslcert.p12" -passout pass:$PASS

# import the p12 file in keychain - UNCOMMENT(ED) THE NEXT LINE AFTER THE TEST RUN WORKED
security import "${PEM_FOLDER}letsencrypt_sslcert.p12" -f pkcs12 -k /Library/Keychains/System.keychain -P $PASS -T /Applications/Server.app/Contents/ServerRoot/System/Library/CoreServices/ServerManagerDaemon.bundle/Contents/MacOS/servermgrd

oldcert="${PEM_FOLDER}letsencrypt_sslcert.p12.old"
newcert="${PEM_FOLDER}letsencrypt_sslcert.p12"
/Applications/Server.app/Contents/ServerRoot/usr/sbin/certupdate replace -c $newcert -C $oldcert
