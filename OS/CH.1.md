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

#### 실습
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
           

