if ! which ufw 2>&1 >/dev/null; then
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport $1 -j ACCEPT
    if [ -n "$(which netfilter-persistent)" ]; then
        sudo netfilter-persistent save
    fi
else
    ufw allow "$1"
fi

# 22/tcp SSH
# 7000/tcp FRP
# 7000/udp FRP
# 8887/tcp PREBOOT-SSH
# 22067/tcp STRELAYSRV
# 22070/tcp STRELAYSRV
# Plus the output of 'grep 'remote_port' files/frpc.template.ini | awk '{print $3 "/tcp"}' | sort | uniq' on the main server. As of now it is:
# 10000/tcp
# 18080/tcp
# 18089/tcp
# 443/tcp
# 80/tcp
# 8888/tcp
