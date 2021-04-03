#!/bin/bash
docker-compose up -d elasticsearch
sleep 10
docker-compose exec -T elasticsearch ./bin/elasticsearch-setup-passwords auto --batch > passwords.txt
docker-compose down
echo "Modificar kibana.yml"