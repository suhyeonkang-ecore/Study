#!/bin/bash
set -euo pipefail

## 신규 사용자 생성 스크립트
# LDAP 환경 변수
BASE_DN="dc=iREMB-R,dc=HPC"
LDAP_URI="ldaps://ldap.iREMB-R.HPC"
ADMIN_DN="cn=Manager,${BASE_DN}"

GROUP_ADD="/etc/openldap/slapd.d/add/group/"

LDAP_PASS_FILE="/etc/openldap/slapd.d/scripts/.ldap_pass"
if [[ -f "$LDAP_PASS_FILE" ]]; then
    LDAP_PASS=$(<"$LDAP_PASS_FILE")
else
    echo "LDAP password file($LDAP_PASS_FILE) not found!"
    exit 1
fi

echo "Please enter the groupname to delete."
read -p "Enter groupname (groupname): " GROUPNAME

# 검토
echo "Please verify the group information."
cat "$GROUP_ADD/$GROUPNAME.ldif"

echo ""

read -rp "Do you want to delete $GROUPNAME? (yes/no): " answer
if [[ "$answer" == "yes" ]]; then
    ldapdelete -x -D "$ADMIN_DN" -w "$LDAP_PASS" "cn=$GROUPNAME,ou=Groups,$BASE_DN"
    echo "Group deletion completed"

    sleep 1
    
    rm -f $GROUP_ADD/$GROUPNAME-group.ldif
else
    echo "Failed to delete the group"
fi
