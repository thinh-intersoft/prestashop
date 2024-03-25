#!/bin/bash
set -e

# Install jq
echo "Installing jq"
apt-get -qq update > /dev/null
apt-get -yqq install jq > /dev/null

# Ngrok configuration
PS_DOMAIN=$( \
  curl -s 'http://ngrok:4040/api/tunnels' \
  | jq -r .tunnels[0].public_url \
  | sed 's/https\?:\/\///' \
)

if [ -z "$PS_DOMAIN" ]; then
  echo "Error: cannot guess ngrok domain. Exiting" && exit 2;
else
  echo "🎊🎊🎊🎊 $PS_DOMAIN 🎊🎊🎊🎊 ngrok detected!"
fi

# Hard coding the variable within docker_run.sh
sed -i "2 i PS_DOMAIN=$PS_DOMAIN" /tmp/docker_run.sh
