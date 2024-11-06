#!/bin/bash

apt-get install zip -y

######################################################################################
# Modifier selon votre configuration.
#REMOTE_IP=""          # Remplacez par l'IP du serveur de destination
#REMOTE_PORT=""        # Remplacez par le port SSH du serveur de destination
#REMOTE_USER=""        # Remplacez par le nom d'utilisateur du serveur de destination
REMOTE_PATH="/opt"     # Remplacez par le chemin de destination sur le serveur
######################################################################################

echo "Veuillez entrer l'ip du serveur distant"
read REMOTE_IP
echo "Veuillez entrer le port du serveur distant"
read REMOTE_PORT
echo "Veuillez entrer le nom d'utilisateur du serveur distant"
read REMOTE_USER

# Variables automatiques
HOSTNAME=$(hostname)
DATE=$(date +%Y-%m-%d)
ZIP_FILE="/root/${HOSTNAME}_${DATE}_backup_config_quil.zip"
FOLDER_PATH="/root/ceremonyclient/node/.config"

# Arrêt du service ceremonyclient
echo "----------> Arrêt du service ceremonyclient. Veuillez patienter 15 secondes ..."
service ceremonyclient stop
sleep 15

echo "----------> Vérification de l'état du service ceremonyclient. Veuillez patienter 5 secondes ..."
sleep 5
if service ceremonyclient status | grep -q "inactive"; then
    echo "----------> Le service ceremonyclient a été arrêté avec succès."
else
    echo "Erreur : Le service ceremonyclient est toujours en cours d'exécution. Arrêt du script."
    exit 1
fi

# Compression moyenne du dossier .config
echo "----------> Compression moyenne du dossier $FOLDER_PATH en $ZIP_FILE ..."
echo "----------> Veuillez patienter 15 secondes ..."
sleep 15
zip -r -3 $ZIP_FILE $FOLDER_PATH

# Redémarrage du service ceremonyclient
echo "----------> Redémarrage du service ceremonyclient. Veuillez patienter 15 secondes ..."
service ceremonyclient start
sleep 15

echo "----------> Vérification de l'état du service ceremonyclient. Veuillez patienter 5 secondes ..."
sleep 5
if service ceremonyclient status | grep -q "running"; then
    echo "----------> Le service ceremonyclient est redémarré avec succès."
else
    echo "Erreur : Le service ceremonyclient n'a pas pu redémarrer. Arrêt du script."
    exit 1
fi

# Transfert du fichier zip vers le serveur distant
echo "----------> Transfert du fichier zip vers le serveur distant $REMOTE_IP ..."
echo "----------> Veuillez entrer le mot de passe de votre utilisateur."
scp -P $REMOTE_PORT $ZIP_FILE $REMOTE_USER@$REMOTE_IP:$REMOTE_PATH

# Vérification du transfert
if [ $? -ne 0 ]; then
    echo "Erreur lors du transfert du fichier vers le serveur distant. Arrêt du script."
    exit 1
else
    echo "----------> Fichier transféré avec succès vers $REMOTE_IP:$REMOTE_PATH."
fi

echo "Suppression de l'archive local precedement crée pour gain de place. Veuillez patienter 5 secondes ...
sleep 5
rm -rf $ZIP_FILE

# Affichage du récapitulatif
echo "-----------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------"
echo "                                  RÉCAPITULATIF                                    "
echo "-----------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------"
echo "         Sauvegarde du dossier .config de votre node a été efféctuée."
echo "         Elle ce trouve dans le dossier /opt de votre serveur distant"
echo "         Rappel de l'ip serveur distant : $REMOTE_IP"
echo "         Rappel du chemin de la sauvegarde : $REMOTE_PATH"
echo "         Rappel du fichier de sauvegarde $ZIP_FILE"
echo "-----------------------------------------------------------------------------------"
echo "-----------------------------------------------------------------------------------"
