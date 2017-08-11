openssl req -nodes -newkey rsa:2048 -keyout /etc/gitlab/ssl/10.1.53.168.key -out /etc/gitlab/ssl/10.1.53.168.csr
cp -v /etc/gitlab/ssl/10.1.53.168.{key,original}
openssl rsa -in /etc/gitlab/ssl/10.1.53.168.original -out /etc/gitlab/ssl/10.1.53.168.key
rm -v /etc/gitlab/ssl/10.1.53.168.original
openssl x509 -req -days 1460 -in /etc/gitlab/ssl/10.1.53.168.csr -signkey /etc/gitlab/ssl/10.1.53.168.key -out /etc/gitlab/ssl/10.1.53.168.crt
rm -v /etc/gitlab/ssl/10.1.53.168.csr
chmod 600 /etc/gitlab/ssl/10.1.53.168.*

