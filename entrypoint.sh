#!/bin/bash
set -euo pipefail

DATE_SUFFIX=$(date +"%Y-%m-%d")

echo "🕒 Backup frequency: $FREQ"
echo "📅 Backup date: $DATE_SUFFIX"

IFS=',' read -r -a DB_LIST < "$DB_LIST_FILE"

CLONE_DIR=$(mktemp -d)
echo "📁 Cloning target repo: $TARGET_REPO (branch: $TARGET_BRANCH)..."
git clone --depth=1 "https://x-access-token:$GITHUBTOKEN@github.com/$TARGET_REPO.git" "$CLONE_DIR" -b "$TARGET_BRANCH"

cd "$CLONE_DIR"

for DB_NAME in "${DB_LIST[@]}"; do
  BACKUP_NAME="pg_backup_${FREQ}_${DB_NAME}_${DATE_SUFFIX}.sql.gz"
  BACKUP_DIR="backups/${FREQ}/${DB_NAME}"

  echo "🛠️ Backing up DB: $DB_NAME at $PG_HOST:$PG_PORT"
  mkdir -p "$BACKUP_DIR"

  if PGPASSWORD="$PG_PASSWORD" pg_dump -U "$PG_USER" -h "$PG_HOST" -p "$PG_PORT" "$DB_NAME" | gzip > "$BACKUP_DIR/$BACKUP_NAME"; then
    echo "✅ Backup successful: $BACKUP_NAME"
  else
    echo "❌ Backup failed for $DB_NAME!" >&2
    continue
  fi

  git config user.email "$GIT_USER_EMAIL"
  git config user.name "$GIT_USER_NAME"

  git add "$BACKUP_DIR/$BACKUP_NAME"
  git commit -m "Backup: ${FREQ} ${DB_NAME} ${DATE_SUFFIX}" || echo "ℹ️ Nothing new to commit for $DB_NAME."
done

echo "🚀 Pushing changes to $TARGET_BRANCH..."
git push origin "$TARGET_BRANCH" || echo "⚠️ Push failed"
