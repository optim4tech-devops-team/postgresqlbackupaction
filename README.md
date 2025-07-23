# PostgreSQL Backup to GitHub Action

This GitHub Action backs up one or more PostgreSQL databases and pushes the backups to a specified GitHub repository and branch.

## 📦 Features

- Supports daily, weekly, or monthly backups
- Dumps compressed `.sql.gz` files
- Organizes backups by frequency and DB name
- Git commits and pushes automatically

## 🚀 Usage

```yaml
jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: your-org/pg-backup-action@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          pg_user: ${{ secrets.PG_USER }}
          pg_password: ${{ secrets.PG_PASSWORD }}
          pg_host: ${{ secrets.PG_HOST }}
          pg_port: '5432'
          target_repo: 'your-org/your-backup-repo'
          target_branch: 'main'
          db_list: 'db1,db2'
          backup_frequency: 'daily'
