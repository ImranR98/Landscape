#!/bin/bash
set -e
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
mkdir -p "$STATE_DIR"/monitoring/prometheus
mkdir -p "$STATE_DIR"/monitoring/grafana/data
mkdir -p "$STATE_DIR"/monitoring/grafana/provisioning