# agorakit
Private install of Agorakit

# Update with your domain
`for file in agorakit/000-default.conf certbot certbot.renew agorakit/default-ssl.conf agorakit/.env ; do sed -i 's/domain\.com/<YOUR DOMAIN>/' $file; done`

# Update with your email password, and use the same for internal mariadb user
`for file in docker-compose.yml agorakit/.env ; do sed -i 's/p@ssw0rd/<YOUR PASSWORD>/' $file; done`

# Generate Let's encrypt SSL certificate for your domain
Pre-requisites:
- DNS A record pointing <YOUR DOMAIN> to the IP of your server
- Appropriate firewall rules:
```
sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
```

`sh certbot`

# Build and start
`docker-compose build agorakit`

`docker-compose up -d`

# Init database and fill it with dummy content
`docker exec -it agorakit.local php artisan migrate --force`

`docker exec -it agorakit.local php artisan db:seed --force`

# Schedule notifications sending
`crontab -l | cat - crontab > /tmp/crontab && crontab /tmp/crontab`
