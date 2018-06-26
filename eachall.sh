#config.init host username password
#!/bin/bash
function eachall()
{
        cat config.ini | while read ip user pass
        do
                echo -e "\n"
                echo "************************************* ${ip} ${user} ${pass} ***************************************"
                sshpass -p ${pass} ssh -n ${user}@${ip} "$@"
        done
}

eachall "free -g"
