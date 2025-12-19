#!/usr/bin/env bash
set -euo pipefail

# ======================================================
# GCP Service Account setup + export key (Ubuntu / Linux)
# ======================================================

# --------------------------
# Configuration
# --------------------------

PROJECT_ID="kani-473603"

SA_NAME="external-secrets-gcp-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

OUTPUT_DIR="./secrets"
KEY_FILE="${OUTPUT_DIR}/external-secrets-gcp-sa.json"

echo "=============================================="
echo "GCP Service Account setup + export key"
echo "Project ID       : ${PROJECT_ID}"
echo "Service Account  : ${SA_EMAIL}"
echo "Key file         : ${KEY_FILE}"
echo "=============================================="
echo

# --------------------------
# 0. Ensure output directory exists
# --------------------------
mkdir -p "${OUTPUT_DIR}"

# --------------------------
# 1. Create GCP Service Account (if not exists)
# --------------------------
echo ">>> Creating GCP Service Account (if not exists)..."

if ! gcloud iam service-accounts describe "${SA_EMAIL}" \
  --project "${PROJECT_ID}" >/dev/null 2>&1; then
  gcloud iam service-accounts create "${SA_NAME}" \
    --display-name="External Secrets GCP SA" \
    --project "${PROJECT_ID}"
else
  echo "Service Account already exists. Skipping."
fi

echo

# --------------------------
# 2. Grant Secret Manager access
# --------------------------
echo ">>> Granting roles/secretmanager.secretAccessor..."

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "${PROJECT_ID}" \
  --quiet

echo

# --------------------------
# 3. Export Service Account key to file
# --------------------------
echo ">>> Exporting Service Account key to file..."

if [ -f "${KEY_FILE}" ]; then
  echo "WARNING: ${KEY_FILE} already exists and will be overwritten!"
fi

gcloud iam service-accounts keys create "${KEY_FILE}" \
  --iam-account="${SA_EMAIL}" \
  --project "${PROJECT_ID}"

echo
echo "=============================================="
echo "DONE!"
echo "Service Account key exported to:"
echo "  ${KEY_FILE}"
echo "=============================================="
