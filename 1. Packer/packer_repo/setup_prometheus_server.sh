yum install -y wget
wget https://github.com/prometheus/prometheus/releases/download/v2.12.0/prometheus-2.12.0.linux-amd64.tar.gz
tar xvf prometheus-2.12.0.linux-amd64.tar.gz
cp prometheus-2.12.0.linux-amd64/prometheus /usr/local/bin/

groupadd prometheus
useradd -g prometheus -d /var/lib/prometheus/ -m prometheus

cat >  /etc/systemd/system/prometheus.service << 'EOF'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yaml \
    --storage.tsdb.path /var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable prometheus

mkdir /etc/prometheus/
