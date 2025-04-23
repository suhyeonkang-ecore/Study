![image](https://github.com/user-attachments/assets/87b0678a-948f-495d-b96b-25f4efcbf20b)![image](https://github.com/user-attachments/assets/cdbc0941-a1a0-4ec1-a44e-70a73c2c0dc8)![image](https://github.com/user-attachments/assets/73ae4fd0-e273-4705-bd83-ca36f516c020)![image](https://github.com/user-attachments/assets/cb5e457b-fabc-4e43-9d5a-f9ecb37386e3)## ssh-keygen
```
[root@gpfs01 ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
26:1c:ef:23:6f:07:d6:61:f9:e5:ac:5a:b8:ba:14:92 root@gpfs01
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
|      .    .     |
|     . +  +   .  |
|      E So o +   |
|       =o.... o  |
|      ..+.. ..   |
|       +...o.    |
|       .++o.     |
+-----------------+
[root@gpfs01 ~]# 
[root@gpfs01 ~]# 
[root@gpfs01 ~]# ls
anaconda-ks.cfg  initial-setup-ks.cfg
[root@gpfs01 ~]# cd .ssh/
[root@gpfs01 .ssh]# ls
id_rsa  id_rsa.pub
[root@gpfs01 .ssh]# cat id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJwOLAEZcCT5mMXOxIIVAkNRlbftt21qdRiR9ktB4a2JAUA1zZnTMhr3zANI5Pn4qMfSy1v3hO0zYAvk7zT/7UfSfHD0t3tZmtXgXqer059aCF3VYaqzymz+a6NDzVmydIg2NVpEA0YZIqKA6emujtqksJT0smphoLXoqT+CU5FmqP3YjYfFaCRqfsxlVlE2fmug/ti8I6b6qXVpQVovZtxROms3/bV8T5lBR5/EmdtJ91jlNgjy97jcYTyo5A45giLTYg5Z5OtCXztQ/YRfUUngydVu/sEjb4JmYxJbWQ6SuAzxM9WQgoHB2dbXP369eK0573Ngc1gcyAxff13Xyj root@gpfs01
[root@gpfs01 .ssh]# cat id_rsa.pub > authorized_keys
```

<br>

```

[root@gpfs01 ~]# vi /etc/hosts
[root@gpfs01 ~]# ping client01
PING client01 (192.168.50.244) 56(84) bytes of data.
64 bytes from client01 (192.168.50.244): icmp_seq=1 ttl=64 time=0.492 ms
^C
--- client01 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.492/0.492/0.492/0.000 ms
[root@gpfs01 ~]# ping client02
PING client02 (192.168.50.245) 56(84) bytes of data.
64 bytes from client02 (192.168.50.245): icmp_seq=1 ttl=64 time=0.198 ms
^C
--- client02 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.198/0.198/0.198/0.000 ms
[root@gpfs01 ~]# ping client03
PING client03 (192.168.50.246) 56(84) bytes of data.
^C
--- client03 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 999ms

[root@gpfs01 ~]# scp -r .ssh/ gpfs02:/root/
The authenticity of host 'gpfs02 (192.168.50.242)' can't be established.
ECDSA key fingerprint is 75:89:20:ab:ee:38:ba:7a:a8:0d:42:74:ed:fd:dd:93.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'gpfs02,192.168.50.242' (ECDSA) to the list of known hosts.
root@gpfs02's password: 
id_rsa                                                                                       100% 1679     1.6KB/s   00:00    
id_rsa.pub                                                                                   100%  393     0.4KB/s   00:00    
authorized_keys                                                                              100%  393     0.4KB/s   00:00    
known_hosts                                                                                  100%  183     0.2KB/s   00:00    
[root@gpfs01 ~]# scp -r .ssh/ gpfs03:/root/
The authenticity of host 'gpfs03 (192.168.50.243)' can't be established.
ECDSA key fingerprint is a3:d9:3f:0c:6d:41:b0:ea:c1:51:c7:0c:14:3d:ca:33.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'gpfs03,192.168.50.243' (ECDSA) to the list of known hosts.
root@gpfs03's password: 
Permission denied, please try again.
root@gpfs03's password: 
id_rsa                                                                                       100% 1679     1.6KB/s   00:00    
id_rsa.pub                                                                                   100%  393     0.4KB/s   00:00    
authorized_keys                                                                              100%  393     0.4KB/s   00:00    
known_hosts                                                                                  100%  366     0.4KB/s   00:00    
[root@gpfs01 ~]# scp -r .ssh/ client01:/root/
```

<br>

```
### gpfs 파일 압축 해제 ###
[root@gpfs01 ~]# ls
anaconda-ks.cfg  initial-setup-ks.cfg  Spectrum_Scale_Standard-4.2.3.4-x86_64-Linux-install
[root@gpfs01 ~]# chmod 700 Spectrum_Scale_Standard-4.2.3.4-x86_64-Linux-install 
[root@gpfs01 ~]# ./Spectrum_Scale_Standard-4.2.3.4-x86_64-Linux-install --text-only

Extracting License Acceptance Process Tool to /usr/lpp/mmfs/4.2.3.4 ...
tail -n +564 ./Spectrum_Scale_Standard-4.2.3.4-x86_64-Linux-install | tar -C /usr/lpp/mmfs/4.2.3.4 -xvz --exclude=installer --exclude=*_rpms --exclude=*rpm  --exclude=*tgz --exclude=*deb 1> /dev/null

Installing JRE ...
tail -n +564 ./Spectrum_Scale_Standard-4.2.3.4-x86_64-Linux-install | tar -C /usr/lpp/mmfs/4.2.3.4 --wildcards -xvz  ibm-java*tgz 1> /dev/null
tar -C /usr/lpp/mmfs/4.2.3.4/ -xzf /usr/lpp/mmfs/4.2.3.4/ibm-java*tgz

Invoking License Acceptance Process Tool ...
/usr/lpp/mmfs/4.2.3.4/ibm-java-x86_64-71/jre/bin/java -cp /usr/lpp/mmfs/4.2.3.4/LAP_HOME/LAPApp.jar com.ibm.lex.lapapp.LAP -l /usr/lpp/mmfs/4.2.3.4/LA_HOME -m /usr/lpp/mmfs/4.2.3.4 -s /usr/lpp/mmfs/4.2.3.4  -text_only

LICENSE INFORMATION

The Programs listed below are licensed under the following 
License Information terms and conditions in addition to the 
Program license terms previously agreed to by Client and 
IBM. If Client does not have previously agreed to license 
terms in effect for the Program, the International Program 
License Agreement (Z125-3301-14) applies.

Program Name (Program Number):
IBM Spectrum Scale V4.2.3.4 (5641-GPF)
IBM Spectrum Scale Data Management Edition V4.2.3.4 (5641-
GPF)
IBM Spectrum Scale Data Management Edition V4.2.3.4 (5725-
Press Enter to continue viewing the license agreement, or 
enter "1" to accept the agreement, "2" to decline it, "3" 
to print it, "4" to read non-IBM terms, or "99" to go back 
to the previous screen.
1

License Agreement Terms accepted.

Extracting Product RPMs to /usr/lpp/mmfs/4.2.3.4 ...
tail -n +564 ./Spectrum_Scale_Standard-4.2.3.4-x86_64-Linux-install | tar -C /usr/lpp/mmfs/4.2.3.4 --wildcards -xvz  gpfs_debs/ubuntu16 gpfs_rpms/rhel7 gpfs_rpms/sles12 zimon_debs/debian6 zimon_debs/debian7 zimon_debs/debian8 zimon_debs/ubuntu12 zimon_debs/ubuntu14 zimon_debs/ubuntu16 zimon_rpms/rhel6 zimon_rpms/rhel7 zimon_rpms/sles11 zimon_rpms/sles12 gpfs_debs gpfs_rpms manifest 1> /dev/null
   - gpfs_debs/ubuntu16
   - gpfs_rpms/rhel7
   - gpfs_rpms/sles12
   - zimon_debs/debian6
   - zimon_debs/debian7
   - zimon_debs/debian8
   - zimon_debs/ubuntu12
   - zimon_debs/ubuntu14
   - zimon_debs/ubuntu16
   - zimon_rpms/rhel6
   - zimon_rpms/rhel7
   - zimon_rpms/sles11
   - zimon_rpms/sles12
   - gpfs_debs
   - gpfs_rpms
   - manifest

Removing License Acceptance Process Tool from /usr/lpp/mmfs/4.2.3.4 ...
rm -rf  /usr/lpp/mmfs/4.2.3.4/LAP_HOME /usr/lpp/mmfs/4.2.3.4/LA_HOME

Removing JRE from /usr/lpp/mmfs/4.2.3.4 ...
rm -rf /usr/lpp/mmfs/4.2.3.4/ibm-java*tgz

==================================================================
Product rpms successfully extracted to /usr/lpp/mmfs/4.2.3.4
```

<br>

## gpfs 설치를 위한 선수 작업 진행
```
[root@gpfs01 ~]# yum install -y ksh
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: ftp.kaist.ac.kr
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
Resolving Dependencies
--> Running transaction check
---> Package ksh.x86_64 0:20120801-34.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================== Package                   Arch                         Version                               Repository                  Size
=====================================================================Installing:
 ksh                       x86_64                       20120801-34.el7                       base                       883 k

Transaction Summary
=====================================================================Install  1 Package

Total download size: 883 k
Installed size: 3.1 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/ksh-20120801-34.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for ksh-20120801-34.el7.x86_64.rpm is not installed
ksh-20120801-34.el7.x86_64.rpm                                                                          | 883 kB  00:00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-3.1611.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : ksh-20120801-34.el7.x86_64                                                                                  1/1 
  Verifying  : ksh-20120801-34.el7.x86_64                                                                                  1/1 

Installed:
  ksh.x86_64 0:20120801-34.el7                                                                                                 

Complete!
```

<br>


```
[root@gpfs02 ~]# yum install -y ksh
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: ftp.kaist.ac.kr
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
Resolving Dependencies
--> Running transaction check
---> Package ksh.x86_64 0:20120801-34.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================== Package                   Arch                         Version                               Repository                  Size
=====================================================================Installing:
 ksh                       x86_64                       20120801-34.el7                       base                       883 k

Transaction Summary
=====================================================================Install  1 Package

Total download size: 883 k
Installed size: 3.1 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/ksh-20120801-34.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for ksh-20120801-34.el7.x86_64.rpm is not installed
ksh-20120801-34.el7.x86_64.rpm                                                                          | 883 kB  00:00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-3.1611.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : ksh-20120801-34.el7.x86_64                                                                                  1/1 
  Verifying  : ksh-20120801-34.el7.x86_64                                                                                  1/1 

Installed:
  ksh.x86_64 0:20120801-34.el7                                                                                                 

Complete!
```

<br>

```
[root@gpfs03 ~]# yum install -y ksh
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: ftp.kaist.ac.kr
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
Resolving Dependencies
--> Running transaction check
---> Package ksh.x86_64 0:20120801-34.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================== Package                   Arch                         Version                               Repository                  Size
=====================================================================Installing:
 ksh                       x86_64                       20120801-34.el7                       base                       883 k

Transaction Summary
=====================================================================Install  1 Package

Total download size: 883 k
Installed size: 3.1 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/ksh-20120801-34.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for ksh-20120801-34.el7.x86_64.rpm is not installed
ksh-20120801-34.el7.x86_64.rpm                                                                          | 883 kB  00:00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-3.1611.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : ksh-20120801-34.el7.x86_64                                                                                  1/1 
  Verifying  : ksh-20120801-34.el7.x86_64                                                                                  1/1 

Installed:
  ksh.x86_64 0:20120801-34.el7                                                                                                 

Complete!
```

<br>

```
[root@client01 ~]# yum install -y ksh
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: ftp.kaist.ac.kr
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
Resolving Dependencies
--> Running transaction check
---> Package ksh.x86_64 0:20120801-34.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================== Package                   Arch                         Version                               Repository                  Size
=====================================================================Installing:
 ksh                       x86_64                       20120801-34.el7                       base                       883 k

Transaction Summary
=====================================================================Install  1 Package

Total download size: 883 k
Installed size: 3.1 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/ksh-20120801-34.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for ksh-20120801-34.el7.x86_64.rpm is not installed
ksh-20120801-34.el7.x86_64.rpm                                                                          | 883 kB  00:00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-3.1611.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : ksh-20120801-34.el7.x86_64                                                                                  1/1 
  Verifying  : ksh-20120801-34.el7.x86_64                                                                                  1/1 

Installed:
  ksh.x86_64 0:20120801-34.el7                                                                                                 

Complete!
```

<br>

```
[root@client03 ~]# yum install -y ksh
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: ftp.kaist.ac.kr
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
Resolving Dependencies
--> Running transaction check
---> Package ksh.x86_64 0:20120801-34.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================== Package                   Arch                         Version                               Repository                  Size
=====================================================================Installing:
 ksh                       x86_64                       20120801-34.el7                       base                       883 k

Transaction Summary
=====================================================================Install  1 Package

Total download size: 883 k
Installed size: 3.1 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/ksh-20120801-34.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for ksh-20120801-34.el7.x86_64.rpm is not installed
ksh-20120801-34.el7.x86_64.rpm                                                                          | 883 kB  00:00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-3.1611.el7.centos.x86_64 (@anaconda)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : ksh-20120801-34.el7.x86_64                                                                                  1/1 
  Verifying  : ksh-20120801-34.el7.x86_64                                                                                  1/1 

Installed:
  ksh.x86_64 0:20120801-34.el7                                                                                                 

Complete!
```

<br>

```
root@client02:~# apt-get install ksh m4 dbus python binutils libaio1 make cpp gcc g++
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  binfmt-support cpp-5 g++-5 gcc-5 gcc-5-base libasan2 libatomic1 libc-dev-bin libc6 libc6-dev libcc1-0 libcilkrts5
  libdbus-1-3 libgcc-5-dev libgomp1 libisl15 libitm1 liblsan0 libmpc3 libmpx0 libpython-stdlib libpython2.7-minimal
  libpython2.7-stdlib libquadmath0 libstdc++-5-dev libstdc++6 libtsan0 libubsan0 linux-libc-dev manpages-dev python-minimal
  python2.7 python2.7-minimal
Suggested packages:
  binutils-doc cpp-doc gcc-5-locales dbus-user-session | dbus-x11 g++-multilib g++-5-multilib gcc-5-doc libstdc++6-5-dbg
  gcc-multilib autoconf automake libtool flex bison gdb gcc-doc gcc-5-multilib libgcc1-dbg libgomp1-dbg libitm1-dbg
  libatomic1-dbg libasan2-dbg liblsan0-dbg libtsan0-dbg libubsan0-dbg libcilkrts5-dbg libmpx0-dbg libquadmath0-dbg glibc-doc
  libstdc++-5-doc make-doc python-doc python-tk python2.7-doc
The following NEW packages will be installed:
  binfmt-support binutils cpp cpp-5 g++ g++-5 gcc gcc-5 ksh libaio1 libasan2 libatomic1 libc-dev-bin libc6-dev libcc1-0
  libcilkrts5 libgcc-5-dev libgomp1 libisl15 libitm1 liblsan0 libmpc3 libmpx0 libpython-stdlib libpython2.7-minimal
  libpython2.7-stdlib libquadmath0 libstdc++-5-dev libtsan0 libubsan0 linux-libc-dev m4 make manpages-dev python
  python-minimal python2.7 python2.7-minimal
The following packages will be upgraded:
  dbus gcc-5-base libc6 libdbus-1-3 libstdc++6
5 upgraded, 38 newly installed, 0 to remove and 185 not upgraded.
Need to get 45.9 MB of archives.
After this operation, 160 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
```

<br>

```
root@client04:~# apt-get install ksh m4 dbus python binutils libaio1 make cpp gcc g++
Reading package lists... Done
Building dependency tree       
Reading state information... Done
python is already the newest version.
The following extra packages will be installed:
  cpp-4.8 g++-4.8 gcc-4.8 gcc-4.8-base libasan0 libatomic1 libc-dev-bin libc6
  libc6-dev libcloog-isl4 libgcc-4.8-dev libgmp10 libgomp1 libisl10 libitm1
  libmpc3 libmpfr4 libquadmath0 libstdc++-4.8-dev libstdc++6 libtsan0
  linux-libc-dev manpages-dev
Suggested packages:
  binutils-doc cpp-doc gcc-4.8-locales dbus-x11 g++-multilib g++-4.8-multilib
  gcc-4.8-doc libstdc++6-4.8-dbg gcc-multilib autoconf automake1.9 libtool
  flex bison gdb gcc-doc gcc-4.8-multilib libgcc1-dbg libgomp1-dbg libitm1-dbg
  libatomic1-dbg libasan0-dbg libtsan0-dbg libquadmath0-dbg glibc-doc
  libstdc++-4.8-doc make-doc
The following NEW packages will be installed:
  binutils cpp cpp-4.8 g++ g++-4.8 gcc gcc-4.8 ksh libaio1 libasan0 libatomic1
  libc-dev-bin libc6-dev libcloog-isl4 libgcc-4.8-dev libgmp10 libgomp1
  libisl10 libitm1 libmpc3 libmpfr4 libquadmath0 libstdc++-4.8-dev libtsan0
  linux-libc-dev m4 make manpages-dev
The following packages will be upgraded:
  dbus gcc-4.8-base libc6 libstdc++6
4 upgraded, 28 newly installed, 0 to remove and 152 not upgraded.
Need to get 44.9 MB of archives.
After this operation, 115 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
```

<br>

```
[root@gpfs01 gpfs_rpms]# cat /etc/redhat-release 
CentOS Linux release 7.3.1611 (Core) 

[root@gpfs02 gpfs_rpms]# cat /etc/redhat-release 
CentOS Linux release 7.3.1611 (Core) 

[root@gpfs03 gpfs_rpms]# cat /etc/redhat-release 
CentOS Linux release 7.3.1611 (Core)

[root@client01 gpfs_rpms]# cat /etc/redhat-release 
CentOS Linux release 7.3.1611 (Core) 

root@client02:~# cat /etc/issue
Ubuntu 16.04.1 LTS \n \l

[root@client03 gpfs_rpms]# cat /etc/redhat-release 
CentOS release 6.7 (Final)

root@client04:~# cat /etc/issue
Ubuntu 14.04.4 LTS \n \l

```

<br>

## gpfs 설치 및 컴파일
```
### GPFS 설치 및 컴파일 하기 ###
[root@gpfs01 gpfs_rpms]# ls
gpfs.base-4.2.3-4.x86_64.rpm                     gpfs.gskit-8.0.50-75.x86_64.rpm        gpfs.msg.en_US-4.2.3-4.noarch.rpm
gpfs.callhome-ecc-client-4.2.3-4.000.noarch.rpm  gpfs.gui-4.2.3-4.noarch.rpm            repodata
gpfs.docs-4.2.3-4.noarch.rpm                     gpfs.hdfs-protocol-2.7.2-3.x86_64.rpm  rhel7
gpfs.ext-4.2.3-4.x86_64.rpm                      gpfs.java-4.2.3-4.x86_64.rpm           sles12
gpfs.gpl-4.2.3-4.noarch.rpm                      gpfs.license.std-4.2.3-4.x86_64.rpm
[root@gpfs01 gpfs_rpms]# pwd
/usr/lpp/mmfs/4.2.3.4/gpfs_rpms

[root@gpfs01 gpfs_rpms]# rpm -ivh gpfs.base-4.2.3-4.x86_64.rpm gpfs.docs-4.2.3-4.noarch.rpm gpfs.ext-4.2.3-4.x86_64.rpm gpfs.gpl-4.2.3-4.noarch.rpm gpfs.gskit-8.0.50-75.x86_64.rpm gpfs.msg.en_US-4.2.3-4.noarch.rpm 
Preparing...                          ################################# [100%]
Updating / installing...
   1:gpfs.base-4.2.3-4                ################################# [ 17%]
Created symlink from /etc/systemd/system/multi-user.target.wants/gpfs.service to /usr/lib/systemd/system/gpfs.service.
   2:gpfs.ext-4.2.3-4                 ################################# [ 33%]
   3:gpfs.gpl-4.2.3-4                 ################################# [ 50%]
   4:gpfs.msg.en_US-4.2.3-4           ################################# [ 67%]
   5:gpfs.gskit-8.0.50-75             ################################# [ 83%]
   6:gpfs.docs-4.2.3-4                ################################# [100%]

[root@gpfs02 gpfs_rpms]# rpm -ivh gpfs.base-4.2.3-4.x86_64.rpm gpfs.docs-4.2.3-4.noarch.rpm gpfs.ext-4.2.3-4.x86_64.rpm gpfs.gpl-4.2.3-4.noarch.rpm gpfs.gskit-8.0.50-75.x86_64.rpm gpfs.msg.en_US-4.2.3-4.noarch.rpm 
Preparing...                          ################################# [100%]
Updating / installing...
   1:gpfs.base-4.2.3-4                ################################# [ 17%]
Created symlink from /etc/systemd/system/multi-user.target.wants/gpfs.service to /usr/lib/systemd/system/gpfs.service.
   2:gpfs.ext-4.2.3-4                 ################################# [ 33%]
   3:gpfs.gpl-4.2.3-4                 ################################# [ 50%]
   4:gpfs.msg.en_US-4.2.3-4           ################################# [ 67%]
   5:gpfs.gskit-8.0.50-75             ################################# [ 83%]
   6:gpfs.docs-4.2.3-4                ################################# [100%]

[root@gpfs03 gpfs_rpms]# rpm -ivh gpfs.base-4.2.3-4.x86_64.rpm gpfs.docs-4.2.3-4.noarch.rpm gpfs.ext-4.2.3-4.x86_64.rpm gpfs.gpl-4.2.3-4.noarch.rpm gpfs.gskit-8.0.50-75.x86_64.rpm gpfs.msg.en_US-4.2.3-4.noarch.rpm 
Preparing...                          ################################# [100%]
Updating / installing...
   1:gpfs.base-4.2.3-4                ################################# [ 17%]
Created symlink from /etc/systemd/system/multi-user.target.wants/gpfs.service to /usr/lib/systemd/system/gpfs.service.
   2:gpfs.ext-4.2.3-4                 ################################# [ 33%]
   3:gpfs.gpl-4.2.3-4                 ################################# [ 50%]
   4:gpfs.msg.en_US-4.2.3-4           ################################# [ 67%]
   5:gpfs.gskit-8.0.50-75             ################################# [ 83%]
   6:gpfs.docs-4.2.3-4                ################################# [100%]
```

<br>

```
[root@client01 gpfs_rpms]# rpm -ivh gpfs.base-4.2.3-4.x86_64.rpm gpfs.docs-4.2.3-4.noarch.rpm gpfs.ext-4.2.3-4.x86_64.rpm gpfs.gpl-4.2.3-4.noarch.rpm gpfs.gskit-8.0.50-75.x86_64.rpm gpfs.msg.en_US-4.2.3-4.noarch.rpm 
Preparing...                          ################################# [100%]
Updating / installing...
   1:gpfs.base-4.2.3-4                ##                                (  7%)
################################# [ 17%]
Created symlink from /etc/systemd/system/multi-user.target.wants/gpfs.service to /usr/lib/systemd/system/gpfs.service.
   2:gpfs.ext-4.2.3-4                 ################################# [ 33%]
   3:gpfs.gpl-4.2.3-4                 ################################# [ 50%]
   4:gpfs.msg.en_US-4.2.3-4           ################################# [ 67%]
   5:gpfs.gskit-8.0.50-75             ################################# [ 83%]
   6:gpfs.docs-4.2.3-4                ################################# [100%]
[root@client03 gpfs_rpms]#  rpm -ivh gpfs.base-4.2.3-4.x86_64.rpm gpfs.docs-4.2.3-4.noarch.rpm gpfs.ext-4.2.3-4.x86_64.rpm gpfs.gpl-4.2.3-4.noarch.rpm gpfs.gskit-8.0.50-75.x86_64.rpm gpfs.msg.en_US-4.2.3-4.noarch.rpm 
Preparing...                ########################################### [100%]
   1:gpfs.base              ########################################### [ 17%]
   2:gpfs.ext               ########################################### [ 33%]
   3:gpfs.gpl               ########################################### [ 50%]
   4:gpfs.msg.en_US         ########################################### [ 67%]
   5:gpfs.gskit             ########################################### [ 83%]
   6:gpfs.docs              ########################################### [100%]

root@client02:~/4.2.3.4/gpfs_debs# dpkg -i gpfs.base_4.2.3-4_amd64.deb gpfs.docs_4.2.3-4_all.deb gpfs.ext_4.2.3-4_amd64.deb gpfs.gpl_4.2.3-4_all.deb gpfs.gskit_8.0.50-75_amd64.deb gpfs.msg.en-us_4.2.3-4_all.deb 
Selecting previously unselected package gpfs.base.
(Reading database ... 64324 files and directories currently installed.)
Preparing to unpack gpfs.base_4.2.3-4_amd64.deb ...
Unpacking gpfs.base (4.2.3-4) ...
Selecting previously unselected package gpfs.docs.
Preparing to unpack gpfs.docs_4.2.3-4_all.deb ...
Unpacking gpfs.docs (4.2.3-4) ...
Selecting previously unselected package gpfs.ext.
Preparing to unpack gpfs.ext_4.2.3-4_amd64.deb ...
Unpacking gpfs.ext (4.2.3-4) ...
Selecting previously unselected package gpfs.gpl.
Preparing to unpack gpfs.gpl_4.2.3-4_all.deb ...
Unpacking gpfs.gpl (4.2.3-4) ...
Selecting previously unselected package gpfs.gskit.
Preparing to unpack gpfs.gskit_8.0.50-75_amd64.deb ...
Unpacking gpfs.gskit (8.0.50-75) ...
Selecting previously unselected package gpfs.msg.en-us.
Preparing to unpack gpfs.msg.en-us_4.2.3-4_all.deb ...
Unpacking gpfs.msg.en-us (4.2.3-4) ...
Setting up gpfs.base (4.2.3-4) ...
Setting up gpfs.docs (4.2.3-4) ...
Setting up gpfs.ext (4.2.3-4) ...
Setting up gpfs.gpl (4.2.3-4) ...
Setting up gpfs.gskit (8.0.50-75) ...
Setting up gpfs.msg.en-us (4.2.3-4) ...
Processing triggers for man-db (2.7.5-1) ...
Processing triggers for libc-bin (2.23-0ubuntu3) ...
```

<br>

```
root@client04:~/4.2.3.4/gpfs_debs# dpkg -i gpfs.base_4.2.3-4_amd64.deb gpfs.docs_4.2.3-4_all.deb gpfs.ext_4.2.3-4_amd64.deb gpfs.gpl_4.2.3-4_all.deb gpfs.gskit_8.0.50-75_amd64.deb gpfs.msg.en-us_4.2.3-4_all.deb
Selecting previously unselected package gpfs.base.
(Reading database ... 61422 files and directories currently installed.)
Preparing to unpack gpfs.base_4.2.3-4_amd64.deb ...
Unpacking gpfs.base (4.2.3-4) ...
Selecting previously unselected package gpfs.docs.
Preparing to unpack gpfs.docs_4.2.3-4_all.deb ...
Unpacking gpfs.docs (4.2.3-4) ...
Selecting previously unselected package gpfs.ext.
Preparing to unpack gpfs.ext_4.2.3-4_amd64.deb ...
Unpacking gpfs.ext (4.2.3-4) ...
Selecting previously unselected package gpfs.gpl.
Preparing to unpack gpfs.gpl_4.2.3-4_all.deb ...
Unpacking gpfs.gpl (4.2.3-4) ...
Selecting previously unselected package gpfs.gskit.
Preparing to unpack gpfs.gskit_8.0.50-75_amd64.deb ...
Unpacking gpfs.gskit (8.0.50-75) ...
Selecting previously unselected package gpfs.msg.en-us.
Preparing to unpack gpfs.msg.en-us_4.2.3-4_all.deb ...
Unpacking gpfs.msg.en-us (4.2.3-4) ...
Setting up gpfs.base (4.2.3-4) ...
 Adding system startup for /etc/init.d/gpfs ...
   /etc/rc0.d/K30gpfs -> ../init.d/gpfs
   /etc/rc1.d/K30gpfs -> ../init.d/gpfs
   /etc/rc6.d/K30gpfs -> ../init.d/gpfs
   /etc/rc2.d/S30gpfs -> ../init.d/gpfs
   /etc/rc3.d/S30gpfs -> ../init.d/gpfs
   /etc/rc4.d/S30gpfs -> ../init.d/gpfs
   /etc/rc5.d/S30gpfs -> ../init.d/gpfs
Setting up gpfs.docs (4.2.3-4) ...
Setting up gpfs.ext (4.2.3-4) ...
Setting up gpfs.gpl (4.2.3-4) ...
Setting up gpfs.gskit (8.0.50-75) ...
Setting up gpfs.msg.en-us (4.2.3-4) ...
Processing triggers for man-db (2.6.7.1-1ubuntu1) ...
Processing triggers for libc-bin (2.19-0ubuntu6.7) ...
```

<br>

```
[root@gpfs01 src]# make Autoconfig LINUX_DISTRIBUTION=REDHAT_AS_LINUX
cd /usr/lpp/mmfs/src/config; ./configure --genenvonly; if [ $? -eq 0 ]; then /usr/bin/cpp -P def.mk.proto > ./def.mk; exit $? || exit 1; else exit $?; fi
[root@gpfs01 src]# make World
[root@gpfs01 src]# make InstallImages

[root@gpfs02 src]# make Autoconfig LINUX_DISTRIBUTION=REDHAT_AS_LINUX
cd /usr/lpp/mmfs/src/config; ./configure --genenvonly; if [ $? -eq 0 ]; then /usr/bin/cpp -P def.mk.proto > ./def.mk; exit $? || exit 1; else exit $?; fi
[root@gpfs02 src]# make World
[root@gpfs02 src]# make InstallImages

[root@gpfs03 src]# make Autoconfig LINUX_DISTRIBUTION=REDHAT_AS_LINUX
cd /usr/lpp/mmfs/src/config; ./configure --genenvonly; if [ $? -eq 0 ]; then /usr/bin/cpp -P def.mk.proto > ./def.mk; exit $? || exit 1; else exit $?; fi
[root@gpfs03 src]# make World
[root@gpfs03 src]# make InstallImages

[root@client01 src]# make Autoconfig LINUX_DISTRIBUTION=REDHAT_AS_LINUX
cd /usr/lpp/mmfs/src/config; ./configure --genenvonly; if [ $? -eq 0 ]; then /usr/bin/cpp -P def.mk.proto > ./def.mk; exit $? || exit 1; else exit $?; fi
[root@client01 src]# make World
[root@client01 src]# make InstallImages

[root@client01 src]# make Autoconfig LINUX_DISTRIBUTION=REDHAT_AS_LINUX
cd /usr/lpp/mmfs/src/config; ./configure --genenvonly; if [ $? -eq 0 ]; then /usr/bin/cpp -P def.mk.proto > ./def.mk; exit $? || exit 1; else exit $?; fi
[root@client01 src]# make World
[root@client01 src]# make InstallImages

[root@client03 src]# make Autoconfig LINUX_DISTRIBUTION=REDHAT_AS_LINUX
cd /usr/lpp/mmfs/src/config; ./configure --genenvonly; if [ $? -eq 0 ]; then /usr/bin/cpp -P def.mk.proto > ./def.mk; exit $? || exit 1; else exit $?; fi
[root@client03 src]# make World
[root@client03 src]# make InstallImages
```

<br>

```
root@client02:~# mmbuildgpl 
--------------------------------------------------------
mmbuildgpl: Building GPL module begins at Wed Nov  1 14:06:40 KST 2017.
--------------------------------------------------------
Verifying Kernel Header...
  kernel version = 40400031 (4.4.0-31-generic, 4.4.0-31) 
  module include dir = /lib/modules/4.4.0-31-generic/build/include 
  module build dir   = /lib/modules/4.4.0-31-generic/build 
  kernel source dir  = /usr/src/linux-4.4.0-31-generic/include 
  Found valid kernel header file under /lib/modules/4.4.0-31-generic/build/include
Verifying Compiler...
  make is present at /usr/bin/make
  cpp is present at /usr/bin/cpp
  gcc is present at /usr/bin/gcc
  g++ is present at /usr/bin/g++
  ld is present at /usr/bin/ld
make World ...
make InstallImages ...
--------------------------------------------------------
mmbuildgpl: Building GPL module completed successfully at Wed Nov  1 14:07:00 KST 2017.
--------------------------------------------------------

root@client04:~# mmbuildgpl 
--------------------------------------------------------
mmbuildgpl: Building GPL module begins at Wed Nov  1 14:06:49 KST 2017.
--------------------------------------------------------
Verifying Kernel Header...
  kernel version = 40200027 (4.2.0-27-generic, 4.2.0-27) 
  module include dir = /lib/modules/4.2.0-27-generic/build/include 
  module build dir   = /lib/modules/4.2.0-27-generic/build 
  kernel source dir  = /usr/src/linux-4.2.0-27-generic/include 
  Found valid kernel header file under /lib/modules/4.2.0-27-generic/build/include
Verifying Compiler...
  make is present at /usr/bin/make
  cpp is present at /usr/bin/cpp
  gcc is present at /usr/bin/gcc
  g++ is present at /usr/bin/g++
  ld is present at /usr/bin/ld
make World ...
make InstallImages ...
--------------------------------------------------------
mmbuildgpl: Building GPL module completed successfully at Wed Nov  1 14:07:06 KST 2017.
--------------------------------------------------------
```

<br>

## gpfs 클러스터 생성
```
### GPFS 클러스터 생성 ###
[root@gpfs01 work]# mmcrcluster 
mmcrcluster: Missing arguments.
Usage:
  mmcrcluster -N {NodeDesc[,NodeDesc...] | NodeFile}
     [--ccr-enable | {--ccr-disable -p PrimaryServer [-s SecondaryServer]}]
     [ [-r RemoteShellCommand] [-R RemoteFileCopyCommand] | --use-sudo-wrapper ]
     [-C ClusterName] [-U DomainName] [-A]
     [-c ConfigFile | --profile ProfileName]

[root@gpfs01 work]# cat node
gpfs01:quorum-manager
gpfs02:quorum-manager
gpfs03:quorum-manager

[root@gpfs01 work]# mmcrcluster -N node -p gpfs01 -s gpfs02 -C test
mmcrcluster: Performing preliminary node verification ...
mmcrcluster: Processing quorum and other critical nodes ...
The authenticity of host 'gpfs01 (192.168.50.241)' can't be established.
ECDSA key fingerprint is e4:d2:df:f8:25:9a:cc:1d:12:d4:f7:ff:cd:04:63:9d.
Are you sure you want to continue connecting (yes/no)? yes
mmcrcluster: Finalizing the cluster data structures ...
mmcrcluster: Command successfully completed
mmcrcluster: Warning: Not all nodes have proper GPFS license designations.
    Use the mmchlicense command to designate licenses as needed.
mmcrcluster: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.

[root@gpfs01 work]# mmlscluster

=====================================================================
| Warning:                                                                    |
|   This cluster contains nodes that do not have a proper GPFS license        |
|   designation.  This violates the terms of the GPFS licensing agreement.    |
|   Use the mmchlicense command and assign the appropriate GPFS licenses      |
|   to each of the nodes in the cluster.  For more information about GPFS     |
|   license designation, see the Concepts, Planning, and Installation Guide.  |
=====================================================================
GPFS cluster information
========================
  GPFS cluster name:         test.gpfs01
  GPFS cluster id:           9842223104266949822
  GPFS UID domain:           test.gpfs01
  Remote shell command:      /usr/bin/ssh
  Remote file copy command:  /usr/bin/scp
  Repository type:           CCR

 Node  Daemon node name  IP address      Admin node name  Designation
----------------------------------------------------------------------
   1   gpfs01            192.168.50.241  gpfs01           quorum-manager
   2   gpfs02            192.168.50.242  gpfs02           quorum-manager
   3   gpfs03            192.168.50.243  gpfs03           quorum-manager
```

<br>

## gpfs 라이선스 등록
```
### GPFS 라이선스 등록 ###
[root@gpfs01 work]# mmchlicense 
Mmchlicense: Missing arguments.
Usage:
  mmchlicense {client|fpo|server} [--accept] –N {Node[,Node…] | NodeFile | NodeClass}

[root@gpfs01 work]# mmchlicense server –accept –N gpfs01,gpfs02,gpfs03

The following nodes will be designated as possessing server licenses:
	gpfs02
	gpfs03
	gpfs01
Mmchlicense: Command successfully completed
Mmchlicense: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.

### NSD 생성 ###
[root@gpfs01 work]# mmcrnsd
Mmcrnsd: Missing arguments.
Usage: mmcrnsd –F StanzaFile [-v {yes | no}]

[root@gpfs01 work]# cat nsd
%nsd: device=/dev/sdb nsd=nsd01 servers=gpfs01 usage=dataAndMetadata failureGroup=-1 pool=system
%nsd: device=/dev/sdc nsd=nsd02 servers=gpfs01 usage=dataAndMetadata failureGroup=-1 pool=system
%nsd: device=/dev/sdb nsd=nsd03 servers=gpfs02 usage=dataAndMetadata failureGroup=-1 pool=system
%nsd: device=/dev/sdc nsd=nsd04 servers=gpfs02 usage=dataAndMetadata failureGroup=-1 pool=system
%nsd: device=/dev/sdc nsd=nsd05 servers=gpfs03 usage=dataAndMetadata failureGroup=-1 pool=system
%nsd: device=/dev/sdc nsd=nsd06 servers=gpfs03 usage=dataAndMetadata failureGroup=-1 pool=system

[root@gpfs01 work]# mmcrnsd –F nsd
[root@gpfs01 work]# mmlsnsd

 File system   Disk name    NSD servers                                    
---------------------------------------------------------------------------
 (free disk)   nsd01        gpfs01                   
 (free disk)   nsd02        gpfs01                   
 (free disk)   nsd03        gpfs02                   
 (free disk)   nsd04        gpfs02                   
 (free disk)   nsd05        gpfs03                   
 (free disk)   nsd06        gpfs03 
```

<br>

## gpfs startup
```
### GPFS startup ###
[root@gpfs01 ~]# mmgetstate -a

 Node number  Node name        GPFS state 
------------------------------------------
       1      gpfs01           down
       2      gpfs02           down
       3      gpfs03           down

[root@gpfs01 ~]# mmstartup -a
Wed Nov  1 14:08:30 KST 2017: mmstartup: Starting GPFS ...
gpfs01:  /tmp/mmfs has been created successfully.
gpfs02:  /tmp/mmfs has been created successfully.
gpfs03:  /tmp/mmfs has been created successfully.

[root@gpfs01 ~]# tail -f /var/mmfs/gen/mmfslog 
2017-11-01_14:08:35.312+0900: [D] PFD load: nextToWriteIdx: 1 seq: 19 (4096)
2017-11-01_14:08:35.312+0900: [N] CCR: failed to connect to node 192.168.50.243:1191 (sock 17 err 79)
2017-11-01_14:08:35.332+0900: [N] handleCcrReq: server not yet started
2017-11-01_14:08:35.711+0900: [I] Accepted and connected to 192.168.50.242 gpfs02 <c0p0>
2017-11-01_14:08:35.865+0900: [N] Connecting to 192.168.50.243 gpfs03 <c0p1>
2017-11-01_14:08:35.874+0900: [I] Connected to 192.168.50.243 gpfs03 <c0p1>
2017-11-01_14:08:35.874+0900: [D] Running election ...
2017-11-01_14:08:35.903+0900: [I] This node got elected. Sequence: 1
2017-11-01_14:08:35.908+0900: [D] Election completed. Details: OLLG: 4304442 OLLG delta: 0
2017-11-01_14:08:35.908+0900: [I] Delay 93 seconds for safe recovery.
2017-11-01_14:10:08.919+0900: [I] Node 192.168.50.241 (gpfs01) is now the Group Leader.
2017-11-01_14:10:08.941+0900: [N] This node (192.168.50.241 (gpfs01)) is now Cluster Manager for test.gpfs01.
2017-11-01_14:10:09.134+0900: [I] Calling user exit script mmClusterManagerRoleChange: event clusterManagerTakeOver, Async command /usr/lpp/mmfs/bin/mmsysmonc.
2017-11-01_14:10:09.157+0900: [N] mmfsd ready
2017-11-01_14:10:09.284+0900: mmcommon mmfsup invoked. Parameters: 192.168.50.241 192.168.50.241 all
2017-11-01_14:10:09.610+0900: [I] Calling user exit script mmSysMonGpfsStartup: event startup, Async command /usr/lpp/mmfs/bin/mmsysmoncontrol.
2017-11-01_14:10:09.619+0900: [I] Calling user exit script mmSinceShutdownRoleChange: event startup, Async command /usr/lpp/mmfs/bin/mmsysmonc.
2017-11-01_14:10:11.637+0900: [I] Calling user exit script mmsysmonjsonChange: event ccrFileChange, Async command /usr/lpp/mmfs/bin/mmsysmonc.
^C
You have new mail in /var/spool/mail/root
[root@gpfs01 ~]# mmgetstate -a

 Node number  Node name        GPFS state 
------------------------------------------
       1      gpfs01           active
       2      gpfs02           active
       3      gpfs03           active

```

<br>

## gpfs 파일시스템 생성
```
### GPFS 파일시스템 생성 ###
[root@gpfs01 work]# cat mmcrfs
/usr/lpp/mmfs/bin/mmcrfs ffs -F nsd -A yes -B 512k -j scatter -T /xfel/ffs
[root@gpfs01 work]# chmod 700 mmcrfs
[root@gpfs01 work]# ./mmcrfs 

The following disks of ffs will be formatted on node gpfs02:
    nsd01: size 16384 MB
    nsd02: size 16384 MB
    nsd03: size 16384 MB
    nsd04: size 16384 MB
    nsd05: size 16384 MB
    nsd06: size 16384 MB
Formatting file system ...
Disks up to size 288 GB can be added to storage pool system.
Creating Inode File
Creating Allocation Maps
Creating Log Files
Clearing Inode Allocation Map
Clearing Block Allocation Map
Formatting Allocation Map for storage pool system
Completed creation of file system /dev/ffs.
mmcrfs: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
```

<br>

```
[root@gpfs01 work]# mmlsfs all

File system attributes for /dev/ffs:
====================================
flag                value                    description
------------------- ------------------------ -----------------------------------
 -f                 16384                    Minimum fragment size in bytes
 -i                 4096                     Inode size in bytes
 -I                 16384                    Indirect block size in bytes
 -m                 1                        Default number of metadata replicas
 -M                 2                        Maximum number of metadata replicas
 -r                 1                        Default number of data replicas
 -R                 2                        Maximum number of data replicas
 -j                 scatter                  Block allocation type
 -D                 nfs4                     File locking semantics in effect
 -k                 all                      ACL semantics in effect
 -n                 32                       Estimated number of nodes that will mount file system
 -B                 524288                   Block size
 -Q                 none                     Quotas accounting enabled
                    none                     Quotas enforced
                    none                     Default quotas enabled
 --perfileset-quota No                       Per-fileset quota enforcement
 --filesetdf        No                       Fileset df enabled?
 -V                 17.00 (4.2.3.0)          File system version
 --create-time      Wed Nov  1 14:11:39 2017 File system creation time
 -z                 No                       Is DMAPI enabled?
 -L                 4194304                  Logfile size
 -E                 Yes                      Exact mtime mount option
 -S                 No                       Suppress atime mount option
 -K                 whenpossible             Strict replica allocation option
 --fastea           Yes                      Fast external attributes enabled?
 --encryption       No                       Encryption enabled?
 --inode-limit      99072                    Maximum number of inodes
 --log-replicas     0                        Number of log replicas
 --is4KAligned      Yes                      is4KAligned?
 --rapid-repair     Yes                      rapidRepair enabled?
 --write-cache-threshold 0                   HAWC Threshold (max 65536)
 --subblocks-per-full-block 32               Number of subblocks per full block
 -P                 system                   Disk storage pools in file system
 -d                 nsd01;nsd02;nsd03;nsd04;nsd05;nsd06  Disks in file system
 -A                 yes                      Automatic mount option
 -o                 none                     Additional mount options
 -T                 /xfel/ffs                Default mount point
 --mount-priority   0                        Mount priority
```

<br>

```
[root@gpfs01 work]# mmmount all -a
Wed Nov  1 14:26:35 KST 2017: mmmount: Mounting file systems ...
[root@gpfs01 work]# df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/cl-root   17G  5.7G   12G  34% /
devtmpfs             3.9G     0  3.9G   0% /dev
tmpfs                3.9G   84K  3.9G   1% /dev/shm
tmpfs                3.9G  8.9M  3.9G   1% /run
tmpfs                3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sda1           1014M  155M  860M  16% /boot
tmpfs                799M   16K  799M   1% /run/user/42
tmpfs                799M     0  799M   0% /run/user/0
ffs                   96G   85G   12G  88% /xfel/ffs
```

<br>

## NTP 설정
```
### NTP 설정 ###
[root@gpfs01 ~]# yum install -y ntp
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirror.navercorp.com
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
Resolving Dependencies
--> Running transaction check
---> Package ntp.x86_64 0:4.2.6p5-25.el7.centos.2 will be installed
--> Processing Dependency: ntpdate = 4.2.6p5-25.el7.centos.2 for package: ntp-4.2.6p5-25.el7.centos.2.x86_64
--> Running transaction check
---> Package ntpdate.x86_64 0:4.2.6p5-25.el7.centos will be updated
---> Package ntpdate.x86_64 0:4.2.6p5-25.el7.centos.2 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================
 Package                    Arch                      Version                                    Repository               Size
===============================================================================================================================
Installing:
 ntp                        x86_64                    4.2.6p5-25.el7.centos.2                    base                    547 k
Updating for dependencies:
 ntpdate                    x86_64                    4.2.6p5-25.el7.centos.2                    base                     86 k

Transaction Summary
===============================================================================================================================
Install  1 Package
Upgrade             ( 1 Dependent package)

ntpdate.x86_64 0:4.2.6p5-25.el7.centos.2                                                                                     

Complete!
```

<br>

```
[root@gpfs01 ~]# vi /etc/hosts
[root@gpfs01 ~]# ping client01
PING client01 (192.168.50.244) 56(84) bytes of data.
64 bytes from client01 (192.168.50.244): icmp_seq=1 ttl=64 time=0.492 ms
^C
--- client01 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.492/0.492/0.492/0.000 ms
[root@gpfs01 ~]# ping client02
PING client02 (192.168.50.245) 56(84) bytes of data.
64 bytes from client02 (192.168.50.245): icmp_seq=1 ttl=64 time=0.198 ms
^C
--- client02 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.198/0.198/0.198/0.000 ms
[root@gpfs01 ~]# ping client03
PING client03 (192.168.50.246) 56(84) bytes of data.
^C
--- client03 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 999ms

[root@gpfs01 ~]# scp -r .ssh/ gpfs02:/root/
The authenticity of host 'gpfs02 (192.168.50.242)' can't be established.
ECDSA key fingerprint is 75:89:20:ab:ee:38:ba:7a:a8:0d:42:74:ed:fd:dd:93.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'gpfs02,192.168.50.242' (ECDSA) to the list of known hosts.
root@gpfs02's password: 
id_rsa                                                                                       100% 1679     1.6KB/s   00:00    
id_rsa.pub                                                                                   100%  393     0.4KB/s   00:00    
authorized_keys                                                                              100%  393     0.4KB/s   00:00    
known_hosts                                                                                  100%  183     0.2KB/s   00:00    
[root@gpfs01 ~]# scp -r .ssh/ gpfs03:/root/
The authenticity of host 'gpfs03 (192.168.50.243)' can't be established.
ECDSA key fingerprint is a3:d9:3f:0c:6d:41:b0:ea:c1:51:c7:0c:14:3d:ca:33.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'gpfs03,192.168.50.243' (ECDSA) to the list of known hosts.
root@gpfs03's password: 
Permission denied, please try again.
root@gpfs03's password: 
id_rsa                                                                                       100% 1679     1.6KB/s   00:00    
id_rsa.pub                                                                                   100%  393     0.4KB/s   00:00    
authorized_keys                                                                              100%  393     0.4KB/s   00:00    
known_hosts                                                                                  100%  366     0.4KB/s   00:00    
[root@gpfs01 ~]# scp -r .ssh/ client01:/root/
```

<br>

```
[root@gpfs01 ~]# cat /etc/ntp.conf 
# For more information about this file, see the man pages
# ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).

driftfile /var/lib/ntp/drift

# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
restrict default nomodify notrap nopeer noquery

# Permit all access over the loopback interface.  This could
# be tightened as well, but to do so would effect some of
# the administrative functions.
restrict 127.0.0.1 
restrict ::1

# Hosts on local network are less restricted.
restrict 192.168.50.0 mask 255.255.255.0 nomodify notrap

# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst
server	kr.pool.ntp.org

includefile /etc/ntp/ctypto/pw

#broadcast 192.168.1.255 autokey	# broadcast server
#broadcastclient			# broadcast client
#broadcast 224.0.1.1 autokey		# multicast server
#multicastclient 224.0.1.1		# multicast client
#manycastserver 239.255.254.254		# manycast server
#manycastclient 239.255.254.254 autokey # manycast client

server	127.127.1.0
fudge	127.127.1.0 strtum 3
```

<br>

```
# Enable public key cryptography.
#crypto

includefile /etc/ntp/crypto/pw

# Key file containing the keys and key identifiers used when operating
# with symmetric key cryptography. 
keys /etc/ntp/keys

# Specify the key identifiers which are trusted.
#trustedkey 4 8 42

# Specify the key identifier to use with the ntpdc utility.
#requestkey 8

# Specify the key identifier to use with the ntpq utility.
#controlkey 8

# Enable writing of statistics records.
#statistics clockstats cryptostats loopstats peerstats

# Disable the monitoring facility to prevent amplification attacks using ntpdc
# monlist command when default restrict does not include the noquery flag. See
# CVE-2013-5211 for more details.
# Note: Monitoring will not be disabled with the limited restriction flag.
disable monitor

[root@gpfs01 ~]# systemctl restart ntpd
[root@gpfs01 ~]# systemctl status ntpd
● ntpd.service - Network Time Service
   Loaded: loaded (/usr/lib/systemd/system/ntpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 15:31:31 KST; 2s ago
  Process: 23964 ExecStart=/usr/sbin/ntpd -u ntp:ntp $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 23966 (ntpd)
   CGroup: /system.slice/ntpd.service
           └─23966 /usr/sbin/ntpd -u ntp:ntp -g

Nov 01 15:31:31 gpfs01 ntpd[23966]: Listen normally on 3 ens192 192.168.50.241...23
Nov 01 15:31:31 gpfs01 ntpd[23966]: Listen normally on 4 virbr0 192.168.122.1 ...23
Nov 01 15:31:31 gpfs01 ntpd[23966]: Listen normally on 5 lo ::1 UDP 123
Nov 01 15:31:31 gpfs01 ntpd[23966]: Listen normally on 6 ens192 fe80::250:56ff...23
Nov 01 15:31:31 gpfs01 ntpd[23966]: Listening on routing socket on fd #23 for ...es
Nov 01 15:31:31 gpfs01 systemd[1]: Started Network Time Service.
Nov 01 15:31:31 gpfs01 ntpd[23966]: 0.0.0.0 c016 06 restart
Nov 01 15:31:31 gpfs01 ntpd[23966]: 0.0.0.0 c012 02 freq_set kernel 0.000 PPM
Nov 01 15:31:31 gpfs01 ntpd[23966]: 0.0.0.0 c011 01 freq_not_set
Nov 01 15:31:33 gpfs01 ntpd[23966]: 0.0.0.0 c514 04 freq_mode
Hint: Some lines were ellipsized, use -l to show in full.

```

<br>

### ntp 서버 구성 확인(http://tez.kr/150)



## gpfs 클라이언트 등록
```
### GPFS 클라이언트 등록 ###
[root@gpfs01 work]# mmaddnode -N client 
Wed Nov  1 16:01:09 KST 2017: mmaddnode: Processing node client01
Wed Nov  1 16:01:11 KST 2017: mmaddnode: Processing node client02
Wed Nov  1 16:01:13 KST 2017: mmaddnode: Processing node client03
Wed Nov  1 16:01:16 KST 2017: mmaddnode: Processing node client04
Wed Nov  1 16:01:18 KST 2017: mmaddnode: Processing node client05
mmaddnode: client05 cannot be reached.
mmaddnode: The following nodes could not be added to the GPFS cluster:
		client05
   Correct the problems and use the mmaddnode command to add these nodes
   to the cluster.
mmaddnode: Command successfully completed
mmaddnode: Warning: Not all nodes have proper GPFS license designations.
    Use the mmchlicense command to designate licenses as needed.
mmaddnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.

[root@gpfs01 work]# mmchlicense client --accept -N client01,client02,client03,client04

The following nodes will be designated as possessing client licenses:
	client01
	client02
	client03
	client04
mmchlicense: Command successfully completed
mmchlicense: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.

[root@gpfs01 work]# mmstartup -N client01,client02,client03,client04
Wed Nov  1 16:03:02 KST 2017: mmstartup: Starting GPFS ...
client01:  /tmp/mmfs has been created successfully.
client03:  /tmp/mmfs has been created successfully.
client02:  /tmp/mmfs has been created successfully.
client04:  /tmp/mmfs has been created successfully.

[root@gpfs01 work]# mmgetstate -aL

 Node number  Node name       Quorum  Nodes up  Total nodes  GPFS state  Remarks    
------------------------------------------------------------------------------------
       1      gpfs01             2        3          7       active      quorum node
       2      gpfs02             2        3          7       active      quorum node
       3      gpfs03             2        3          7       active      quorum node
       4      client01           2        3          7       active      
       5      client02           2        3          7       active      
       6      client03           2        3          7       active      
       7      client04           2        3          7       active 

```

<br>

## 파일시스템 마운트
```
### 파일시스템 마운트 ###
[root@gpfs01 work]# mmmount all -N client01,client02,client03,client04
Wed Nov  1 16:03:49 KST 2017: mmmount: Mounting file systems ...
[root@gpfs01 work]# mmlsmount all -L
                                            
File system ffs is mounted on 7 nodes:
  192.168.50.242  gpfs02                    
  192.168.50.241  gpfs01                    
  192.168.50.243  gpfs03                    
  192.168.50.244  client01                  
  192.168.50.246  client03                  
  192.168.50.247  client04                  
  192.168.50.245  client02 

[root@gpfs01 work]# mmlsmgr
file system      manager node
---------------- ------------------
ffs              192.168.50.242 (gpfs02)

Cluster manager node: 192.168.50.241 (gpfs01)
```

<br>

## gpfs config 등록
```
### GPFS config 등록 ###
mmchconfig nfsPrefetchStrategy=1,maxReceiverThreads=32,logWrapThreads=16,worker1Threads=720,tscWorkerPool=64,statCacheDirPct=50,nsdInlineWriteMax=8K,maxAllocRegionsPerNode=64,maxFileCleaners=32,maxBackgroundDeletionThreads=128,maxInodeDeallocPrefetch=8,statCacheDirPct=50,seqDiscardThreshhold=999G,prefetchPct=40,nsdMinWorkerThreads=32,nsdMaxWorkerThreads=800,nsdbufspace=70,nsdThreadsPerDisk=60,maxFilesToCache=4M,tokenMemLimit=8G,pagepool=32G -N gpfs01,gpfs02,gpfs03

[root@gpfs01 work]# ./mmchconfig 
mmchconfig: Command successfully completed
mmchconfig: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
[root@gpfs01 work]# mmlsconfig
Configuration data for cluster test.gpfs01:
-------------------------------------------
clusterName test.gpfs01
clusterId 9842223104266949822
autoload no
dmapiFileHandleSize 32
minReleaseLevel 4.2.3.0
ccrEnabled yes
cipherList AUTHONLY
[gpfs01,gpfs02,gpfs03]
nfsPrefetchStrategy 1
maxReceiverThreads 32
logWrapThreads 16
worker1Threads 720
tscWorkerPool 64
nsdInlineWriteMax 8K
maxAllocRegionsPerNode 64
maxFileCleaners 32
maxBackgroundDeletionThreads 128
maxInodeDeallocPrefetch 8
statCacheDirPct 50
seqDiscardThreshhold 999G
prefetchPct 40
nsdMinWorkerThreads 32
nsdMaxWorkerThreads 800
nsdbufspace 70
nsdThreadsPerDisk 60
maxFilesToCache 4M
tokenMemLimit 8G
pagepool 32G
[common]
adminMode central

File systems in cluster test.gpfs01:
------------------------------------
/dev/ffs
```

<br>

```
[root@gpfs01 work]# cat verbs
mmchconfig pagepool=512M numaMemoryInterleave=yes,maxblocksize=16M,maxMBpS=6000,verbsRdmasPerNode=512,verbsRdmasPerConnection=64,verbsRdmaMinBytes=1024,verbsRdma=enable,verbsPorts=mlx4_0/1

[root@gpfs01 work]# mmlsconfig
Configuration data for cluster test.gpfs01:
-------------------------------------------
clusterName test.gpfs01
clusterId 9842223104266949822
autoload no
dmapiFileHandleSize 32
minReleaseLevel 4.2.3.0
ccrEnabled yes
cipherList AUTHONLY
[gpfs01,gpfs02,gpfs03]
nfsPrefetchStrategy 1
maxReceiverThreads 32
logWrapThreads 16
worker1Threads 720
tscWorkerPool 64
nsdInlineWriteMax 8K
maxAllocRegionsPerNode 64
maxFileCleaners 32
maxBackgroundDeletionThreads 128
maxInodeDeallocPrefetch 8
statCacheDirPct 50
seqDiscardThreshhold 999G
prefetchPct 40
nsdMinWorkerThreads 32
nsdMaxWorkerThreads 800
nsdbufspace 70
nsdThreadsPerDisk 60
maxFilesToCache 4M
tokenMemLimit 8G
pagepool 32G
[common]
verbsRdmasPerNode 512
verbsRdmasPerConnection 64
verbsRdmaMinBytes 1024
verbsRdma enable
adminMode central

File systems in cluster test.gpfs01:
------------------------------------
/dev/ffs
```

<br>

## gpfs gui 서버 설치
```
### GPFS GUI 서버 설치 ###
[root@gpfs01 gpfs_rpms]# rpm -ivh gpfs.java-4.2.3-4.x86_64.rpm 
Preparing...                          ################################# [100%]
Updating / installing...
   1:gpfs.java-4.2.3-4                ################################# [100%]

[root@gpfs01 rhel7]# yum localinstall gpfs.gss.pmcollector-4.2.3-4.el7.x86_64.rpm gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm 
Loaded plugins: fastestmirror, langpacks
Examining gpfs.gss.pmcollector-4.2.3-4.el7.x86_64.rpm: gpfs.gss.pmcollector-4.2.3-4.el7.x86_64
Marking gpfs.gss.pmcollector-4.2.3-4.el7.x86_64.rpm to be installed
Examining gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm: gpfs.gss.pmsensors-4.2.3-4.el7.x86_64
Marking gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package gpfs.gss.pmcollector.x86_64 0:4.2.3-4.el7 will be installed
--> Processing Dependency: libboost_regex.so.1.53.0()(64bit) for package: gpfs.gss.pmcollector-4.2.3-4.el7.x86_64
Loading mirror speeds from cached hostfile
 * base: ftp.daumkakao.com
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
---> Package gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7 will be installed
--> Running transaction check
---> Package boost-regex.x86_64 0:1.53.0-27.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================
 Package                       Arch            Version                 Repository                                         Size
===============================================================================================================================
Installing:
 gpfs.gss.pmcollector          x86_64          4.2.3-4.el7             /gpfs.gss.pmcollector-4.2.3-4.el7.x86_64          8.9 M
 gpfs.gss.pmsensors            x86_64          4.2.3-4.el7             /gpfs.gss.pmsensors-4.2.3-4.el7.x86_64            1.6 M
Installing for dependencies:
 boost-regex                   x86_64          1.53.0-27.el7           base                                              300 k

Transaction Summary
===============================================================================================================================
Install  2 Packages (+1 Dependent package)

Total size: 11 M
Total download size: 300 k
Installed size: 13 M
Is this ok [y/d/N]: y

Downloading packages:
boost-regex-1.53.0-27.el7.x86_64.rpm                                                                    | 300 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Installing : boost-regex-1.53.0-27.el7.x86_64                                                                            1/3 
  Installing : gpfs.gss.pmcollector-4.2.3-4.el7.x86_64                                                                     2/3 
Created symlink from /etc/systemd/system/multi-user.target.wants/pmcollector.service to /usr/lib/systemd/system/pmcollector.service.
  Installing : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       3/3 
Created symlink from /etc/systemd/system/multi-user.target.wants/pmsensors.service to /usr/lib/systemd/system/pmsensors.service.
  Verifying  : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/3 
  Verifying  : boost-regex-1.53.0-27.el7.x86_64                                                                            2/3 
  Verifying  : gpfs.gss.pmcollector-4.2.3-4.el7.x86_64                                                                     3/3 

Installed:
  gpfs.gss.pmcollector.x86_64 0:4.2.3-4.el7                       gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7                      

Dependency Installed:
  boost-regex.x86_64 0:1.53.0-27.el7                                                                                           

Complete!
```

<br>

```
[root@gpfs01 gpfs_rpms]# yum localinstall gpfs.gui-4.2.3-4.noarch.rpm 
Loaded plugins: fastestmirror, langpacks
Examining gpfs.gui-4.2.3-4.noarch.rpm: gpfs.gui-4.2.3-4.noarch
Marking gpfs.gui-4.2.3-4.noarch.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package gpfs.gui.noarch 0:4.2.3-4 will be installed
--> Processing Dependency: postgresql-server for package: gpfs.gui-4.2.3-4.noarch
Loading mirror speeds from cached hostfile
 * base: ftp.daumkakao.com
 * extras: ftp.kaist.ac.kr
 * updates: ftp.kaist.ac.kr
--> Running transaction check
---> Package postgresql-server.x86_64 0:9.2.23-1.el7_4 will be installed
--> Processing Dependency: postgresql-libs(x86-64) = 9.2.23-1.el7_4 for package: postgresql-server-9.2.23-1.el7_4.x86_64
--> Processing Dependency: postgresql(x86-64) = 9.2.23-1.el7_4 for package: postgresql-server-9.2.23-1.el7_4.x86_64
--> Processing Dependency: libpq.so.5()(64bit) for package: postgresql-server-9.2.23-1.el7_4.x86_64
--> Running transaction check
---> Package postgresql.x86_64 0:9.2.23-1.el7_4 will be installed
---> Package postgresql-libs.x86_64 0:9.2.23-1.el7_4 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================
 Package                        Arch                Version                        Repository                             Size
===============================================================================================================================
Installing:
 gpfs.gui                       noarch              4.2.3-4                        /gpfs.gui-4.2.3-4.noarch               83 M
Installing for dependencies:
 postgresql                     x86_64              9.2.23-1.el7_4                 updates                               3.0 M
 postgresql-libs                x86_64              9.2.23-1.el7_4                 updates                               233 k
 postgresql-server              x86_64              9.2.23-1.el7_4                 updates                               3.8 M

Transaction Summary
===============================================================================================================================
Install  1 Package (+3 Dependent packages)

Total size: 90 M
Total download size: 7.0 M
Installed size: 116 M
Is this ok [y/d/N]: y
Downloading packages:
(1/3): postgresql-libs-9.2.23-1.el7_4.x86_64.rpm                                                        | 233 kB  00:00:00     
(2/3): postgresql-9.2.23-1.el7_4.x86_64.rpm                                                             | 3.0 MB  00:00:00     
(3/3): postgresql-server-9.2.23-1.el7_4.x86_64.rpm                                                      | 3.8 MB  00:00:00     
-------------------------------------------------------------------------------------------------------------------------------
Total                                                                                           17 MB/s | 7.0 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : postgresql-libs-9.2.23-1.el7_4.x86_64                                                                       1/4 
  Installing : postgresql-9.2.23-1.el7_4.x86_64                                                                            2/4 
  Installing : postgresql-server-9.2.23-1.el7_4.x86_64                                                                     3/4 
  Installing : gpfs.gui-4.2.3-4.noarch                                                                                     4/4 
  Verifying  : postgresql-libs-9.2.23-1.el7_4.x86_64                                                                       1/4 
  Verifying  : postgresql-server-9.2.23-1.el7_4.x86_64                                                                     2/4 
  Verifying  : postgresql-9.2.23-1.el7_4.x86_64                                                                            3/4 
  Verifying  : gpfs.gui-4.2.3-4.noarch                                                                                     4/4 

Installed:
  gpfs.gui.noarch 0:4.2.3-4                                                                                                    

Dependency Installed:
  postgresql.x86_64 0:9.2.23-1.el7_4    postgresql-libs.x86_64 0:9.2.23-1.el7_4    postgresql-server.x86_64 0:9.2.23-1.el7_4   

Complete!

```

```
[root@gpfs01 gpfs_rpms]# systemctl status gpfsgui.service 
● gpfsgui.service - IBM_Spectrum_Scale Administration GUI
   Loaded: loaded (/usr/lib/systemd/system/gpfsgui.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
[root@gpfs01 gpfs_rpms]# systemctl restart gpfsgui.service 

[root@gpfs01 gpfs_rpms]# systemctl status gpfsgui.service 
● gpfsgui.service - IBM_Spectrum_Scale Administration GUI
   Loaded: loaded (/usr/lib/systemd/system/gpfsgui.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 17:56:53 KST; 13s ago
  Process: 10997 ExecStartPre=/usr/bin/sudo /usr/lpp/mmfs/gui/bin-sudo/cleanupdumps (code=exited, status=0/SUCCESS)
  Process: 10958 ExecStartPre=/usr/bin/sudo /usr/lpp/mmfs/gui/bin-sudo/check4iptables (code=exited, status=0/SUCCESS)
  Process: 10825 ExecStartPre=/usr/bin/sudo /usr/lpp/mmfs/gui/bin-sudo/check4pgsql (code=exited, status=0/SUCCESS)
 Main PID: 11009 (java)
   Status: "GSS/GPFS GUI started"
   CGroup: /system.slice/gpfsgui.service
           └─11009 /usr/lpp/mmfs/java/jre/bin/java -XX:+HeapDumpOnOutOfMemoryError -Dcom.ibm.gpfs.platform=GPFS -Dcom.ibm.gp...

Nov 01 17:56:57 gpfs01 java[11009]: (Startup) schedulePeriodicTasks: register and schedule task NODE_LICENSE to run e...minutes
Nov 01 17:56:57 gpfs01 sudo[11450]: scalemgmt : TTY=unknown ; PWD=/opt/ibm/wlp ; USER=root ; COMMAND=/usr/lpp/mmfs/bi..._events
Nov 01 17:56:57 gpfs01 java[11009]: (Startup) 129ms Background tasks started.
Nov 01 17:56:57 gpfs01 java[11009]: (Startup) 4ms Alert Event components initialized.
Nov 01 17:56:57 gpfs01 java[11009]: Systems Management JVM environment runtime:
Nov 01 17:56:57 gpfs01 java[11009]: Free memory in the JVM: 15MB
Nov 01 17:56:57 gpfs01 java[11009]: Total memory in the JVM: 62MB
Nov 01 17:56:57 gpfs01 java[11009]: Available memory in the JVM: 465MB
Nov 01 17:56:57 gpfs01 java[11009]: Max memory that the JVM will attempt to use: 512MB
Nov 01 17:56:57 gpfs01 java[11009]: Number of processors available to JVM: 2
Hint: Some lines were ellipsized, use -l to show in full.
```

```
[root@gpfs01 gpfs_rpms]# mmperfmon config generate --collectors gpfs01
mmperfmon: Node gpfs01 is not a perfmon node.
mmperfmon: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
[root@gpfs01 gpfs_rpms]# mmchnode --perfmon -N gpfs01
mmchnode: The main GPFS cluster configuration file is locked.  Retrying ...
mmchnode: Lock creation successful.
Wed Nov  1 17:57:58 KST 2017: mmchnode: Processing node gpfs01
mmchnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.

[root@gpfs01 gpfs_rpms]# systemctl restart pmcollector.service 
[root@gpfs01 gpfs_rpms]# systemctl status pmcollector.service 
● pmcollector.service - zimon collector daemon
   Loaded: loaded (/usr/lib/systemd/system/pmcollector.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 17:58:22 KST; 3s ago
 Main PID: 15539 (pmcollector)
   CGroup: /system.slice/pmcollector.service
           └─15539 /opt/IBM/zimon/sbin/pmcollector -C /opt/IBM/zimon/ZIMonCollector.cfg -R /var/run/perfmon

Nov 01 17:58:22 gpfs01 systemd[1]: Started zimon collector daemon.
Nov 01 17:58:22 gpfs01 systemd[1]: Starting zimon collector daemon...
[root@gpfs01 gpfs_rpms]# systemctl status pmsensors.service 
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/usr/lib/systemd/system/pmsensors.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 17:57:59 KST; 33s ago
 Main PID: 14572 (pmsensors)
   CGroup: /system.slice/pmsensors.service
           ├─14572 /opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon
           ├─14597 /opt/IBM/zimon/MmpmonSockProxy
           ├─14598 /opt/IBM/zimon/MMDFProxy
           └─14618 /opt/IBM/zimon/MMCmdProxy

Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSAFMFSET registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSRPCS registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSRPCSPeer registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSFilesetQuota registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSDiskCap registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSFileset registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSPool registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: GPFSWaiters registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: SensorFactory: Blaster registered
Nov 01 17:57:59 gpfs01 pmsensors[14572]: Nov-01 17:57:59  [Info   ]: Successfully read configuration from file /opt/IB...rs.cfg
Hint: Some lines were ellipsized, use -l to show in full.
```

<br>

- 웹페이지에 Pmcollector 서버의 IP 로 접속하면 아래와 같은 웹페이지 화면을 확인 할 수 있다.

	![image](https://github.com/user-attachments/assets/96daba1b-1766-40be-9096-b8af05a1c6f7)


	![image](https://github.com/user-attachments/assets/43c62674-e11d-47d6-851b-0642b046f367)

	|id|pw|
	|--|--|
	|admin|admin001|

<br>

## gpfs 노드별 gui 서버 등록
```
### GPFS 노드별 GUI 서비스 등록 ###
[root@gpfs02 rhel7]# yum localinstall gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm 
Loaded plugins: fastestmirror, langpacks
Examining gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm: gpfs.gss.pmsensors-4.2.3-4.el7.x86_64
Marking gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7 will be installed
--> Finished Dependency Resolution
base/7/x86_64                                                                                           | 3.6 kB  00:00:00     
extras/7/x86_64                                                                                         | 3.4 kB  00:00:00     
updates/7/x86_64                                                                                        | 3.4 kB  00:00:00     

Dependencies Resolved

===============================================================================================================================
 Package                      Arch             Version                  Repository                                        Size
===============================================================================================================================
Installing:
 gpfs.gss.pmsensors           x86_64           4.2.3-4.el7              /gpfs.gss.pmsensors-4.2.3-4.el7.x86_64           1.6 M

Transaction Summary
===============================================================================================================================
Install  1 Package

Total size: 1.6 M
Installed size: 1.6 M
Is this ok [y/d/N]: y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/1 
Created symlink from /etc/systemd/system/multi-user.target.wants/pmsensors.service to /usr/lib/systemd/system/pmsensors.service.
  Verifying  : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/1 

Installed:
  gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7                                                                                      

Complete!
```

<br>

```
[root@gpfs02 ~]# systemctl status pmsensors.service 
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/usr/lib/systemd/system/pmsensors.service; enabled; vendor preset: disabled)
   Active: failed (Result: start-limit) since Wed 2017-11-01 18:03:20 KST; 1s ago
  Process: 18235 ExecStart=/opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon (code=exited, status=78)
 Main PID: 18235 (code=exited, status=78)

Nov 01 18:03:20 gpfs02 pmsensors[18235]: SensorFactory: Blaster registered
Nov 01 18:03:20 gpfs02 pmsensors[18235]: Nov-01 18:03:20  [Error  ]: Could not open configuration file /opt/IBM/zimon/...ading.
Nov 01 18:03:20 gpfs02 pmsensors[18235]: Nov-01 18:03:20  [Error  ]: No collector host defined in /opt/IBM/zimon/ZIMon...s.cfg!
Nov 01 18:03:20 gpfs02 systemd[1]: Unit pmsensors.service entered failed state.
Nov 01 18:03:20 gpfs02 systemd[1]: pmsensors.service failed.
Nov 01 18:03:20 gpfs02 systemd[1]: pmsensors.service holdoff time over, scheduling restart.
Nov 01 18:03:20 gpfs02 systemd[1]: start request repeated too quickly for pmsensors.service
Nov 01 18:03:20 gpfs02 systemd[1]: Failed to start zimon sensor daemon.
Nov 01 18:03:20 gpfs02 systemd[1]: Unit pmsensors.service entered failed state.
Nov 01 18:03:20 gpfs02 systemd[1]: pmsensors.service failed.
Hint: Some lines were ellipsized, use -l to show in full.

[root@gpfs01 gpfs_rpms]# mmchnode --perfmon -N gpfs02
Wed Nov  1 18:03:34 KST 2017: mmchnode: Processing node gpfs02
mmchnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
[root@gpfs01 gpfs_rpms]# mmlscluster

GPFS cluster information
========================
  GPFS cluster name:         test.gpfs01
  GPFS cluster id:           9842223104266949822
  GPFS UID domain:           test.gpfs01
  Remote shell command:      /usr/bin/ssh
  Remote file copy command:  /usr/bin/scp
  Repository type:           CCR

 Node  Daemon node name  IP address      Admin node name  Designation
----------------------------------------------------------------------
   1   gpfs01            192.168.50.241  gpfs01           quorum-manager-perfmon
   2   gpfs02            192.168.50.242  gpfs02           quorum-manager-perfmon
   3   gpfs03            192.168.50.243  gpfs03           quorum-manager
   4   client01          192.168.50.244  client01         
   5   client02          192.168.50.245  client02         
   6   client03          192.168.50.246  client03         
   7   client04          192.168.50.247  client04 
```

<br>

```
[root@gpfs02 ~]# systemctl restart pmsensors
[root@gpfs02 ~]# systemctl status pmsensors
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/usr/lib/systemd/system/pmsensors.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 18:04:00 KST; 4s ago
 Main PID: 19726 (pmsensors)
   CGroup: /system.slice/pmsensors.service
           ├─19726 /opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon
           ├─19745 /opt/IBM/zimon/MmpmonSockProxy
           └─19749 /opt/IBM/zimon/MMCmdProxy

Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSAFMFSET registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSRPCS registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSRPCSPeer registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSFilesetQuota registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSDiskCap registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSFileset registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSPool registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: GPFSWaiters registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: SensorFactory: Blaster registered
Nov 01 18:04:00 gpfs02 pmsensors[19726]: Nov-01 18:04:00  [Info   ]: Successfully read configuration from file /opt/IB...rs.cfg
Hint: Some lines were ellipsized, use -l to show in full.
```

<br>

```
[root@gpfs03 rhel7]# yum localinstall gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm 
Loaded plugins: fastestmirror, langpacks
Examining gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm: gpfs.gss.pmsensors-4.2.3-4.el7.x86_64
Marking gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7 will be installed
--> Finished Dependency Resolution
base/7/x86_64                                                                                           | 3.6 kB  00:00:00     
extras/7/x86_64                                                                                         | 3.4 kB  00:00:00     
updates/7/x86_64                                                                                        | 3.4 kB  00:00:00     

Dependencies Resolved

===============================================================================================================================
 Package                      Arch             Version                  Repository                                        Size
===============================================================================================================================
Installing:
 gpfs.gss.pmsensors           x86_64           4.2.3-4.el7              /gpfs.gss.pmsensors-4.2.3-4.el7.x86_64           1.6 M

Transaction Summary
===============================================================================================================================
Install  1 Package

Total size: 1.6 M
Installed size: 1.6 M
Is this ok [y/d/N]: y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/1 
Created symlink from /etc/systemd/system/multi-user.target.wants/pmsensors.service to /usr/lib/systemd/system/pmsensors.service.
  Verifying  : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/1 

Installed:
  gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7                                                                                      

Complete!
```

<br>

```
[root@gpfs01 gpfs_rpms]# mmchnode --perfmon -N gpfs03
Wed Nov  1 18:06:51 KST 2017: mmchnode: Processing node gpfs03
mmchnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
[root@gpfs01 gpfs_rpms]# mmlscluster

GPFS cluster information
========================
  GPFS cluster name:         test.gpfs01
  GPFS cluster id:           9842223104266949822
  GPFS UID domain:           test.gpfs01
  Remote shell command:      /usr/bin/ssh
  Remote file copy command:  /usr/bin/scp
  Repository type:           CCR

 Node  Daemon node name  IP address      Admin node name  Designation
----------------------------------------------------------------------
   1   gpfs01            192.168.50.241  gpfs01           quorum-manager-perfmon
   2   gpfs02            192.168.50.242  gpfs02           quorum-manager-perfmon
   3   gpfs03            192.168.50.243  gpfs03           quorum-manager-perfmon
   4   client01          192.168.50.244  client01         
   5   client02          192.168.50.245  client02         
   6   client03          192.168.50.246  client03         
   7   client04          192.168.50.247  client04 

[root@gpfs03 ~]# systemctl status pmsensors
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/usr/lib/systemd/system/pmsensors.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 18:06:55 KST; 15s ago
 Main PID: 19793 (pmsensors)
   CGroup: /system.slice/pmsensors.service
           ├─19793 /opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon
           ├─19811 /opt/IBM/zimon/MmpmonSockProxy
           └─19819 /opt/IBM/zimon/MMCmdProxy

Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSAFMFSET registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSRPCS registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSRPCSPeer registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSFilesetQuota registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSDiskCap registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSFileset registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSPool registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: GPFSWaiters registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: SensorFactory: Blaster registered
Nov 01 18:06:55 gpfs03 pmsensors[19793]: Nov-01 18:06:55  [Info   ]: Successfully read configuration from file /opt/IB...rs.cfg
Hint: Some lines were ellipsized, use -l to show in full.
```

<br>

```
[root@client01 rhel7]# yum localinstall gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm 
Loaded plugins: fastestmirror, langpacks
Examining gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm: gpfs.gss.pmsensors-4.2.3-4.el7.x86_64
Marking gpfs.gss.pmsensors-4.2.3-4.el7.x86_64.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7 will be installed
--> Finished Dependency Resolution
base/7/x86_64                                                                                           | 3.6 kB  00:00:00     
extras/7/x86_64                                                                                         | 3.4 kB  00:00:00     
updates/7/x86_64                                                                                        | 3.4 kB  00:00:00     

Dependencies Resolved

===============================================================================================================================
 Package                      Arch             Version                  Repository                                        Size
===============================================================================================================================
Installing:
 gpfs.gss.pmsensors           x86_64           4.2.3-4.el7              /gpfs.gss.pmsensors-4.2.3-4.el7.x86_64           1.6 M

Transaction Summary
===============================================================================================================================
Install  1 Package

Total size: 1.6 M
Installed size: 1.6 M
Is this ok [y/d/N]: y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/1 
Created symlink from /etc/systemd/system/multi-user.target.wants/pmsensors.service to /usr/lib/systemd/system/pmsensors.service.
  Verifying  : gpfs.gss.pmsensors-4.2.3-4.el7.x86_64                                                                       1/1 

Installed:
  gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el7                                                                                      

Complete!
```

<br>

```[root@gpfs01 gpfs_rpms]# mmchnode --perfmon -N client01
Wed Nov  1 18:08:13 KST 2017: mmchnode: Processing node client01
mmchnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.

[root@client01 rhel7]# systemctl restart pmsensors
[root@client01 rhel7]# systemctl status pmsensors
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/usr/lib/systemd/system/pmsensors.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-11-01 18:08:27 KST; 3s ago
 Main PID: 6483 (pmsensors)
   CGroup: /system.slice/pmsensors.service
           ├─6483 /opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon
           └─6499 /opt/IBM/zimon/MmpmonSockProxy

Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSAFMFSET registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSRPCS registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSRPCSPeer registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSFilesetQuota registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSDiskCap registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSFileset registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSPool registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: GPFSWaiters registered
Nov 01 18:08:27 client01 pmsensors[6483]: SensorFactory: Blaster registered
Nov 01 18:08:27 client01 pmsensors[6483]: Nov-01 18:08:27  [Info   ]: Successfully read configuration from file /opt/I...rs.cfg
Hint: Some lines were ellipsized, use -l to show in full.
```

<br>

```
root@client02:~/4.2.3.4/zimon_debs/ubuntu16# dpkg -i gpfs.gss.pmsensors_4.2.3-4.U16.04_amd64.deb 
Selecting previously unselected package gpfs.gss.pmsensors.
(Reading database ... 65405 files and directories currently installed.)
Preparing to unpack gpfs.gss.pmsensors_4.2.3-4.U16.04_amd64.deb ...
Unpacking gpfs.gss.pmsensors (4.2.3-4) ...
Setting up gpfs.gss.pmsensors (4.2.3-4) ...
Created symlink from /etc/systemd/system/multi-user.target.wants/pmsensors.service to /lib/systemd/system/pmsensors.service.

root@client02:~/4.2.3.4/zimon_debs/ubuntu16# systemctl restart pmsensors
root@client02:~/4.2.3.4/zimon_debs/ubuntu16# systemctl status pmsensors
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/lib/systemd/system/pmsensors.service; enabled; vendor preset: enabled)
   Active: inactive (dead) (Result: exit-code) since Wed 2017-11-01 18:09:35 KST; 1s ago
  Process: 11747 ExecStart=/opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon (code=exited, s
 Main PID: 11747 (code=exited, status=78)

Nov 01 18:09:34 client02 pmsensors[11747]: SensorFactory: Blaster registered
Nov 01 18:09:34 client02 pmsensors[11747]: Nov-01 18:09:34  [Error  ]: Could not open configuration file /opt/IBM/zimon/ZIMonSe
Nov 01 18:09:34 client02 pmsensors[11747]: Nov-01 18:09:34  [Error  ]: No collector host defined in /opt/IBM/zimon/ZIMonSensors
Nov 01 18:09:34 client02 systemd[1]: pmsensors.service: Main process exited, code=exited, status=78/n/a
Nov 01 18:09:34 client02 systemd[1]: pmsensors.service: Unit entered failed state.
Nov 01 18:09:34 client02 systemd[1]: pmsensors.service: Failed with result 'exit-code'.
Nov 01 18:09:35 client02 systemd[1]: pmsensors.service: Service hold-off time over, scheduling restart.
Nov 01 18:09:35 client02 systemd[1]: Stopped zimon sensor daemon.
Nov 01 18:09:35 client02 systemd[1]: pmsensors.service: Start request repeated too quickly.
Nov 01 18:09:35 client02 systemd[1]: Failed to start zimon sensor daemon.
```

<br>

```
root@client02:~/4.2.3.4/zimon_debs/ubuntu16# systemctl restart pmsensors
root@client02:~/4.2.3.4/zimon_debs/ubuntu16# systemctl status pmsensors
● pmsensors.service - zimon sensor daemon
   Loaded: loaded (/lib/systemd/system/pmsensors.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2017-11-01 18:10:03 KST; 5s ago
 Main PID: 12962 (pmsensors)
    Tasks: 19
   Memory: 5.3M
      CPU: 14ms
   CGroup: /system.slice/pmsensors.service
           ├─12962 /opt/IBM/zimon/sbin/pmsensors -C /opt/IBM/zimon/ZIMonSensors.cfg -R /var/run/perfmon
           └─12980 /opt/IBM/zimon/MmpmonSockProxy

Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSAFMFSET registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSRPCS registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSRPCSPeer registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSFilesetQuota registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSDiskCap registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSFileset registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSPool registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: GPFSWaiters registered
Nov 01 18:10:03 client02 pmsensors[12962]: SensorFactory: Blaster registered
Nov 01 18:10:03 client02 pmsensors[12962]: Nov-01 18:10:03  [Info   ]: Successfully read configuration from file /opt/IBM/zimon
```

<br>

```
[root@client03 rhel6]# yum localinstall gpfs.gss.pmsensors-4.2.3-4.el6.x86_64.rpm 
Loaded plugins: fastestmirror, refresh-packagekit, security
Setting up Local Package Process
Examining gpfs.gss.pmsensors-4.2.3-4.el6.x86_64.rpm: gpfs.gss.pmsensors-4.2.3-4.el6.x86_64
Marking gpfs.gss.pmsensors-4.2.3-4.el6.x86_64.rpm to be installed
Loading mirror speeds from cached hostfile
 * base: ftp.daumkakao.com
 * extras: centos.mirror.cdnetworks.com
 * updates: centos.mirror.cdnetworks.com
Resolving Dependencies
--> Running transaction check
---> Package gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================
 Package                      Arch             Version                  Repository                                        Size
===============================================================================================================================
Installing:
 gpfs.gss.pmsensors           x86_64           4.2.3-4.el6              /gpfs.gss.pmsensors-4.2.3-4.el6.x86_64           1.7 M

Transaction Summary
===============================================================================================================================
Install       1 Package(s)

Total size: 1.7 M
Installed size: 1.7 M
Is this ok [y/N]: y
Downloading Packages:
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
pmsensors: unrecognized service
error reading information on service pmsensors: No such file or directory
  Installing : gpfs.gss.pmsensors-4.2.3-4.el6.x86_64                                                                       1/1 
  Verifying  : gpfs.gss.pmsensors-4.2.3-4.el6.x86_64                                                                       1/1 

Installed:
  gpfs.gss.pmsensors.x86_64 0:4.2.3-4.el6                                                                                      

Complete!
```

<br>

```
[root@client03 rhel6]# /etc/init.d/pmsensors restart
Restarting performance monitor sensors: Stopping performance monitor sensors...
Starting performance monitor sensors...SensorFactory: Blaster registered
SensorFactory: GPFSWaiters registered
SensorFactory: GPFSPool registered
SensorFactory: GPFSFileset registered
SensorFactory: GPFSDiskCap registered
SensorFactory: GPFSFilesetQuota registered
SensorFactory: GPFSRPCSPeer registered
SensorFactory: GPFSRPCS registered
SensorFactory: GPFSAFMFSET registered
SensorFactory: GPFSAFMFS registered
SensorFactory: GPFSAFM registered
SensorFactory: GPFSCHMS registered
SensorFactory: GPFSLROC registered
SensorFactory: GPFSFilesystemAPI registered
SensorFactory: GPFSNodeAPI registered
SensorFactory: GPFSNode registered
SensorFactory: GPFSvFLUSH registered
SensorFactory: GPFSPDDisk registered
SensorFactory: GPFSVIO registered
SensorFactory: GPFSIOC registered
SensorFactory: GPFSVFS registered
SensorFactory: GPFSPoolIO registered
SensorFactory: GPFSNSDDisk registered
SensorFactory: GPFSFilesystem registered
SensorFactory: GPFSDisk registered
SensorFactory: Infiniband registered
SensorFactory: Load registered
SensorFactory: DiskFree registered
SensorFactory: HDDTemp registered
SensorFactory: Diskstat registered
SensorFactory: Netstat registered
SensorFactory: Network registered
SensorFactory: Memory registered
SensorFactory: CPU registered
Nov-01 18:11:17  [Error  ]: Could not open configuration file /opt/IBM/zimon/ZIMonSensors.cfg for reading.
Nov-01 18:11:17  [Error  ]: No collector host defined in /opt/IBM/zimon/ZIMonSensors.cfg!
```

<br>

```
[root@gpfs01 gpfs_rpms]# mmchnode --perfmon -N client03
Wed Nov  1 18:11:34 KST 2017: mmchnode: Processing node client03
mmchnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
[root@gpfs01 gpfs_rpms]# mmlscluster

GPFS cluster information
========================
  GPFS cluster name:         test.gpfs01
  GPFS cluster id:           9842223104266949822
  GPFS UID domain:           test.gpfs01
  Remote shell command:      /usr/bin/ssh
  Remote file copy command:  /usr/bin/scp
  Repository type:           CCR

 Node  Daemon node name  IP address      Admin node name  Designation
----------------------------------------------------------------------
   1   gpfs01            192.168.50.241  gpfs01           quorum-manager-perfmon
   2   gpfs02            192.168.50.242  gpfs02           quorum-manager-perfmon
   3   gpfs03            192.168.50.243  gpfs03           quorum-manager-perfmon
   4   client01          192.168.50.244  client01         perfmon
   5   client02          192.168.50.245  client02         perfmon
   6   client03          192.168.50.246  client03         perfmon
   7   client04          192.168.50.247  client04 
```

<br>

```
[root@client03 rhel6]# /etc/init.d/pmsensors restart
Restarting performance monitor sensors: Stopping performance monitor sensors...
Starting performance monitor sensors...SensorFactory: Blaster registered
SensorFactory: GPFSWaiters registered
SensorFactory: GPFSPool registered
SensorFactory: GPFSFileset registered
SensorFactory: GPFSDiskCap registered
SensorFactory: GPFSFilesetQuota registered
SensorFactory: GPFSRPCSPeer registered
SensorFactory: GPFSRPCS registered
SensorFactory: GPFSAFMFSET registered
SensorFactory: GPFSAFMFS registered
SensorFactory: GPFSAFM registered
SensorFactory: GPFSCHMS registered
SensorFactory: GPFSLROC registered
SensorFactory: GPFSFilesystemAPI registered
SensorFactory: GPFSNodeAPI registered
SensorFactory: GPFSNode registered
SensorFactory: GPFSvFLUSH registered
SensorFactory: GPFSPDDisk registered
SensorFactory: GPFSVIO registered
SensorFactory: GPFSIOC registered
SensorFactory: GPFSVFS registered
SensorFactory: GPFSPoolIO registered
SensorFactory: GPFSNSDDisk registered
SensorFactory: GPFSFilesystem registered
SensorFactory: GPFSDisk registered
SensorFactory: Infiniband registered
SensorFactory: Load registered
SensorFactory: DiskFree registered
SensorFactory: HDDTemp registered
SensorFactory: Diskstat registered
SensorFactory: Netstat registered
SensorFactory: Network registered
SensorFactory: Memory registered
SensorFactory: CPU registered
Nov-01 18:12:01  [Info   ]: Successfully read configuration from file /opt/IBM/zimon/ZIMonSensors.cfg

[root@client03 rhel6]# /etc/init.d/pmsensors status
pmsensors (pid  28108) is running...
```

<br>

```
root@client04:~/4.2.3.4/zimon_debs/ubuntu14# dpkg -i gpfs.gss.pmsensors_4.2.3-4.U14.04_amd64.deb 
Selecting previously unselected package gpfs.gss.pmsensors.
(Reading database ... 62470 files and directories currently installed.)
Preparing to unpack gpfs.gss.pmsensors_4.2.3-4.U14.04_amd64.deb ...
pmsensors: unrecognized service
 Removing any system startup links for /etc/init.d/pmsensors ...
Unpacking gpfs.gss.pmsensors (4.2.3-4) ...
Setting up gpfs.gss.pmsensors (4.2.3-4) ...
update-rc.d: warning: default start runlevel arguments (2 3 4 5) do not match pmsensors Default-Start values (3 5)
update-rc.d: warning: default stop runlevel arguments (0 1 6) do not match pmsensors Default-Stop values (0 1 2 6)
 Adding system startup for /etc/init.d/pmsensors ...
   /etc/rc0.d/K20pmsensors -> ../init.d/pmsensors
   /etc/rc1.d/K20pmsensors -> ../init.d/pmsensors
   /etc/rc6.d/K20pmsensors -> ../init.d/pmsensors
   /etc/rc2.d/S20pmsensors -> ../init.d/pmsensors
   /etc/rc3.d/S20pmsensors -> ../init.d/pmsensors
   /etc/rc4.d/S20pmsensors -> ../init.d/pmsensors
   /etc/rc5.d/S20pmsensors -> ../init.d/pmsensors
Processing triggers for ureadahead (0.100.0-16) ...
```

<br>

```
root@client04:~/4.2.3.4/zimon_debs/ubuntu14# service pmsensors restart
 * Restarting performance monitor sensors pmsensors                                                                            SensorFactory: CPU registered
SensorFactory: Memory registered
SensorFactory: Network registered
SensorFactory: TopProc registered
SensorFactory: Netstat registered
SensorFactory: Diskstat registered
SensorFactory: HDDTemp registered
SensorFactory: DiskFree registered
SensorFactory: Load registered
SensorFactory: Infiniband registered
SensorFactory: GPFSDisk registered
SensorFactory: GPFSFilesystem registered
SensorFactory: GPFSNSDDisk registered
SensorFactory: GPFSPoolIO registered
SensorFactory: GPFSVFS registered
SensorFactory: GPFSIOC registered
SensorFactory: GPFSVIO registered
SensorFactory: GPFSPDDisk registered
SensorFactory: GPFSvFLUSH registered
SensorFactory: GPFSNode registered
SensorFactory: GPFSNodeAPI registered
SensorFactory: GPFSFilesystemAPI registered
SensorFactory: GPFSLROC registered
SensorFactory: GPFSCHMS registered
SensorFactory: GPFSAFM registered
SensorFactory: GPFSAFMFS registered
SensorFactory: GPFSAFMFSET registered
SensorFactory: GPFSRPCS registered
SensorFactory: GPFSRPCSPeer registered
SensorFactory: GPFSFilesetQuota registered
SensorFactory: GPFSDiskCap registered
SensorFactory: GPFSFileset registered
SensorFactory: GPFSPool registered
SensorFactory: GPFSWaiters registered
SensorFactory: Blaster registered
Nov-01 18:12:55  [Error  ]: Could not open configuration file /opt/IBM/zimon/ZIMonSensors.cfg for reading.
Nov-01 18:12:55  [Error  ]: No collector host defined in /opt/IBM/zimon/ZIMonSensors.cfg!
                                                                                                                        [fail]
```

<br>

```
root@client04:~/4.2.3.4/zimon_debs/ubuntu14# dpkg -i gpfs.gss.pmsensors_4.2.3-4.U14.04_amd64.deb 
Selecting previously unselected package gpfs.gss.pmsensors.
(Reading database ... 62470 files and directories currently installed.)
Preparing to unpack gpfs.gss.pmsensors_4.2.3-4.U14.04_amd64.deb ...
pmsensors: unrecognized service
 Removing any system startup links for /etc/init.d/pmsensors ...
Unpacking gpfs.gss.pmsensors (4.2.3-4) ...
Setting up gpfs.gss.pmsensors (4.2.3-4) ...
update-rc.d: warning: default start runlevel arguments (2 3 4 5) do not match pmsensors Default-Start values (3 5)
update-rc.d: warning: default stop runlevel arguments (0 1 6) do not match pmsensors Default-Stop values (0 1 2 6)
 Adding system startup for /etc/init.d/pmsensors ...
   /etc/rc0.d/K20pmsensors -> ../init.d/pmsensors
   /etc/rc1.d/K20pmsensors -> ../init.d/pmsensors
   /etc/rc6.d/K20pmsensors -> ../init.d/pmsensors
   /etc/rc2.d/S20pmsensors -> ../init.d/pmsensors
   /etc/rc3.d/S20pmsensors -> ../init.d/pmsensors
   /etc/rc4.d/S20pmsensors -> ../init.d/pmsensors
   /etc/rc5.d/S20pmsensors -> ../init.d/pmsensors
Processing triggers for ureadahead (0.100.0-16) ...

[root@gpfs01 gpfs_rpms]# mmchnode --perfmon -N client04
Wed Nov  1 18:13:16 KST 2017: mmchnode: Processing node client04
mmchnode: Propagating the cluster configuration data to all
  affected nodes.  This is an asynchronous process.
[root@gpfs01 gpfs_rpms]# mmlscluster

GPFS cluster information
========================
  GPFS cluster name:         test.gpfs01
  GPFS cluster id:           9842223104266949822
  GPFS UID domain:           test.gpfs01
  Remote shell command:      /usr/bin/ssh
  Remote file copy command:  /usr/bin/scp
  Repository type:           CCR

 Node  Daemon node name  IP address      Admin node name  Designation
----------------------------------------------------------------------
   1   gpfs01            192.168.50.241  gpfs01           quorum-manager-perfmon
   2   gpfs02            192.168.50.242  gpfs02           quorum-manager-perfmon
   3   gpfs03            192.168.50.243  gpfs03           quorum-manager-perfmon
   4   client01          192.168.50.244  client01         perfmon
   5   client02          192.168.50.245  client02         perfmon
   6   client03          192.168.50.246  client03         perfmon
   7   client04          192.168.50.247  client04         perfmon
```

<br>

```
root@client04:~/4.2.3.4/zimon_debs/ubuntu14# /etc/init.d/pmsensors restart
 * Restarting performance monitor sensors pmsensors                                                                            SensorFactory: CPU registered
SensorFactory: Memory registered
SensorFactory: Network registered
SensorFactory: TopProc registered
SensorFactory: Netstat registered
SensorFactory: Diskstat registered
SensorFactory: HDDTemp registered
SensorFactory: DiskFree registered
SensorFactory: Load registered
SensorFactory: Infiniband registered
SensorFactory: GPFSDisk registered
SensorFactory: GPFSFilesystem registered
SensorFactory: GPFSNSDDisk registered
SensorFactory: GPFSPoolIO registered
SensorFactory: GPFSVFS registered
SensorFactory: GPFSIOC registered
SensorFactory: GPFSVIO registered
SensorFactory: GPFSPDDisk registered
SensorFactory: GPFSvFLUSH registered
SensorFactory: GPFSNode registered
SensorFactory: GPFSNodeAPI registered
SensorFactory: GPFSFilesystemAPI registered
SensorFactory: GPFSLROC registered
SensorFactory: GPFSCHMS registered
SensorFactory: GPFSAFM registered
SensorFactory: GPFSAFMFS registered
SensorFactory: GPFSAFMFSET registered
SensorFactory: GPFSRPCS registered
SensorFactory: GPFSRPCSPeer registered
SensorFactory: GPFSFilesetQuota registered
SensorFactory: GPFSDiskCap registered
SensorFactory: GPFSFileset registered
SensorFactory: GPFSPool registered
SensorFactory: GPFSWaiters registered
SensorFactory: Blaster registered
Nov-01 18:13:43  [Info   ]: Successfully read configuration from file /opt/IBM/zimon/ZIMonSensors.cfg
                                                                                                                        [ OK ]
root@client04:~/4.2.3.4/zimon_debs/ubuntu14# 

root@client04:~/4.2.3.4/zimon_debs/ubuntu14# /etc/init.d/pmsensors status
 * pmsensors is running
```

<br>

### gpfs gui 메인 접속 화면

	![image](https://github.com/user-attachments/assets/c95f3592-b4c3-4df7-87bf-47f607abd4d9)

### gpfs gui node 리소스 확인 가능

	![image](https://github.com/user-attachments/assets/f57b0775-2b57-4089-bad3-8be7736738d4)


### gpfs gui 파일시스템 모니터링

	![image](https://github.com/user-attachments/assets/7b851f19-41b1-4115-a0ea-e3de68f57032)

### gpfs gui nsd 모니터링

	![image](https://github.com/user-attachments/assets/72484cde-2f05-4fc2-8d59-1163a5be607e)

## gpfs gui 서비스 확인
```
### GPFS GUI 서비스 확인 ###
root@client04:~/4.2.3.4/zimon_debs/ubuntu14# mmshutdown
Wed Nov  1 18:19:51 KST 2017: mmshutdown: Starting force unmount of GPFS file systems
Wed Nov  1 18:19:56 KST 2017: mmshutdown: Shutting down GPFS daemons
Shutting down!
'shutdown' command about to kill process 12032
Unloading modules from /lib/modules/4.2.0-27-generic/extra
Unloading module mmfs26
Unloading module mmfslinux
Wed Nov  1 18:20:05 KST 2017: mmshutdown: Finished

[root@gpfs01 gpfs_rpms]# mmgetstate -a

 Node number  Node name        GPFS state 
------------------------------------------
       1      gpfs01           active
       2      gpfs02           active
       3      gpfs03           active
       4      client01         active
       5      client02         active
       6      client03         active
       7      client04         down
[root@gpfs01 gpfs_rpms]# 
```

	![image](https://github.com/user-attachments/assets/af7b58ec-3ca5-4941-a841-fd2622040949)


## IOR 설치
```
### IOR  설치 ###

[root@gpfs01 ffs]# tar -zxvf IOR-2.10.3.tgz 
IOR/
IOR/README
IOR/USER_GUIDE
IOR/IOR.vcproj
IOR/Makefile
IOR/UNDOCUMENTED_OPTIONS
IOR/COPYRIGHT
IOR/src/
IOR/src/C/
IOR/src/C/defaults.h
IOR/src/C/utilities.c
IOR/src/C/IOR-aiori.h
IOR/src/C/iordef.h
IOR/src/C/parse_options.c
IOR/src/C/Makefile
IOR/src/C/aiori-noNCMPI.c
IOR/src/C/IOR.c
IOR/src/C/IOR.h
IOR/src/C/cbif/
IOR/src/C/cbif/cbif.c
IOR/src/C/cbif/Makefile
IOR/src/C/aiori.h
IOR/src/C/aiori-POSIX.c
IOR/src/C/Makefile.config
IOR/src/C/aiori-NCMPI.c
IOR/src/C/aiori-noMPIIO.c
IOR/src/C/aiori-MPIIO.c
IOR/src/C/aiori-noHDF5.c
IOR/src/C/win/
IOR/src/C/win/getopt.h
IOR/src/C/win/getopt.c
IOR/src/C/aiori-HDF5.c
IOR/RELEASE_LOG
IOR/scripts/
IOR/scripts/run_script.cnl
IOR/scripts/run_script.linux
IOR/scripts/exampleScript
IOR/testing/
IOR/testing/hintsFile
IOR/testing/IOR-tester.README
IOR/testing/IOR-tester.py
```

<br>

```
[root@gpfs01 IOR]# yum install -y openmpi-devel git automake
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirror.navercorp.com
 * extras: mirror.navercorp.com
 * updates: mirror.navercorp.com
Package automake-1.13.4-3.el7.noarch already installed and latest version

Dependencies Resolved

================================================================================== Package                                 Arch               Version                                  Repository           Size
==================================================================================Installing:
 openmpi-devel                           x86_64             1.10.6-2.el7                             base                4.7 M
 rdma-core                               i686               13-7.el7                                 base                 43 k
     replacing  rdma.noarch 7.3_4.7_rc2-5.el7
 rdma-core                               x86_64             13-7.el7                                 base                 43 k
     replacing  rdma.noarch 7.3_4.7_rc2-5.el7
Updating:
 dracut                                  x86_64             033-502.el7                              base                321 k
 git                                     x86_64             1.8.3.1-12.el7_4                         updates             4.4 M
Installing for dependencies:
 audit-libs                              i686               2.7.6-3.el7                              base                 96 k
 bzip2-libs                              i686               1.0.6-13.el7                             base                 40 k
 cracklib                                i686               2.9.0-11.el7                             base                 79 k
 elfutils-default-yama-scope             noarch             0.168-8.el7                              base                 30 k
 elfutils-libelf                         i686               0.168-8.el7                              base                196 k
 elfutils-libs                           i686               0.168-8.el7                              base                285 k
 environment-modules                     x86_64             3.2.10-10.el7                            base                107 k
 glibc                                   i686               2.17-196.el7                             base                4.2 M
 hwloc-libs                              x86_64             1.11.2-2.el7                             base                1.5 M

Transaction Summary
===============================================================================================================================
x86_64 0:033-502.el7 will be an update
---> Package
```

## mpich 설치
```
### mpich install ###

root@gpfs01 ffs]# cd mpich-3.2/
[root@gpfs01 mpich-3.2]# ls
aclocal.m4  confdb        contrib    examples     Makefile.in  mpich-doxygen.in  README.envvar  subsys_include.m4
autogen.sh  configure     COPYRIGHT  maint        man          mpi.def           RELEASE_NOTES  test
CHANGES     configure.ac  doc        Makefile.am  mpich.def    README            src            www
[root@gpfs01 mpich-3.2]# ./configure –prefix=/xfel/ffs/mpich-3.2
[root@gpfs01 mpich-3.2]# make
[root@gpfs01 mpich-3.2]# make install
[root@gpfs01 ~]# cd /etc/profile.d/
[root@gpfs01 profile.d]# cat app.sh 
# mpich-3.2
mpich_PATH=/xfel/ffs/mpich-3.2/

if ! echo ${PATH} | /bin/grep -q ${mpich_PATH}/bin; then
        PATH=${mpich_PATH}/bin:${PATH}
         LD_LIBRARY_PATH=${mpich_PATH}/lib:$LD_LIBRARY_PATH
fi

[root@gpfs01 profile.d]# source /etc/profile.d/app.sh 
[root@gpfs01 profile.d]# mpi
mpic++         mpichversion   mpiexec        mpif77         mpifort        mpivars        
mpicc          mpicxx         mpiexec.hydra  mpif90         mpirun         
[root@gpfs01 profile.d]# which mpirun
/xfel/ffs/mpich-3.2/bin/mpirun
```

<br>

```
[root@gpfs01 ffs]# tar -zxvf IOR-2.10.3.tgz
[root@gpfs01 IOR]# pwd
/xfel/ffs/IOR

[root@gpfs01 IOR]# make
(cd ./src/C && make posix)
make[1]: Entering directory `/xfel/ffs/IOR/src/C'
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c IOR.c
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c utilities.c
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c parse_options.c
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c aiori-POSIX.c
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c aiori-noMPIIO.c
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c aiori-noHDF5.c
mpicc -g -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -c aiori-noNCMPI.c
mpicc -o IOR IOR.o utilities.o parse_options.o \
	aiori-POSIX.o aiori-noMPIIO.o aiori-noHDF5.o aiori-noNCMPI.o \
	 -lm 
make[1]: Leaving directory `/xfel/ffs/IOR/src/C'
[root@gpfs01 IOR]# cd src/
[root@gpfs01 src]# ls
C
[root@gpfs01 src]# cd C/
[root@gpfs01 C]# ls
aiori.h        aiori-noHDF5.c   aiori-noNCMPI.c  cbif         IOR.c     Makefile         utilities.c
aiori-HDF5.c   aiori-noHDF5.o   aiori-noNCMPI.o  defaults.h   iordef.h  Makefile.config  utilities.o
aiori-MPIIO.c  aiori-noMPIIO.c  aiori-POSIX.c    IOR          IOR.h     parse_options.c  win
aiori-NCMPI.c  aiori-noMPIIO.o  aiori-POSIX.o    IOR-aiori.h  IOR.o     parse_options.o

```

<br>

## Random IO test
```
### Random I/O test ###

[root@gpfs01 ffs]# mpirun -np 8 --hostfile hosts -wdir /xfel/ffs/benchmark_dir/ /xfel/ffs/IOR/src/C/IOR -v -a POSIX -i5 -g -e -w -r -b 8g -T 10 -F -z -t 4m
IOR-2.10.3: MPI Coordinated Test of Parallel I/O

Run began: Fri Nov  3 12:31:07 2017
Command line used: /xfel/ffs/IOR/src/C/IOR -v -a POSIX -i5 -g -e -w -r -b 8g -T 10 -F -z -t 4m
Machine: Linux gpfs01
Start time skew across all tasks: 0.00 sec
Path: /xfel/ffs/benchmark_dir
FS: 96.0 GiB   Used FS: 17.9%   Inodes: 0.1 Mi   Used Inodes: 20.8%
Participating tasks: 8

Summary:
	api                = POSIX
	test filename      = testFile
	access             = file-per-process
	pattern            = segmented (1 segment)
	ordering in a file = random offsets
	ordering inter file= no tasks offsets
	clients            = 8 (2 per node)
	repetitions        = 5
	xfersize           = 4 MiB
	blocksize          = 8 GiB
	aggregate filesize = 64 GiB

Commencing write performance test.
Fri Nov  3 12:31:07 2017

Commencing read performance test.
Fri Nov  3 12:38:57 2017

Operation  Max (MiB)  Min (MiB)  Mean (MiB)   Std Dev  Max (OPs)  Min (OPs)  Mean (OPs)   Std Dev  Mean (s)  Op grep #Tasks tPN reps  fPP reord reordoff reordrand seed segcnt blksiz xsize aggsize

---------  ---------  ---------  ----------   -------  ---------  ---------  ----------   -------  --------
write         139.48       0.00       27.90     55.79        inf      34.87         inf       nan  93.97123   8 2 5 1 0 1 0 0 1 8589934592 4194304 68719476736 -1 POSIX EXCEL
read          143.82       0.00       28.76     57.53        inf      35.95         inf       nan  91.13882   8 2 5 1 0 1 0 0 1 8589934592 4194304 68719476736 -1 POSIX EXCEL

Max Write: 139.48 MiB/sec (146.26 MB/sec)
Max Read:  143.82 MiB/sec (150.80 MB/sec)

Run finished: Fri Nov  3 12:46:33 2017
```

<br>

## Streaming test
```
### Streaming test ##

[root@gpfs01 ffs]# mpiexec --hosts=gpfs01,gpfs02,gpfs03,client01 -np 16 /xfel/ffs/IOR/src/C/IOR -v -F -t 1m -b 5g -o /xfel/ffs/benchmark_dir/
IOR-2.10.3: MPI Coordinated Test of Parallel I/O

Run began: Fri Nov  3 16:55:06 2017
Command line used: /xfel/ffs/IOR/src/C/IOR -v -F -t 1m -b 5g -o /xfel/ffs/benchmark_dir/
Machine: Linux gpfs01
Start time skew across all tasks: 0.03 sec
Path: /xfel/ffs/benchmark_dir
FS: 96.0 GiB   Used FS: 1.1%   Inodes: 0.1 Mi   Used Inodes: 20.8%
Participating tasks: 16

Summary:
	api                = POSIX
	test filename      = /xfel/ffs/benchmark_dir/
	access             = file-per-process
	pattern            = segmented (1 segment)
	ordering in a file = sequential offsets
	ordering inter file= no tasks offsets
	clients            = 16 (4 per node)
	repetitions        = 1
	xfersize           = 1 MiB
	blocksize          = 5 GiB
	aggregate filesize = 80 GiB

Commencing write performance test.
Fri Nov  3 16:55:10 2017

Commencing read performance test.
Fri Nov  3 17:05:36 2017

Operation  Max (MiB)  Min (MiB)  Mean (MiB)   Std Dev  Max (OPs)  Min (OPs)  Mean (OPs)   Std Dev  Mean (s)  Op grep #Tasks tPN reps  fPP reord reordoff reordrand seed segcnt blksiz xsize aggsize

---------  ---------  ---------  ----------   -------  ---------  ---------  ----------   -------  --------
write         130.13     130.13      130.13      0.00     130.13     130.13      130.13      0.00 629.51497   16 4 1 1 0 1 0 0 1 5368709120 1048576 85899345920 -1 POSIX EXCEL
read          138.57     138.57      138.57      0.00     138.57     138.57      138.57      0.00 591.16219   16 4 1 1 0 1 0 0 1 5368709120 1048576 85899345920 -1 POSIX EXCEL

Max Write: 130.13 MiB/sec (136.45 MB/sec)
Max Read:  138.57 MiB/sec (145.31 MB/sec)

Run finished: Fri Nov  3 17:15:29 2017
```

<br>

```
[root@gpfs02 ~]# mmchfs
mmchfs: Missing arguments.
Usage:
   mmchfs Device [-A {yes | no | automount}] [-D {posix | nfs4}] [-E {yes | no}]
          [-k {posix | nfs4 | all}] [-K {no | whenpossible | always}]
          [-L LogFileSize] [-m DefaultMetadataReplicas] [-n NumNodes]
          [-o MountOptions] [-r DefaultDataReplicas] [-S {yes | no | relatime}]
          [-T Mountpoint] [-t DriveLetter] [-V {full | compat}] [-z {yes | no}]
          [--filesetdf | --nofilesetdf]
          [--inode-limit MaxNumInodes[:NumInodesToPreallocate]]
          [--log-replicas LogReplicas] [--mount-priority Priority]
          [--perfileset-quota | --noperfileset-quota]
          [--rapid-repair | --norapid-repair]
          [--write-cache-threshold HAWCThreshold]
      or
   mmchfs Device -Q {yes | no}
      or
   mmchfs Device -W NewDeviceName
[root@gpfs02 ~]# df -i
Filesystem           Inodes  IUsed   IFree IUse% Mounted on
/dev/mapper/cl-root 8910848 147066 8763782    2% /
devtmpfs            1018045    376 1017669    1% /dev
tmpfs               1021992      7 1021985    1% /dev/shm
tmpfs               1021992    734 1021258    1% /run
tmpfs               1021992     16 1021976    1% /sys/fs/cgroup
/dev/sda1            524288    329  523959    1% /boot
tmpfs               1021992     17 1021975    1% /run/user/42
tmpfs               1021992      1 1021991    1% /run/user/0
ffs                   99072  20643   78429   21% /xfel/ffs
[root@gpfs02 ~]# mmchfs ffs --inode-limit 100000
Set maxInodes for inode space 0 to 100096
Fileset root changed.
[root@gpfs02 ~]# df -i
Filesystem           Inodes  IUsed   IFree IUse% Mounted on
/dev/mapper/cl-root 8910848 147066 8763782    2% /
devtmpfs            1018045    376 1017669    1% /dev
tmpfs               1021992      7 1021985    1% /dev/shm
tmpfs               1021992    734 1021258    1% /run
tmpfs               1021992     16 1021976    1% /sys/fs/cgroup
/dev/sda1            524288    329  523959    1% /boot
tmpfs               1021992     17 1021975    1% /run/user/42
tmpfs               1021992      1 1021991    1% /run/user/0
ffs                  100096  20643   79453   21% /xfel/ffs
```

<br>

```
[root@gpfs02 ~]# mmchfs ffs --inode-limit 200000
Set maxInodes for inode space 0 to 200064
Fileset root changed.
[root@gpfs02 ~]# df -i
Filesystem           Inodes  IUsed   IFree IUse% Mounted on
/dev/mapper/cl-root 8910848 147066 8763782    2% /
devtmpfs            1018045    376 1017669    1% /dev
tmpfs               1021992      7 1021985    1% /dev/shm
tmpfs               1021992    735 1021257    1% /run
tmpfs               1021992     16 1021976    1% /sys/fs/cgroup
/dev/sda1            524288    329  523959    1% /boot
tmpfs               1021992     17 1021975    1% /run/user/42
tmpfs               1021992      1 1021991    1% /run/user/0
ffs                  200064  20643  179421   11% /xfel/ffs
```



