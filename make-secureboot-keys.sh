#!/usr/bin/env bash
set -e

OUTDIR=secureboot-custom
mkdir -p "$OUTDIR"
cd "$OUTDIR"

echo "[*] Generating PK, KEK, DB, DBX keys and certs..."

# 1. Generate keys and self-signed certs
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Rabiu-PlatformKey/" \
  -keyout PK.key -out PK.crt -days 3650 -nodes

openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Rabiu-KEK/" \
  -keyout KEK.key -out KEK.crt -days 3650 -nodes

openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Rabiu-DB/" \
  -keyout DB.key -out DB.crt -days 3650 -nodes

openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Rabiu-DBX/" \
  -keyout DBX.key -out DBX.crt -days 3650 -nodes

echo "[*] Converting certs to ESL..."

cert-to-efi-sig-list PK.crt PK.esl
cert-to-efi-sig-list KEK.crt KEK.esl
cert-to-efi-sig-list DB.crt DB.esl
cert-to-efi-sig-list DBX.crt DBX.esl

echo "[*] Creating AUTH files..."

# PK signs PK and KEK
sign-efi-sig-list -k PK.key -c PK.crt PK PK.esl PK.auth
sign-efi-sig-list -k PK.key -c PK.crt KEK KEK.esl KEK.auth

# KEK signs DB and DBX
sign-efi-sig-list -k KEK.key -c KEK.crt db DB.esl DB.auth
sign-efi-sig-list -k KEK.key -c KEK.crt dbx DBX.esl DBX.auth

echo "[*] Done. Copy these to a FAT32 USB:"
echo "    PK.auth  KEK.auth  DB.auth  DBX.auth"
