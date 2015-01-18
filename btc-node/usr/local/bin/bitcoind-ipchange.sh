#!/bin/bash

# CRONTAB
# */5 * * * *  /bin/bash -l -c '/usr/local/bin/bitcoind-ipchange.sh >> /home/xxx/bitcoind-ipchange.log'' 

EXT_IP=$(ssh -i /home/xxx/.ssh/id_dsa.pub myip@router /ip address print | perl -lne 'print $1 if /\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\/32/;')
BTC_IP=$(bitcoind getnetworkinfo | perl -lne 'print $1 if /^\s+"address"\s:\s"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})",$/;')

# DEBUG
# echo "$EXT_IP - $BTC_IP"

if [ $EXT_IP != $BTC_IP ];
then
        echo "$(date): Restarting bitcoind - IP change $BTC_IP -> $EXT_IP "
        sudo systemctl restart bitcoind
else
        echo "$(date): Doing noting - noting changed $EXT_IP = $BTC_IP"
fi
