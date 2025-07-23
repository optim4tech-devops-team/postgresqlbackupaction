#!/bin/bash
set -euo pipefail

PG_USER=$1
PG_PASSWORD=$2
PG_HOST=$3
PG_PORT=$4
DB_LIST=$5         # comma-separated
FREQ=$6
GITHUB_TOKEN=$7
TARGET_REPO=$8
TARGET_BRANCH=$9

DATE_SUFFIX=$(date +"%Y-%m-%d")

IFS=',' read -ra DBS <<< "$DB_LIST"

for DB_NAME in "${DBS[@]}"; do
  BACKUP_NAME="pg_backup_${FREQ}_${DB_NAME}_${DATE_SUFFIX}.sql.gz"
  BACKUP_DIR="backups/${FREQ}/${DB_NAME}"

  echo "📦 Dumping: $DB_NAME"
  export PGPASSWORD="$PG_PASSWORD"
  pg_dump -U "$PG_USER" -h "$PG_HOST" -p "$PG_PORT" "$DB_NAME" | gzip > "$BACKUP_NAME"

  mkdir -p "$BACKUP_DIR"
  mv "$BACKUP_NAME" "$BACKUP_DIR/"

  git config user.email "support@optim4tech.com"
  git config user.name "optim4tech-devops-team"

  git add "$BACKUP_DIR/$BACKUP_NAME"
  git commit -m "Backup: ${FREQ} ${DB_NAME} ${DATE_SUFFIX}" || echo "ℹ️ No changes for $DB_NAME"
done

echo "🚀 Pushing to $TARGET_BRANCH on $TARGET_REPO"
git push "https://x-access-token:$GITHUB_TOKEN@github.com/${TARGET_REPO}.git" HEAD:$TARGET_BRANCH || echo "⚠️ Push failed"
