#!/bin/bash

#
# Get digest & imageId from dockerhub
#
# usage:
#       ./get_digest.sh [username] [password] [image]
#
# before use this script, you need to install jq
# in ubuntu:
#       sudo apt-get install jq
#

USERNAME=$1         # reset USERNAME
PASSWORD=$2         # reset PASSWORD
REPOSITORY=$3       # get repositry name from argument1
TAG=""

if [ -z $4 ]
then
    TAG=latest #default tag
else
    TAG=$4
fi

#echo "$USERNAME:$PASSWORD"

# Encode or Decode base64 from the Command Line – scottlinux.com | Linux Blog
# https://scottlinux.com/2012/09/01/encode-or-decode-base64-from-the-command-line/
# 
# echo -n 'scottlinux.com rocks' | base64
# use “echo -n” to prevent the newline from echo being encoded in the result as well.
#
USERNAME_PASSWORD_BASE64=$(echo -n "$USERNAME:$PASSWORD" | base64)

#echo "$USERNAME_PASSWORD_BASE64"

#
# bash - Parsing JSON with Unix tools - Stack Overflow
# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
#
# There are a number of tools specifically designed for the purpose of manipulating JSON 
# from the command line, and will be a lot easier and more reliable than doing it with Awk, such as jq:
# curl -s 'https://api.github.com/users/lambda' | jq -r '.name'
#
# Basic access authentication - Wikiwand
# https://www.wikiwand.com/en/Basic_access_authentication
#
# if the browser uses Aladdin as the username and OpenSesame as the password, 
# then the field's value is the base64-encoding of Aladdin:OpenSesame, 
# or QWxhZGRpbjpPcGVuU2VzYW1l. Then the Authorization header will appear as:
# Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
#
# docker - Can I get an image digest without downloading the image? - Stack Overflow
# https://stackoverflow.com/questions/39375421/can-i-get-an-image-digest-without-downloading-the-image
# 
# ex:
# $ curl 'https://auth.docker.io/token?service=registry.docker.io&scope=repository:waisbrot/wait:pull' -H "Authorization: Basic ${username_password_base64}"
# store the resulting token in DT
# $ curl -v https://registry-1.docker.io/v2/waisbrot/wait/manifests/latest -H "Authorization: Bearer $DT" -XHEAD
# 
# The problem is that the default content-type being selected by the server is 
# application/vnd.docker.distribution.manifest.v1+prettyjws (a v1 manifest) and you need to v2 manifest. 
# Therefore, you need to set the Accept header to application/vnd.docker.distribution.manifest.v2+json.
#
#DT=\
#$(
#curl -s \
#"https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPOSITORY:pull&account=$USERNAME" \
#-H "Authorization: Basic $USERNAME_PASSWORD_BASE64" \
#| jq -r '.access_token'
#)

#
# dockerhub - How to determine the Docker image ID for a tag via Docker Hub API? - Stack Overflow
# https://stackoverflow.com/questions/41808763/how-to-determine-the-docker-image-id-for-a-tag-via-docker-hub-api
#
# if you want to use this on a private repo, you need to add basic auth with 
# your registry user credentials, and the additional scope parameter 'account='
# (see http://www.cakesolutions.net/teamblogs/docker-registry-api-calls-as-an-authenticated-user)
# curl -u $UNAME:$UPASS "https://auth.docker.io/token?service=registry.docker.io&sco‌​pe=repository:$REPOS‌​ITORY:pull&account=$‌​UNAME"
DT=\
$(
curl -s \
-u $USERNAME:$PASSWORD \
"https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPOSITORY:pull&account=$USERNAME" \
| jq -r '.access_token'
)

#echo "$DT"

#
# linux - How I get the HTTP responses from bash script with curl command? - Stack Overflow
# https://stackoverflow.com/questions/33300021/how-i-get-the-http-responses-from-bash-script-with-curl-command
#
# curl - How To Use
# https://curl.haxx.se/docs/manpage.html
#
# -I : fetch header only
# -s : Silent or quiet mode. Don't show progress meter or error messages.
# -i : Include the HTTP response headers in the output.
# -v : Makes curl verbose during the operation. 
# 
# linux - How do I get cURL to not show the progress bar? - Stack Overflow
# https://stackoverflow.com/questions/7373752/how-do-i-get-curl-to-not-show-the-progress-bar
#
# if for some reason that does not work on your platform, you could always redirect stderr to /dev/null
# 2>/dev/null
#
# Get image digest from remote registry via API - Open Source Projects / Open Source Registry API - Docker Forums
# https://forums.docker.com/t/get-image-digest-from-remote-registry-via-api/9480
# I need to add "Accept: application/vnd.docker.distribution.manifest.v2+json" as an HTTP header:
# curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET -vvv -k http://registry-server:5000/v2/good_image/manifests/latest
#
HEADER=\
$(
curl -s -v -I \
-H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
-H "Authorization: Bearer $DT" \
https://registry-1.docker.io/v2/$REPOSITORY/manifests/$TAG \
2>/dev/null
)

BODY=\
$(
curl -s -v \
-H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
-H "Authorization: Bearer $DT" \
https://registry-1.docker.io/v2/$REPOSITORY/manifests/$TAG \
2>/dev/null
)

DIGEST=$(echo "$HEADER" | grep Docker-Content-Digest | cut -d ':' -f3)
IMAGEID=$(echo "$BODY" | jq -r '.config.digest' | cut -d ':' -f2)

echo "The digest of $REPOSITORY is:"
echo "$DIGEST"
echo
echo "The imageId of $REPOSITORY is:"
echo "$IMAGEID"
echo

# get all tags
#curl -s -H "Authorization: Bearer $DT" https://index.docker.io/v2/$REPOSITORY/tags/list

