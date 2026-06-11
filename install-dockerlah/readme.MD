# 🐳 install-dockerlah.sh

Auto-scripted by **MinKacakZ** — Use It Wisely ⚡

A one-command Docker installer for **Ubuntu 24.04 LTS** with a colourful, step-by-step terminal UI.

---

## 🚀 Quick Start

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aezmine/autoscript/main/install-dockerlah/install-dockerlah.sh)
```

Or download and inspect first (recommended):

```bash
curl -fsSL https://raw.githubusercontent.com/aezmine/autoscript/main/install-dockerlah/install-dockerlah.sh \
  -o install-dockerlah.sh && chmod +x install-dockerlah.sh && bash install-dockerlah.sh
```

---

## 📋 What It Does

| Step | Action |
|------|--------|
| 1 | Removes conflicting old Docker packages |
| 2 | Updates & upgrades the system |
| 3 | Installs dependencies (`ca-certificates`, `curl`, `gnupg`) |
| 4 | Adds Docker's official GPG key & APT repository |
| 5 | Installs Docker CE, CLI, Buildx & Compose plugin |
| 6 | Enables & starts the Docker service |
| 7 | Adds current user to the `docker` group |
| 8 | Verifies the installation with `hello-world` |

---

## ⚙️ Requirements

- Ubuntu **24.04 LTS**
- A user with `sudo` privileges
- Internet connection

---

## ⚠️ After Install

Run this to apply the docker group without logging out:

```bash
newgrp docker
```

Or simply **log out and log back in**.

---

## 📝 Install Log

Full output is saved to:

```
/tmp/docker_install_log
```

---

## 📦 Installed Packages

- `docker-ce`
- `docker-ce-cli`
- `containerd.io`
- `docker-buildx-plugin`
- `docker-compose-plugin`

---

## 🛠️ Author

Made with 🔥 by **MinKacakZ**  
> Use it wisely.

---

## 📄 License

MIT — free to use, modify, and share.
