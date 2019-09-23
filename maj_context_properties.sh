#!/bin/sh

usage(){
    echo "$0 <mysql|postgres> <DB_NAME> <DB_HOST> <USERNAME> <PASSWORD> [<TOMCAT_PROPERTIES_DIR>] \n"
    echo "exemple 1 : $0 mysql logicaldoc ld_mysql ldoc password "
    echo "exemple 2 : $0 postgres logicaldoc ld_postgres ldoc password "
    echo "exemple 3 : $0 postgres logicaldoc localhost ldoc password \"/usr/local/tomcat/webapps/logicaldoc/WEB-INF/classes\" "
    exit $1
}

# Controle du nombre d'arguments saisi (doit etre egal a 5 ou 6)
[ $# -ne 5 -a $# -ne 6 ] && usage 1

MYSQL_ENGINE="mysql"
POSTGRES_ENGINE="postgres"
#
DBMS_TYPE="$1"
DB_NAME="$2"
DB_HOST="$3"
USERNAME="$4"
PASSWORD="$5"
#
if [ $# -eq 6 ]
then
    FILE="$6/context.properties"
else
    FILE="/usr/local/tomcat/webapps/logicaldoc/WEB-INF/classes/context.properties"
fi

# Controle de la variable ${DBMS_TYPE} (doit etre egale a 'mysql' ou 'postgres')
if [ "${DBMS_TYPE}" != "${MYSQL_ENGINE}" -a "${DBMS_TYPE}" != "${POSTGRES_ENGINE}" ] 
then
    echo "Type de moteur de SGBDR ${DBMS_TYPE} non conforme !"
    usage 2
fi
echo $0

# Mise a jour du fichier : context.properties
# ===========================================
# jdbc.dbms
sed -i "s/^jdbc.dbms.*/jdbc.dbms=${DBMS_TYPE}/" ${FILE}
cat ${FILE} | grep "jdbc.dbms"

# jdbc.password
sed -i "s/^jdbc.password.*/jdbc.password=${PASSWORD}/" ${FILE}
cat ${FILE} | grep "jdbc.password"

# jdbc.username
sed -i "s/^jdbc.username.*/jdbc.username=${USERNAME}/" ${FILE}
cat ${FILE} | grep "jdbc.username"

# jdbc.validationQuery
sed -i "s/^jdbc.validationQuery.*/jdbc.validationQuery=SELECT 1/" ${FILE}
cat ${FILE} | grep "jdbc.validationQuery"

# initialized
sed -i "s/^initialized.*/initialized=true/" ${FILE}
cat ${FILE} | grep "initialized"

# cas.lang
sed -i "s/^cas.lang.*/cas.lang=fr/" ${FILE}
cat ${FILE} | grep "cas.lang"

# jdbc.driver et jdbc.url
case ${DBMS_TYPE} in
	${MYSQL_ENGINE})
		# jdbc.driver
		sed -i "s/^jdbc.driver.*/jdbc.driver=com.${DBMS_TYPE}.jdbc.Driver/" ${FILE}
		cat ${FILE} | grep "jdbc.driver"
		# jdbc.url
		sed -i "s!^jdbc.url.*!jdbc.url=jdbc:${DBMS_TYPE}://${DB_HOST}:3306/${DB_NAME}?useSSL=false\&allowPublicKeyRetrieval=true!" ${FILE}
		cat ${FILE} | grep "jdbc.url"
		;;
	${POSTGRES_ENGINE})
		# jdbc.driver
		sed -i "s/^jdbc.driver.*/jdbc.driver=org.${DBMS_TYPE}ql.Driver/" ${FILE}
		cat ${FILE} | grep "jdbc.driver"

		# jdbc.url
		sed -i "s!^jdbc.url.*!jdbc.url=jdbc:${DBMS_TYPE}ql://${DB_HOST}:5432/${DB_NAME}!" ${FILE}
		cat ${FILE} | grep "jdbc.url"
		;;
	*)
 		echo "Moteur de BDD \"${DBMS_TYPE}\" non géré !"
		exit 3
		;;
esac

exit 0
