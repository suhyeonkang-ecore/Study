![image](https://github.com/user-attachments/assets/cb5e457b-fabc-4e43-9d5a-f9ecb37386e3)## ssh-keygen
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












