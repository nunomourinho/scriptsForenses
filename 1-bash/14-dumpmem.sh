shopt -s extglob

timestamp() {
	echo date --iso-8601=ns >> $ficheiro
}

escreveSecao() {
  echo "Relatório: Escrita a seccao " $1 " no ficheiro " $ficheiro
  echo "\newpage" >> $ficheiro
  echo "\section{"$1"}" >> $ficheiro
}

obs() {
  echo "\begin{observacoes}" >> $ficheiro
  echo $1 >> $ficheiro
  echo "\end{observacoes}" >> $ficheiro
}

executa() {
  declare msg=$1
  shift
  declare comandos=$@
  echo "Relatório: " $comandos " > " $ficheiro
  echo "\textbf{Descrição do propósito:}" $msg " \newline \newline" >> $ficheiro
  echo "Comando executado: " >> $ficheiro
  echo "\begin{bashcode}" >> $ficheiro
  echo $comandos >> $ficheiro
  echo "\end{bashcode}" >> $ficheiro
  echo "Resultado(s): \newline" >>$ficheiro
  echo "\begin{bashcode}" >>$ficheiro
  start=`date --iso-8601=ns`
  /usr/bin/time -v -o /tmp/tempo_decorrido.txt $comandos 2>&1 | tee -a $ficheiro
  end=`date --iso-8601=ns`
  echo "\end{bashcode}" >>$ficheiro
  echo "Tempo decorrido: \newline" >>$ficheiro
  echo "\begin{tempo}" >>$ficheiro
  echo "Início:" $start >> $ficheiro
  echo "Fim:" $end >> $ficheiro
  cat /tmp/tempo_decorrido.txt | grep -E "Elapsed|Exit">> $ficheiro
  rm /tmp/tempo_decorrido.txt
  echo "\end{tempo}" >>$ficheiro
}

executaScript() {
  declare msg=$1
  shift
  declare comandos=`cat $1`
  declare execcomando=$1
  echo "Relatório: " $comandos " > " $ficheiro
  echo "\textbf{Descrição do propósito:}" $msg " \newline \newline" >> $ficheiro
  echo "Comando executado: " >> $ficheiro
  echo "\begin{bashcode}" >> $ficheiro
  echo $comandos >> $ficheiro
  echo "\end{bashcode}" >> $ficheiro
  echo "Resultado(s): \newline" >>$ficheiro
  echo "\begin{bashcode}" >>$ficheiro
  start=`date --iso-8601=ns`
  /usr/bin/time -v -o /tmp/tempo_decorrido.txt bash $execcomando 2>&1 | tee -a $ficheiro
  end=`date --iso-8601=ns`
  echo "\end{bashcode}" >>$ficheiro
  echo "Tempo decorrido: \newline" >>$ficheiro
  echo "\begin{tempo}" >>$ficheiro
  echo "Início:" $start >> $ficheiro
  echo "Fim:" $end >> $ficheiro
  cat /tmp/tempo_decorrido.txt | grep -E "Elapsed|Exit">> $ficheiro
  rm /tmp/tempo_decorrido.txt
  echo "\end{tempo}" >>$ficheiro
}






comandos() {
declare ficheiro="/root/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_dumpfiles.txt"

escreveSecao "Find AES - Procura chaves AES na memória, e grava as chaves encontradas num ficheiro"
executa "Pesquisa as chaves AES na memória" ./findaes-1.2/findaes /mnt/imagens/20200601.mem > /tmp/resultados.txt
executa "Detalhe das chaves encontradas" cat /tmp/resultados.txt

echo 'echo "Chaves Descodificadas para ASCII:"; echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"; echo "    NUM ASCII"; cat /tmp/resultados.txt | grep -A1 Found | grep -v Found | while read line ; do echo $line | xxd -r -p ; echo \n; done | sort | uniq -c' > /tmp/script.sh
executaScript "Converte as chaves de hexadecimal para ascii" /tmp/script.sh
obs "Foi encontrada a chave, com a maior frequência  ----- Nenhuma das chaves encontradas é válida ---- Não foi encontrada nenhuma chave"
}

touch $ficheiro
comandos
