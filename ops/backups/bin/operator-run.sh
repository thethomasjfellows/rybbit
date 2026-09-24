#!/usr/bin/env bash

set -Eeuo pipefail

[[ $# -eq 1 ]] || exit 2
case "$1" in
  postgres) systemctl start rybbit-postgres-backup.service ;;
  clickhouse) systemctl start rybbit-clickhouse-backup.service ;;
  *) exit 2 ;;
esac
