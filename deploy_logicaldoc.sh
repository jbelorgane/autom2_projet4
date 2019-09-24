#!/bin/sh

usage(){
    echo "$0 <all|mysql|postgres> \n"
    echo "exemple 1 : $0 all "
    echo "exemple 2 : $0 mysql "
    echo "exemple 3 : $0 postgres "
    exit $1
}

# Controle du nombre d'arguments saisi (doit etre egal a 1)
[ $# -ne 1 ] && usage 1

# Controle de la variable ${SGBDR} si saisie (doit etre egale a 'all' ou  'mysql' ou 'postgres')
SGBDR="$1"
SGBDR_ALL="all"
SGBDR_MYSQL="mysql"
SGBDR_POSTGRES="postgres"
if [ "${SGBDR}" != "${SGBDR_ALL}" -a "${SGBDR}" != "${SGBDR_MYSQL}" -a "${SGBDR}" != "${SGBDR_POSTGRES}" ] 
then
        echo "Argument '${SGBDR}' non valide !"
        usage 2
fi

# Renseignement des autres variables 
AUTO_IDX_FILE="$(basename $0 .sh).idx" ; [ ! -s ${AUTO_IDX_FILE} ] && echo "0" > ${AUTO_IDX_FILE} 
#
DC_LD_POSTGRES="docker-compose-ld_postgres.yml"
TEMP_DC_LD_POSTGRES="docker-compose-ld_postgres_XX.yml"
#
DC_LD_MYSQL="docker-compose-ld_mysql.yml"
TEMP_DC_LD_MYSQL="docker-compose-ld_mysql_XX.yml"


# ======================================================================
# Generation des fichiers docker_compose* a partir des fichiers template
# ======================================================================
IDX=$(cat ${AUTO_IDX_FILE})
IDX=$(expr ${IDX} + 1)
F_IDX=`echo ${IDX} | awk '{printf("%02d", $1);}'`
#echo "IDX=${IDX}, F_IDX=${F_IDX}"

case ${SGBDR} in
    ${SGBDR_POSTGRES}) 
        # TEMP_DC_LD_POSTGRES --> DC_LD_POSTGRES
        sed "s/XX/${F_IDX}/g" ${TEMP_DC_LD_POSTGRES} > ${DC_LD_POSTGRES}
        NEW_8080=$(expr ${IDX} + 8080)
        sed -i "s/8080:/${NEW_8080}:/" ${DC_LD_POSTGRES}
	echo "URL LogicalDoc avec Postgresql = localhost:${NEW_8080}/logicaldoc "
        ;;

    ${SGBDR_MYSQL})
        # TEMP_DC_LD_MYSQL --> DC_LD_MYSQL
        sed "s/XX/${F_IDX}/g" ${TEMP_DC_LD_MYSQL} > ${DC_LD_MYSQL}
        NEW_8180=$(expr ${IDX} + 8180)
        sed -i "s/8180:/${NEW_8180}:/" ${DC_LD_MYSQL}
	echo "URL LogicalDoc avec Mysql = localhost:${NEW_8180}/logicaldoc "
        ;;

    *) # TEMP_DC_LD_POSTGRES --> DC_LD_POSTGRES
        sed "s/XX/${F_IDX}/g" ${TEMP_DC_LD_POSTGRES} > ${DC_LD_POSTGRES}
        NEW_8080=$(expr ${IDX} + 8080)
        sed -i "s/8080:/${NEW_8080}:/" ${DC_LD_POSTGRES}
	echo "URL LogicalDoc avec Postgresql = localhost:${NEW_8080}/logicaldoc "

       # TEMP_DC_LD_MYSQL --> DC_LD_MYSQL
        sed "s/XX/${F_IDX}/g" ${TEMP_DC_LD_MYSQL} > ${DC_LD_MYSQL}
        NEW_8180=$(expr ${IDX} + 8180)
        sed -i "s/8180:/${NEW_8180}:/" ${DC_LD_MYSQL}
	echo "URL LogicalDoc avec Mysql = localhost:${NEW_8180}/logicaldoc "
        ;;
esac
echo "${IDX}" > ${AUTO_IDX_FILE} 

exit 0

