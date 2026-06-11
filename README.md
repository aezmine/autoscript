# 🚀 autoscript

> **One command. Full server. Go touch grass.**  
> Auto-installer for FYP / personal VPS — Ubuntu 24.04 LTS

Made by **Azmin** · [minazmin.my](https://minazmin.my) · Maybe have error, just contact me 😄

---

## ⚡ Quick Install

Copy, paste, done.

```bash
bash <(wget -qO- https://raw.githubusercontent.com/aezmine/autoscript/main/fyp-installer.sh)
```

> ✅ Run as **root** or with `sudo`

---

## 📦 What Gets Installed

| Component | Version | Purpose |
|-----------|---------|---------|
| ☕ Java (OpenJDK) | 21 | Run your Spring Boot / WAR app |
| 🐱 Apache Tomcat | 9.0.118 | Java web server |
| 🗄️ MySQL | Latest | Database |
| 🌐 Nginx | Latest | Reverse proxy |
| 🔒 SSL (Certbot) | Latest | Free HTTPS via Let's Encrypt |
| 🔥 UFW Firewall | Latest | Block bad stuff |

---

## 🗺️ How It Works

```
You run the script
      │
      ▼
  Ask for domain ──────────────────────────┐
      │                                    │
      ▼                                    ▼
 Update system                    e.g. fyp.minazmin.my
      │
      ▼
Install Java → MySQL → Nginx → Tomcat → UFW
      │
      ▼
Configure Nginx as reverse proxy
(yoursite.com → localhost:8080)
      │
      ▼
 DNS check → install SSL
      │
      ▼
   🎉 Done!
```

---

## 🛠️ After Install — Deploy Your App

**Step 1 — Rename your build**
```
myapp.war  →  ROOT.war
```

**Step 2 — Upload to VPS**
```bash
scp ROOT.war root@your-server-ip:/tmp/
```

**Step 3 — Deploy it**
```bash
sudo rm -rf /opt/tomcat/webapps/ROOT
sudo rm -f  /opt/tomcat/webapps/ROOT.war
sudo cp /tmp/ROOT.war /opt/tomcat/webapps/
sudo systemctl restart tomcat
```

**Step 4 — Check logs**
```bash
tail -f /opt/tomcat/logs/catalina.out
```

That's it. Your app is live at `https://yourdomain.com` 🎉

---

## 🗄️ MySQL Credentials

> ⚠️ Default credentials — change these if it's a public server!

| Field | Value |
|-------|-------|
| Database | `fypdb` |
| Username | `root` |
| Password | `admin` |

```bash
# Access MySQL
mysql -u root -padmin

# Use the database
USE fypdb;
```

---

## 🩺 Useful Commands

```bash
# Restart everything
systemctl restart tomcat nginx mysql

# Check service status
systemctl status tomcat
systemctl status nginx

# View Tomcat live logs
tail -f /opt/tomcat/logs/catalina.out

# Test Nginx config before restarting
nginx -t

# Renew SSL (auto-renews, but manual if needed)
certbot renew
```

---

## 🌍 DNS Setup

Before running the script (or when prompted), make sure you have this DNS record:

| Type | Host | Value |
|------|------|-------|
| `A` | `yourdomain.com` | `your-server-ip` |

Not sure what your server IP is?
```bash
curl ifconfig.me
```

---

## 🏗️ Server Architecture

```
Internet
   │
   ▼
[ Nginx :80/:443 ]  ← handles SSL, static files
   │
   ▼ proxy_pass
[ Tomcat :8080 ]    ← runs your WAR / Java app
   │
   ▼
[ MySQL :3306 ]     ← stores your data
```

---

## ⚠️ Tested On

- ✅ Ubuntu 24.04 LTS (x86_64)
- ✅ Ubuntu 24.04 LTS (ARM64 / aarch64)
- 🤷 Other distros — maybe works, maybe not, good luck

---

## 😅 Known Issues / Disclaimer

- Script might have bugs — it's built for fun and FYP projects
- MySQL password is `admin` — don't blame me if production gets hacked 😅
- DNS propagation can take a few minutes, be patient
- If Tomcat doesn't start, check Java path in `/etc/systemd/system/tomcat.service`

**Got an error?** Contact me → [minazmin.my](https://minazmin.my)  
I'll try to help, no promises though 😄

---

## 📄 License

Do whatever you want with it. Just don't sell it and pretend you made it 🙃

---

<div align="center">

Built with ☕ and lack of sleep by **Azmin**  
[minazmin.my](https://minazmin.my)

</div>
