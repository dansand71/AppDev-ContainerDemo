#install the pre-req's for VSTS BUILD Agent - https://github.com/Microsoft/vsts-agent/blob/master/docs/start/envredhat.md'
sudo yum -y install libunwind.x86_64 icu

#configure git 2.9
sudo yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
sudo yum -y install gcc perl-ExtUtils-MakeMaker

#remove version 1.8
sudo yum -y remove git
sudo yum install http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm
#install version 2.11
sudo yum -y install git

#Install instructions for VSTS - https://www.visualstudio.com/en-us/docs/build/actions/agents/v2-linux

#download
mkdir  $HOME/Downloads && cd $HOME/Downloads
wget https://github.com/Microsoft/vsts-agent/releases/download/v2.115.0/vsts-agent-rhel.7.2-x64-2.115.0.tar.gz
cd $HOME
mkdir $HOME/vsts-agent && cd vsts-ag
# DanSand Jumpbox BUILD Token - example
# qyjkfevaql353fg53z7yra22sxbfbyslklvp3cb2p3n6kpvh3nma
./config.sh
./run.sh

# Add local user to DOCKER Group so they can do DOCKER BUILDS
sudo usermod -aG docker $USER
# REboot jumpbox