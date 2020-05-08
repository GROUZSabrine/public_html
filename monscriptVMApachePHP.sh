#!/bin/bash
# monscriptVMApachePHP.sh

####################################################
# Partie 2 : Application LAMP 2-tiers
####################################################
echo "Installez le serveur web Apache"
sudo apt update
sudo apt install apache2
echo "Installez le module PHP"
sudo apt install libapache2-mod-php
sudo apt-get install php-mysql
sudo systemctl restart apache2
echo "Créez et hébergez quelles que pages PHP manipulant votre BD"
touch index.html
echo "<html>
<head><title>Ceci est une page index</title><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /></head>
<body><h2>Page index </h2><a href='test.php'>Page Test</a></body></html>" > index.html
sudo mv /var/www/html/index.html /var/www/html/index.html.origin
sudo cp ./index.html /var/www/html/
cd /var/www/html/
sudo touch test.php
sudo chmod 777 test.php
echo "<html>
<head><title>Ceci est une page PHP de test</title><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /></head>
<body><h2>Page de test</h2><p><?php echo 'site web Sabrine GROUZ'; ?></p>
<a href='produit.php'>Ajouter un produit</a>
<h4>Liste des produits</h4>
<table border=2><tr><th>Nom Produit</th><th>Prix</th><th>Quantité</th><th>Actions</th></tr>
<?php
\$bdd = new PDO('mysql:host=192.168.56.23;dbname=db_proj', 'user_proj', 'abc');
\$reponse = \$bdd ->query('SELECT * FROM produit'); 
while (\$donnees = \$reponse ->fetch()){ ?><tr><td><?php echo \$donnees['nom']; ?></td><td><?php echo \$donnees['prix']; ?></td><td><?php echo \$donnees['qte']; ?></td><td><a href='produit.php?edit=<?php echo \$donnees['prod_id']; ?>' >Modifier</a>&nbsp;&nbsp;<a href='produit.php?del=<?php echo \$donnees['prod_id']; ?>'>Supprimer</a></td></tr>
<?php } ?>
</table></body></html>" > test.php
sudo touch produit.php
sudo chmod 777 produit.php
echo "<html>
<head><title>Page Produit</title></head>
<body>
<form action='produit.php' method='POST'>
<?php
try{
\$connection = new PDO('mysql:host=192.168.56.23;dbname=db_proj', 'user_proj', 'abc');
\$connection->exec('set names utf8');
}catch(PDOException \$exception){
echo 'Connection error: ' . \$exception->getMessage();
}

if (isset(\$_GET['edit']) || isset(\$_GET['del'])){
\$id = \$_GET['edit'];
\$id1 = \$_GET['del'];
\$sql = 'SELECT * FROM produit WHERE prod_id=:id or prod_id=:id1';
\$query = \$connection->prepare(\$sql);
\$query->execute(array(':id' => \$id,':id1' => \$id1));
 
while(\$row = \$query->fetch(PDO::FETCH_ASSOC))
{
    \$nom = \$row['nom'];
    \$prix = \$row['prix'];
    \$qte = \$row['qte'];
}
}
?>

<div>
<input type='hidden' name='id' value='<?php echo \$_GET['edit'];?>'>
<input type='hidden' name='id1' value='<?php echo \$_GET['del'];?>'>
<div><b>Nom de produit</b>
<input name='nom'  type='text' value='<?php echo \$nom; ?>'
<?php if (isset(\$_GET['del'])){?> readonly <?php } ?> >
</div>
<div><b>Prix</b>
<input name='prix' type='text' value='<?php echo \$prix; ?>'
<?php if (isset(\$_GET['del'])){?> readonly <?php } ?> >
</div>
<div><b>Quantité</b>
<input name='qte' type='text' value='<?php echo \$qte; ?>'
<?php if (isset(\$_GET['del'])){?> readonly <?php } ?> >
</div>
</div>
<br/>
<?php if (isset(\$_GET['edit'])){?>
<input value='Modifier' name='modif' type='submit'><br>
<a href='test.php' >Liste des produits</a>
<?php } elseif (isset(\$_GET['del'])){?>
<input value='Supprimer' name='supp' type='submit'><br>
<a href='test.php' >Liste des produits</a>
<?php }else{ ?>
<input value='Ajouter' name='ajout' type='submit'><br>
<a href='test.php' >Liste des produits</a>
<?php } ?>
</form>
</body>
</html>

<?php

function ajouter(\$nom, \$prix, \$qte){
global \$connection;
\$query = 'INSERT INTO produit(nom, prix, qte) VALUES( :nom, :prix, :qte)';
\$callToDb = \$connection->prepare(\$query);
\$nom=htmlspecialchars(strip_tags(\$nom));
\$prix=htmlspecialchars(strip_tags(\$prix));
\$callToDb->bindParam(':nom',\$nom);
\$callToDb->bindParam(':prix',\$prix);
\$callToDb->bindParam(':qte',\$qte);
if(\$callToDb->execute()){
header('Location:test.php');
}
}

if( isset(\$_POST['ajout'])){
\$nom = htmlentities(\$_POST['nom']);
\$prix = htmlentities(\$_POST['prix']);
\$qte = htmlentities(\$_POST['qte']);
\$result = ajouter(\$nom, \$prix, \$qte);
echo \$result;
}


function modifier(\$id,\$nom, \$prix, \$qte){
global \$connection;
\$query = 'UPDATE produit SET nom=:nom, prix=:prix, qte=:qte WHERE prod_id=:id';
\$callToDb = \$connection->prepare(\$query);
\$id = \$_POST['id'];
\$nom=htmlspecialchars(strip_tags(\$nom));
\$prix=htmlspecialchars(strip_tags(\$prix));
\$callToDb->bindParam(':id',\$id);
\$callToDb->bindParam(':nom',\$nom);
\$callToDb->bindParam(':prix',\$prix);
\$callToDb->bindParam(':qte',\$qte);
if(\$callToDb->execute()){
header('Location:test.php');
}
}

if( isset(\$_POST['modif'])){
\$id = \$_GET['edit'];
\$nom = htmlentities(\$_POST['nom']);
\$prix = htmlentities(\$_POST['prix']);
\$qte = htmlentities(\$_POST['qte']);
\$result = modifier(\$id,\$nom, \$prix, \$qte);
echo \$result;
}


function supprimer(\$id){
global \$connection;
\$query = 'DELETE FROM produit WHERE prod_id=:id';
\$callToDb = \$connection->prepare(\$query);
\$id = \$_POST['id1'];
\$callToDb->bindParam(':id',\$id);
if(\$callToDb->execute()){
header('Location:test.php');
}
}

if (isset(\$_POST['supp'])){
\$id = \$_GET['del'];
\$result = supprimer(\$id);
echo \$result;
}
?>" > produit.php
