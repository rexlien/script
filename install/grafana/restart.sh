docker volume create grafana-storage

# start grafana
docker stop grafana | true
docker rm grafana | true
docker run -d --restart=always -p 3000:3000 --name=grafana -v grafana-storage:/var/lib/grafana -e "GF_INSTALL_PLUGINS=grafana-piechart-panel" grafana/grafana 