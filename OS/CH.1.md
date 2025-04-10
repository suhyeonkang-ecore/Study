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



