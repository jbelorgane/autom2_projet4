/* Création de la base de donnéees */
CREATE DATABASE XXX_NAME;

/* Création du user */
CREATE USER 'XXX_USER';

/* Création du password pour le user */
SET PASSWORD FOR XXX_USER@'%'=PASSWORD('XXX_PASSWORD');

/* Grant des privilèges pour le user */
GRANT ALL PRIVILEGES ON XXX_NAME.* TO 'XXX_USER'@'%' IDENTIFIED BY 'XXX_PASSWORD';
