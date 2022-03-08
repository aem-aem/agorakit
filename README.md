# Agora
Private install of Agorakit

Source: https://docs.agorakit.org/#/en/install

[Support](https://agorakit.org/fr/soutenir.php) and thanks to [Philippe](https://github.com/philippejadin), author of [Agorakit](https://github.com/agorakit/agorakit)

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
`docker-compose build agorakit db`

`docker-compose up -d`
  
# Stop
`docker-compose down`

# Init database and fill it with dummy content
`docker exec -it agorakit.local php artisan migrate --force`

`docker exec -it agorakit.local php artisan db:seed --force`

# Schedule notifications sending and maintenance tasks
`crontab -l | cat - crontab | sort -u > /tmp/crontab && crontab /tmp/crontab`

# Backup database and storage
Storage and database are persisted into a docker volume

A backup every 6 hours of storage and database dump is already configured to work with MEGA.nz cloud storage (included in crontab maintenance tasks)

To authenticate with your MEGA.nz account you need to login only once : `docker exec -it agorakit.local mega-login <your email> '<your password>'`
  
