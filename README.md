# Docker Elasticsearch Kibana y Logstash
### docker-compose.yml
```
version: "3.9"  

services:
    elasticsearch:
        container_name: elasticsearch    
        restart: unless-stopped
        image: docker.elastic.co/elasticsearch/elasticsearch:7.10.2
        hostname: elasticsearch
        domainname: elasticsearch
        user: "root"
              
        environment:
            - bootstrap.memory_lock=true
            - "ES_JAVA_OPTS=-Xms512m -Xmx512m"                    
#            - node.name=es01
#            - cluster.name=docker-cluster
##            - discovery.seed_hosts=es02,es03
##            - cluster.initial_master_nodes=es01,es02,es03
#            - discovery.type=single-node
            
        ulimits:
          memlock:
            soft: -1
            hard: -1
        
        networks:
            - es-tier
        ports:
          - 9200:9200
          - 9300:9300
          
        volumes:
          - ./data:/usr/share/elasticsearch/data
          - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml

    kibana:
        container_name: kibana    
        restart: unless-stopped
        image: docker.elastic.co/kibana/kibana:7.10.2
        hostname: kibana
        domainname: kibana
        depends_on:
          - elasticsearch

        environment:
            - bootstrap.memory_lock=true
            - "ES_JAVA_OPTS=-Xms256m -Xmx256m"         
#            - server.name=kibana
#            - server.host="0"
#            - elasticsearch.hosts="http://elasticsearch:9200"            
      
        links:
            - "elasticsearch:elasticsearch"

        networks:
            - es-tier
        ports:
          - 5601:5601

        volumes:
          - ./kibana.yml:/usr/share/kibana/config/kibana.yml
          
    logstash:            
        container_name: logstash            
        image: docker.elastic.co/logstash/logstash:7.10.2
        hostname: logstash
        domainname: logstash
                    
        depends_on:
          - elasticsearch  
          
        entrypoint: ["echo", "Service disabled"]
            
        environment:
            - bootstrap.memory_lock=true
            - "ES_JAVA_OPTS=-Xms256m -Xmx256m"            
                    
        networks:
            - es-tier
            
        deploy:
          mode: replicated
          replicas: 1            
            
        ports:
          - 5044:5044
          - 5000:5000
          - 9600:9600
          
        volumes:
          - ./logstash/logstash_beats.conf:/usr/share/logstash/pipeline/logstash.conf
          - ./logstash/logstash.yml:/usr/share/logstash/config/logstash.yml
          - ./logstash/:/csv/
              
networks:
    es-tier:
        name: es-tier
        driver: bridge
  

   
```
