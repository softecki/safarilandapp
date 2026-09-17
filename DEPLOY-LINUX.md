# Deploy Pamoja on a Linux server

This file is the Linux install guide for the three Pamoja surfaces:

| App | Folder | What it is | Needs disk writes |
|---|---|---|---|
| Fan website | `pamojaweb` | Next.js fan portal | No |
| Admin / OPS | `pamojadmin` | Next.js ops portal | **Yes** — `data/*.txt` is the database |
| Super App | `pamojaapp` | Flutter (optional web build) | No (static files) |

Use a real Linux VM (Ubuntu 22.04 or 24.04). Do not deploy OPS to serverless hosting if you want create/edit/delete to persist. The admin app stores all records as text files on disk.

Suggested public URLs:

- Fan site: `https://pamoja.africa` → port 3000
- OPS: `https://ops.pamoja.africa` → port 3001
- Flutter web (optional): `https://app.pamoja.africa`

Demo login (unchanged):

- Fan OTP `481028` / password `Pamoja2027`
- Admin `admin@pamoja.africa` / `Pamoja2027!`

---

## 1. Server layout

SSH in as a sudo user, then:

```bash
sudo mkdir -p /opt/pamoja
sudo adduser --system --group --home /opt/pamoja pamoja
sudo chown -R pamoja:pamoja /opt/pamoja
```

Copy the three project folders onto the server so you have:

```text
/opt/pamoja/pamojaweb
/opt/pamoja/pamojadmin
/opt/pamoja/pamojaapp      # only if you also ship Flutter web
```

Examples:

```bash
# from your Windows PC (PowerShell / Git Bash), using scp
scp -r C:/xampp/htdocs/project/pamojaweb  user@YOUR_SERVER:/tmp/
scp -r C:/xampp/htdocs/project/pamojadmin user@YOUR_SERVER:/tmp/
```

On the server:

```bash
sudo mv /tmp/pamojaweb /tmp/pamojadmin /opt/pamoja/
sudo chown -R pamoja:pamoja /opt/pamoja
```

If you use git instead:

```bash
sudo -u pamoja git clone YOUR_REPO_URL /opt/pamoja/pamojaweb
sudo -u pamoja git clone YOUR_REPO_URL /opt/pamoja/pamojadmin
```

---

## 2. Install Node.js 20 and nginx

```bash
sudo apt update
sudo apt install -y nginx curl ufw git
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v    # v20.x
npm -v
```

---

## 3. Build the Next.js apps

Fan website:

```bash
cd /opt/pamoja/pamojaweb
sudo -u pamoja npm install
sudo -u pamoja npm run build
```

Admin / OPS (this is the one with the text-file database):

```bash
cd /opt/pamoja/pamojadmin
sudo -u pamoja npm install
sudo -u pamoja npm run build
sudo mkdir -p /opt/pamoja/pamojadmin/data
sudo chown -R pamoja:pamoja /opt/pamoja/pamojadmin/data
sudo chmod 775 /opt/pamoja/pamojadmin/data
```

`pamojadmin/data/` must stay writable. Create, edit and delete in OPS rewrite files such as `fans.txt`, `wallet.txt`, `reports.txt`. Back that folder up.

Quick test (stop these with Ctrl+C after you see “Ready”):

```bash
sudo -u pamoja bash -c 'cd /opt/pamoja/pamojaweb && npx next start -p 3000'
sudo -u pamoja bash -c 'cd /opt/pamoja/pamojadmin && npx next start -p 3001'
```

---

## 4. systemd services

`/etc/systemd/system/pamoja-web.service`

```ini
[Unit]
Description=Pamoja fan website
After=network.target

[Service]
Type=simple
User=pamoja
Group=pamoja
WorkingDirectory=/opt/pamoja/pamojaweb
Environment=NODE_ENV=production
Environment=PORT=3000
ExecStart=/usr/bin/npx next start -p 3000
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

`/etc/systemd/system/pamoja-ops.service`

```ini
[Unit]
Description=Pamoja OPS admin
After=network.target

[Service]
Type=simple
User=pamoja
Group=pamoja
WorkingDirectory=/opt/pamoja/pamojadmin
Environment=NODE_ENV=production
Environment=PORT=3001
ExecStart=/usr/bin/npx next start -p 3001
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now pamoja-web pamoja-ops
sudo systemctl status pamoja-web pamoja-ops
```

Useful commands later:

```bash
sudo systemctl restart pamoja-web pamoja-ops
sudo journalctl -u pamoja-ops -f
```

---

## 5. nginx reverse proxy

`/etc/nginx/sites-available/pamoja`

```nginx
server {
    listen 80;
    server_name pamoja.africa www.pamoja.africa;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

server {
    listen 80;
    server_name ops.pamoja.africa;

    client_max_body_size 20m;

    location / {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

If you only have one domain, use paths instead:

```nginx
server {
    listen 80;
    server_name YOUR_SERVER_IP;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /ops/ {
        proxy_pass http://127.0.0.1:3001/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Activate:

```bash
sudo ln -s /etc/nginx/sites-available/pamoja /etc/nginx/sites-enabled/pamoja
sudo nginx -t
sudo systemctl reload nginx
```

Firewall:

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

---

## 6. HTTPS (Let’s Encrypt)

Point DNS A records to the server, then:

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d pamoja.africa -d www.pamoja.africa -d ops.pamoja.africa
```

Certbot rewrites the nginx file and renews automatically.

---

## 7. Text-file database (OPS)

Live data is here:

```text
/opt/pamoja/pamojadmin/data/
```

| File | Contents |
|---|---|
| `fans.txt` | Fan ID records |
| `visas.txt` | eVisa cases |
| `wallet.txt` | Ledger |
| `programs.txt` | Mini programs |
| `reports.txt` | Reports |
| `home.txt` | Home finance dashboard |
| `*.txt` | All other OPS modules |

Backup daily:

```bash
sudo mkdir -p /opt/pamoja/backups
sudo crontab -u pamoja -e
```

Add:

```cron
15 2 * * * tar -czf /opt/pamoja/backups/data-$(date +\%F).tgz -C /opt/pamoja/pamojadmin data
```

Restore:

```bash
sudo systemctl stop pamoja-ops
sudo tar -xzf /opt/pamoja/backups/data-YYYY-MM-DD.tgz -C /opt/pamoja/pamojadmin
sudo chown -R pamoja:pamoja /opt/pamoja/pamojadmin/data
sudo systemctl start pamoja-ops
```

You can also open any `.txt` file in nano/vim. Keep valid JSON.

---

## 8. Optional: Flutter Super App (web)

On a machine with Flutter installed (can be the same server if you install Flutter, or build on Windows then copy `build/web`):

```bash
cd /opt/pamoja/pamojaapp
flutter pub get
flutter build web --release --base-href /
```

Serve with nginx:

```nginx
server {
    listen 80;
    server_name app.pamoja.africa;
    root /opt/pamoja/pamojaapp/build/web;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Android APK (build on a workstation, then publish to Play or sideload):

```bash
flutter build apk --release
```

The APK is `build/app/outputs/flutter-apk/app-release.apk`.

---

## 9. Update after code changes

```bash
cd /opt/pamoja/pamojaweb && sudo -u pamoja git pull && sudo -u pamoja npm install && sudo -u pamoja npm run build
cd /opt/pamoja/pamojadmin && sudo -u pamoja git pull && sudo -u pamoja npm install && sudo -u pamoja npm run build
sudo systemctl restart pamoja-web pamoja-ops
```

Do not delete `pamojadmin/data/` on update. That folder is production data.

---

## 10. Check it works

```bash
curl -I http://127.0.0.1:3000
curl -I http://127.0.0.1:3001/login
ls -l /opt/pamoja/pamojadmin/data
```

Then in a browser:

1. Fan site → register / OTP `481028`
2. OPS → `admin@pamoja.africa` / `Pamoja2027!`
3. Issue a Fan ID, then confirm a new row appeared in `fans.txt`

---

## Common problems

| Symptom | Fix |
|---|---|
| OPS create/edit does not stick | `data/` not writable. `chown pamoja:pamoja` and `chmod 775` |
| `next start` fails | Run `npm run build` first in that app folder |
| 502 Bad Gateway | Service down: `systemctl status pamoja-ops` |
| Port already in use | `ss -lptn \| grep 3001` then stop the old process |
| Permission denied on `data/*.txt` | App must run as `pamoja`, not root, and own the files |
| Site works on IP but not domain | DNS A record, then `nginx -t` and certbot |

This stack is enough for a stakeholder / staging deploy. Production later still needs real APIs (Immigration, NIDA, Unlimit, NMB/NBC, WhatsApp) behind these same front ends.
