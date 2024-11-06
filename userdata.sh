#!/bin/bash
apt update
apt install -y apache2

# Get the metadata token and instance ID
METADATA_TOKEN=$(curl -s --header "X-aws-ec2-metadata-token-ttl-seconds: 60" --request PUT http://169.254.169.254/latest/api/token)
INSTANCE_ID=$(curl -s --header "X-aws-ec2-metadata-token: $METADATA_TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# Install the AWS CLI (if you need it)
apt install -y awscli

# Create a simple HTML file with the portfolio content and dynamically insert the instance ID
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Portfolio</title>
  <style>
    /* Add animation and styling for the text */
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }
    h1 {
      animation: colorChange 2s infinite;
    }
  </style>
</head>
<body>
  <h1>Terraform Project Server 1</h1>
  <h2>Instance ID: <span style="color:green">$INSTANCE_ID</span></h2>
  <p>Welcome to Abhishek Veeramalla's Channel</p>
</body>
</html>
EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2
