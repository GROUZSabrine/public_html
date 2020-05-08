#!/bin/bash
# monscriptVMMySQL.sh

####################################################
# Partie 2 : Application LAMP 2-tiers
####################################################
echo "Installez le SGBD MySQL"
sudo apt update
sudo apt install mysql-server 
echo "Créez une BD relative à votre projet "
echo "Création d'un utilisateur ayant tous les droits sur cette BD"
echo "create database db_proj; create user user_proj identified by 'abc'; grant all on db_proj.* to user_proj@'%'; " | sudo mysql

echo "Créez une table très simple et remplissez la par quelles que lignes"
echo "Testez l’accès à la base et l’affichage du contenu de la table en utilisant le client MySQL"
echo "Votre application se connectera à la BD avec les paramètres de cet utilisateur & password='abc'"

echo "CREATE TABLE IF NOT EXISTS produit (
    prod_id int NOT NULL AUTO_INCREMENT,
    nom varchar(50) DEFAULT NULL,
    prix varchar(20) DEFAULT NULL,
    qte int NOT NULL,
    PRIMARY KEY(prod_id)
    );
INSERT INTO produit (nom, prix, qte) VALUES ('Produit1', '2,500', 20),('Produit2', '5,500', 50),('Produit3','1,500', 10); USE db_proj; show databases; show tables; show columns in produit; SELECT * FROM produit;" | mysql -u user_proj -p -D db_proj 
