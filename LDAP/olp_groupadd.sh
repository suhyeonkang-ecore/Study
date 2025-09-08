#!/bin/bash
set -euo pipefail

# 신규 사용자 생성 스크립트
# LDAP 환경 변수
BASE_DN="dc=iREMB-R,dc=HPC"
LDAP_URI="ldaps://ldap.iREMB-R.HPC"
ADMIN_DN="cn=Manager,${BASE_DN}"

LDAP_PASS_FILE="/etc/openldap/slapd.d/scripts/.ldap_pass"
if [ ! -f "$LDAP_PASS_FILE" ]; then
  LDAP_PASS=$(<"$LDAP_PASS_FILE")
else
  echo "LDAP password file($LDAP_PASS_FILE) not found!"
  exit 1
fi

GID_MIN=${GID_MIN:-5000}
GID_MAX=${GID_MAX:-60000}

GROUP_ADD="/etc/openldap/slapd.d/add/group/"
mkdir -p "$GROUP_ADD"

# 현재 최대 gidNumber 가져오기
MAX_GID=$(ldapsearch -x -D "$ADMIN_DN" -w "$LDAP_PASS" -H "$LDAP_URI" -b "$BASE_DN" \
    "(gidNumber=*)" gidNumber 2>/dev/null | awk '/gidNumber/ {print $2}' | sort -n | tail -1)

# GID 자동 할당
if [ -z "$MAX_GID" ]; then
    NEXT_GID=$GID_MIN
else
    NEXT_GID=$((MAX_GID + 1))
fi

# GID 범위 체크
if [[ $NEXT_GID -lt $GID_MIN || $NEXT_GID -gt $GID_MAX ]]; then
    echo "GID $NEXT_GID is out of range ($GID_MIN-$GID_MAX)."
    exit 1
fi

read -p "Enter new Group name: " GROUP_NAME
echo ""

cat <<EOF > "$GROUP_ADD/$GROUP_NAME.ldif"
dn: cn=$GROUP_NAME,ou=Groups,$BASE_DN
objectClass: top
objectClass: posixGroup
cn: $GROUP_NAME
gidNumber: $NEXT_GID
EOF

# 검토
echo "Verifying group information..."
cat "$GROUP_ADD/$GROUP_NAME.ldif"

echo ""

read -rp "Do you want to create the \"$GROUP_NAME\" group? (yes/no): " answer
if [[ "$answer" == "yes" ]] ; then
    if [[ -s "$GROUP_ADD/$GROUP_NAME.ldif" ]]; then
        ldapadd -x -D "$ADMIN_DN" -w "$LDAP_PASS" -f "$GROUP_ADD/$GROUP_NAME.ldif"
        echo "Group \"$GROUP_NAME\" has been successfully created."
    else
        echo "Group \"$GROUP_NAME\" creation has been canceled."
    fi
fi

echo "Group \"$GROUP_NAME\" created with GID \"$NEXT_GID\""
