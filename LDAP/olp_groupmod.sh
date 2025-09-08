#!/bin/bash
set -euo pipefail

# ===== 설정 =====
BASE_DN="dc=iREMB-R,dc=HPC"
OU_GROUPS="ou=Groups"
LDAP_URI="ldaps://ldap.iREMB-R.HPC"
LDAP_ADMIN_DN="cn=Manager,$BASE_DN"

LDAP_PASS_FILE="/etc/openldap/slapd.d/scripts/.ldap_pass"
if [[ -f "$LDAP_PASS_FILE" ]]; then
    LDAP_PASS=$(<"$LDAP_PASS_FILE")
else
    echo "LDAP password file($LDAP_PASS_FILE) not found!"
    exit 1
fi

# ===== 입력 =====
read -rp "Group name: " GROUP
read -rp "Username: " USERNAME
read -rp "Action (add/del): " ACTION

GROUP_DN="cn=$GROUP,$OU_GROUPS,$BASE_DN"

# ===== LDIF 생성 =====
TMP_LDIF=$(mktemp)

if [[ "$ACTION" == "add" ]]; then
    cat <<EOF > "$TMP_LDIF"
dn: $GROUP_DN
changetype: modify
add: memberUid
memberUid: $USERNAME
EOF
elif [[ "$ACTION" == "del" ]]; then
    cat <<EOF > "$TMP_LDIF"
dn: $GROUP_DN
changetype: modify
delete: memberUid
memberUid: $USERNAME
EOF
else
    echo "Invalid action: $ACTION (must be add or del)"
    exit 1
fi

# ===== 실행 =====
ldapmodify -x -H "$LDAP_URI" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$TMP_LDIF"

# ===== 정리 =====
rm -f "$TMP_LDIF"
echo "Operation '$ACTION' for user '$USERNAME' on group '$GROUP' completed."
