#!/usr/bin/env bash
set -euo pipefail

# Load local overrides only in dev; CI provides env vars directly.
if [[ -f .env ]]; then
    # shellcheck disable=SC1091
    source .env
fi

if [[ -z "${DATABASE_URL:-}" ]]; then
    echo "[migrateup] DATABASE_URL not set; skipping migrations." >&2
    exit 0
fi

echo "[migrateup] Running migrations with goose (driver=sqlite3) against ${DATABASE_URL}"
cd sql/schema

if ! command -v goose >/dev/null 2>&1; then
    echo "[migrateup] ERROR: goose not found on PATH." >&2
    exit 1
fi

set -x
goose -v -dir . sqlite3 "${DATABASE_URL}" up
set +x

echo "[migrateup] Migrations completed successfully."
