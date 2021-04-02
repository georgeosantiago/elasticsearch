docker run \
--rm -h logstash --name logstash_tmp --network es-tier --env ES_JAVA_OPTS="-Xms256m -Xmx256m" \
-v /opt/docker/elasticsearch/logstash/logstash_csv.conf:/usr/share/logstash/pipeline/logstash.conf  \
-v /opt/docker/elasticsearch/logstash/logstash.yml:/usr/share/logstash/config/logstash.yml  \
-v /opt/docker/elasticsearch/logstash/numeraciongeografica.csv:/csv/numeraciongeografica.csv  \
docker.elastic.co/logstash/logstash:7.10.2
