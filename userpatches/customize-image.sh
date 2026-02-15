#!/bin/bash
set -e

# 启用p910nd（USB打印转发，端口9100）
systemctl enable p910nd
systemctl start p910nd

# 启用CUPS（网页管理：631端口）
systemctl enable cups
systemctl start cups

# 防火墙放行9100/631
ufw allow 9100/tcp
ufw allow 631/tcp

# 配置p910nd（默认/dev/usb/lp0）
cat > /etc/default/p910nd <<EOF
P910ND_OPTS="-f /dev/usb/lp0"
EOF

# 配置CUPS允许远程访问
sed -i 's/Listen localhost:631/Port 631/' /etc/cups/cupsd.conf
sed -i 's/<Location \/>/<Location \/>\n  Allow all/' /etc/cups/cupsd.conf
