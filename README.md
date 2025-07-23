# PostgreSQL Backup to GitHub

This GitHub Action takes scheduled or manual PostgreSQL backups and pushes them to a target GitHub repository.

---

## 💡 Features

- Supports `daily`, `weekly`, and `monthly` backups
- Dumps `.sql.gz` backups per DB
- Stores backups in organized folders
- Commits and pushes to a target GitHub repo and branch

---

## 📥 Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `backup_frequency` | How often to back up: `daily`, `weekly`, or `monthly` | ✅ | – |
| `github_token` | GitHub token with write access to target repo | ✅ | – |
| `db_list_file` | Path to file with comma-separated DB names | ✅ | `./project.txt` |
| `target_repo` | Repo to push backups to (e.g. `user/repo`) | ✅ | – |
| `target_branch` | Branch to push into | ✅ | `main` |
| `pg_user` | PostgreSQL username | ✅ | – |
| `pg_password` | PostgreSQL password | ✅ | – |
| `pg_host` | PostgreSQL host | ✅ | – |
| `pg_port` | PostgreSQL port | ✅ | – |
| `git_user_name` | Git commit username | ❌ | `postgres-backup-action` |
| `git_user_email` | Git commit email | ❌ | `noreply@github.com` |

---

## 🔁 Backup Frequency Details

| Value | Description | Output Path Example |
|-------|-------------|----------------------|
| `daily` | Backup runs every day | `backups/daily/db1/pg_backup_daily_db1_2025-07-23.sql.gz` |
| `weekly` | Backup runs once per week | `backups/weekly/db1/pg_backup_weekly_db1_2025-07-21.sql.gz` |
| `monthly` | Backup runs monthly (1st of each month) | `backups/monthly/db1/pg_backup_monthly_db1_2025-07-01.sql.gz` |

---

## 🚀 Example Usage

```yaml
name: PostgreSQL Backup

on:
  schedule:
    - cron: '0 3 * * *'  # Daily
  workflow_dispatch:

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - name: PostgreSQL Backup
        uses: your-username/postgresql-backup-action@v1
        with:
          backup_frequency: daily
          github_token: ${{ secrets.GITHUBTOKEN }}
          db_list_file: ./project.txt
          target_repo: your-username/your-backup-repo
          target_branch: main
          pg_user: ${{ secrets.PG_USER }}
          pg_password: ${{ secrets.PG_PASSWORD }}
          pg_host: ${{ secrets.PG_HOST }}
          pg_port: ${{ secrets.PG_PORT }}
