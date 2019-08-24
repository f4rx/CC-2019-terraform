wget https://dl.grafana.com/oss/release/grafana-6.3.3-1.x86_64.rpm
yum localinstall grafana-6.3.3-1.x86_64.rpm -y



mkdir -p /etc/grafana/dashboards
cp /tmp/bootstrap/dashboard.json /etc/grafana/dashboards/prom_dashboad.json
cp /tmp/bootstrap/dashboard.yml /etc/grafana/provisioning/dashboards/dashboard.yml
cp /tmp/bootstrap/datasource.yml /etc/grafana/provisioning/datasources/datasource.yml

cp /root/grafana.ini /etc/grafana/grafana.ini

systemctl start grafana-server
systemctl enable grafana-server



