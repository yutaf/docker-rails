FROM ubuntu:14.04
MAINTAINER yutaf <yutafuji2008@gmail.com>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
# binaries
  git \
  man \
  curl \
# vim
  vim \
# ruby
  build-essential \
  zlib1g-dev \
  libcurl4-openssl-dev \
  libreadline-dev \
# sqlite3
  sqlite3 \
  libsqlite3-dev \
# mysql
  mysql-server-5.6 \
  libmysqlclient-dev \
## Apache, php \
#  make \
#  gcc \
#  zlib1g-dev \
#  libssl-dev \
#  libpcre3-dev \
## php
#  perl \
#  libxml2-dev \
#  libjpeg-dev \
#  libpng12-dev \
#  libfreetype6-dev \
#  libmcrypt-dev \
#  libcurl4-openssl-dev \
#  libreadline-dev \
#  libicu-dev \
#  g++ \
## xdebug
#  autoconf \
## ssh
#  openssh-server \
# supervisor
  supervisor

# ruby
# from http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz
COPY ./src/ruby-2.2.2.tar.gz .
RUN \
  tar -zxvf ruby-2.2.2.tar.gz && \
  cd ruby-2.2.2 && \
  ./configure --disable-install-doc && \
  make && \
  make install && \
  cd .. && \
  rm -r ruby-2.2.2 ruby-2.2.2.tar.gz && \
  echo 'gem: --no-document' > /usr/local/etc/gemrc

COPY www/Gemfile www/Gemfile.lock /srv/www/
RUN echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc && \
  gem install bundler && \
  (cd /srv/www; bundle install)


#
# Apache
#

#ADD http://apache.cs.utah.edu//httpd/httpd-2.2.29.tar.gz /usr/local/src/
#RUN cd /usr/local/src && \
#  tar xzvf httpd-2.2.29.tar.gz && \
#  cd httpd-2.2.29 && \
#    ./configure \
#      --prefix=/opt/apache2.2.29 \
#      --enable-mods-shared=all \
#      --enable-proxy \
#      --enable-ssl \
#      --with-ssl \
#      --with-mpm=prefork \
#      --with-pcre
#
## install
#RUN cd /usr/local/src/httpd-2.2.29 && \
#  make && make install

#
# php
#

#ADD http://php.net/distributions/php-5.6.7.tar.gz /usr/local/src/
#
#RUN cd usr/local/src && \
#  tar xzvf php-5.6.7.tar.gz && \
#  cd php-5.6.7 && \
#  ./configure \
#    --prefix=/opt/php-5.6.7 \
#    --with-config-file-path=/srv/php \
#    --with-apxs2=/opt/apache2.2.29/bin/apxs \
#    --with-libdir=lib64 \
#    --enable-mbstring \
#    --enable-intl \
#    --with-icu-dir=/usr \
#    --with-gettext=/usr \
#    --with-pcre-regex=/usr \
#    --with-pcre-dir=/usr \
#    --with-readline=/usr \
#    --with-libxml-dir=/usr/bin/xml2-config \
#    --with-zlib=/usr \
#    --with-zlib-dir=/usr \
#    --with-gd \
#    --with-jpeg-dir=/usr \
#    --with-png-dir=/usr \
#    --with-freetype-dir=/usr \
#    --enable-gd-native-ttf \
#    --enable-gd-jis-conv \
#    --with-openssl=/usr \
## ubuntu only
#    --with-libdir=/lib/x86_64-linux-gnu \
#    --with-mcrypt=/usr \
#    --enable-bcmath \
#    --with-curl \
#    --enable-exif
#
## install
#RUN cd /usr/local/src/php-5.6.7 && \
#  make && make install
#
##
## xdebug
##
#
## set php PATH because using phpize for xdebug installation
#ENV PATH /opt/php-5.6.7/bin:$PATH
#
#RUN cd /usr/local/src && \
#  curl -L -O http://xdebug.org/files/xdebug-2.3.2.tgz && \
#  tar -xzf xdebug-2.3.2.tgz && \
#  cd xdebug-2.3.2 && \
#  phpize && \
#  ./configure --enable-xdebug && \
#  make && \
#  make install
#
## php.ini
#COPY templates/php.ini /srv/php/
#RUN echo 'zend_extension = "/opt/php-5.6.7/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so"' >> /srv/php/php.ini

#
# Edit config files
#

## Apache config
#RUN sed -i "s/^Listen 80/#&/" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "s/^DocumentRoot/#&/" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "/^<Directory/,/^<\/Directory/s/^/#/" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "s;ScriptAlias /cgi-bin;#&;" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "s;#\(Include conf/extra/httpd-mpm.conf\);\1;" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "s;#\(Include conf/extra/httpd-default.conf\);\1;" /opt/apache2.2.29/conf/httpd.conf && \
## DirectoryIndex; index.html precedes index.php
#  sed -i "/^\s*DirectoryIndex/s/$/ index.php/" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "s/\(ServerTokens \)Full/\1Prod/" /opt/apache2.2.29/conf/extra/httpd-default.conf && \
#  echo "Include /srv/apache/apache.conf" >> /opt/apache2.2.29/conf/httpd.conf && \
## Change User & Group
#  useradd --system --shell /usr/sbin/nologin --user-group --home /dev/null apache; \
#  sed -i "s;^\(User \)daemon$;\1apache;" /opt/apache2.2.29/conf/httpd.conf && \
#  sed -i "s;^\(Group \)daemon$;\1apache;" /opt/apache2.2.29/conf/httpd.conf
#
#COPY templates/apache.conf /srv/apache/apache.conf
#RUN echo 'CustomLog "|/opt/apache2.2.29/bin/rotatelogs /srv/www/logs/access/access.%Y%m%d.log 86400 540" combined' >> /srv/apache/apache.conf && \
#  echo 'ErrorLog "|/opt/apache2.2.29/bin/rotatelogs /srv/www/logs/error/error.%Y%m%d.log 86400 540"' >> /srv/apache/apache.conf
##  "mkdir {a,b}" does not work in Ubuntu's /bin/sh, And "RUN <command>" uses "/bin/sh -c".
## Use "RUN ["executable", "param1", "param2"]" instead of "RUN <command>"
#RUN ["/bin/bash", "-c", "mkdir -m 777 -p /srv/www/logs/{access,error,app}"]
#
## make Apache document root
#COPY www/htdocs/ /srv/www/htdocs/

# mysql config
COPY templates/my.cnf /etc/mysql/my.cnf
RUN mkdir -p -m 777 /var/tmp/mysql && \
# alternative to　"mysql_secure_installation"
  /etc/init.d/mysql start && \
#TODO command below issues 'Warning: Using a password on the command line interface can be insecure.'
#TODO http://qiita.com/cs_sonar/items/d4a0534a0eaeb93b3215
  mysqladmin -u root password "ai3Yut4x" && \
  echo "[client]"             >> /root/.my.cnf && \
  echo "user = root"          >> /root/.my.cnf && \
  echo "password = ai3Yut4x"  >> /root/.my.cnf && \
  echo "host = localhost"     >> /root/.my.cnf && \
  chmod 600 /root/.my.cnf && \
  mysql --defaults-extra-file=/root/.my.cnf -e "DELETE FROM mysql.user WHERE User='';" && \
  mysql --defaults-extra-file=/root/.my.cnf -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" && \
  mysql --defaults-extra-file=/root/.my.cnf -e "DROP DATABASE IF EXISTS test;" && \
  mysql --defaults-extra-file=/root/.my.cnf -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" && \
  mysql --defaults-extra-file=/root/.my.cnf -e "FLUSH PRIVILEGES;" && \
  /etc/init.d/mysql stop

# supervisor
COPY templates/supervisord.conf /etc/supervisor/conf.d/
#RUN echo '[program:apache2]' >> /etc/supervisor/conf.d/supervisord.conf && \
#  echo 'command=/opt/apache2.2.29/bin/httpd -DFOREGROUND' >> /etc/supervisor/conf.d/supervisord.conf

# set PATH
#RUN sed -i 's;^PATH="[^"]*;&:/opt/php-5.6.7/bin;' /etc/environment

# set TERM
RUN echo export TERM=xterm-256color >> /root/.bashrc && \
# set timezone
  ln -sf /usr/share/zoneinfo/Japan /etc/localtime

## ssh
#RUN mkdir /var/run/sshd && \
#  echo 'root:screencast' | chpasswd && \
#  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
## SSH login fix. Otherwise user is kicked off after login
#  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

# Set up script for running container
COPY scripts/rails_start.sh scripts/run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/rails_start.sh /usr/local/bin/run.sh

EXPOSE 3000
#EXPOSE 80 22
CMD ["/usr/local/bin/run.sh"]
