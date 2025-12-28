#!/bin/bash
set -e

# -----------------------------
# Update system
# -----------------------------
yum update -y

# -----------------------------
# Install Apache
# -----------------------------
yum install httpd -y

# -----------------------------
# Start and enable Apache
# -----------------------------
systemctl start httpd
systemctl enable httpd

# -----------------------------
# Get metadata token (IMDSv2)
# -----------------------------
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# -----------------------------
# Get instance metadata
# -----------------------------
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

PUBLIC_DNS=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-hostname)

HOSTNAME=$(hostname)

DEPLOY_TIME=$(date)

# -----------------------------
# Create HTML page
# -----------------------------
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Backend Server</title>
    <style>
        body {
            font-family: Arial;
            background: #1e1e2f;
            color: white;
            padding: 40px;
        }
        .box {
            background: rgba(255,255,255,0.1);
            padding: 25px;
            border-radius: 10px;
        }
        h1 { color: #ffd700; }
        p { margin: 8px 0; }
    </style>
</head>
<body>
    <div class="box">
        <h1>Backend Web Server</h1>
        <p><b>Hostname:</b> $HOSTNAME</p>
        <p><b>Private IP:</b> $PRIVATE_IP</p>
        <p><b>Public IP:</b> $PUBLIC_IP</p>
        <p><b>Public DNS:</b> $PUBLIC_DNS</p>
        <p><b>Deployed At:</b> $DEPLOY_TIME</p>
        <p><b>Status:</b> Active Backend Server</p>
        <p><b>Managed By:</b> Terraform</p>
    </div>
</body>
</html>
EOF

# -----------------------------
# Set permissions
# -----------------------------
chmod 644 /var/www/html/index.html

echo "Apache backend setup completed"
