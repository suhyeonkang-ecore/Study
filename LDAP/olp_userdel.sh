#!/bin/bash
set -euo pipefail

## 신규 사용자 생성 스크립트
# LDAP 환경 변수
BASE_DN="dc=iREMB-R,dc=HPC"
LDAP_URI="ldaps://ldap.iREMB-R.HPC"
ADMIN_DN="cn=Manager,${BASE_DN}"
OU_PEOPLE="ou=Users"
OU_GROUPS="ou=Groups"

LDAP_PASS_FILE="/etc/openldap/slapd.d/scripts/.ldap_pass"
if [[ -f "$LDAP_PASS_FILE" ]]; then
  LDAP_PASS=$(<"$LDAP_PASS_FILE")
else
  echo "LDAP password file($LDAP_PASS_FILE) not found!"
  exit 1
fi

# 삭제할 사용자 입력
echo "Please enter the username to delete."
read -p "Enter username (username): " USERNAME
read -s -p "Enter password for $USERNAME: " USER_PASS
echo ""

# 사용자 인증 확인
USER_DN="uid=$USERNAME,ou=Users,$BASE_DN"
if ldapwhoami -x -D "$USER_DN" -w "$USER_PASS" -H "$LDAP_URI" >/dev/null 2>&1; then
  echo "User authentication successful: $USERNAME"
else
  echo "Authentication failed. The password is incorrect or the account does not exist"
  exit 1
fi

# 기타 필요 변수
USER_ADD="/etc/openldap/slapd.d/add/user/"
GROUP_ADD="/etc/openldap/slapd.d/add/group/"

# 검토
echo "Please verify the user information"
cat "$USER_ADD/$USERNAME.ldif"

echo ""

read -rp "Do you want to delete $USERNAME? (yes/no): " answer
if [[ "$answer" == "yes" ]] ; then
  ldapdelete -x -D "$ADMIN_DN" -w "$LDAP_PASS" "uid=$USERNAME,ou=Users,$BASE_DN"
  echo "User deletion completed"

  sleep 1

  ldapdelete -x -D  "$ADMIN_DN" -w "$LDAP_PASS" "cn=$USERNAME,ou=Groups,$BASE_DN"
  echo "User's primary group deleted successfully"

  sleep 1

  rm -f $USER_ADD/$USERNAME.ldif
  rm -f $GROUP_ADD/$USERNAME-group.ldif
  rm -rf /home/$USERNAME
else
  echo "Failed to delete the user"
fi
