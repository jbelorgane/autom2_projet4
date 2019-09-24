#!/bin/sh
chmod +x deploy_logicaldoc.sh && ./deploy_logicaldoc.sh mysql && sudo docker-compose -f docker-compose-ld_mysql.yml up
