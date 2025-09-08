#!/bin/bash
set -euo pipefail

# ======= 설정 =======
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

DEFAULT_PASS="Ecore123!@#"
PASS_HASH=$(slappasswd -s "$DEFAULT_PASS")

LOCAL_PASSWD="/etc/passwd"
LOCAL_GROUP="/etc/group"

LOGFILE="./log/ldap_sync_$(date +%Y%m%d_%H%M%S).log"
TMP_DIR="./tmp_ldap_sync"
mkdir -p "$TMP_DIR" ./log

OUTPUT_ADD="$TMP_DIR/ldap_user_add.ldif"
#OUTPUT_MOD="$TMP_DIR/ldap_user_modify.ldif"

BACKUP_BASE="/home/ecore/ldap_backup/${TODAY}-org"

# 백업 디렉토리 생성
mkdir -p "$BACKUP_BASE"
echo "백업 디렉토리 생성: $BACKUP_BASE"

echo "동기화 시작 전, 기존 사용자 및 그룹 계정 파일 백업"
cp -arp /etc/passwd /etc/shadow /etc/group /etc/gshadow $BACKUP_BASE


echo "사용자 정보 동기화 시작"
: > "$OUTPUT_ADD"
#: > "$OUTPUT_MOD"

# LDAP에 존재하는 사용자 uid와 uidNumber 리스트 추출
ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" uid uidNumber > "$TMP_DIR/ldap_users.txt"
awk '/^uid:/ {u=$2} /^uidNumber:/ {print u ":" $2}' "$TMP_DIR/ldap_users.txt" > "$TMP_DIR/ldap_uids.list"

# 로컬 사용자 목록(uid, uidNumber) (UID>=1000, nobody 제외)
awk -F: '($3 >= 1000) && ($1 != "nobody") {print $1 ":" $3}' "$LOCAL_PASSWD" > "$TMP_DIR/local_uids.list"

# --- 신규 사용자 LDAP에 추가 ---
while IFS=: read -r user uid; do
  if ! grep -Fq "^$user:" "$TMP_DIR/ldap_uids.list"; then
    # 신규 사용자 정보 수집
    info=$(getent passwd "$user")
    gid=$(echo "$info" | cut -d: -f4)
    home=$(echo "$info" | cut -d: -f6)
    shell=$(echo "$info" | cut -d: -f7)
    gecos=$(echo "$info" | cut -d: -f5)

    # shadow 정보
    shadow_line=$(getent shadow "$user" || echo "")
    if [[ -z "$shadow_line" ]]; then
      echo "[WARN] 사용자 '$user'의 shadow 정보 없음. 기본값 사용."
      slastchg=0; smin=0; smax=99999; swarn=7; sinactive=-1; sexpire=-1
    else
      IFS=: read -r _ spwd slastchg smin smax swarn sinactive sexpire _ <<< "$shadow_line"
      slastchg=${slastchg:-0}
      smin=${smin:-0}
      smax=${smax:-99999}
      swarn=${swarn:-7}
      sinactive=${sinactive:--1}
      sexpire=${sexpire:--1}
    fi

    cat >> "$OUTPUT_ADD" <<EOF
dn: uid=$user,$OU_PEOPLE,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: $user
sn: $user
uid: $user
uidNumber: $uid
gidNumber: $gid
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
  fi
done < "$TMP_DIR/local_uids.list"

# --- 기존 LDAP 사용자 중 변경점 있는 사용자 수정 ---
while IFS=: read -r user uid; do
  # 해당 유저가 LDAP에 있는지 확인
  if grep -Fq "^$user:" "$TMP_DIR/ldap_uids.list"; then
    # 로컬 정보 조회
    info=$(getent passwd "$user")
    gid=$(echo "$info" | cut -d: -f4)
    home=$(echo "$info" | cut -d: -f6)
    shell=$(echo "$info" | cut -d: -f7)
    gecos=$(echo "$info" | cut -d: -f5)

    # shadow 정보
    shadow_line=$(getent shadow "$user" || echo "")
    if [[ -z "$shadow_line" ]]; then
      echo "[WARN] 사용자 '$user'의 shadow 정보 없음. 기본값 사용."
      slastchg=0; smin=0; smax=99999; swarn=7; sinactive=-1; sexpire=-1
    else
      IFS=: read -r _ spwd slastchg smin smax swarn sinactive sexpire _ <<< "$shadow_line"
      slastchg=${slastchg:-0}
      smin=${smin:-0}
      smax=${smax:-99999}
      swarn=${swarn:-7}
      sinactive=${sinactive:--1}
      sexpire=${sexpire:--1}
    fi

    # LDAP에서 기존 값 조회 (필요 시 LDAP에서 단일 유저 정보 가져오기)
    ldap_attrs=$(ldapsearch -x -LLL -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" \
      -b "$OU_PEOPLE,$BASE_DN" "uid=$user" \
      uidNumber gidNumber homeDirectory loginShell gecos shadowLastChange shadowMin shadowMax shadowWarning shadowInactive shadowExpire)

    ldap_uidNumber=$(echo "$ldap_attrs" | awk '/^uidNumber:/ {print $2}')
    ldap_gidNumber=$(echo "$ldap_attrs" | awk '/^gidNumber:/ {print $2}')
    ldap_homeDirectory=$(echo "$ldap_attrs" | awk '/^homeDirectory:/ {print $2}')
    ldap_loginShell=$(echo "$ldap_attrs" | awk '/^loginShell:/ {print $2}')
    ldap_gecos=$(echo "$ldap_attrs" | awk '/^gecos:/ {print $2}')
    ldap_shadowLastChange=$(echo "$ldap_attrs" | awk '/^shadowLastChange:/ {print $2}')
    ldap_shadowMin=$(echo "$ldap_attrs" | awk '/^shadowMin:/ {print $2}')
    ldap_shadowMax=$(echo "$ldap_attrs" | awk '/^shadowMax:/ {print $2}')
    ldap_shadowWarning=$(echo "$ldap_attrs" | awk '/^shadowWarning:/ {print $2}')
    ldap_shadowInactive=$(echo "$ldap_attrs" | awk '/^shadowInactive:/ {print $2}')
    ldap_shadowExpire=$(echo "$ldap_attrs" | awk '/^shadowExpire:/ {print $2}')

    # 변경사항 확인 및 ldif 작성
    changes=()

    [[ "$uid" != "$ldap_uidNumber" ]] && changes+=("replace: uidNumber"$'\n'"uidNumber: $uid")
    [[ "$gid" != "$ldap_gidNumber" ]] && changes+=("replace: gidNumber"$'\n'"gidNumber: $gid")
    [[ "$home" != "$ldap_homeDirectory" ]] && changes+=("replace: homeDirectory"$'\n'"homeDirectory: $home")
    [[ "$shell" != "$ldap_loginShell" ]] && changes+=("replace: loginShell"$'\n'"loginShell: $shell")
    [[ "$gecos" != "$ldap_gecos" ]] && changes+=("replace: gecos"$'\n'"gecos: $gecos")

    [[ "$slastchg" != "$ldap_shadowLastChange" ]] && changes+=("replace: shadowLastChange"$'\n'"shadowLastChange: $slastchg")
    [[ "$smin" != "$ldap_shadowMin" ]] && changes+=("replace: shadowMin"$'\n'"shadowMin: $smin")
    [[ "$smax" != "$ldap_shadowMax" ]] && changes+=("replace: shadowMax"$'\n'"shadowMax: $smax")
    [[ "$swarn" != "$ldap_shadowWarning" ]] && changes+=("replace: shadowWarning"$'\n'"shadowWarning: $swarn")
    [[ "$sinactive" != "$ldap_shadowInactive" ]] && changes+=("replace: shadowInactive"$'\n'"shadowInactive: $sinactive")
    [[ "$sexpire" != "$ldap_shadowExpire" ]] && changes+=("replace: shadowExpire"$'\n'"shadowExpire: $sexpire")

    if (( ${#changes[@]} > 0 )); then
      ldif_file="$TMP_DIR/modify_${user}.ldif"
      : > "$ldif_file"
      echo "dn: uid=$user,$OU_PEOPLE,$BASE_DN" >> "$ldif_file"
      echo "changetype: modify" >> "$ldif_file"
      for ((i=0; i<${#changes[@]}; i++)); do
        echo "${changes[i]}" >> "$ldif_file"
      done
      echo "-" >> "$ldif_file"
    fi
  fi
done < "$TMP_DIR/local_uids.list"

if [[ -s "$OUTPUT_ADD" ]]; then
  echo "=== 신규 추가 예정 사용자 목록 (dry-run) ==="
  grep "^dn: uid=" "$OUTPUT_ADD" | awk -F'[:,]' '{print " - " $2}' | sort
  echo ""
  echo "신규 사용자를 LDAP에 추가할 예정입니다. (dry-run)"
  ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -n -f "$OUTPUT_ADD" | tee -a "$LOGFILE"
  echo ""
fi

mod_files=("$TMP_DIR"/modify_*.ldif)
if [[ ${#mod_files[@]} -gt 0 && -s "${mod_files[0]}" ]]; then
  echo "=== 수정 예정 사용자 목록 (dry-run) ==="
  for f in "${mod_files[@]}"; do
    basename "$f" | sed 's/^modify_//' | sed 's/.ldif$//' | awk '{print " - " $1}'
  done
  echo ""
  echo "기존 LDAP 사용자에 대해 속성 변경 예정입니다. (dry-run)"
  for f in "${mod_files[@]}"; do
    ldapmodify -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -n -f "$f" | tee -a "$LOGFILE"
  done
  echo ""
fi

read -rp "LDAP에 실제 반영할까요? (yes/no): " answer
if [[ "$answer" == "yes" ]]; then
  if [[ -s "$OUTPUT_ADD" ]]; then
    ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$OUTPUT_ADD"
    echo "LDAP 신규 사용자 추가 완료"
  fi

  if [[ -n $(ls "$TMP_DIR"/modify_*.ldif 2>/dev/null) ]]; then
    for f in "$TMP_DIR"/modify_*.ldif; do
      ldapmodify -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$f"
    done
    echo "LDAP 사용자 수정 완료"
  fi
else
  echo "사용자 동기화 작업 취소됨"
fi

# ===========gid>=1000 그룹 생성 ================
# 백업 디렉토리의 최신 group 파일을 기준으로 함
echo "▶ 일반 그룹 정보 동기화 (신규 추가만)"

# LDAP에서 기존 그룹 목록 가져오기
ldap_existing_groups=$(ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_GROUPS,$BASE_DN" cn | awk '/^cn:/ {print $2}' | sort -u)

#BACKUP_BASE="/home/ecore/ldap_backup/${TODAY}-org"
#LATEST_DATE_DIR=$(find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d -printf "%T@ %p\n" | sort -nr | head -n1 | cut -d' ' -f2-)

BACKUP_PARENT="/home/ecore/ldap_backup"
LATEST_DATE_DIR=$(find "$BACKUP_PARENT" -mindepth 1 -maxdepth 1 -type d -printf "%T@ %p\n" | sort -nr | head -n1 | cut -d' ' -f2-)

if [[ -z "$LATEST_DATE_DIR" ]]; then
  echo "[ERROR] 백업 날짜별 디렉토리를 찾을 수 없습니다."
  exit 1
fi

LATEST_GROUP_BAK="$LATEST_DATE_DIR/group"

echo "최신 그룹 백업 파일: $LATEST_GROUP_BAK"

if [[ ! -f "$LATEST_GROUP_BAK" ]]; then
  echo "  [!] group 백업 파일이 없습니다: $LATEST_GROUP_BAK"
else
  awk -F: -v min_gid=1000 '{
    if ($3 >= min_gid && $1 != "nobody") print $1 ":" $3 ":" $4 ":" $NF
  }' "$LATEST_GROUP_BAK" | while IFS=: read -r group_name gid _ members; do
    # 기본 그룹 제외 (UID와 동일한 그룹은 사용자 생성시 이미 처리됨)
    if [[ "$group_name" =~ ^[a-zA-Z0-9._-]+$ && ! " ${ldap_existing_groups[*]} " =~ " $group_name " ]]; then
      echo "  [+] 신규 그룹 추가 대상 발견: $group_name (GID=$gid)"
      cat <<EOF >> "$OUTPUT_ADD"
dn: cn=$group_name,$OU_GROUPS,$BASE_DN
objectClass: top
objectClass: posixGroup
cn: $group_name
gidNumber: $gid
EOF

      if [[ -n "$members" && "$members" != "$group_name" ]]; then
        IFS=',' read -ra member_array <<< "$members"
        for m in "${member_array[@]}"; do
          echo "memberUid: $m" >> "$OUTPUT_ADD"
        done
      fi

      echo "" >> "$OUTPUT_ADD"
    fi
  done
fi


# ======== LDAP 사용자 기본 그룹 누락 여부 점검 및 자동 생성 ========
ldapsearch -x -LLL -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" \
    -b "$OU_GROUPS,$BASE_DN" "objectClass=posixGroup" cn gidNumber > "$TMP_DIR/ldap_groups.txt"
  awk '/^cn:/ {c=$2} /^gidNumber:/ {print $2 " " c}' "$TMP_DIR/ldap_groups.txt" > "$TMP_DIR/gid_group.map"

  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" uid gidNumber > "$TMP_DIR/uid_gid.txt"
  #awk '/^uid:/ {u=$2} /^gidNumber:/ {print $2 " " u}' "$TMP_DIR/uid_gid.txt" > "$TMP_DIR/user_gid.map"
  awk '
  /^uid:/ {u=$2}
  /^gidNumber:/ {print $2, u}
  ' "$TMP_DIR/uid_gid.txt" > "$TMP_DIR/user_gid.map"

  : > "$TMP_DIR/missing_groups.ldif"


  while read -r gid user; do
    if ! grep -q "^$gid " "$TMP_DIR/gid_group.map"; then
      cat >> "$TMP_DIR/missing_groups.ldif" <<EOF
dn: cn=$user,$OU_GROUPS,$BASE_DN
objectClass: top
objectClass: posixGroup
cn: $user
gidNumber: $gid
memberUid: $user

EOF
    fi
  done < "$TMP_DIR/user_gid.map"

  if [[ -s "$TMP_DIR/missing_groups.ldif" ]]; then
    ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$TMP_DIR/missing_groups.ldif"
    echo "누락된 기본 그룹 생성 완료"
  else
    echo "기본 그룹 누락 없음"
  fi

if [[ ! -s "$TMP_DIR/uid_gid.txt" ]]; then
  echo "[ERROR] 사용자 정보를 불러오지 못했습니다."
  exit 1
fi


# 로컬 그룹 -> ldap 그룹 memberUid 병합
  echo " 로컬 그룹 → LDAP 그룹 memberUid 병합 시작"

  while IFS=: read -r groupname _ gid members; do
    # GID가 1000 미만이면 건너뛰기
    if [[ "$gid" -lt 1000 ]]; then
      echo "그룹 '$groupname' GID가 1000 미만이므로 스킵"
      continue
    fi

    [[ -z "$members" ]] && continue
    ldap_dn="cn=${groupname},${OU_GROUPS},${BASE_DN}"

    existing_members=$(ldapsearch -x -LLL -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" \
      -b "$ldap_dn" memberUid 2>/dev/null | awk '/^memberUid:/ {print $2}')

    if [[ -z "$existing_members" ]]; then
      echo "LDAP 그룹 '$groupname'이 존재하지 않아 스킵합니다."
      continue
    fi

    declare -A existing_map=()
    for em in $existing_members; do
      existing_map["$em"]=1
    done

    IFS=',' read -ra local_members <<< "$members"
    : > "$TMP_DIR/modify_$groupname.ldif"
    update_needed=false

    for lm in "${local_members[@]}"; do
      lm_trimmed=$(echo "$lm" | xargs)
      [[ -z "$lm_trimmed" ]] && continue

      # nobody는 무조건 제외
      if [[ "$lm_trimmed" == "nobody" ]]; then
        continue
      fi

      # 사용자 UID 확인 (1000 이상만 처리)
      user_uid=$(getent passwd "$lm_trimmed" | cut -d: -f3 || echo "")
      if [[ -z "$user_uid" || "$user_uid" -lt 1000 ]]; then
        echo "사용자 '$lm_trimmed' UID가 1000 미만이거나 존재하지 않아 제외"
        continue
      fi

      if [[ -z "${existing_map[$lm_trimmed]+_}" ]]; then
        if ! $update_needed; then
          echo "dn: $ldap_dn" >> "$TMP_DIR/modify_$groupname.ldif"
          echo "changetype: modify" >> "$TMP_DIR/modify_$groupname.ldif"
          echo "add: memberUid" >> "$TMP_DIR/modify_$groupname.ldif"
          update_needed=true
        fi
        echo "memberUid: $lm_trimmed" >> "$TMP_DIR/modify_$groupname.ldif"
      fi
    done

    if $update_needed; then
      echo "-" >> "$TMP_DIR/modify_$groupname.ldif"
      ldapmodify -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$TMP_DIR/modify_$groupname.ldif" | tee -a "$LOGFILE"
      echo "LDAP 그룹 '$groupname'에 memberUid 업데이트 적용됨"
    fi

  done < "$LOCAL_GROUP"

#========local에 남아있는 일반 사용자 계정 삭제==============
ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" uid | awk '/^uid:/{print $2}' > ./USER_LIST

pattern=$(tr '\n' '|' < ./USER_LIST | sed 's/|$//')

# 날짜별 백업 디렉터리 생성 (scripts 폴더 아래)
mkdir -p "/etc/openldap/slapd.d/scripts/local_backup/${TODAY}"
LOCAL_BACKUP_DIR="/etc/openldap/slapd.d/scripts/local_backup/${TODAY}"

# 사용자/그룹 관련 로컬 수정 파일들 저장 경로 지정
LOCAL_PASSWD_FILE="$LOCAL_BACKUP_DIR/local_passwd"
LOCAL_SHADOW_FILE="$LOCAL_BACKUP_DIR/local_shadow"
LOCAL_GROUP_FILE="$LOCAL_BACKUP_DIR/local_group"
LOCAL_GSHADOW_FILE="$LOCAL_BACKUP_DIR/local_gshadow"

# 예시) 패턴으로 제외한 사용자만 남긴 passwd 파일 생성
egrep -v "^($pattern):" /etc/passwd > "$LOCAL_PASSWD_FILE"
egrep -v "^($pattern):" /etc/shadow > "$LOCAL_SHADOW_FILE"
egrep -v "^($pattern):" /etc/group > "$LOCAL_GROUP_FILE"
egrep -v "^($pattern):" /etc/gshadow > "$LOCAL_GSHADOW_FILE"

echo "수정된 파일들 $LOCAL_BACKUP_DIR 에 생성 완료"

echo "시스템 파일 덮어쓰기 절차 필요 (수동으로 진행)"
echo "예: cp -arp ./local_backup/${TODAY}/local_passwd /etc/passwd"
