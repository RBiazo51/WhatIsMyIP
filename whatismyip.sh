updateip (){
	dig +short txt ch whoami.cloudflare @1.0.0.1 > myiptemp.txt
	sed 's/"//g' myiptemp.txt > myip.txt
	rm myiptemp.txt
}

setoldandnew (){
	oldip=$(cat myip.txt)
	updateip
	newip=$(cat myip.txt)
}

checkifempty (){
	setoldandnew
	if [ -z "$newip" ]
	then
		echo $oldip > myip.txt
	else
		didmyipchange
	fi
}

didmyipchange (){
	if [ $oldip = $newip ]
	then
		echo "IP Did NOT Change"
	else
		echo $newip
		swaks --to rbiazo51@gmail.com -s smtp.gmail.com:587 -tls -au rbiazo51@gmail.com -ap "PASSWORD" --header "Subject:External IP Updated" --body "New IP: $newip/nOld IP: $oldip"
		
	fi
}

checkifempty
