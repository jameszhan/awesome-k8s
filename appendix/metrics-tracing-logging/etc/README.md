



```bash
$ grafana-server -config grafana/grafana.ini

$ prometheus --web.listen-address=localhost:9090 --storage.tsdb.path=/var/prometheus/data --config.file=prometheus/prometheus.yml

$ alertmanager --web.listen-address=localhost:9093 --storage.path=/var/alertmanager/data --config.file=alertmanager/alertmanager.yml
```