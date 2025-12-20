# ======================================================
# GCP Service Account + KMS Encrypt/Decrypt (FULL)
# Windows PowerShell
# ======================================================

$ErrorActionPreference = "Stop"

# --------------------------
# Configuration
# --------------------------

$PROJECT_ID = "kani-473603"

# Service Account
$SA_NAME  = "crypto-key-ed-sa"
$SA_EMAIL = "$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# KMS
$LOCATION  = "asia-southeast1"
$KEYRING   = "kani-crypto-keyring"
$CRYPTOKEY = "kani-crypto-key"

# Output key file
$OUTPUT_DIR = ".\secrets"
$KEY_FILE   = "$OUTPUT_DIR\crypto-key-ed-sa.json"

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "GCP Service Account + KMS Encrypt/Decrypt" -ForegroundColor Cyan
Write-Host "Project ID      : $PROJECT_ID"
Write-Host "Service Account : $SA_EMAIL"
Write-Host "Location        : $LOCATION"
Write-Host "KeyRing         : $KEYRING"
Write-Host "CryptoKey       : $CRYPTOKEY"
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# --------------------------
# 0. Ensure output directory exists
# --------------------------
if (!(Test-Path $OUTPUT_DIR)) {
    New-Item -ItemType Directory -Path $OUTPUT_DIR | Out-Null
}

# --------------------------
# 1. Create Service Account (if not exists)
# --------------------------
Write-Host ">>> Checking Service Account..." -ForegroundColor Yellow

$SA_EXISTS = $false
$serviceAccounts = gcloud iam service-accounts list `
    --project=$PROJECT_ID `
    --format="value(email)"

if ($serviceAccounts -contains $SA_EMAIL) {
    $SA_EXISTS = $true
}

if ($SA_EXISTS) {
    Write-Host "Service Account already exists. Using existing SA." -ForegroundColor Green
} else {
    Write-Host "Creating Service Account..." -ForegroundColor Yellow

    gcloud iam service-accounts create $SA_NAME `
        --display-name="Crypto Key Encryptor Decryptor SA" `
        --project=$PROJECT_ID

    Write-Host "Service Account created." -ForegroundColor Green
}

Write-Host ""

# --------------------------
# 2. Get or Create KeyRing
# --------------------------
Write-Host ">>> Checking KMS KeyRing..." -ForegroundColor Yellow

$KEYRING_EXISTS = $false
$keyrings = gcloud kms keyrings list `
    --location=$LOCATION `
    --project=$PROJECT_ID `
    --format="value(name)"

foreach ($kr in $keyrings) {
    if ($kr -match "/keyRings/$KEYRING$") {
        $KEYRING_EXISTS = $true
        break
    }
}

if ($KEYRING_EXISTS) {
    Write-Host "KeyRing '$KEYRING' already exists." -ForegroundColor Green
} else {
    Write-Host "Creating KeyRing '$KEYRING'..." -ForegroundColor Yellow

    gcloud kms keyrings create $KEYRING `
        --location=$LOCATION `
        --project=$PROJECT_ID

    Write-Host "KeyRing created." -ForegroundColor Green
}

Write-Host ""

# --------------------------
# 3. Get or Create CryptoKey
# --------------------------
Write-Host ">>> Checking KMS CryptoKey..." -ForegroundColor Yellow

$CRYPTOKEY_EXISTS = $false
$keys = gcloud kms keys list `
    --keyring=$KEYRING `
    --location=$LOCATION `
    --project=$PROJECT_ID `
    --format="value(name)"

foreach ($k in $keys) {
    if ($k -match "/cryptoKeys/$CRYPTOKEY$") {
        $CRYPTOKEY_EXISTS = $true
        break
    }
}

if ($CRYPTOKEY_EXISTS) {
    Write-Host "CryptoKey '$CRYPTOKEY' already exists." -ForegroundColor Green
} else {
    Write-Host "Creating CryptoKey '$CRYPTOKEY'..." -ForegroundColor Yellow

    gcloud kms keys create $CRYPTOKEY `
        --location=$LOCATION `
        --keyring=$KEYRING `
        --purpose=encryption `
        --project=$PROJECT_ID

    Write-Host "CryptoKey created." -ForegroundColor Green
}

Write-Host ""

# --------------------------
# 4. Grant KMS Encrypt / Decrypt role
# --------------------------
Write-Host ">>> Granting roles/cloudkms.cryptoKeyEncrypterDecrypter..." -ForegroundColor Yellow

gcloud kms keys add-iam-policy-binding $CRYPTOKEY `
    --location=$LOCATION `
    --keyring=$KEYRING `
    --member="serviceAccount:$SA_EMAIL" `
    --role="roles/cloudkms.cryptoKeyEncrypterDecrypter" `
    --project=$PROJECT_ID

Write-Host "IAM role granted." -ForegroundColor Green
Write-Host ""

# --------------------------
# 5. Export Service Account key
# --------------------------
Write-Host ">>> Exporting Service Account key..." -ForegroundColor Yellow

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
