#!/bin/bash

set -e

CRON_FILE="/etc/cron.d/test_cron"
CRON_JOB="*/5 * * * * root date '+\%Y-\%m-\%d \%H:\%M:\%S' >> /tmp/runtime.txt"

echo "Setting up cron job..."

if [[ $EUID -ne 0 ]]; then
  echo "Error: script must be run as root"
  exit 1
fi

if [[ -f "$CRON_FILE" ]] && grep -Fxq "$CRON_JOB" "$CRON_FILE"; then
  echo "Cron job already exists. Skipping."
  exit 0
fi

echo "$CRON_JOB" > "$CRON_FILE"

chown root:root "$CRON_FILE"
chmod 644 "$CRON_FILE"

echo "Cron job successfully installed."