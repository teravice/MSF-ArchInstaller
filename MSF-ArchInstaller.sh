echo 'Initializing installation of Metasploit Framework from Github.' 2> 
~/LOGFILE.txt
echo "Installation started from $USER at $HOSTNAME at " 2>> 
~/LOGFILE.txt
date 2>> ~/LOGFILE.txt


echo '***********************************************************'
echo '* Metasploit  Framework  Git  Installer  for  Arch  Linux *' 
echo '* brought to you by teravice. Distributed under GPLv3  ****'
echo '* teravice[at]gmail.com************************************'
echo '* www.0x3f.co**********************************************' 
echo '***********************************************************'
echo ''

echo '***********************************************************'
echo '* Checking if system is up to date, updating(if necessary)*' 
echo '* and installing dependancies... **************************' 
echo '***********************************************************'
echo ''
sudo pacman -Syyu --noconfirm 2>> ~/LOGFILE.txt


sudo pacman -S --needed --noconfirm wget git gcc patch curl zlib 
readline autoconf automake diffutils make libtool bison subversion gnupg 
postgresql python python2-pysqlite-legacy gtk2 pygtk libpcap jdk7-openjdk 2>> 
~/LOGFILE.txt


echo '***********************************************************'
echo '* Creating installation directory ~/dev *******************' 
echo '* and proceeding with the svn download and installation ***' 
echo '* of nmap. ************************************************'
echo '***********************************************************'
echo ''

mkdir ~/dev

cd ~/dev

svn co https://svn.nmap.org/nmap 2>> ~/LOGFILE.txt

cd nmap

./configure 2>> ~/LOGFILE.txt

make 2>> ~/LOGFILE.txt

sudo make install 2>> ~/LOGFILE.txt

make clean 2>> ~/LOGFILE.txt


echo '***********************************************************'
echo '* We are  now goint to check whether  en_US.UTF8  locale  *' 
echo '* is set. We are going to  use  nano  again.  If  needed  *' 
echo '* the file /etc/locale.gen will be opened. You have  to   *'
echo '* remove the # that are  in  front  of  en_US.UTF-8 UTF-8 *' 
echo '* and en_US ISO-8859-1. Then hit Ctrl+O and Ctrl+X        *'
echo '***********************************************************'
echo ''

read -p "* Press [Enter] key to continue...*************************"

if ! ( locale -a | grep "en_US.utf8" ) ; then
	echo "* Locales not found. 
Generating...*************************"
	sudo nano /etc/locale.gen
	sudo locale-gen 2>> ~/LOGFILE.txt
	else
	echo "* Locales found. Nothing to do here. 
**********************"
fi


echo '***********************************************************'
echo '* Setting up postgresql. Starting, enabling and creating **' 
echo '* the user msf and the database msf.***********************' 
echo '***********************************************************'
echo ''

sudo -s

chown -R postgres:postgres /var/lib/postgres/ 2>> ~/LOGFILE.txt

su postgres

initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data' 2>> 
~/LOGFILE.txt

exit

systemctl start postgresql 2>> ~/LOGFILE.txt

systemctl enable postgresql 2>> ~/LOGFILE.txt

su postgres

createuser msf -P -S -R -D 2>> ~/LOGFILE.txt

createdb -O msf msf 2>> ~/LOGFILE.txt

exit

exit

cd ~/dev

echo '***********************************************************'
echo '* Cloning Metasploit Framework from Github. ***************' 
echo '* After cloning is complete,bundle install will be run so *' 
echo '* all the required gems will be installed directly. *******'
echo '***********************************************************'
echo ''
git clone https://github.com/rapid7/metasploit-framework.git 2>> 
~/LOGFILE.txt

cd metasploit-framework


echo '***********************************************************'
echo '* Downloading,compiling & installing RVM. *****************' 
echo '***********************************************************'
echo ''

curl -sSL https://rvm.io/mpapis.asc | gpg --import - 2>> 
~/LOGFILE.txt

curl -L https://get.rvm.io | bash -s stable


echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc

source ~/.rvm/scripts/rvm

rvm install 2.3.3

rvm use 2.3.3 --default


echo '***********************************************************'
echo '* Installing basic gems that we will need. ****************' 
echo '* wirble **************************************************' 
echo '* sqlite3 *************************************************'
echo '* bundler *************************************************' 
echo '***********************************************************'
echo ''

gem install wirble sqlite3 bundler 2>> ~/LOGFILE.txt

bundle install 2>> ~/LOGFILE.txt

sudo chmod a+r ~/.rvm/gems/ruby-2.3.3/gems/robots-0.10.1/lib/robots.rb


echo '***********************************************************'
echo '* Creating simlinks for msf executables at /usr/local/bin *' 
echo '* Creating database.yml file with all the settings so that*' 
echo '* msfconsole can connect to postgres automatically. *******'
echo '***********************************************************'
echo ''

sudo bash -c 'for MSF in $(ls msf*); do ln -s $PWD/$MSF 
/usr/local/bin/$MSF;done' 2>> ~/LOGFILE.txt

sudo echo -e 'production:\n adapter: postgresql\n database: msf\n 
username: msf\n password: \n host: 127.0.0.1\n port: 5432\n pool: 75\n 
timeout: 5\n' > 
~/dev/metasploit-framework/config/database.yml 2>> 
~/LOGFILE.txt

sudo sh -c "echo export 
MSF_DATABASE_CONFIG=~/dev/metasploit-framework/config/database.yml 
>> /etc/profile" 2>> ~/LOGFILE.txt

source /etc/profile


echo '***********************************************************'
echo '* Downloading the latest version of Armitage. *************' 
echo '* After  the   download  is  complete  armitage  will  be *' 
echo '* installed and linked properly.*'
echo '***********************************************************'
echo ''


curl -# -o ~/dev/armitage.tgz 
http://www.fastandeasyhacking.com/download/armitage150813.tgz 2>> 
~/LOGFILE.txt

tar -xvzf ~/dev/armitage.tgz -C ~/dev 2>> ~/LOGFILE.txt

sudo ln -s ~/dev/armitage/armitage /usr/local/bin/armitage 
2>> ~/LOGFILE.txt

sudo ln -s ~/dev/armitage/teamserver /usr/local/bin/teamserver 2>> ~/LOGFILE.txt

sh -c "echo java -jar ~/dev/armitage/armitage.jar \$\* > ~/dev/armitage/armitage" 2>> ~/LOGFILE.txt

sudo perl -pi -e 's/armitage.jar/~\/dev\/armitage\/armitage.jar/g' ~/dev/armitage/teamserver 2>> ~/LOGFILE.txt


echo '***********************************************************'
echo '* Congratulations! Setup is complete. If something is not *' 
echo '* working properly check ~/LOGFILE.txt for errors and post*' 
echo '* them to https://github.com/teravice/MSF-ArchInstaller   *'
echo '* This is a new project so every help provided is much    *' 
echo '* appreciated.                                            *'
echo '***********************************************************'
echo ''
echo ''

echo '***********************************************************'                                                  
echo ' #    # ###  #####   #####  '
echo ' #   #   #  #     # #     # '
echo ' #  #    #  #       #       '
echo ' ###     #   #####   #####  '
echo ' #  #    #        #       # '
echo ' #   #   #  #     # #     # '
echo ' #    # ###  #####   #####  '
echo '***********************************************************'
