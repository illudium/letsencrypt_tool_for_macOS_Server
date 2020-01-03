# letsencrypt_tool_for_macOS_Server

I've posted this to provide a customized script I created to address the issue of Server.app not picking a new(ly) renewed Let's Encrypt SSL certificate.

This is known to work with OS X Server (mac OS with supporting Server.app) 10.13, anything newer will very probably require some adjustments to work as intended.

The other requirement (and basis for this tool) are that you install certbot via MacPorts, https://www.macports.org/ports.php?by=name&substr=certbot

The problem this script addressed, was that Server.app was not picking up a new(ly) renewed Let's Encrypt SSL cert.

I discovered the following, from https://certbot.eff.org/docs/using.html#renewal "You can also specify hooks by placing files in subdirectories of Certbot’s configuration directory. Assuming your configuration directory is /etc/letsencrypt, any executable files found in /etc/letsencrypt/renewal-hooks/pre, /etc/letsencrypt/renewal-hooks/deploy, and /etc/letsencrypt/renewal-hooks/post will be run as pre, deploy, and post hooks respectively when any certificate is renewed with the renew subcommand. These hooks are run in alphabetical order and are not run for other subcommands. (The order the hooks are run is determined by the byte value of the characters in their filenames and is not dependent on your locale.)"

Place update_letsencryptcert.sh in /opt/local/etc/letsencrypt/renewal-hooks/post and of course make sure the script is executable.

(Noting that MacPorts using /opt/local as the base default location for binaries it installs).
