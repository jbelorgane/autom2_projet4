#!/bin/sh
chmod +x deploy_logicaldoc.sh && ./deploy_logicaldoc.sh postgres && sudo docker-compose -f docker-compose-ld_postgres.yml up
