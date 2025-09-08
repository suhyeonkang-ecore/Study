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

# /etc/login.defs 정보 파싱
UID_MIN=${UID_MIN:-5000}
UID_MAX=${UID_MAX:-60000}
GID_MIN=${GID_MIN:-5000}
GID_MAX=${GID_MAX:-60000}
UMASK_VAL=$(grep "^UMASK" /etc/login.defs | awk '{print $2}')

# 사용자 입력
read -p "Enter new username (User ID): " USERNAME
echo ""

echo ""

while true; do
    read -rsp "Please enter the password: " new_password
    echo

    # 비어있는지 확인
    if [ -z "$new_password" ]; then
        echo "Password cannot be empty. Please try again."
        continue
    fi

    # 길이 확인
    password_length=${#new_password}
    if [ "$password_length" -lt 8 ]; then
        echo "Password must be at least 8 characters long."
        continue
    fi

    # 문자 종류 개수 세기
    uppercase_count=$(echo "$new_password" | grep -o '[A-Z]' | wc -l)
    lowercase_count=$(echo "$new_password" | grep -o '[a-z]' | wc -l)
    digit_count=$(echo "$new_password" | grep -o '[0-9]' | wc -l)
    special_count=$(echo "$new_password" | grep -o '[^a-zA-Z0-9]' | wc -l)

    # 조건 검사
    if [ "$uppercase_count" -lt 1 ]; then
        echo "Password must contain at least one uppercase letter."
        continue
    fi

    if [ "$lowercase_count" -lt 1 ]; then
        echo "Password must contain at least one lowercase letter."
        continue
    fi

    if [ "$digit_count" -lt 1 ]; then
        echo "Password must contain at least one number."
        continue
    fi

    if [ "$special_count" -lt 1 ]; then
        echo "Password must contain at least one special character."
        continue
    fi

    # Confirm password
    read -rsp "Please confirm the new password: " confirm_password
    echo

    if [ "$new_password" != "$confirm_password" ]; then
        echo "Password do not match. Re-type your password."
        continue
    fi

    echo "Password confirmed and accepted. All checks passed."

    # PASSWORD 변수에 최종 비밀번호 저장
    PASSWORD="$new_password"
    break
done

echo ""

# 현재 최대 uidNumber 가져오기
MAX_UID=$(ldapsearch -x -D "$ADMIN_DN" -w "$ADMIN_PASS" -H "$LDAP_URI" -b "$BASE_DN" \
    "(uidNumber=*)" uidNumber 2>/dev/null | awk '/uidNumber/ {print $2}' | sort -n | tail -1)

# 현재 최대 gidNumber 가져오기
MAX_GID=$(ldapsearch -x -D "$ADMIN_DN" -w "$ADMIN_PASS" -H "$LDAP_URI" -b "$BASE_DN" \
  "(gidNumber=*)" gidNumber 2>/dev/null | awk '/gidNumber/ {print $2}' | sort -n | tail -1)

# UID 자동 할당
if [ -z "$MAX_UID" ]; then
  NEXT_UID=$UID_MIN
else
  NEXT_UID=$((MAX_UID + 1))
fi

# GID 자동 할당
if [ -z "$MAX_GID" ]; then
  NEXT_GID=$GID_MIN
else
  NEXT_GID=$((MAX_GID + 1))
fi

# UID 범위 체크
if [[ $NEXT_UID -lt $UID_MIN || $NEXT_UID -gt $UID_MAX ]]; then
  echo "UID $NEXT_UID is out of range ($UID_MIN~$UID_MAX)."
  exit 1
fi

# GID 범위 체크
if [[ $NEXT_GID -lt $GID_MIN || $NEXT_GID -gt $GID_MAX ]]; then
  echo "GID $NEXT_GID is out of range ($GID_MIN~$GID_MAX)."
  exit 1
fi

# shadow 변수 지정
today_epoch_days=$(($(date +%s) / 86400))
slastchg=$today_epoch_days
smin=0
smax=99999
swarn=7
sinactive=-1
sexpire=-1

# 암호 해시 생성
PASS_HASH=$(slappasswd -s "$PASSWORD")

# 기타 필요 변수
USER_ADD="/etc/openldap/slapd.d/add/user/"
GROUP_ADD="/etc/openldap/slapd.d/add/group/"

mkdir -p "$USER_ADD"
mkdir -p "$GROUP_ADD"

home="/home/$USERNAME"
shell="/bin/bash"
gecos="$CN"

# 사용자 생성 LDIF
cat <<EOF > "$USER_ADD/$USERNAME.ldif"
dn: uid=$USERNAME,ou=Users,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
sn: ${CN##* }
cn: $CN
uid: $USERNAME
uidNumber: $NEXT_UID
gidNumber: $NEXT_GID
homeDirectory: $home
loginShell: $shell
gecos: $gecos
userPassword: $PASS_HASH
shadowLastChange: $slastchg
shadowMin: $smin
shadowMax: $smax
shadowWarning: $swarn
shadowInactive: $sinactive
shadowExpire: $sexpire
EOF

# 사용자 기본 그룹 생성하는 ldif
cat <<EOF > "$GROUP_ADD/$USERNAME-group.ldif"
dn: cn=$USERNAME,ou=Groups,$BASE_DN
objectClass: top
objectClass: posixGroup
cn= $USERNAME
gidNumber: $NEXT_GID
memberUid: $USERNAME
EOF

# 사용자에 정책 연결 ldif
cat <<EOF > "$USER_ADD/${USERNAME}-policy.ldif"
dn: uid=$USERNAME,ou=Users,$BASE_DN
changetype: modify
add: pwdPolicySubentry
pwdPolicySubentry: cn=default,ou=Policies,$BASE_DN

EOF

# 검토
echo "Verifying user information"
cat "$USER_ADD/$USERNAME.ldif"

echo ""

read -rp "Do you want to create the user \"$USERNAME\"? (yes/no): " answer
if [[ "$answer" == "yes" ]] ; then
  if [[ -s "$USER_ADD/$USERNAME.ldif" ]]; then
    ldapadd -x -D "$ADMIN_DN" -w "$LDAP_PASS" -f "$USER_ADD/$USERNAME.ldif"
    echo "New user has been successfully added"

    sleep 1

    ldapadd -x -D "$ADMIN_DN" -w "$LDAP_PASS" -f "$GROUP_ADD/$USERNAME-group.ldif"
    echo "User's primary group created successfully"

    sleep 1

    ldapmodify -x -D "cn=Manager,$BASE_DN" -w "$LDAP_PASS" -f "$USER_ADD/${USERNAME}-policy.ldif"
  fi
fi
