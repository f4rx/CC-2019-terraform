

yum install -y git wget
wget https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.12.9.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin



git clone https://github.com/f4rx/cameron.git
cd cameron
go build

cp cameron /usr/local/bin/avatar

groupadd avatar
useradd -g avatar avatar

cat >  /etc/systemd/system/avatar.service << 'EOF'
[Unit]
Description=Avatar
Wants=network-online.target
After=network-online.target

[Service]
User=avatar
Group=avatar
Type=simple
ExecStart=/usr/local/bin/avatar
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable avatar
