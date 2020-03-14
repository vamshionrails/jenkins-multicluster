# jenkins-multicluster

HAPROXY 
==================================================================================
# Make sure you have these installed
yum install -y make gcc perl pcre-devel zlib-devel openssl-devel
# Download/Extract source
wget -O /tmp/haproxy.tgz http://www.haproxy.org/download/1.7/src/haproxy-1.7.2.tar.gz
tar -zxvf /tmp/haproxy.tgz -C /tmp
cd /tmp/haproxy-*
# Compile HAProxy
# https://github.com/haproxy/haproxy/blob/master/README
make \
    TARGET=linux-glibc USE_LINUX_TPROXY=1 USE_ZLIB=1 USE_REGPARM=1 USE_PCRE=1 USE_PCRE_JIT=1 \
    USE_OPENSSL=1 SSL_INC=/usr/include SSL_LIB=/usr/lib ADDLIB=-ldl \
    CFLAGS="-O2 -g -fno-strict-aliasing -DTCP_USER_TIMEOUT=18"
make install
# Check your sbin path at /usr/local/sbin, consider copying these two to it
cp haproxy /usr/local/sbin/haproxy
cp haproxy-systemd-wrapper /usr/local/sbin/haproxy-systemd-wrapper

CERTIFICATES
===================================================================
# Generate a unique private key (KEY)
sudo openssl genrsa -out localhost.key 1024

# Generating a Certificate Signing Request (CSR)
sudo openssl req -new -key localhost.key -out localhost.csr

# Creating a Self-Signed Certificate (CRT)
openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt

# Append KEY and CRT to mydomain.pem
sudo bash -c 'cat localhost.key localhost.crt >> localhost.pem'

# Specify PEM in haproxy config
sudo vim /etc/haproxy/haproxy.cfg
listen haproxy
  bind 0.0.0.0:443 ssl crt /etc/ssl/private/mydomain.pem
  
  ======================================================================
  https://www.percona.com/blog/2014/10/03/haproxy-give-me-some-logs-on-centos-6-5/
