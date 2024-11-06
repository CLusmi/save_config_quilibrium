Ce script permet de sauvegarder le dossier .config de votre node Quilibrium sur un serveur distant.
Vous devez connaitre l'ip et le mot de passe ROOT du serveur de sauvegarde.
J'utilise SCP pour le transfert entre les deux machines.
Ce script fonctionne si vous avez installé le node Quilibrium grace au script QONE.

Pour l'utiliser, il suffit de lancer cette commande dans un shell sur votre machine de Node.

cd /root && rm -rf save_config_quil.sh && wget -O /root/save_config_quil.sh https://github.com/CLusmi/save_config_quilibrium/raw/main/save_config_quil.sh && chmod +x save_config_quil.sh && ./save_config_quil.sh
