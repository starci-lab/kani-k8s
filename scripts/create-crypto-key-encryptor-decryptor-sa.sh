#!/usr/bin/env bash

# ======================================================
# GCP Service Account + KMS Encrypt/Decrypt (FULL)
# Ubuntu / Linux
# ======================================================

set -euo pipefail

# --------------------------
# Configuration
# --------------------------

PROJECT_ID="kani-473603"

# Service Account
SA_NAME="crypto-key-ed-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# KMS
LOCATION="asia-southeast1"
KEYRING="kani-crypto-keyring"
CRYPTOKEY="kani-crypto-key"

# Output key file
OUTPUT_DIR="./secrets"
KEY_FILE="${OUTPUT_DIR}/crypto-key-ed-sa.json"

echo "=============================================="
echo "GCP Service Account + KMS Encrypt/Decrypt"
echo "Project ID      : ${PROJECT_ID}"
echo "Service Account : ${SA_EMAIL}"
echo "Location        : ${LOCATION}"
echo "KeyRing         : ${KEYRING}"
echo "CryptoKey       : ${CRYPTOKEY}"
echo "=============================================="
echo ""

# --------------------------
# 0. Ensure output directory exists
# --------------------------
mkdir -p "${OUTPUT_DIR}"

# --------------------------
# 1. Create Service Account (if not exists)
# --------------------------
echo ">>> Checking Service Account..."

if gcloud iam service-accounts list \
  --project="${PROJECT_ID}" \
  --format="value(email)" | grep -qx "${SA_EMAIL}"; then
  echo "Service Account already exists. Using existing SA."
else
  echo "Creating Service Account..."
  gcloud iam service-accounts create "${SA_NAME}" \
    --display-name="Crypto Key Encryptor Decryptor SA" \
    --project="${PROJECT_ID}"
  echo "Service Account created."
fi

echo ""

# --------------------------
# 2. Get or Create KeyRing
# --------------------------
echo ">>> Checking KMS KeyRing..."

if gcloud kms keyrings list \
  --location="${LOCATION}" \
  --project="${PROJECT_ID}" \
  --format="value(name)" | grep -q "/keyRings/${KEYRING}$"; then
  echo "KeyRing '${KEYRING}' already exists."
else
  echo "Creating KeyRing '${KEYRING}'..."
  gcloud kms keyrings create "${KEYRING}" \
    --location="${LOCATION}" \
    --project="${PROJECT_ID}"
  echo "KeyRing created."
fi

echo ""

# --------------------------
# 3. Get or Create CryptoKey
# --------------------------
echo ">>> Checking KMS CryptoKey..."

if gcloud kms keys list \
  --keyring="${KEYRING}" \
  --location="${LOCATION}" \
  --project="${PROJECT_ID}" \
  --format="value(name)" | grep -q "/cryptoKeys/${CRYPTOKEY}$"; then
  echo "CryptoKey '${CRYPTOKEY}' already exists."
else
  echo "Creating CryptoKey '${CRYPTOKEY}'..."
  gcloud kms keys create "${CRYPTOKEY}" \
    --location="${LOCATION}" \
    --keyring="${KEYRING}" \
    --purpose="encryption" \
    --project="${PROJECT_ID}"
  echo "CryptoKey created."
fi

echo ""

# --------------------------
# 4. Grant KMS Encrypt / Decrypt role
# --------------------------
echo ">>> Granting roles/cloudkms.cryptoKeyEncrypterDecrypter..."

gcloud kms keys add-iam-policy-binding "${CRYPTOKEY}" \
  --location="${LOCATION}" \
  --keyring="${KEYRING}" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/cloudkms.cryptoKeyEncrypterDecrypter" \
  --project="${PROJECT_ID}"

echo "IAM role granted."
echo ""

# --------------------------
# 5. Export Service Account key
# --------------------------
echo ">>> Exporting Service Account key..."

if [ -f "${KEY_FILE}" ]; then
  echo "WARNING: Key file already exists and will be overwritten!"
fi

gcloud iam service-accounts keys create "${KEY_FILE}" \
  --iam-account="${SA_EMAIL}" \
  --project="${PROJECT_ID}"

echo ""
echo "=============================================="
echo "DONE!"
echo "Service Account key exported to:"
echo "  ${KEY_FILE}"
echo "=============================================="