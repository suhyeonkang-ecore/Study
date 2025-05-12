### 실습 환경
| hostname | 공인 IP | 사설 IP | domain| OS |
|-----------|--------|----------|--------|------|
|dns|115.21.73.7/25|192.168.52.2/16|hanaidc.com|RHEL-8.9|

<br>

1️⃣ 네임서버 설치 및 관련 설정 진행
1. 패키지 설치
   ```
   yum install bind bind-utils
   ```


2. `/etc/named.conf` 파일 수정
   - DNS 서버의 전체 동작 방식, 영역(zone), 접근 제어 등을 설정하는 메인 설정 파일
   
    ![image](https://github.com/user-attachments/assets/7bad651b-f242-4b20-9f06-aba250f2b0fe)

     - ipv4용 53번 포트 수신 허용 / ipv6 비활성화
     - 외부 누구나 질의 가능
     - `DNSSEC` 응답 검증 하지 않음
       - Domain Name System Security Extensions: DNS의 위변조 방지 및 무결성 검증을 위한 보안 확장 기능

3. 서비스 활성화
   ```
   systemctl restart named
   systemctl enable named
   systemctl status named
   ```

4. 네임서버 작동 테스트
   
   ![image](https://github.com/user-attachments/assets/dd9daa48-02ba-430b-b19f-9b5f5f0c3542)


2️⃣

3️⃣

4️⃣

5️⃣
