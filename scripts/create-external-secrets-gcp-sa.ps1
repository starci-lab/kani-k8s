# ======================================================
# GCP Service Account setup + export key (Windows)
# ======================================================

$ErrorActionPreference = "Stop"

# --------------------------
# Configuration
# --------------------------

$PROJECT_ID   = "kani-473603"
$SA_NAME      = "crypto-key-encryptor-decryptor-sa"
$SA_EMAIL     = "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# Output key file
$OUTPUT_DIR   = ".\secrets"
$KEY_FILE     = "$OUTPUT_DIR\crypto-key-encryptor-decryptor-sa.json"

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "GCP Service Account setup + export key" -ForegroundColor Cyan
Write-Host "Project ID : $PROJECT_ID"
Write-Host "Service Account : $SA_EMAIL"
Write-Host "Key file : $KEY_FILE"
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# --------------------------
# 0. Ensure output directory exists
# --------------------------
if (!(Test-Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# --------------------------
# 1. Create GCP Service Account (if not exists)
# --------------------------
Write-Host ">>> Creating GCP Service Account (if not exists)..." -ForegroundColor Yellow

try {
    gcloud iam service-accounts create $SA_NAME `
        --display-name="Crypto Key Encryptor Decryptor SA" `
        --project=$PROJECT_ID
} catch {
    Write-Host "Service Account already exists. Skipping..." -ForegroundColor DarkYellow
}

Write-Host ""

# --------------------------
# 2. Grant Secret Manager access
# --------------------------
Write-Host ">>> Granting roles/secretmanager.secretAccessor..." -ForegroundColor Yellow

gcloud projects add-iam-policy-binding $PROJECT_ID `
    --member="serviceAccount:$SA_EMAIL" `
    --role="roles/secretmanager.secretAccessor" `
    --project=$PROJECT_ID

Write-Host ""

# --------------------------
# 3. Export Service Account key to file
# --------------------------
Write-Host ">>> Exporting Service Account key to file..." -ForegroundColor Yellow

# (Optional) Warn if file already exists
if (Test-Path $KEY_FILE) {
    Write-Host "WARNING: Key file already exists and will be overwritten!" -ForegroundColor Red
}

gcloud iam service-accounts keys create $KEY_FILE `
    --iam-account=$SA_EMAIL `
    --project=$PROJECT_ID

Write-Host ""

Write-Host "==============================================" -ForegroundColor Green
Write-Host "DONE!"
Write-Host "Service Account key exported to:"
Write-Host "  $KEY_FILE"
Write-Host "==============================================" -ForegroundColor Green
