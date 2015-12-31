#!/bin/bash

Dispaly_Selection()
{
#set mysql root password

    DB_Root_Password="root"
    Echo_Yellow "Please setup root password of MySQL.(Default password: root)"
    read -p "Please enter: " DB_Root_Password
    if [ "${DB_Root_Password}" = "" ]; then
        DB_Root_Password="root"
    fi
    echo "MySQL root password: ${DB_Root_Password}"

#do you want to enable or disable the InnoDB Storage Engine?
    echo "==========================="

    InstallInnodb="y"
    Echo_Yellow "Do you want to enable or disable the InnoDB Storage Engine?"
    read -p "Default enable,Enter your choice [Y/n]: " InstallInnodb

    case "${InstallInnodb}" in
    [yY][eE][sS]|[yY])
        echo "You will enable the InnoDB Storage Engine"
        InstallInnodb="y"
        ;;
    [nN][oO]|[nN])
        echo "You will disable the InnoDB Storage Engine!"
        InstallInnodb="n"
        ;;
    *)
        echo "No input,The InnoDB Storage Engine will enable."
        InstallInnodb="y"
    esac

#which MySQL Version do you want to install?
    echo "==========================="

    DBSelect="2"
    Echo_Yellow "You have 5 options for your DataBase install."
    echo "1: Install MySQL 5.1.73"
    echo "2: Install MySQL 5.5.46 (Default)"
    echo "3: Install MySQL 5.6.27"
    echo "4: Install MariaDB 5.5.46"
    echo "5: Install MariaDB 10.0.21"
    echo "6: Install MySQL 5.7.9"
    read -p "Enter your choice (1, 2, 3, 4, 5 or 6): " DBSelect

    case "${DBSelect}" in
    1)
        echo "You will install MySQL 5.1.73"
        ;;
    2)
        echo "You will install MySQL 5.5.46"
        ;;
    3)
        echo "You will Install MySQL 5.6.27"
        ;;
    4)
        echo "You will install MariaDB 5.5.46"
        ;;
    5)
        echo "You will install MariaDB 10.0.21"
        ;;
    6)
        echo "You will install MySQL 5.7.9"
        ;;
    *)
        echo "No input,You will install MySQL 5.5.46"
        DBSelect="2"
    esac

    if [[ "${DBSelect}" = "3" || "${DBSelect}" = "5" || "${DBSelect}" = "6" ]] && [ `free -m | grep Mem | awk '{print  $2}'` -le 1024 ]; then
        echo "Memory less than 1GB, can't install MySQL 5.6, 5.7 or MairaDB 10!"
        exit 1
    fi

    if [[ "${DBSelect}" = "4" || "${DBSelect}" = "5" ]]; then
        MySQL_Bin="/usr/local/mariadb/bin/mysql"
        MySQL_Config="/usr/local/mariadb/bin/mysql_config"
        MySQL_Dir="/usr/local/mariadb"
    else
        MySQL_Bin="/usr/local/mysql/bin/mysql"
        MySQL_Config="/usr/local/mysql/bin/mysql_config"
        MySQL_Dir="/usr/local/mysql"
    fi

#which PHP Version do you want to install?
    echo "==========================="

    PHPSelect="3"
    Echo_Yellow "You have 6 options for your PHP install."
    echo "1: Install PHP 5.2.17"
    echo "2: Install PHP 5.3.29"
    echo "3: Install PHP 5.4.45 (Default)"
    echo "4: Install PHP 5.5.30"
    echo "5: Install PHP 5.6.16"
    echo "6: Install PHP 7.0.1"
    read -p "Enter your choice (1, 2, 3, 4, 5 or 6): " PHPSelect

    case "${PHPSelect}" in
    1)
        echo "You will install PHP 5.2.17"
        ;;
    2)
        echo "You will install PHP 5.3.29"
        ;;
    3)
        echo "You will Install PHP 5.4.45"
        ;;
    4)
        echo "You will install PHP 5.5.30"
        ;;
    5)
        echo "You will install PHP 5.6.16"
        ;;
    6)
        echo "You will install PHP 7.0.1"
        ;;
    *)
        echo "No input,You will install PHP 5.4.45"
        PHPSelect="3"
    esac

#which Memory Allocator do you want to install?
    echo "==========================="

    SelectMalloc="1"
    Echo_Yellow "You have 3 options for your Memory Allocator install."
    echo "1: Don't install Memory Allocator. (Default)"
    echo "2: Install Jemalloc"
    echo "3: Install TCMalloc"
    read -p "Enter your choice (1, 2 or 3): " SelectMalloc

    case "${SelectMalloc}" in
    1)
        echo "You will install not install Memory Allocator."
        ;;
    2)
        echo "You will install JeMalloc"
        ;;
    3)
        echo "You will Install TCMalloc"
        ;;
    *)
        echo "No input,You will not install Memory Allocator."
        SelectMalloc="1"
    esac

    if [ "${SelectMalloc}" =  "1" ]; then
        MySQL51MAOpt=''
        MySQL55MAOpt=''
        NginxMAOpt=''
    elif [ "${SelectMalloc}" =  "2" ]; then
        MySQL51MAOpt='--with-mysqld-ldflags=-ljemalloc'
        MySQL55MAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF"
        MariaDBMAOpt=''
        NginxMAOpt="--with-ld-opt='-ljemalloc'"
    elif [ "${SelectMalloc}" =  "3" ]; then
        MySQL51MAOpt='--with-mysqld-ldflags=-ltcmalloc'
        MySQL55MAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ltcmalloc' -DWITH_SAFEMALLOC=OFF"
        MariaDBMAOpt="-DCMAKE_EXE_LINKER_FLAGS='-ltcmalloc' -DWITH_SAFEMALLOC=OFF"
        NginxMAOpt='--with-google_perftools_module'
    fi
}

Apache_Selection()
{
    echo "==========================="
#set Server Administrator Email Address
    ServerAdmin=""
    read -p "Please enter Administrator Email Address: " ServerAdmin
    if [ "${ServerAdmin}" == "" ]; then
        echo "Administrator Email Address will set to webmaster@example.com!"
        ServerAdmin="webmaster@example.com"
    else
    echo "==========================="
    echo Server Administrator Email: "${ServerAdmin}"
    echo "==========================="
    fi

#which Apache Version do you want to install?
    echo "==========================="

    ApacheSelect="1"
    Echo_Yellow "You have 2 options for your Apache install."
    echo "1: Install Apache 2.2.31 (Default)"
    echo "2: Install Apache 2.4.16"
    read -p "Enter your choice (1 or 2): " ApacheSelect

    if [ "${ApacheSelect}" = "1" ]; then
        echo "You will install Apache 2.2.31"
    elif [ "${ApacheSelect}" = "2" ]; then
        echo "You will install Apache 2.4.16"
    else
        echo "No input,You will install Apache 2.2.31"
        ApacheSelect="1"
    fi
    if [[ "${PHPSelect}" = "1" && "${ApacheSelect}" = "2" ]]; then
        Echo_Red "PHP 5.2.17 is not compatible with Apache 2.4.16."
        Echo_Red "Force use Apache 2.2.31"
        ApacheSelect="1"
    fi
}

Kill_PM()
{
    if ps aux | grep "yum" | grep -qv "grep"; then
        killall yum
    elif ps aux | grep "apt-get" | grep -qv "grep"; then
        killall apt-get
    fi
}

Press_Install()
{
    echo ""
    Echo_Green "Press any key to install...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
    . include/version.sh
    Kill_PM
}

Press_Start()
{
    echo ""
    Echo_Green "Press any key to start...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
}

Install_LSB()
{
    if [ "$PM" = "yum" ]; then
        yum -y install redhat-lsb
    elif [ "$PM" = "apt" ]; then
        apt-get update
        apt-get install -y lsb-release
    fi
}

Get_Dist_Version()
{
    Install_LSB
    eval ${DISTRO}_Version=`lsb_release -rs`
    eval echo "${DISTRO} \${${DISTRO}_Version}"
}

Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    Get_OS_Bit
}

Get_RHEL_Version()
{
    Get_Dist_Name
    if [ "${DISTRO}" = "RHEL" ]; then
        if grep -Eqi "release 5." /etc/redhat-release; then
            echo "Current Version: RHEL Ver 5"
            RHEL_Ver='5'
        elif grep -Eqi "release 6." /etc/redhat-release; then
            echo "Current Version: RHEL Ver 6"
            RHEL_Ver='6'
        elif grep -Eqi "release 7." /etc/redhat-release; then
            echo "Current Version: RHEL Ver 7"
            RHEL_Ver='7'
        fi
    fi
}

Get_OS_Bit()
{
    if [[ `getconf WORD_BIT` = '32' && `getconf LONG_BIT` = '64' ]] ; then
        Is_64bit='y'
    else
        Is_64bit='n'
    fi
}

Get_ARM()
{
    if uname -m | grep -Eqi "arm"; then
        Is_ARM='y'
    fi
}

Download_Files()
{
    local URL=$1
    local FileName=$2
    if [ -s "${FileName}" ]; then
        echo "${FileName} [found]"
    else
        echo "Error: ${FileName} not found!!!download now..."
        wget -c --progress=bar:force ${URL}
    fi
}

Tar_Cd()
{
    local FileName=$1
    local DirName=$2
    cd ${cur_dir}/src
    [[ -d "${DirName}" ]] && rm -rf ${DirName}
    echo "Uncompress ${FileName}..."
    tar zxf ${FileName}
    echo "cd ${DirName}..."
    cd ${DirName}
}

Print_APP_Ver()
{
    echo "You will install ${Stack} stack."
    if [ "${Stack}" != "lamp" ]; then
        echo ${Nginx_Ver}
    fi

    if [[ "${DBSelect}" = "1" || "${DBSelect}" = "2" || "${DBSelect}" = "3" || "${DBSelect}" = "6" ]]; then
        echo "${Mysql_Ver}"
    elif [[ "${DBSelect}" = "4" || "${DBSelect}" = "5" ]]; then
        echo "${Mariadb_Ver}"
    fi

    echo "${Php_Ver}"

    if [ "${Stack}" != "lnmp" ]; then
        echo "${Apache_Ver}"
    fi

    if [ "${SelectMalloc}" = "2" ]; then
        echo "${Jemalloc_Ver}"
    elif [ "${SelectMalloc}" = "3" ]; then
        echo "${TCMalloc_Ver}"
    fi
    echo "Enable InnoDB: ${InstallInnodb}"
    echo "Print lnmp.conf infomation..."
    echo "Download Mirror: ${Download_Mirror}"
    echo "Nginx Additional Modules: ${Nginx_Modules_Options}"
    echo "PHP Additional Modules: ${PHP_Modules_Options}"
    if [[ "${DBSelect}" = "1" || "${DBSelect}" = "2" || "${DBSelect}" = "3" || "${DBSelect}" = "6" ]]; then
        echo "Database Directory: ${MySQL_Data_Dir}"
    elif [[ "${DBSelect}" = "4" || "${DBSelect}" = "5" ]]; then
        echo "Database Directory: ${MariaDB_Data_Dir}"
    fi
    echo "Default Website Directory: ${Default_Website_Dir}"
}

Print_Sys_Info()
{
    cat /etc/issue
    cat /etc/*-release
    uname -a
    MemTotal=`free -m | grep Mem | awk '{print  $2}'`
    echo "Memory is: ${MemTotal} MB "
    df -h
}

StartUp()
{
    init_name=$1
    echo "Add ${init_name} service at system startup..."
    if [ "$PM" = "yum" ]; then
        chkconfig --add ${init_name}
        chkconfig ${init_name} on
    elif [ "$PM" = "apt" ]; then
        update-rc.d -f ${init_name} defaults
    fi
}

Remove_StartUp()
{
    init_name=$1
    echo "Removing ${init_name} service at system startup..."
    if [ "$PM" = "yum" ]; then
        chkconfig ${init_name} off
        chkconfig --del ${init_name}
    elif [ "$PM" = "apt" ]; then
        update-rc.d -f ${init_name} remove
    fi
}

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

Get_PHP_Ext_Dir()
{
    Cur_PHP_Version=`/usr/local/php/bin/php -r 'echo PHP_VERSION;'`
    if echo "${Cur_PHP_Version}" | grep -Eqi '^5.2.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.3.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.4.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20100525/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.5.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20121212/"
    elif echo "${Cur_PHP_Version}" | grep -Eqi '^5.6.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20131226/"
   elif echo "${Cur_PHP_Version}" | grep -Eqi '^7.0.'; then
       zend_ext_dir="/usr/local/php/lib/php/extensions/no-debug-non-zts-20151012/"
    fi
}

Check_Stack()
{
    if [[ -s /usr/local/php/bin/php-cgi || -s /usr/local/php/sbin/php-fpm ]] && [[ -s /usr/local/php/etc/php-fpm.conf && -s /etc/init.d/php-fpm && -s /usr/local/nginx/sbin/nginx ]]; then
        Get_Stack="lnmp"
    elif [[ -s /usr/local/nginx/sbin/nginx && -s /usr/local/apache/bin/httpd && -s /usr/local/apache/conf/httpd.conf && -s /etc/init.d/httpd && ! -s /usr/local/php/sbin/php-fpm ]]; then
        Get_Stack="lnmpa"
    elif [[ -s /usr/local/apache/bin/httpd && -s /usr/local/apache/conf/httpd.conf && -s /etc/init.d/httpd && ! -s /usr/local/php/sbin/php-fpm ]]; then
        Get_Stack="lamp"
    else
        Get_Stack="unknow"
    fi
}

Check_DB()
{
    if [[ -s /usr/local/mariadb/bin/mysql && -s /usr/local/mariadb/bin/mysqld_safe && -s /etc/my.cnf ]]; then
        MySQL_Bin="/usr/local/mariadb/bin/mysql"
        MySQL_Config="/usr/local/mariadb/bin/mysql_config"
        MySQL_Dir="/usr/local/mariadb"
        Is_MySQL="n"
        DB_Name="mariadb"
    else
        MySQL_Bin="/usr/local/mysql/bin/mysql"
        MySQL_Config="/usr/local/mysql/bin/mysql_config"
        MySQL_Dir="/usr/local/mysql"
        Is_MySQL="y"
        DB_Name="mysql"
    fi
}

Do_Query()
{
    echo "$1" >/tmp/.mysql.tmp
    Check_DB
    ${MySQL_Bin} --defaults-file=~/.my.cnf </tmp/.mysql.tmp
    return $?
}

Make_TempMycnf()
{
    cat >~/.my.cnf<<EOF
[client]
user=root
password='$1'
EOF
}

Verify_DB_Password()
{
    Check_DB
    status=1
    while [ $status -eq 1 ]; do
        stty -echo
        echo "Enter current root password of Database (Password will not shown): "
        read DB_Root_Password
        echo
        stty echo
        Make_TempMycnf "${DB_Root_Password}"
        Do_Query ""
        status=$?
    done
    echo "OK, MySQL root password correct."
}

TempMycnf_Clean()
{
    if [ -s ~/.my.cnf ]; then
        rm -f ~/.my.cnf
    fi
    if [ -s /tmp/.mysql.tmp ]; then
        rm -f /tmp/.mysql.tmp
    fi
}
