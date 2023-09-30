

## 安装 Nginx

```bash
$ sudo apt -y update
$ sudo apt -y install nginx

$ sudo usermod -aG adm ubuntu
```

## 生成证书

### 安装 certbot

```bash
$ sudo apt-get update
$ sudo apt-get install python3-pip
$ sudo apt-get install certbot python3-certbot-nginx
$ sudo pip3 install certbot-dns-cloudflare
```

### 生成证书

```bash
$ cat <<EOF | sudo tee /etc/cloudflare.ini > /dev/null
# Cloudflare API credentials used by Certbot
dns_cloudflare_api_token = "your-api-token-here"
EOF
$ sudo chmod 600 /etc/cloudflare.ini

$ sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/cloudflare.ini -d "*.localgpt.net"
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/localgpt.net/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/localgpt.net/privkey.pem
This certificate expires on 2023-12-28.
```

## 配置反向代理

### 代理Google

```bash
$ cat <<EOF | sudo tee /etc/nginx/sites-available/reverse-proxy.conf > /dev/null
server {
    listen 443 ssl http2;
    server_name g.localgpt.net;
    
    ssl_certificate /etc/letsencrypt/live/localgpt.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/localgpt.net/privkey.pem;

    location / {
        proxy_pass https://www.google.com;
        proxy_set_header Host www.google.com;
        proxy_http_version 1.1;
        
        proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        proxy_ssl_ciphers HIGH:!aNULL:!MD5;
        proxy_ssl_verify off;
        
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
```

### 代理POE

```bash
$ openssl s_client -connect poe.com:443

$ cat <<EOF | sudo tee /etc/nginx/sites-available/reverse-proxy.conf > /dev/null
server {
    listen 443 ssl http2;
    server_name poe.localgpt.net;
    
    ssl_certificate /etc/letsencrypt/live/localgpt.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/localgpt.net/privkey.pem;

    location / {
        proxy_pass https://poe.com;
        proxy_set_header Host poe.com;        
        proxy_ssl_server_name on;
        proxy_ssl_protocols TLSv1.3;
        proxy_ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384;
        
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
```

### 重启服务

```bash
$ sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/

$ sudo nginx -t
$ sudo systemctl restart nginx
```