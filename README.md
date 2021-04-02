# Docker Elasticsearch Kibana y Logstash
### docker-compose.yml
'''
version: '2'

services:

  apache:
    container_name: apache  
    image: bitnami/apache:latest
    networks:
      - app-tier        
    ports:
      - 80:8080
    volumes:
      - /opt/docker/amp/apache-vhost/myapp.conf:/vhosts/myapp.conf:ro
      - /opt/docker/amp/html:/app
      
  nginx:
    container_name: nginx  
    image: bitnami/nginx:latest
    depends_on:
      - php-fpm    
    networks:
      - app-tier            
    links:
      - php-fpm:php-fpm    
    ports:
      - 8080:8080
    volumes:
      - /opt/docker/amp/nginx-vhost/my_server_block.conf:/opt/bitnami/nginx/conf/server_blocks/yourapp.conf
      - /opt/docker/amp/html:/app

  mariadb:
    container_name: mariadb 
    image: bitnami/mariadb:latest
    networks:
      - app-tier            
    environment:
      - MARIADB_ROOT_PASSWORD=1sushi
    ports:
      - 3306:3306
    volumes:
      - mariadb_data:/bitnami/mariadb

  php-fpm:
    image: bitnami/php-fpm:latest
    networks:
      - app-tier     
    container_name: php-fpm
    links:
      - "mariadb:database"    
    ports:
      - 9000:9000    
    volumes:
      - /opt/docker/amp/html:/app

networks:
  app-tier:
    driver: bridge

volumes:
  mariadb_data:
    driver: local
'''
