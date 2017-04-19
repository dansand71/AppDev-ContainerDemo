#from https://blacksaildivision.com/git-latest-version-centos
sudo yum install autoconf libcurl-devel expat-devel gcc gettext-devel kernel-headers openssl-devel perl-devel zlib-devel -y
cd ~/
curl -O -L https://github.com/git/git/archive/v2.10.2.tar.gz
tar -zxvf v2.10.2.tar.gz
cd git-2.10.2
echo ".make clean"
make clean --quiet
echo ".make configure"
make configure 
./configure --prefix=/usr
echo ".make"
make --quiet
echo ".make install"
sudo make install --quiet
#cleanup
echo ".cleanup"
rm -rf git-2.10.2 v2.10.2.tar.gz