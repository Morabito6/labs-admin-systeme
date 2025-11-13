#!/bin/bash
# Répertoire local du dépôt (ajuste le chemin)
REPO_DIR="$HOME/labs-admin-systeme"
BACKUP_DIR="$REPO_DIR/semaine1_linux_reseau/backups/$(hostname)_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Exemples de fichiers à sauvegarder (adapter)
FILES_TO_SAVE=(
  "/etc/ssh/sshd_config"
  "/etc/netplan"
  "/etc/hosts"
  "/etc/ufw"
)

for f in "${FILES_TO_SAVE[@]}"; do
  if [ -e "$f" ]; then
    cp -rL "$f" "$BACKUP_DIR/"
  fi
done

# Ajout au dépôt local
cd "$REPO_DIR" || exit 1
git pull --rebase origin main || true
git add -A .
git commit -m "Backup configs $(hostname) $(date +'%Y-%m-%d %H:%M:%S')" || true
git push origin main || echo "Push failed - vérifier connexion"
