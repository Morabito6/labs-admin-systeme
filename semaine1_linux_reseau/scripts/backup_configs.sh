#!/bin/bash

# -----------------------------
# Variables
# -----------------------------
BASE_DIR="$HOME/labs-admin-systeme"
LAB_DIR="$BASE_DIR/semaine1_linux_reseau"
BACKUP_DIR="$LAB_DIR/backups"
SCRIPT_PATH="$LAB_DIR/scripts/backup_configs.sh"
LOG_FILE="$BACKUP_DIR/cron.log"

# Crée le dossier backup si inexistant
mkdir -p "$BACKUP_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Début du backup" >> "$LOG_FILE"

# -----------------------------
# Copier fichiers système (UFW)
# -----------------------------
sudo cp /etc/ufw/after.* "$BACKUP_DIR" 2>> "$LOG_FILE"
sudo cp /etc/ufw/before.* "$BACKUP_DIR" 2>> "$LOG_FILE"
sudo cp /etc/ufw/user* "$BACKUP_DIR" 2>> "$LOG_FILE"

# Corriger les permissions pour que Git puisse gérer les fichiers
sudo chown -R $USER:$USER "$BACKUP_DIR"
sudo chmod +x "$SCRIPT_PATH"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Fichiers UFW copiés et permissions corrigées" >> "$LOG_FILE"

# -----------------------------
# Gestion Git
# -----------------------------
cd "$BASE_DIR" || exit

# Ajouter tous les fichiers modifiés
git add .

# Commit automatique si changements
if ! git diff --cached --quiet; then
    git commit -m "Backup automatique $(date '+%Y-%m-%d_%H-%M-%S')" >> "$LOG_FILE" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Commit effectué" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Aucun changement à committer" >> "$LOG_FILE"
fi

# Synchronisation avec GitHub sans erreur de rebase
git fetch origin main >> "$LOG_FILE" 2>&1
git reset --hard origin/main >> "$LOG_FILE" 2>&1

# Push des commits locaux
git push >> "$LOG_FILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Push terminé" >> "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup terminé" >> "$LOG_FILE"
