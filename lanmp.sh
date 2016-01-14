#!/bin/bash
echo "Welcome to install lamp or lnmp."
sleep 1
##check last command is exeuted successful or not.
check_ok()
{
if [ $?!=0 ]
then
    echo "Error occurs, Please check the error log."
    exit 1
fi 
}
##get the archive of the system, i686 or x86_64.
arch=`uname -r | awk -F '.' '{print $NF}'`
##clone seliux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
selinux_s=`getenforce`
if [ "$selinux_s" == "Enforcing" ]
then
    setenforce 0
fi
##close iptables
iptables-save > /etc/sysconfig/iptables_`date +%s`
iptables -F
service iptables save

##if the pacage installed, then omit.
myum()
{
if ! rpm -qa| grep -q "^$1"
then
    yum install -y $1
    check_ok
else
    echo $1 already installed
fi
}

## install some packages.
for p in gcc wget perl perl-devel libaio libaio-devel pcre-devel zlib-devel
do
  myum $p
done

##install epel.
if rpm -qa epel-release >/dev/null
then
    rpm -e epel-release
fi
if ls /etc/yum.repos.d/epel-6.repo* >/dev/null 2>&1
then
    rm -rf /etc/yum.repos.d/epel-6.repo*
fi
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-6.repo

##function of installing mysqld.
install_mysqld()
{
    echo "Please choose the version of mysql."
    select mysql_v 5.1 5.6
    do
        case $mysql_v in
            5.1)
            cd /usr/local/src
            [ -f mysql-5.1.72-linux-$arch-glibc23.tar.gz ] || wget http://mirrors.sohu.com/mysql/MySQL-5.1/mysql5.1.72-linux-$arch-glibc23.tar.gz
            check_ok
            tar zxf mysql-5.1.72-linux-$arch-glibc23.tar.gz
            check_ok
            [ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql_bak`date +%s`
            mv mysql-5.1.72-linux-$arch-glibc23 /usr/local/mysql
            if ! grep 'mysql:' /etc/passwd
            then
                useradd -M mysql -s /sbin/nologin
            fi
            myum compat-libstdc++-33
            [ -d /data/mysql ] && /bin/mv /data/mysql /data/mysql_bak`date +%s`
            mkdir -p /data/mysql
            chown -R mysql:mysql /data/mysql
            cd /usr/local/mysql
            ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
            check_ok
            /bin/cp support-files/my-huge.cnf /etc/my.cnf
            check_ok
            sed -i '/^\[mysqld\]$/a\datadir = /data/mysql' /etc/my.cnf
            /bin/cp support-files/mysql.server /etc/init.d/mysqld
            sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
            chmod 755 /etc/init.d/mysqld
            chkconfig --add mysqld
            chkconfig mysqld on
            service mysqld start
            check_ok
            break
            ;;
        5.6)
            cd /usr/local/src
            [ -f mysql-5.6.24-linux-$arch-glibc23.tar.gz ] || wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql5.6.24-linux-$arch-glib    c23.tar.gz
            check_ok
            tar zxf mysql-5.6.24-linux-$arch-glibc23.tar.gz
            check_ok
            [ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql_bak`date +%s`
            mv mysql-5.6.24-linux-$arch-glibc23 /usr/local/mysql
            if ! grep 'mysql:' /etc/passwd
            then
                useradd -M mysql -s /sbin/nologin
            fi
            myum compat-libstdc++-33
            [ -d /data/mysql ] && /bin/mv /data/mysql /data/mysql_bak`date +%s`
            mkdir -p /data/mysql
            chown -R mysql:mysql /data/mysql
            cd /usr/local/mysql
            ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
            check_ok
            /bin/cp support-files/my-huge.cnf /etc/my.cnf
            check_ok
            sed -i '/^\[mysqld\]$/a\datadir = /data/mysql' /etc/my.cnf
            /bin/cp support-files/mysql.server /etc/init.d/mysqld
            sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
            chmod 755 /etc/init.d/mysqld
            chkconfig --add mysqld
            chkconfig mysqld on
            service mysqld start
            check_ok
            break
            ;;
        *)
            echo "only 1(5.1) or 2(5.6)"
            exit 1;
    esac
done
}

##function of install httpd.
install_httpd()
{
echo "Install apache version 2.2"
cd /usr/local/src
[ -f httpd-2.2.16.tar.gz ] || wget http://syslab.comsenz.com/downloads/linux/httpd-2.2.16.tar.gz
check_ok
tar zxf httpd-2.2.16.tar.gz && cd httpd-2.2.16
check_ok
./configure \
--prefix=/usr/local/apache2 \
--with-included-apr \
--enable-so \
--enable-deflate=shared \
--enable-expires=shared \
--enable-rewrite=shared \
--with-pcre
check_ok
make && make install
check_ok
}

##function of install nginx.
install_nginx()
{
cd /usr/local/src
[ -f nginx-1.8.0.tar.gz ] || wget http://nginx.org/download/nginx-1.8.0.tar.gz
check_ok
tar zxf nginx-1.8.0.tar.gz
cd nginx-1.8.0
myum pcre-devel
./configure --prefix=/usr/local/nginx
check_ok
make && make install
check_ok
if [ -f /etc/init.d/nginx ]
then
    //bin/mv /etc/init.d/nginx /etc/init.d/nginx_`date +%s`
fi
curl http://www.apelearn.com/study_v2/.nginx_init -o /usr/init.d/nginx
check_ok
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
chkconfig nginx on
curl http://www.apelearn.com/study_v2/.nginx.conf -o /usr/local/nginx/conf/nginx.conf
check_ok
service nginx start
check_ok
echo -e "<?php\n    phpinfo();\n?>" > /usr/local/nginx/html/index.php
check_ok
}

##function of installing php.
install_php()
{
    echo "Please choose the version of php."
    select php_v 5.3 5.6
    do
        case $php_v in
            5.3)
            cd /usr/local/src
            [ -f php-5.3.10.tar.bz2 ] || wget http://syslab.comsenz.com/downloads/linux/php-5.3.10.tar.bz2
            check_ok
            tar jxf php-5.3.10.tar.bz2 && cd php-5.3.10
            check_ok
            for p in openssl-devel bzip2-devel libxml-devel curl-devel libpng-devel libjpeg-devel freetype-devel libmcrypt-devel libtool-ltdl-devel perl-devel
            do
                myum $p
            done
            check_ok
            ./configure \
            --prefix=/usr/local/php \
            --with-apxs2=/usr/local/apache2/bin/apxs \
            --with-config-file-path=/usr/local/php/etc \
            --with-mysql=/usr/local/mysql \
            --with-libxml-dir \
            --with-gd \
            --with-jpeg-dir \
            --with-png-dir \
            --with-freetype-dir \
            --with-iconv-dir \
            --with-zlib-dir \
            --with-bz2 \
            --with-openssl \
            --with-mcrypt \
            --enable-soap \
            --enable-gd-native-ttf \
            --enable-mbstring \
            --enable-sockets \
            --enable-exif \
            --disable-ipv6
            check_ok
            make && make install
            check_ok
            [ -f /usr/local/php/etc/php.ini ] || /bin/cp php.ini-production /usr/local/php/etc/php.ini
            break
            ;;

           case $php_v in
            5.6)
            cd /usr/local/src
            [ -f php-5.6.6.tar.bz2 ] || wget http://syslab.comsenz.com/downloads/linux/php-5.6.6.tar.bz2
            check_ok
            tar jxf php-5.6.6.tar.bz2 && cd php-5.6.6
            check_ok
            for p in openssl-devel bzip2-devel libxml-devel curl-devel libpng-devel libjpeg-devel freetype-devel libmcrypt-devel libtool-ltdl-devel perl-devel
            do
                myum $p
            done
            check_ok
            ./configure \
            --prefix=/usr/local/php \
            --with-apxs2=/usr/local/apache2/bin/apxs \
            --with-config-file-path=/usr/local/php/etc \
            --with-mysql=/usr/local/mysql \
            --with-libxml-dir \
            --with-gd \
            --with-jpeg-dir \
            --with-png-dir \
            --with-freetype-dir \
            --with-iconv-dir \
            --with-zlib-dir \
            --with-bz2 \
            --with-openssl \
            --with-mcrypt \
            --enable-soap \
            --enable-gd-native-ttf \
            --enable-mbstring \
            --enable-sockets \
            --enable-exif \
            --disable-ipv6
            check_ok
            make && make install
            check_ok
            [ -f /usr/local/php/etc/php.ini ] || /bin/cp php.ini-production /usr/local/php/etc/php.ini
            break
            ;;
        *)
            echo "only 1(5.3) or 2(5.6)"
            exit 1;
    esac
done
}

## function of apache and php configuration.
join_apache_php()
{
    sed -i 'AddType .*.gz .tgz$/a\AddType application\/x-httpd-php .php' /usr/local/apache2/conf/httpd.conf
    check_ok
    sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html index.htm/' /usr/local/apache2/conf/httpd.conf
    check_ok
    cat > /usr/local/apache2/htdocs/index.php <<EOF
    <?
        phpinfo();
    ?>
EOF

    if /usr/local/php/bin/php -i | grep -iq 'date.timezone -> no value'
    then
        sed -i '/;date.timezone =$/a\date.timezone = "Asia\/Chongqing"' /usr/local/php/etc/php.ini
    fi

    /usr/local/apache2/bin/apachectl restart
    check_ok
}

## functon of check service is running or not, exampe nginx, httpd, php-fpm.
check_service()
{
    if [ "$1" == "php-fpm" ]
    then
        s="php-fpm"
    else
        s=$1
    fi
    
    n=`ps aux | grep "$s"| wc -l`

    if [ $n -gt 1 ]
    then
        echo "$1 service is running."
    else
        if [ -f /etc/init.d/$1 ]
        then
            /etc/init.d/$1 start
            check_ok
        else
            intall_$!
        fi

    fi
}

## function of install lamp.
install_lamp()
{
    check_service mysqld
    check_service httpd
    install_php
    join_apache_php
    echo "LAMP done successfully. please access the URL http://<ip>/index.php. "
}

## function of install lamp.
install_lnmp()
{
    check_service mysqld
    check_service nginx
    install_php
    join_apache_php
    echo "LNMP done successfully. please access the URL http://<ip>/index.php. "
}

echo "Please choose which type of environment you want to install, (lamp|lnmp)?"
PS3="Please input lamp or lnmp"
select env_v lamp lnmp
do
    case $env_v in
        lamp)
            lamp
        lnmp)
            lnmp
        *)
            echo "Input is invalid. lamp or lnmp is allowed."
            exit 1
    esac
done