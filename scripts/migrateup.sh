#!/usr/bin/env bash
set -euo pipefail

# Optionally source local overrides (dev only). In CI the DATABASE_URL should
# come from the GitHub Actions secret injected at the job level.
if [[ -f .env ]]; then
    # shellcheck disable=SC1091
    source .env
fi

if [[ -z "${DATABASE_URL:-}" ]]; then
    echo "[migrateup] DATABASE_URL not set; skipping migrations." >&2
    exit 0
fi

echo "[migrateup] Starting migrations with goose (driver=sqlite3)"
cd sql/schema

# goose driver note: Turso/libsql is SQLite compatible. The goose CLI does not
# have a dedicated 'turso' driver; using sqlite3 works for libsql remote URLs
# when the libsql driver is installed. If remote libsql URL is unsupported by
# the bundled sqlite3 driver, this will fail fast.

if ! command -v goose >/dev/null 2>&1; then
    echo "[migrateup] ERROR: goose binary not found on PATH." >&2
    exit 1
fi

set -x
goose -v -dir . sqlite3 "${DATABASE_URL}" up
set +x

echo "[migrateup] Migrations completed successfully."
