# 실습 환경 구성

| Hostname | NAT-Network IP | intnet IP | 호스트전용어댑터 | CPU | MEM | DISK |
| -- | -- | -- | -- | -- | -- | -- |
| client01 | 172.16.2.5/16 | 10.0.0.5/16 | 192.168.56.5/24 | 2 | 4G | 50G |
| client02 | 172.16.2.6 | 10.0.0.6 | 192.168.56.6 | 2 | 4G | 50G |
| client03 | 172.16.2.7 | 10.0.0.7 | 192.168.56.7 | 2 | 4G | 50G |

### 로컬 레포 구성
- client01 : Rocky-8.9-x86_64-dvd1
- client02, client03 : Rocky-8.9-x86_64-minimal

➡️ client01에서 필요 패키지를 scp를 통해 전송하였음

<br>

1. client01에서 02, 03으로 패키지 전송
2. localinstall 활용하기 (의존패키지 설치 필요)
![Image](https://github.com/user-attachments/assets/fbd1c94b-6110-4de7-a4e2-cce79ad3aa05)

3. scp를 통해 의존패키지 가져오기
![Image](https://github.com/user-attachments/assets/cadf3e75-8f61-4d15-ad3a-f0c10766370d)
![Image](https://github.com/user-attachments/assets/1c3c9a96-ac9c-415c-8539-315fe9542aff)
   
4. 의존성 패키지부터 설치 후 createrepo 설치
    ```
    [root@client03 c]# yum localinstall ./drpm-0.4.1-3.el8.x86_64.rpm
    [root@client03 c]# yum localinstall createrepo_c-libs-0.17.7-6.el8.x86_64.rpm
    [root@client03 c]# yum localinstall createrepo_c-0.17.7-6.el8.x86_64.rpm
    ```

<br>

## [217p] 하드 링크와 심볼릭 링크 생성하기
```
# cd
~# mkdir linktest && cd $_

[root@client02 linktest]# vi basefile
[root@client02 linktest]# ln basefile hardlink
[root@client02 linktest]# ln -s basefile softlink

[root@client02 linktest]# cat basefile
   original file for file link test
[root@client02 linktest]# cat hardlink
   original file for file link test
[root@client02 linktest]# cat softlink
   original file for file link test
```

```
[root@client02 linktest]# ls -il
total 8
1448904 -rw-r--r-- 2 root root 33 Apr 10 13:02 basefile
1448904 -rw-r--r-- 2 root root 33 Apr 10 13:02 hardlink
1448903 lrwxrwxrwx 1 root root  8 Apr 10 13:03 softlink -> basefile

// basefile과 hardlink의 inode 번호가 같음
```

- mv로 원본 파일 이동시킨 후 상태

   ![Image](https://github.com/user-attachments/assets/9984066f-b33c-4c0a-9593-5e82710c7b11)

---

## [245p] 파일 압축과 묶기
### tar
> 동작
   ```
   c : 새로운 묶음 파일 생성
   x : 묶음 파일을 품
   t : 묶음 파일 해제 전에 묶인 경로 표시
   C : 지정된 디렉터리에 묶음 파일을 품. 지정하지 않으면 묶을 때와 동일한 디렉터리에 해제
   ```

> 옵션
   ```
   f(필수) : 묶음 파일의 이름 지정
   v (visual) : 파일이 묶이거나 풀리는 과정 표시 (생략가능)
   J : tar + xz
   j : tar + bz2
   z : tar + gzip
   ```

## [248p] 파일 위치 검색
1. find 경로옵션조건 action
   - 옵션
     ```
     -name
     -user (소유자)
     -newer(전,후)
     -perm(허가권)
     -size(크기)
     ```

   - action
     ```
     -print (기본값)
     -exec (외부 명령 실행)
     ```

> 기본 사용 예시
   ```
   # find /etc -name "*.conf
   # find /home -user rocky
   # find ~ -perm 644
   # find /usr/bin -size +10k -size -100k
   ```

> 고급 사용 예시
   ```
   # find ~ `size 0k exec ls -l { } \;         // 현재 사용자의 홈 디렉터리 하위에서 크기가 0인 파일 목록 상세히 출력
   # find /home -name "*.swp" -exec rm { } \;  // /home 디렉터리 하위에서 확장명이 *.swp인 파일 삭제
   ```

2. which
   - PATH에 설정된 디렉터리만 검색. 절대경로를 포함한 위치 검색

3. whereis
   - 실행파일 및 소스, man 페이지 파일까지 검색

---

## [252p] CRON
### 1. CRON
- `/etc/crontab`
  ```
  분 시 일 월 요일 사용자 실행명령
  ```

- `/etc/crontab` 디렉터리 구조
  - /etc/cron.hourly      매시
  - /etc/cron.daily       매일
  - /etc/cron.weekly      매주
  - /etc/cron.monthly     매달

#### 💡실습
> 매월 15일 새벽 3시 1분에 /home 디렉터리와 그 하위 디렉터리를 /backup 디렉터리에 백업하도록 예약 작업 설정

1. `crond` 상태 확인

   ![Image](https://github.com/user-attachments/assets/a99a865d-3f05-46de-81f2-ac10456e5e60)
   
2. `/etc/crontab` 파일 수정

   ![Image](https://github.com/user-attachments/assets/fc4d9658-d23a-4a16-a1aa-19053cc9bc1b)

3. `/etc/cron.monthly` 파일 수정
   
   ![Image](https://github.com/user-attachments/assets/506795cc-3c93-4cad-977c-8b4268fa0879)
      
4. `/backup` 디렉터리 생성
      ```
      mkdir /backup
      ```
      
5. `crond` 서비스 재시작
      ```
      systemctl restart crond
      ```
      
6. 날짜 변경 후 테스트

   ![Image](https://github.com/user-attachments/assets/317361ce-2d8e-42b5-a532-80e912f4c2a5)

---

## [274p] SELinux
- 보안에 취약한 리눅스 보호 위해 탄생
- 시스템에서 보안에 영향을 미치는 서비스, 권한 등 제어 가능
- 침입자가 네트워크의 어떤 경로로 시스템 침입에 성공하더라고 침입한 경로의 애플리케이션 사용 이상의 권한을 얻지는 못함
  - e.g. FTP 서버의 경로로 침입한 경우, FTP와 관련된 디렉터리나 파일 외 다른 서버에는 접근 불가

<br>

#### 🌟selinux 활성화 여부 확인

   ![Image](https://github.com/user-attachments/assets/5ecf603b-5db6-4f74-be78-c5e34b5e1ff7)

<br>

#### 🌟`/etc/selinux/config` 파일 확인
   1. `SELINUX=` 항목
    
      ![Image](https://github.com/user-attachments/assets/888b32ce-7140-4c58-9498-5ca79002553e)

         - `enforcing` : SELinux 정책 적용
         - `permissive` : 정책 위반 시 경고만 출력 (실제 차단은 하지 않음)
         - `disabled` : SELinux 기능이 완전히 꺼짐

   2. `SELINUXTYPE` 항목

       ![Image](https://github.com/user-attachments/assets/0835a907-5f2f-4575-b716-fb775d01c526)

         - `targeted` : 기본값, 주요 시스템 데몬만 보호
              - SELINUX가 활성화될 경우, 기본 `targeted` 정책을 사용하게 설정돼 있음.
         - `minimum` : `targeted`보다 더 적은 범위 보호
         - `mls` : 다단계 보안(Multi-Level Security). 고보안 환경에 사용

#### ✅ 폐쇄망에서 SELinux를 끄는 주요 이유
1. 디버깅과 문제 해결이 복잡해짐
   - selinux는 정상적인 서비스 동작도 차단할 가능성 O
   - e.g.
     - 특정 디렉터리 접근 불가
     - 로그 파일 생성 안 됨
     - 포트를 열더라도 서비스가 차단됨
   
---

## [285p] root password 복구

### 1️⃣ Step 1
1. 사용자 모드(응급 복구 모드) 접속
   - 부팅 후 GRUB 부트 로더가 나타났을 때, 첫 번째 항목이 선택된 상태에서 `E` 클릭 (Edit)
     
      ![Image](https://github.com/user-attachments/assets/483c4bf8-6335-42cd-bd96-efe877175db0)

2. 노란색 부분 수정하기
     - `rhgb quiet` ➡️ `init=/bin/bash`
       
         ![Image](https://github.com/user-attachments/assets/f576fea8-fcef-4b5d-af3b-9d3ce103a650)

3. `Ctrl`+`X` 눌러서 부팅

### 2️⃣ Step 2
- 단일 사용자 모드에서 root의 비밀번호를 변경한다.
1. 별도의 로그인 절차 없이 부팅이 된다.

    ![Image](https://github.com/user-attachments/assets/6d4bacbc-9ca5-4599-a688-7076b185d0fa)
      - `whoami` 명령을 입력해 현재 로그인된 사용자가 root인지 확인

2. `passwd` 명령을 통해 패스워드 변경
      - 변경할 수 없다는 오류 메시지가 출력됨.
      - 현재 '/' 파티션(루트파티션)이 읽기 전용모드로 마운트되어 있기 때문!

### 3️⃣ Step 3
- 마운트된 파티션을 읽기/쓰기 모드로 변경한다.

1. `mount` 명령을 입력한 후 가장 아래쪽을 보면, '/' 파티션이 읽기 전용(ro) 모드로 마운트되어 있는 사실 확인 가능
   
     ![Image](https://github.com/user-attachments/assets/997ec9e9-149b-4c5a-b29a-34682c384400)
   
2. `mount -o remount,rw /` 명령을 입력해 rw 모드로 다시 마운트 + 상태 확인

      ![Image](https://github.com/user-attachments/assets/2d103e03-b4ac-44b1-bfc9-c83aacba2934)

3. 다시 `passwd` 명령을 입력해 비밀번호 변경 시도 --> 성공!

      ![Image](https://github.com/user-attachments/assets/268cead4-56a6-4f70-8b75-bec1ff2a8fbc)
    
4. 재부팅 후 로그인에 시도하면 성공

<br>

---

## [288p] GRUB 부트로더
```
├── grub2
│   ├── device.map
│   ├── fonts
│   │   └── unicode.pf2
│   ├── grub.cfg            // GRUB의 핵심 설정 파일
│   ├── grubenv             // GRUB 환경 변수 저장 파일
│   └── i386-pc             // GRUB2 모듈(.mod 파일) 저장 디렉터리
│       ├── acpi.mod
│       ├── adler32.mod
│       ├── ...

```

- `GRUB 부트로더`란 Rocky linux를 부팅할 때 처음 나오는 선택 화면을 말함
  
- GRUB 2의 설정파일은 `/boot/grub2/grub.cfg`이며, 그 링크 파일은 `/etc/grub2.cfg`다.
  - `grub.cfg` : 일반 사용자에게는 읽기 전용으로 권한 설정되어 있음. root는 r/w 가능
  - 하지만 GRUB 2의 설정을 변경하고자 이 파일을 직접 편집해서는 안 됨!
  - 설정 내용을 변경하려면 `/etc/default/grub` 파일과 `/etc/grub.d` 디렉터리의 파일을 수정한 후 `grub2-mkconfig`명령을 실행해 설정을 적용해야 함

<br>

### `vi /etc/default/grub`

| 행 | 내용 |
|---|----------|
|1|GRUB_TIMEOUT=5|
|2|GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g'/etc/system-release)"|
|3|GRUB_DEFAULT=saved|
|4|GRUB_DISABLE_SUBMENU=true|
|5|GRUB_TERMINAL_OUTPUT="console"|
|6|GRUB_CMDLINE_LINUX="resume=UUID=22f95bfe-c61f-45b7-a86f-e78606b368e8 rhgb quiet"|
|7|GRUB_DISABLE_RECOVERY="true"|
|8|GRUB_ENABLE_BLSCFG=true|

- 1행 : GRUB 부트로더 나온 후 자동 부팅되는 시간 지정
  
- 2행 : 초기 부팅 화면의 각 엔트리 앞에 붙을 배포판 이름 추출
     - 위의 경우, /etc/system-release 파일에서 `Rocky Linux`라는 글자를 추출
       
- 3행 : 기본 선택 엔트리 지정.
     - `saved` : 이전에 선택한 엔트리가 기본으로 계속 선택되도록 한다는 뜻
     - `0`으로 설정하면 첫 번째 엔트리가 선택됨
       
- 4행 : 서브 메뉴 사용 여부 결정
     - `true`로 설정하면 서브 메뉴를 사용할 수 없음. 변경할 필요 x
     - 서브메뉴??????
- 5행 : GRUB 부트로더가 출력될 장치 지정
     - console로 설정하면 모니터로 설정됨. 그 외 serial, gfxterm (그래픽 모드 출력) 등으로 설정 가능 

- 6행 : 부팅 시 커널에 전달할 파라미터 지정 설정
     - 응급 복구 모드 접속 위해 이 행 가장 뒤에 `init=/bin/bash`를 붙여서 부팅했었음!

- 7행 : 엔트리에 복구 관련 내용 표시 여부 결정
     - `true`로 설정하면 메뉴 엔트리에서 복구와 관련된 내용 비활성화함. 변경할 필요 x

- 8행 : 생략

<br>

#### 💡 실습 1
> 부트로더의 일부 설정을 변경하고 부트로더에 비밀번호 설정해보기
- 부팅 시 GRUB 부트로더가 나타나도록 운영체제 선택 대기 시간을 20초로 설정한다.
  -  `vi /etc/default/grub`
    
  ![Image](https://github.com/user-attachments/assets/823e1dc5-24eb-4506-8794-6c20e11be954)

  ![Image](https://github.com/user-attachments/assets/0b134bb2-a59a-4255-85ff-0032a4d80aaf)

- 변경 확인

  ![Image](https://github.com/user-attachments/assets/d3b532de-059e-49eb-b3d7-c265563fe297)

<br>

#### 💡 실습 2
> 누구나 GRUB 부트로더를 편집할 수 있었던 문제점을 해결하기 위해, GRUB 부트로더에 비밀번호를 설정한다.

1. `/etc/grub.d/00_geader` 파일을 열고 가장 아래쪽에 다음 4개의 행을 추가하고 저장

   ![image](https://github.com/user-attachments/assets/fbbffe25-9aad-4a23-8bdd-8970879f372e)


2. 변경한 내용 적용
   ```
   grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

3. `reboot` 명령을 통해 재부팅.
   - 이제부터는 GRUB 부트로더를 사용하려면 앞에서 설정한 사용자 이름과 비밀번호 입력해야 함
   - 제대로 작동하는지 확인하기 위해 부팅 시 `E`를 눌러 편집화면에 진입해볼 것

      ![Image](https://github.com/user-attachments/assets/935c5fa4-a3d9-48f5-b2ae-4df9439655bb)

