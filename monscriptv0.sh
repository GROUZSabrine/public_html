#!/bin/bash
# monscript.sh

####################################################
# Partie 1 : Application LAMP All-in-One
####################################################
echo "Créez une VM ubuntu server 18.04"
echo "Cloner VM ubuntu server 18.04: clone lié"
echo "Configurer le clone de VM ubuntu server 18.04:Réseau -> carte1 : NAT -> carte2 : Réseau privé hote"
##############################################################################################################
# Comment lancer le scripte principale dans ma VM qui permet de déployer votre application (Apache+PHP+MySQL+Application)? 
##############################################################################################################
echo "Installez le serveur web Apache"
sudo apt update
sudo apt install apache2
echo "Installez le module PHP"
sudo apt install libapache2-mod-php
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
INSERT INTO produit (nom, prix, qte) VALUES ('Produit1', '2,500', 20),('Produit2', '5,500', 50),('Produit3','1,500', 10); USE db_proj; show databases; show tables; show columns in produit; SELECT * FROM produit;" | mysql -u user_proj -p -D db_proj -h 192.168.56.20 -P 3306 

echo "Créez et hébergez quelles que pages PHP manipulant votre BD"
cd /var/www/html/
sudo touch index.html
echo "<html>
<head><title>Ceci est une page index</title><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /></head>
<body><h2>Page index </h2><a href='test.php'>Page Test</a></body></html>" > index.html
sudo touch test.php
sudo chmod 777 test.php
echo "<html>
<head><title>Ceci est une page PHP de test</title><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /></head>
<body><h2>Page de test</h2><p><?php echo 'site web Sabrine GROUZ'; ?></p>
<h4>Liste des produits</h4>
<table border=2><tr><th>Nom Produit</th><th>Prix</th><th>Quantité</th></tr>
<?php
\$bdd = new PDO('mysql:host=192.168.56.20.;dbname=db_proj', 'user_proj', 'abc');
\$reponse = \$bdd ->query('SELECT * FROM produit'); 
while (\$donnees = \$reponse ->fetch()){ ?><tr><td><?php echo \$donnees['nom']; ?></td><td><?php echo \$donnees['prix']; ?></td><td><?php echo \$donnees['qte']; ?></td></tr>
<?php } ?>
</table></body></html>" > test.php
