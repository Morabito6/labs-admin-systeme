#!/bin/bash

# -----------------------------
# Variables
# -----------------------------
LAB_DIR="$HOME/labs-admin-systeme/semaine1_linux_reseau"
BACKUP_DIR="$LAB_DIR/backups"
SCRIPTS_DIR="$LAB_DIR/semaine1_linux_reseau/scripts"
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

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Fichiers système copiés" >> "$LOG_FILE"

# -----------------------------
# Gestion Git
# -----------------------------
cd "$LAB_DIR" || exit

# Ajouter tous les fichiers modifiés
git add .

# Commit automatique si changements
if ! git diff --cached --quiet; then
    git commit -m "Backup automatique $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Commit effectué" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Aucun changement à committer" >> "$LOG_FILE"
fi

# Pull avant push pour éviter conflits
git pull --rebase >> "$LOG_FILE" 2>&1

# Push sur GitHub (Git Credential Store doit avoir ton token)
git push >> "$LOG_FILE" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Push terminé" >> "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup terminé" >> "$LOG_FILE"

