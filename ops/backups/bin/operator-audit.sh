#!/usr/bin/env bash

set -Eeuo pipefail

[[ $# -eq 0 ]] || exit 2

printf '%s\n' 'Replay table TTLs (1 means 14-day TTL is present):'
docker exec clickhouse clickhouse-client --query \
  "SELECT name, create_table_query LIKE '%toIntervalDay(14)%' AS ttl_14_days FROM system.tables WHERE database = 'analytics' AND name IN ('session_replay_events', 'session_replay_metadata') ORDER BY name"

printf '%s\n' 'Backup service results:'
systemctl show rybbit-postgres-backup.service rybbit-clickhouse-backup.service \
  -p Id -p Result -p ExecMainStatus -p ActiveState

printf '%s\n' 'Backup timers:'
systemctl list-timers --all --no-legend \
  rybbit-postgres-backup.timer rybbit-clickhouse-backup.timer

printf '%s\n' 'Remote backup directories:'
rclone lsf rybbit_r2:rybbit-backups/postgres/analytics --dirs-only | tail -5
rclone lsf rybbit_r2:rybbit-backups/clickhouse/analytics --dirs-only | tail -5
