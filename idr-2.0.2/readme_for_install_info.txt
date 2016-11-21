I installed idr by running the following commands:
wget https://github.com/nboley/idr/archive/2.0.2.zip
unzip 2.0.2.zip
mv idr-2.0.2/ src/
cd idr-2.0.2/
sudo apt-get install python3-dev python3-numpy python3-setuptools python3-matplotlib
python3 setup.py install --user
# Note that I had to run the above command twice, I tried running it without the user tag and with sudo in front, but that didn't work
# Add: :/home/jswenson/anaconda3/bin/idr\ to ~/.bashrc
source ~/.bashrc

# Note that there is a bug if there are no peaks for a chromosome, see: https://github.com/taoliu/MACS/issues/108
# to fix first try updating MACS2 instead, I had to install in my user directory: https://github.com/taoliu/MACS/wiki/Install-macs2
sudo -H pip install MACS2 --upgrade



