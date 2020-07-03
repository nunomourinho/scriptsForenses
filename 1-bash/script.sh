echo "Chaves Descodificadas para ASCII:"; echo "    NUM ASCII"; cat /tmp/resultados.txt | grep -A1 Found | grep -v Found | while read line ; do echo $line | xxd -r -p ; echo \n; done | sort | uniq -c
