#!/bin/bash

# STEP 1: CLEAN SLATE (Remove Everything)
podman stop nginx-container-12319700 2>/dev/null || true
podman rm nginx-container-12319700 2>/dev/null || true
sudo systemctl stop container-nginx-container-12319700.service 2>/dev/null || true
sudo systemctl disable container-nginx-container-12319700.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/container-nginx-container-12319700.service
sudo systemctl daemon-reload
rm -rf /home/12319700/webcontent

# STEP 2: SET REGISTRATION PROMPT (PERMANENT)
echo "export PS1='[12319700]\u@\h:\w\$ '" >> ~/.bashrc
source ~/.bashrc

# STEP 3: VERIFY PODMAN
podman --version

# STEP 4: CREATE WEB CONTENT
mkdir -p /home/12319700/webcontent
cd /home/12319700/webcontent

cat > index.html << 'EOF'
<!DOCTYPE html>
<html><head><title>Podman Project 12319700</title>
<style>body{font-family:Arial;margin:40px;background:#e3f2fd;}
.container{max-width:800px;margin:auto;padding:30px;background:white;border-radius:15px;box-shadow:0 4px 12px rgba(0,0,0,0.15);}
h1{color:#1976d2;font-size:2.2em;} .success{color:#4caf50;}</style></head>
<body><div class="container">
<h1>🎉 Podman Nginx Deployment Complete!</h1>
<div style="background:#e8f5e8;padding:20px;border-left:5px solid #4caf50;">
<strong>Student:</strong> Vivek K<br>
<strong>Registration:</strong> 12319700<br>
<strong>Container:</strong> nginx-container-12319700<br>
<strong>Access:</strong> http://localhost:8080
</div>
<h2>✅ All Objectives Met:</h2>
<ul><li>Custom web page from host volume mount</li>
<li>Systemd boot autostart configured</li>
<li>Data persistence verified</li>
<li>SELinux permissions set</li></ul>
<p>Generated: $(date)</p></div></body></html>
EOF
chmod 644 index.html

# STEP 5: DEPLOY CONTAINER
podman run -d --name nginx-container-12319700 -p 8080:80 -v /home/12319700/webcontent:/usr/share/nginx/html:ro --restart unless-stopped nginx:latest

# STEP 6: SELINUX FIX (IF 403 ERROR)
chcon -Rt container_file_t /home/12319700/webcontent

# STEP 7: SYSTEMD BOOT AUTOSTART
podman generate systemd --name nginx-container-12319700 --files --new
sudo mv container-nginx-container-12319700.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable container-nginx-container-12319700.service
sudo systemctl start container-nginx-container-12319700.service

# STEP 8: FINAL VERIFICATION
podman ps
curl http://localhost:8080/
sudo systemctl is-enabled container-nginx-container-12319700.service
echo "TEST PERSISTENCE:" && echo "<p>Updated: $(date)</p>" >> index.html && curl http://localhost:8080/ | grep -i "updated"
