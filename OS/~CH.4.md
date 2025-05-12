# 실습 환경 구성

| Hostname | NAT-Network IP | intnet IP | 호스트전용어댑터 | CPU | MEM | DISK |
| -- | -- | -- | -- | -- | -- | -- |
| client01 | 172.16.2.5/16 | 10.0.0.5/16 | 192.168.56.5/24 | 2 | 4G | 50G |
| client02 | 172.16.2.6 | 10.0.0.6 | 192.168.56.6 | 2 | 4G | 50G |
| client03 | 172.16.2.7 | 10.0.0.7 | 192.168.56.7 | 2 | 4G | 50G |

- `Rocky-8.9-x86_64-minimal` 설치
- 로컬 레포 구성은 `Rocky-8.9-x86_64-dvd1` 사용

<br>

# ⚒️ 로컬 레포 구성(1)
1. iso 파일 삽입
   ```
   mount -o loop /dev/sr0 /mnt
   ```

2. 디렉터리 생성 후 파일 복사
   ```
   mkdir /localrepo
   cd /mnt
   cp -ar AppStream/ BaseOS/ /localrepo/
   ```

3. 마운트 해제
   ```
   umount /mnt
   ```


4. `/etc/yum.repos.d/local.repo` 파일 생성

   ![image](https://github.com/user-attachments/assets/531c70f5-a69e-45be-9203-7a13efa11341)



5. 설치 테스트

   ![image](https://github.com/user-attachments/assets/df2688c4-61dd-4c09-93eb-46febbff05d6)

<br>

---
# ⚒️ 로컬 레포 구성(2)
1. 드래그 앤 드롭으로 iso 파일 삽입 (위치: /root/)
   
   ![image](https://github.com/user-attachments/assets/391b96e9-6e10-4c71-beab-c5341d71c25c)


2. 마운트

   ```
   mount -o loop /root/rhel-8.9-x86_64-dvd.iso /mnt/iso
   ```

   ```
   yum clean all
   yum makecache
   yum repolist
   ```


3. 자동 마운트 설정
   ```
   vi /etc/fstab

   /root/rhel-8.9-x86_64-dvd.iso /mnt/iso iso9660 loop,ro,nofail 0 0
   ```

   ![image](https://github.com/user-attachments/assets/7c622000-216c-40b6-b4fc-3d6305571924)


4. 테스트

   ![image](https://github.com/user-attachments/assets/500adbf7-f584-45a2-a0e3-a08614500783)

<br>

---

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

   ![image](https://github.com/user-attachments/assets/2994cc70-f93d-4fe1-800d-9757cff5a255)


3. `/etc/cron.monthly` 파일 수정
   
   ![Image](https://github.com/user-attachments/assets/506795cc-3c93-4cad-977c-8b4268fa0879)

   - /home 디렉토리를 압축해서 /backup 디렉토리에 저장하는 백업 스크립트
      
5. `/backup` 디렉터리 생성
      ```
      mkdir /backup
      ```
      
6. `crond` 서비스 재시작
      ```
      systemctl restart crond
      ```
      
7. 날짜 변경 후 테스트

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

  -  여기서 `-o` 옵션은 output을 의미. 출력 위치 지정!
  -  == grub2-mkconfig가 생성한 부팅 설정 내용을 /boot/grub2/grub.cfg 파일에 저장해라
    
  ![Image](https://github.com/user-attachments/assets/0b134bb2-a59a-4255-85ff-0032a4d80aaf)

- 변경 확인

  ![Image](https://github.com/user-attachments/assets/d3b532de-059e-49eb-b3d7-c265563fe297)

<br>

#### 💡 실습 2
> 누구나 GRUB 부트로더를 편집할 수 있었던 문제점을 해결하기 위해, GRUB 부트로더에 비밀번호를 설정한다.

1. `/etc/grub.d/00_geader` 파일을 열고 가장 아래쪽에 다음 4개의 행을 추가하고 저장

   ![image](https://github.com/user-attachments/assets/fbbffe25-9aad-4a23-8bdd-8970879f372e)


3. 변경한 내용 적용
   ```
   grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

4. `reboot` 명령을 통해 재부팅.
   - 이제부터는 GRUB 부트로더를 사용하려면 앞에서 설정한 사용자 이름과 비밀번호 입력해야 함
   - 제대로 작동하는지 확인하기 위해 부팅 시 `E`를 눌러 편집화면에 진입해볼 것

      ![Image](https://github.com/user-attachments/assets/935c5fa4-a3d9-48f5-b2ae-4df9439655bb)

---

## [293p] 커널/컴파일
### 커널
- 컴퓨터의 자원을 효율적으로 관리하고, 사용자 프로그램이 하드웨어에 직접 접근하지 않도록 보호하면서 필요한 자원을 제공하는 핵심 소프트웨어

#### 핵심 역할
![image](https://github.com/user-attachments/assets/66d97d6e-b8c4-4370-9019-df31a3df97bf)
- 최근에 출시된 하드웨어를 장착할 때 기존의 커널은 해당 하드웨어를 지원하지 않지만, 최신의 커널은 지원할 경우 커널 업그레이드를 해야 할 수 있음
- 주로 하드웨어의 지원 문제 때문에 커널 컴파일 또는 커널 업그레이드 진행

<br>

#### 동작 방식
1. 사용자가 응용 프로그램 실행
2. 응용 프로그램이 시스템 자원 요청 (e.g. 파일열기)
3. 시스템 호출을 통해 커널에 요청 전달
4. 커널이 하드웨어 제어 및 자원 할당
5. 결과를 사용자 프로그램에 반환

<br>

#### 💡참고
- `dmesg` 명령어로 커널 로그 확인 -> 커널이 하드웨어를 어떻게 인식했는지 알 수 있음
- `uname -r` 명령으로 현재 사용 중인 커널 버전 확인 가능

<br>

### ✅ 리눅스 커널 관련 정보 검증 명령어
1. 커널 버전 확인
   ```
   uname -r
   ```

   ![image](https://github.com/user-attachments/assets/03ae4964-64bc-471b-89d2-666591ba96a9)


2. 커널 로그 확인
   - 부팅 과정에서 커널이 하드웨어를 어떻게 인식하고 설정했는지 로그 확인 가능
     
   ```
   dmesg | less
   ```

      ![image](https://github.com/user-attachments/assets/46b57138-c7c6-4242-a0c4-856b570be26e)

   - 커널 및 GCC 버전
     ```
     version 8.5.0 20210514 (Red Hat 8.5.0-20) (GCC)
     ```

   - 커널 파라미터
     ```
     Command line: BOOT_IMAGE=(hd0,msdos1)/vmlinuz-4.18.0-513.5.1.el8_9.x86_64 ...
     ```
     - 부팅 시 사용된 커널 이미지: `vmlinuz-4.18.0-513.5.1.el8_9`
     - 해당 커널은 RHEL 8.9 계열의 최신 보안 패치 버전임
     - 이 줄에서 현재 부팅된 커널의 정확한 버전과 root 디스크정보, quiet 모드 여부 확인 가능

   - 하드웨어 정보 (BIOS, RAM, CPU)

        ![image](https://github.com/user-attachments/assets/ab3df526-2fcf-4ef5-b254-6d40957476f4)
      - `e820` : BIOS가 제공하는 *물리 메모리 맵
           - `*물리 메모리 맵`: 컴퓨터에 장착된 RAM의 주소 공간이 어떤 용도로 사용되고 있는지에 대한 지도 (메모리 충돌 방지)
      - 어떤 메모리 영역이 사용 가능한지(`usable`) 혹은 예약되어 있는지(`reserved`) 확인 가능
   
---

### 커널 모듈
- 커널에 동적으로 추가하거나 제거할 수 있는 기능 단위 코드
  - e.g. 디바이스 드라이버, 파일시스템, 보안기능, CPU/전원관리 등
- 장점: 커널 전체를 재컴파일하지 않아도 기능 확장 가능

<br>

#### 모듈 분석

![image](https://github.com/user-attachments/assets/e80d4c57-abc7-42ed-9f85-930eb2496e4f)

- 모듈을 자세히 보고 싶다면 `modinfo 모듈명` 
     
### 💡실습
> Rocky linux 8.9의 커널을 최신 버전으로 업그레이드하자.

<br>

#### 1️⃣ 설치된 커널 버전과 현재 최신 커널 버전 확인

- 커널 버전 확인 및 업데이트 버전 확인

   - 커널/OS 버전 확인
   
      ![image](https://github.com/user-attachments/assets/5264a2ce-f693-463a-ae34-9c62b8db479e)

   - 업데이트 가능 버전 확인
        ```
        dnf list kernel
        ```   

       ![image](https://github.com/user-attachments/assets/9f89389f-c757-44a1-8ef4-2a995459d841)

     - 공식 사이트에서 확인
            
       ![image](https://github.com/user-attachments/assets/42427615-21c7-4564-b763-49e3cee97c01)

<br>

#### 2️⃣ 필요 패키지 설치
> OS 버전 업데이트는 다른 소프트웨어와의 호환성에 문제가 있을 수 있어 커널 업데이트만 진행

<https://download.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/>

- `client02`는 폐쇄망이기 때문에 인터넷이 가능한 `client01`에서 scp를 통해 전송할 예정

   - `client01`에 패키지 설치
      ```
      wget https://download.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/kernel-core-4.18.0-553.el8_10.x86_64.rpm
      wget https://download.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/kernel-modules-4.18.0-553.el8_10.x86_64.rpm
      wget https://download.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/kernel-modules-extra-4.18.0-553.el8_10.x86_64.rpm

      ```
         
     ![image](https://github.com/user-attachments/assets/712a8dec-147c-450c-8252-996236af5072)

   - `client02`에 scp를 통해 전송
      ```
      scp -r kernel-core-4.18.0-553.el8_10.x86_64.rpm 192.168.56.6:/localrepo//AppStream/Packages/k                         
      scp -r kernel-modules-extra-4.18.0-553.el8_10.x86_64.rpm  192.168.56.6:/localrepo/AppStream/Packages/k
      scp -r kernel-modules-4.18.0-553.el8_10.x86_64.rpm 192.168.56.6:/localrepo/AppStream/Packages/k
      ```
<br>

- `client02`에서 파일 확인
     ```
     ls | grep 553
     ```

  ![image](https://github.com/user-attachments/assets/0fd7fb22-6934-498f-8944-6a56fe7472be)

- kernel 설치
   ```
   yum localinstall ./kernel-core-4.18.0-553.el8_10.x86_64.rpm
   yum localinstall kernel-modules-4.18.0-553.el8_10.x86_64.rpm
   yum localinstall ./kernel-modules-extra-4.18.0-553.el8_10.x86_64.rpm
   ```

<br>

#### 3️⃣ 커널 업데이트 진행
- 설치 후 부팅 커널 설정 (grub에 새 커널 등록)
   ```
   sudo grubby --set-default /boot/vmlinuz-4.18.0-553.el8_10.x86_64
   ```

- 부팅 커널 확인
  ```
  grubby --default-kernel
  ```

   ![image](https://github.com/user-attachments/assets/9f34c5f0-7418-47ea-8fe5-75225456799f)

<br>

#### 4️⃣ 재부팅 후 확인!
- 재부팅 전 커널

  ![image](https://github.com/user-attachments/assets/5b7dbb5f-dd3a-4390-ab07-579d4a9cc1db)

- 재부팅 후 커널

  ![image](https://github.com/user-attachments/assets/37e132a7-5b23-4070-8bce-45f575abeb6e)

<br>

#### 5️⃣ 참고
- `uname -r`로는 커널 업데이트된 것 확인 가능한데, `dnf list kernel`에는 이전 버전만 보이는 상황

   ![image](https://github.com/user-attachments/assets/ae95bc61-6986-4b4c-ab73-d1da99a8bfae)

- `dnf list kernel` 명령은 "kernel"이라는 메타 패키지의 설치 여부만 확인.
- 하지만, 실제로 시스템에 설치되는 건 아래처럼 버전별로 나뉘어진 개별 패키지들임
     
    ![image](https://github.com/user-attachments/assets/eb0843bb-5929-4f80-8aff-01b7739074ff)

- `kernel-core-4.18.0-553.el8_10` 버전은 수동으로 설치했지만, 커널 메타패키지는 업데이트되지 않았기 때문에 예전 버전만 보이는 것임.

<br>

> 🌟 메타패키지도 최신으로 맞추고 싶다면 `kernel-4.18.0-553.el8_10.x86_64.rpm`

- client01
   ```
   wget https://download.rockylinux.org/pub/rocky/8/BaseOS/x86_64/os/Packages/k/kernel-4.18.0-553.el8_10.x86_64.rpm
   scp -r kernel-4.18.0-553.el8_10.x86_64.rpm 192.168.56.6:/localrepo/AppStream/Packages/k
   ```

- client02
   ```
   yum localinstall kernel-4.18.0-553.el8_10.x86_64.rpm
   ```

   ![image](https://github.com/user-attachments/assets/06826011-c427-449b-8488-bb757bab4854)

---




