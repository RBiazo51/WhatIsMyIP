oldip=$(cat myip.txt)
dig +short txt ch whoami.cloudflare @1.0.0.1 > myiptemp.txt
sed 's/"//g' myiptemp.txt > myip.txt
rm myiptemp.txt
newip=$(cat myip.txt)

if [ -z "$newip" ] || [[ "$newip" == *"error"* ]]; then
    echo "$oldip" > myip.txt
else
    if [ "$oldip" = "$newip" ]; then
        echo "IP Did NOT Change"
    else
        echo "$newip"
        swaks --to rbiazo51@gmail.com -s smtp.gmail.com:587 -tls -au rbiazo51@gmail.com -ap "PASSWORD" --header "Subject: External IP Updated" --body "New IP: $newip\nOld IP: $oldip"
    fi
fi
