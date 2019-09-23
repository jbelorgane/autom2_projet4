#!/bin/sh

BDD_CMD="mysql"
BDD_ENGINE="Mysql"

# --------------------------------------------------------
# Vérifier que le serveur de BDD Mysql est up ?
# Rajouter -h ${DB_HOST} si la BDD est sur un host distant
# --------------------------------------------------------
sleep 4
echo "\nVérification que le serveur de BDD ${BDD_ENGINE} est up ?"
${BDD_CMD} -u root -p${MYSQL_ROOT_PASSWORD} -e 'show databases;'
retour=$?
until [ $retour -eq 0 ]
do
    echo "Le serveur de BDD ${BDD_ENGINE} n'est pas encore prêt !"
    sleep 3
    ${BDD_CMD} -u root -p${MYSQL_ROOT_PASSWORD} -e 'show databases;'
    retour=$?
done

# --------------------------------------------------------
# Vérifier que la base 'logicaldoc' est créée ?
# Lancer le script de création de la base et du user 
# --------------------------------------------------------
echo "\nVérification de l'existence de la base ${BDD_ENGINE} '${DB_NAME}' ?"
${BDD_CMD} -u root -p${MYSQL_ROOT_PASSWORD} -e "use ${DB_NAME};"
retour=$?
if [ $retour -eq 0 ] 
then
    echo "OK, la base ${BDD_ENGINE} '${DB_NAME}' existe."
else
    echo "NOT OK, la base ${BDD_ENGINE} '${DB_NAME}' n'existe pas !"

    # Customisation du template de crétion de la BDD
    echo "Création de la base ${BDD_ENGINE} '${DB_NAME}'...\c" 
    sed -i "s/XXX_NAME/${DB_NAME}/g" ./${BDD_INIT_SQL}
    sed -i "s/XXX_USER/${DB_USER}/g" ./${BDD_INIT_SQL}
    sed -i "s/XXX_PASSWORD/${DB_PASSWORD}/g" ./${BDD_INIT_SQL}
    ${BDD_CMD} -u root -p${MYSQL_ROOT_PASSWORD} --force < ./${BDD_INIT_SQL}
    echo " effectuée." 
    
    # Alimentation de la BDD
    echo "\nAlimentation de la base ${BDD_ENGINE} '${DB_NAME}'...\c" 
    ${BDD_CMD} -u root -p${MYSQL_ROOT_PASSWORD} -D ${DB_NAME} --force < ./${BDD_INIT_DUMP}
    echo " effectuée." 
fi
