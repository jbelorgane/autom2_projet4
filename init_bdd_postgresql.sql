/* Création de la base de donnéees */
CREATE DATABASE "XXX_NAME" WITH ENCODING='UTF8';

/* Créatiion du user et du password */
CREATE USER "XXX_USER" WITH PASSWORD 'XXX_PASSWORD';

/* Grant privileges au user */
GRANT ALL PRIVILEGES ON DATABASE "XXX_NAME" TO "XXX_USER";
