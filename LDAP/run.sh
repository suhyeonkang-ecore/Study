#!/bin/bash
set -euo pipefail

# ======== 설정 ========
BASE_DN="dc=iREMB-R,dc=HPC"
OU_PEOPLE="ou=Users"
OU_GROUPS="ou=Groups"
LDAP_ADMIN_DN="cn=Manager,${BASE_DN}"
LDAP_HOST="ldaps://iREMB-R-M.iREMB-R.HPC"

LDAP_PASS_FILE="/etc/openldap/slapd.d/scripts/.ldap_pass"
if [[ -f "$LDAP_PASS_FILE" ]]; then
  LDAP_PASS=$(<"$LDAP_PASS_FILE")
else
  echo "LDAP 패스워드 파일($LDAP_PASS_FILE) 없음!"
  exit 1
fi

LOCAL_PASSWD="/etc/passwd"
LOCAL_GROUP="/etc/group"
LOCAL_SHADOW="/etc/shadow"
LOCAL_GSHADOW="/etc/gshadow"

TARGET_GROUPS=("engineer" "developer" "sales")

LOGFILE="./log/ldap_sync_$(date +%Y%m%d_%H%M%S).log"
TMP_DIR="./tmp_ldap_sync"
mkdir -p "$TMP_DIR" ./log

OUTPUT_ADD="$TMP_DIR/ldap_user_add.ldif"
OUTPUT_MOD="$TMP_DIR/ldap_user_modify.ldif"

# ======== 로그 함수 ========
log() {
  echo -e "[$(date '+%F %T')] $*" | tee -a "$LOGFILE"
}

# ======== 파일 백업 및 변경 교체 함수 ========
backup_and_append_if_changed() {
  local file=$1
  local tmpfile="${file}.tmp_$$"

  # 입력을 stdin 또는 두번째 인수로부터 받음
  if [[ -p /dev/stdin ]]; then
    cat - > "$tmpfile"
  else
    cp "$file" "$tmpfile"
  fi

  # 중복 제거 및 정렬
  sort -u "$tmpfile" -o "$tmpfile"

  if ! cmp -s "$file" "$tmpfile"; then
    local backup="${file}.$(date +%Y%m%d%H%M%S).bak"
    cp "$file" "$backup"
    log "백업 생성됨: $backup"

    mv "$tmpfile" "$file"
    log "변경사항 적용됨: $file"
  else
    rm -f "$tmpfile"
    log "변경사항 없음: $file"
  fi
}

replace_group_entries_by_name() {
  local file=$1
  local tmp_input="$2"
  local backup="${file}.$(date +%Y%m%d%H%M%S).bak"

  cp "$file" "$backup"
  log "백업 생성됨: $backup"

  # map of groupname → line (from tmp_input)
  declare -A new_entries
  while IFS= read -r line; do
    groupname=$(echo "$line" | cut -d: -f1)
    new_entries["$groupname"]="$line"
  done < "$tmp_input"

  # 새 출력 파일
  local tmp_merged="${file}.merged.tmp"
  : > "$tmp_merged"

  # 기존 파일 순회하면서 동일한 그룹이 있으면 교체
  while IFS= read -r line; do
    groupname=$(echo "$line" | cut -d: -f1)
    if [[ -n "${new_entries[$groupname]+_}" ]]; then
      echo "${new_entries[$groupname]}" >> "$tmp_merged"
      unset new_entries["$groupname"]
    else
      echo "$line" >> "$tmp_merged"
    fi
  done < "$file"

  # tmp_input에만 있는 그룹들 이어쓰기
  for line in "${new_entries[@]}"; do
    echo "$line" >> "$tmp_merged"
  done

  mv "$tmp_merged" "$file"
  log "그룹/그섀도우 교체 반영됨: $file"
}

replace_passwd_entries_by_uid() {
  local file=$1
  local tmp_input="$2"
  local backup="${file}.$(date +%Y%m%d%H%M%S).bak"

  cp "$file" "$backup"
  log "백업 생성됨: $backup"

  # map of uid → line (from tmp_input)
  declare -A new_entries
  while IFS=: read -r line; do
    uid=$(echo "$line" | cut -d: -f3)
    new_entries["$uid"]="$line"
  done < "$tmp_input"

  local tmp_merged="${file}.merged.tmp"
  : > "$tmp_merged"

  while IFS=: read -r line; do
    uid=$(echo "$line" | cut -d: -f3)
    if [[ -n "${new_entries[$uid]+_}" ]]; then
      echo "${new_entries[$uid]}" >> "$tmp_merged"
      unset new_entries["$uid"]
    else
      echo "$line" >> "$tmp_merged"
    fi
  done < "$file"

  # tmp_input에만 있는 UID 항목 이어쓰기
  for line in "${new_entries[@]}"; do
    echo "$line" >> "$tmp_merged"
  done

  mv "$tmp_merged" "$file"
  log "passwd 파일 교체 반영됨: $file"
}

replace_shadow_entries_by_uid() {
  local file=$1
  local tmp_input="$2"
  local backup="${file}.$(date +%Y%m%d%H%M%S).bak"

  cp "$file" "$backup"
  log "백업 생성됨: $backup"

  # map of uid → line (from tmp_input)
  declare -A new_entries
  while IFS=: read -r line; do
    uid=$(echo "$line" | cut -d: -f1)
    new_entries["$uid"]="$line"
  done < "$tmp_input"

  local tmp_merged="${file}.merged.tmp"
  : > "$tmp_merged"

  while IFS=: read -r line; do
    uid=$(echo "$line" | cut -d: -f1)
    if [[ -n "${new_entries[$uid]+_}" ]]; then
      echo "${new_entries[$uid]}" >> "$tmp_merged"
      unset new_entries["$uid"]
    else
      echo "$line" >> "$tmp_merged"
    fi
  done < "$file"

  # tmp_input에만 있는 UID 항목 이어쓰기
  for line in "${new_entries[@]}"; do
    echo "$line" >> "$tmp_merged"
  done

  mv "$tmp_merged" "$file"
  log "shadow 파일 교체 반영됨: $file"
}

# ======== 1단계: 필수 그룹 생성 (engineer 등) ========
create_required_groups() {
  log "▶ 1단계: 필수 그룹 생성 시작"
  gid_base=5000
  for group in "${TARGET_GROUPS[@]}"; do
    gid=$(getent group "$group" | cut -d: -f3 || echo "")
    if [[ -z "$gid" || "$gid" -lt 5000 ]]; then
      new_gid=$((gid_base++))
      log " - 그룹 생성: $group (GID=$new_gid)"
      groupadd -g "$new_gid" "$group" || true
    else
      log " - 그룹 존재: $group (GID=$gid)"
    fi
  done
  log "▶ 1단계 완료"
}

# ======== 2-1단계: 로컬 그룹을 LDAP에 등록 및 memberUid 동기화 ========
sync_groups_to_ldap() {
  log "▶ 2-1단계: 로컬 그룹 → LDAP 동기화 시작"

  local ldif="$TMP_DIR/groups.ldif"
  : > "$ldif"

  while IFS=: read -r groupname _ gid members; do
    if ! ldapsearch -x -LLL -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" \
        -b "$OU_GROUPS,$BASE_DN" "(cn=$groupname)" cn >/dev/null 2>&1; then
      cat >> "$ldif" <<EOF
dn: cn=$groupname,$OU_GROUPS,$BASE_DN
objectClass: top
objectClass: posixGroup
cn: $groupname
gidNumber: $gid
EOF
      for m in $(echo "$members" | tr ',' ' '); do
        [[ -n "$m" ]] && echo "memberUid: $m" >> "$ldif"
      done
      echo "" >> "$ldif"
    fi
  done < "$LOCAL_GROUP"

  if [[ -s "$ldif" ]]; then
    ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$ldif" | tee -a "$LOGFILE"
  fi

  log "▶ 2-1단계 완료"
}

# ======== 2-2단계: 로컬 GID 5000 이상 그룹 LDAP 동기화 (gidNumber 기준 신규 등록) ========
sync_local_large_gid_groups_to_ldap() {
  log "▶ 2-2단계: 로컬 GID 5000 이상 그룹 → LDAP 신규 동기화 시작"

  local ldif_file="$TMP_DIR/large_gid_groups.ldif"
  : > "$ldif_file"

  ldapsearch -x -LLL -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" \
    -b "$OU_GROUPS,$BASE_DN" "(objectClass=posixGroup)" cn gidNumber | \
    awk '/^cn:/ {cn=$2} /^gidNumber:/ {print cn, $2}' > "$TMP_DIR/ldap_groups.list"

  while IFS=: read -r groupname _ gid members; do
    if (( gid >= 5000 )); then
      if ! grep -q -E "^${groupname} ${gid}$" "$TMP_DIR/ldap_groups.list"; then
        member_lines=""
        IFS=',' read -ra memarr <<< "$members"
        for mem in "${memarr[@]}"; do
          [[ -n "$mem" ]] && member_lines+="memberUid: $mem\n"
        done

        cat >> "$ldif_file" <<EOF
dn: cn=$groupname,$OU_GROUPS,$BASE_DN
objectClass: top
objectClass: posixGroup
cn: $groupname
gidNumber: $gid
$(echo -e "$member_lines")

EOF
        log "➕ LDAP 신규 그룹 추가 대상: $groupname (GID=$gid)"
      else
        log "✅ LDAP에 이미 존재하는 그룹: $groupname (GID=$gid)"
      fi
    fi
  done < "$LOCAL_GROUP"

  if [[ -s "$ldif_file" ]]; then
    ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$ldif_file" | tee -a "$LOGFILE"
    log "▶ 2-2단계 완료: LDAP 그룹 신규 추가 완료"
  else
    log "▶ 2-2단계: 신규 LDAP 그룹 없음"
  fi
}

# ======== 3단계: 로컬 사용자 → LDAP 사용자 등록 및 수정 ========
sync_users_to_ldap() {
  log "▶ 3단계: 사용자 정보 동기화 시작"

  : > "$OUTPUT_ADD"
  : > "$OUTPUT_MOD"

  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" uid uidNumber > "$TMP_DIR/ldap_users.txt"
  awk '/^uid:/ {u=$2} /^uidNumber:/ {print u ":" $2}' "$TMP_DIR/ldap_users.txt" > "$TMP_DIR/ldap_uids.list"

  awk -F: '($3 >= 1000) && ($1 != "nobody") {print $1 ":" $3}' "$LOCAL_PASSWD" > "$TMP_DIR/local_uids.list"

  while IFS=: read -r user uid; do
    shadow=$(grep "^$user:" "$LOCAL_SHADOW" || true)
    IFS=: read -r _ pw slc smin smax swarn sinact sexp sflag <<< "$shadow"

    info=$(getent passwd "$user")
    gid=$(echo "$info" | cut -d: -f4)
    home=$(echo "$info" | cut -d: -f6)
    shell=$(echo "$info" | cut -d: -f7)
    gecos=$(echo "$info" | cut -d: -f5)

    if ! grep -q "^$user:" "$TMP_DIR/ldap_uids.list"; then
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
userPassword: {CRYPT}$pw
shadowLastChange: ${slc:-0}
shadowMin: ${smin:-0}
shadowMax: ${smax:-99999}
shadowWarning: ${swarn:-7}

EOF
    else
      cat >> "$OUTPUT_MOD" <<EOF
dn: uid=$user,$OU_PEOPLE,$BASE_DN
changetype: modify
replace: loginShell
loginShell: $shell
-
replace: homeDirectory
homeDirectory: $home
-
replace: gecos
gecos: $gecos
-
replace: userPassword
userPassword: {CRYPT}$pw

EOF
    fi
  done < "$TMP_DIR/local_uids.list"

  log "▶ Dry-run 실행 중..."
  [[ -s "$OUTPUT_ADD" ]] && ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -n -f "$OUTPUT_ADD"
  [[ -s "$OUTPUT_MOD" ]] && ldapmodify -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -n -f "$OUTPUT_MOD"

  read -rp "▶ LDAP에 실제 반영할까요? (yes/no): " answer
  if [[ "$answer" == "yes" ]]; then
    [[ -s "$OUTPUT_ADD" ]] && ldapadd -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$OUTPUT_ADD"
    [[ -s "$OUTPUT_MOD" ]] && ldapmodify -x -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" -f "$OUTPUT_MOD"
    log "LDAP 사용자 등록 완료"
  else
    log "사용자 등록 취소됨"
  fi
}

# ======== 4단계: LDAP 사용자들의 기본 그룹 누락 여부 점검 및 자동 생성 ========
create_missing_primary_groups() {
  log "▶ 4단계: LDAP 사용자 기본 그룹 확인 및 누락 생성"

  ldapsearch -x -LLL -H "$LDAP_HOST" -D "$LDAP_ADMIN_DN" -w "$LDAP_PASS" \
    -b "$OU_GROUPS,$BASE_DN" "objectClass=posixGroup" cn gidNumber > "$TMP_DIR/ldap_groups.txt"
  awk '/^cn:/ {c=$2} /^gidNumber:/ {print $2 " " c}' "$TMP_DIR/ldap_groups.txt" > "$TMP_DIR/gid_group.map"

  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" uid gidNumber > "$TMP_DIR/uid_gid.txt"
  awk '/^uid:/ {u=$2} /^gidNumber:/ {print $2 " " u}' "$TMP_DIR/uid_gid.txt" > "$TMP_DIR/user_gid.map"

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
    log "누락된 기본 그룹 생성 완료"
  else
    log "기본 그룹 누락 없음"
  fi
}

# ======== 5단계: LDAP → 로컬 이어쓰기 (중복 방지, 전체 교체) ========
sync_ldap_to_local() {
  log "▶ 5단계: LDAP 사용자/그룹 → 로컬 이어쓰기 시작"

  local tmp_passwd="$TMP_DIR/passwd.tmp"
  local tmp_shadow="$TMP_DIR/shadow.tmp"
  local tmp_group="$TMP_DIR/group.tmp"
  local tmp_gshadow="$TMP_DIR/gshadow.tmp"

  # /etc/passwd
  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" "objectClass=posixAccount" \
    uid uidNumber gidNumber gecos homeDirectory loginShell | \
    awk -F': ' '
    /^uid:/ {u=$2}
    /^uidNumber:/ {uidn=$2}
    /^gidNumber:/ {gid=$2}
    /^gecos:/ {g=$2}
    /^homeDirectory:/ {h=$2}
    /^loginShell:/ {s=$2}
    /^$/ {
      print u ":x:" uidn ":" gid ":" g ":" h ":" s
    }' > "$tmp_passwd"

  # /etc/shadow
  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_PEOPLE,$BASE_DN" "objectClass=shadowAccount" \
    uid userPassword shadowLastChange shadowMin shadowMax shadowWarning | \
    awk -F': ' '
    /^uid:/ {u=$2}
    /^userPassword:/ {p=$2}
    /^shadowLastChange:/ {a=$2}
    /^shadowMin:/ {b=$2}
    /^shadowMax:/ {c=$2}
    /^shadowWarning:/ {d=$2}
    /^$/ {
      print u ":" p ":" a ":" b ":" c ":" d ":::" 
    }' > "$tmp_shadow"

  # /etc/group
  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_GROUPS,$BASE_DN" "objectClass=posixGroup" \
    cn gidNumber memberUid | \
    awk -F': ' '
    /^cn:/ {cn=$2}
    /^gidNumber:/ {gid=$2}
    /^memberUid:/ {
      if(mems=="") mems=$2; else mems=mems","$2
    }
    /^$/ {
      print cn ":x:" gid ":" mems
      mems=""
    }' > "$tmp_group"

  # /etc/gshadow
  ldapsearch -x -LLL -H "$LDAP_HOST" -b "$OU_GROUPS,$BASE_DN" "objectClass=posixGroup" \
    cn memberUid | \
    awk -F': ' '
    /^cn:/ {cn=$2}
    /^memberUid:/ {
      if(mems=="") mems=$2; else mems=mems","$2
    }
    /^$/ {
      print cn ":*::" mems
      mems=""
    }' > "$tmp_gshadow"

  replace_passwd_entries_by_uid "$LOCAL_PASSWD" "$tmp_passwd"
  replace_shadow_entries_by_uid "$LOCAL_SHADOW" "$tmp_shadow"
  replace_group_entries_by_name "$LOCAL_GROUP" "$tmp_group"
  replace_group_entries_by_name "$LOCAL_GSHADOW" "$tmp_gshadow"

  log "▶ 5단계 완료: 로컬 이어쓰기 및 중복 제거"
}

# ======== 메인 실행 ========
main() {
  log "=========================="
  log "LDAP ↔ 로컬 동기화 시작"
  log "=========================="

  create_required_groups

  sync_groups_to_ldap
  sync_local_large_gid_groups_to_ldap

  sync_users_to_ldap
  create_missing_primary_groups
  sync_ldap_to_local

  log "=========================="
  log "LDAP ↔ 로컬 동기화 종료"
  log "=========================="
}

main
