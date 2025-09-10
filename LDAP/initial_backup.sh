#!/bin/bash
set -euo pipefail

# ======== 설정 ========
BASE_DN="dc=iREMB-R,dc=HPC"
OU_PEOPLE="ou=Users"
OU_GROUPS="ou=Groups"
LDAP_ADMIN_DN="cn=Manager,${BASE_DN}"
LDAP_HOST="ldaps://ldap.iREMB-R.HPC"

LDAP_PASS_FILE="/etc/openldap/slapd.d/scripts/.ldap_pass"
if [[ -f "$LDAP_PASS_FILE" ]]; then
  LDAP_PASS=$(<"$LDAP_PASS_FILE")
else
  echo "LDAP 패스워드 파일($LDAP_PASS_FILE) 없음!"
  exit 1
fi

TODAY=$(date +%Y%m%d)

LOG_DIR="./log"
TMP_DIR="./tmp_ldap_sync"
mkdir -p "$TMP_DIR" "$LOG_DIR"

LOGFILE="$LOG_DIR/ldap_sync_$(date +%Y%m%d_%H%M%S).log"

# ======== 로그 함수 ========
log() {
  echo -e "[$(date '+%F %T')] $*" | tee -a "$LOGFILE"
}

# =========최초 백업=========
mkdir -p /home/ecore/ldap_backup/${TODAY}-org
cp -arp /etc/passwd /etc/shadow /etc/group /etc/gshadow /home/ecore/ldap_backup/${TODAY}-org
