sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport $1 -j ACCEPT
if [ -n "$(which netfilter-persistent)" ]; then
    sudo netfilter-persistent save
fi

# 22/TCP SSH
# 7000/TCP FRP
# 7000/UDP FRP
# 80/TCP HTTP
# 443/TCP HTTPS
# 8887/TCP PREBOOT-SSH
# 18080/TCP MONEROD
# 18089/TCP MONEROD
# 22067/TCP STRELAYSRV
# 22070/TCP STRELAYSRV
