#!/bin/bash
set -euo pipefail

DATE=$(date +%Y-%m-%d)
BACKUP_FILE="/tmp/boeirastudio-${DATE}.tar.gz"
LOG=/var/log/backup-boeirastudio.log

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando backup $DATE..." >> "$LOG"

# Cria archive do site
tar -czf "$BACKUP_FILE" -C /var/www boeirastudio

# Envia para Wasabi
/usr/bin/rclone copy "$BACKUP_FILE" wasabi:boeirastudio/backups/ --log-file="$LOG"

# Remove arquivo local temporário
rm -f "$BACKUP_FILE"

# Deleta backups com mais de 30 dias do Wasabi
/usr/bin/rclone delete wasabi:boeirastudio/backups/ --min-age 30d --log-file="$LOG"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup $DATE concluido." >> "$LOG"
