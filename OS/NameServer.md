## [507p] 네임 서버
### 로컬네임서버 + 캐싱네임서버
  
![image](https://github.com/user-attachments/assets/ed81431e-425e-42e7-982a-47c64d9db506)

<br>

### 💡실습
> **client01을 캐싱 전용 네임 서버로 구축하고, client02에서 client01을 네임서버로 사용하도록 설정 변경하기**

#### 1️⃣ `client01`에 네임서버 설치하고 관련 설정 진행
1. 패키지 설치
   
   ```
   yum install bind bind-chroot
   ```
   
   - `bind`: **기본 BIND DNS 서버**
      - dns 서버 기능을 수행하는 기본 패키지
      - 설치 시, dns 서버 데몬인 `named`가 일반적인 시스템 경로에서 실행됨

   - `bind-chroot`: **제한된 가상 환경에서 `bind` 실행**
      - `chroot`: 실행환경을 특정 디렉터리로 가둬서 시스템의 나머지 부분에 접근하지 못하게 하는 보안 기법
      - `bind`를 `/var/named/chroot`라는 격리된 디렉터리 안에서 실행하게 함
      - dns 서버가 해킹당하더라도 시스템 전체에 피해를 주지 않도록 제한함

      ![image](https://github.com/user-attachments/assets/490a7ad6-c08a-4640-b84c-d3f3ed705f6f)

3. 캐싱 전용 네임 서버와 관련된 설정 파일인 `/etc/named.conf` 수정

   ![image](https://github.com/user-attachments/assets/284b3c63-5497-43ad-8d49-68cc9daf5cf9)

   - ipv4용 53번 포트 수신 허용 / ipv6 비활성화
   - 외부 누구나 질의 가능
   - `DNSSEC` 응답 검증 하지 않음
     - Domain Name System Security Extensions: DNS의 위변조 방지 및 무결성 검증을 위한 보안 확장 기능

      ![image](https://github.com/user-attachments/assets/dc256ad9-665a-4f62-ae4a-5cbbca1fec8b)

   <br>
   
   ```
   systemctl restart named
   systemctl enable named
   systemctl status named
   ```

4. 네임서버 작동 테스트

   ![image](https://github.com/user-attachments/assets/8e1256fc-d863-4889-adda-1c914e5e8c9a)

   ```
   nslookup
   server [테스트할 네임서버 IP]    // 질의할 서버 지
   조회할 URL
   exit
   ```

<br>

#### 2️⃣`client02`에서 네임서버 설정 변경
1. `client01`에서 구축한 네임서버가 잘 가동하는지 확인 (`client02`에서 진행)
   
   ![image](https://github.com/user-attachments/assets/ae1fcdcf-04c4-4cd0-841a-3ae3b2230d7f)

2. 위 네임서버를 고정적으로 사용하도록 지정
   - `NetworkManager`를 사용할 경우 수동 변경한 `resolv.conf` 파일은 재부팅 후 초기화가 됨

   ```
   nmcli con mod enp0s9 ipv4.dns 192.168.56.5
   nmcli con mod enp0s9 ipv4.ignore-auto-dns yes
   nmcli con up enp0s9
   ```
   
   ```
   vi /etc/resolv.conf
   ```
   
     ![image](https://github.com/user-attachments/assets/7ce95544-4a5c-466a-8dee-a060583609b6)

   - 폐쇄망으로 구성해서 `curl`은 사용x, `nslookup`으로 테스트

     ![image](https://github.com/user-attachments/assets/88cff000-5670-4244-9523-77c4a50bdbf2)

<br>

---

### 마스터 네임 서버
- 도메인에 속해 있는 컴퓨터의 이름 관리, URL을 가진 컴퓨터의 IP 주소를 알기 원할 때 컴퓨터의 IP 주소를 알려주는 네임서버
- 자신이 별도로 관리하는 도메인이 있으며 외부에서 자신이 관리하는 컴퓨터의 ip 주소를 물어볼 때 자신의 DB에서 그 주소를 찾아 알려주는 네임서버

### 💡실습
> **`client01`에 ecore.com의 마스터 네임 서버를 설치하고 운영하자**

#### 1️⃣ 웹서버 설치
```
yum install httpd
```

- `index.html` 파일 생성
  
   ![image](https://github.com/user-attachments/assets/2bf3c50e-99eb-4529-bed2-f7a4a2db5d5b)

<br>

#### 2️⃣ FTP 서버 설치 및 설정 (`client03`에서 진행)
```
yum install -y vsftpd
```

- `/var/ftp/welcome.msg` 파일 생성

     ![image](https://github.com/user-attachments/assets/91a1d582-083a-4e7f-94de-5da80d9c3461)

- `/etc/vsftpd/vsftpd.conf` 파일 수정
     - 외부에서 FTP Server에 접속했을 때 출력되는 문구

     ![image](https://github.com/user-attachments/assets/dc2fd4a1-5af3-4c8b-b807-0c15f2232e49)

- FTP 서버 재시작
  ```
  systemctl restart vsftpd
  ```

<br>

#### 3️⃣ ecore.com 도메인에 대한 설정 진행 (`client01`에서 진행)
1. `/etc/named.conf` 파일 수정 (**가장 아래쪽**)
    - 네임 서버 서비스가 시작될 때 제일 먼저 읽는 파일

      ![image](https://github.com/user-attachments/assets/d3bb45dd-f7fc-4a0c-9e0e-6586466a40ec)

      ![image](https://github.com/user-attachments/assets/07b31d11-aec9-4028-86bb-8165bc897998)

      - type `hint` or `master` or `slave` : 마스터 네임 서버
      - file `파일이름` : options의 directory에 생성될 `도메인 이름`의 상세 설정 파일
      - `allow-update { IP주소 } or { none } : 2차 네임 서버 주소. 생략하면 none으로 처리
<br>

2. 문법 체크
   - 아무 메시지도 나오지 않으면 정상
   ```
   named-checkconf
   ```
<br>

3. `/var/named/ecore.com.db` 파일 생성
   - 이 파일을 **정방향 영역 파일** 또는 **포워드 존파일**이라고 함

   ![image](https://github.com/user-attachments/assets/6d4cd30b-6e34-4e0d-908f-c3eb0eb515e6)

   | 문법 | 의미 |
   |-----|--------|
   |;(세미콜론)|주석|
   |$TTL|www.ecore.com의 호스트 이름을 물었을 때 문의한 다른 네임서버가 해당 IP 주소를 캐시에 저장하는 시간|
   |@|/etc/named.conf에 정의된 ecore.com을 의미 (ecore.com으로 작성해도 됨)|
   |IN|클래스 이름으로 internet을 의미|
   |SOA|권한의 시작을 의미|
   |NS|name server, 설정된 도메인의 네임 서버 역할을 하는 컴퓨터 지정|
   |MX|Mail Exchanger, 메일 서버 컴퓨터 설정하는 부분|
   |A|호스트 이름에 상응하는 IP 주소 지정|
   |CNAME|호스트 이름에 별칭 부여할 때 사용|

4. 적용
   
   ```
   systemctl restart named
   ```

<br>

#### 4️⃣ `client02`에서 마스터 네임 서버가 제대로 작동하는지 확인
> **🌟 1. x윈도우 설치 과정 + firefox 접속**
- `client01`에서 `httpd` 활성화

     ```
     systemctl start httpd
     systemctl enable httpd
     ```
     
<br>

- 테스트를 위해 `client02`에 xwindow 설치

   ```
   [root@client02 ~]# yum groupinstall "Server With GUI"
   
   [root@client02 ~]# systemctl set-default graphical.target
   Removed /etc/systemd/system/default.target.
   Created symlink /etc/systemd/system/default.target → /usr/lib/systemd/system/graphical.target.
   [root@client02 ~]# systemctl enable gdm
   [root@client02 ~]# systemctl start gdm
   [root@client02 ~]# sudo yum install xorg-x11-drv-evdev xorg-x11-drv-libinput -y

   [root@client02 ~]# reboot

   [root@client02 ~]# firefox
   // 창은 뜨는데 접속이 안 된다면 `client01`의 `httpd` 상태 확인
   ```

<br>

- firefox 접속 성공 (`client01`이 만든 `/var/www/html/welcom.html` 파일)
  
   ![image](https://github.com/user-attachments/assets/7cd44d57-56bb-4b96-a029-e21ea98f8b26)

<br>

> **🌟 2.`client02`에서 `client03`의 FTP 서버 접속 테스트**
  
   ![image](https://github.com/user-attachments/assets/74c5dfbd-4975-476b-afa3-ad9e3553f212)

<br>

---

### ✅ 라운드 로빈 방식의 네임서버 구현

1️⃣ **`client01`**에서 라운드 로빈 설정 진행
- `nslookup` 명령을 입력해 실제 운영 중인 웹 서버의 IP 주소를 몇 개 확인

    ![image](https://github.com/user-attachments/assets/9ea4dec1-8cdc-4c81-a12d-6a10f1becd82)

    - 위 3개의 IP 주소를 www.ecore.com의 웹 서버 3대라고 가정

- 라운드 로빈 설정
  ```
  vi /var/named/ecore.com.db
  ```

  ![image](https://github.com/user-attachments/assets/fe95e900-0ccb-49ba-9d3f-86f0f24bfdeb)

    - 100/200/300은 단순히 차례를 나타내는 것. 다른 숫자를 사용해도 무관

- 네임 서버 재시작
  ```
  systemctl restart named
  ```

- 라운드 로빈 테스트

    ![image](https://github.com/user-attachments/assets/d80071c7-5de7-4489-8027-a6065b747dd2)

<br>

2️⃣ 외부 인터넷에 있는 컴퓨터(`client02`)로 라운드 로빈 작동 테스트
- **문법 확인** : `named-checkzone ecore2.com ecore2.com.db`

     ![image](https://github.com/user-attachments/assets/27283e23-c965-4fd5-910e-5ffcd87dcbe1)

    - 11, 12행에 값이 정의되어 있지만 TTL 100(첫줄)의 값을 상속한다고 되어 있음

<br>

### 💡 파일을 수정하지 않고 firefox로 접속해보았을 때 TTL이 200으로 지정된 `101.79.10.138` 사이트만 접속되는 상황
- 세 IP 중 하나의 사이트만 뜸 + 위에서 TTL(100)을 상속받았다고 했는데 TTL(200) 값의 사이트만 접속됨

  ![image](https://github.com/user-attachments/assets/209f82a9-184c-4892-8f13-90e53fb1c363)

#### ⚒️ 문제 원인
  - `curl`을 이용해 확인해보기
    ```
    curl -I http://120.50.131.112
    curl -I http://101.79.10.138
    curl -I http://203.252.226.20
    ```
    
     ![image](https://github.com/user-attachments/assets/b1416b43-9e5c-4252-b1b0-eec5a11c8d57)

      ✅ `120.50.131.112`
    - 접속은 되지만, GET 대신 HEAD 요청을 거부하거나, 특정 메서드만 허용한 상태
    - 실제 콘텐츠를 보여주지 않음

    ✅ `101.79.10.138`
    - 정상. 응답가능
    - 실제 웹사이트의 INDEX 페이지 반환

    ✅ `203.252.226.20`
    - 리디렉션 응답(302)
    - curl에선 리디렉션을 따라가지 않지만, 브라우저에서는 잘 작동?

<br>

#### 😎 해결 방안 : nginx를 통해 랜덤 리디렉션
1. nginx 설치
   ```
   yum install -y nginx

   systemctl stop httpd
   systemctl disable httpd (nginx와 포트 번호 충돌)

   systemctl start nginx
   systemctl enable nginx
   ```

2. nginx 설정 파일 생성
   ```
   server {
    listen 80;
    server_name www.ecore2.com;

    location / {
        set $target "";

        # 랜덤 숫자 생성 (0, 1, 2 중 하나)
        set $random $request_id;
        if ($random ~* "^(.)(.)") {
            set $target $1;
        }

        # 랜덤 리디렉션 처리
        if ($target = "0") {
            return 302 https://www.cju.ac.kr;
        }
        if ($target = "1") {
            return 302 https://www.hanbit.co.kr;
        }
        if ($target = "2") {
            return 302 https://www.nate.com;
        }

        # 기본 리디렉션 (설정이 잘못됐을 때)
        return 302 https://www.naver.com;
        }
    }
    ```

    ![image](https://github.com/user-attachments/assets/cc9a08a8-650b-4ac6-8609-a370a21ddb8f)

   
<br>

3. firefox에서 접속 테스트
  
    ![image](https://github.com/user-attachments/assets/4e9be5ed-18d3-48f0-af95-c151c9406e4e)

    











- 라운드로빈 방식의 네임서버 구현
- 메일 서버 구성
- 웹서버 + 내 도메인 만들어서 접속 가능하게 만들어보기
