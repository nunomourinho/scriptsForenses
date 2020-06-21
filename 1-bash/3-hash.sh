declare ficheiro="esterilizacao_"$disco$(date +"%Y-%m-%d_%H-%M-%S")".txt"
shopt -s extglob

timestamp() {
	echo date --iso-8601=ns >> $ficheiro
}

escreveSecao() {
  echo "Relatório: Escrita a seccao " $1 " no ficheiro " $ficheiro
  echo "\section{"$1"}" >> $ficheiro
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

executaSE() {
  declare msg=$1
  shift
  declare comandos=$@
  echo "Comandos a executar DEBUG"
  echo $comandos
  read

  echo "Relatório: " $comandos " > " $ficheiro
  echo "\textbf{Descrição do propósito:}" $msg "\newline \newline">> $ficheiro
  echo "Comando executado: " >> $ficheiro
  echo "\begin{bashcode}" >> $ficheiro
  echo $comandos >> $ficheiro
  echo "\end{bashcode}" >> $ficheiro
  echo "Resultado(s): \newline" >>$ficheiro
  echo "\begin{bashcode}" >>$ficheiro
  start=`date --iso-8601=ns`
  echo "$comandos" > /tmp/comandos.sh
  bash -c 'chmod 700 /tmp/comandos.sh'
  $comandos | tee -a $ficheiro
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



calculoHASH() {

cd /media/sdb1

executa "Calcular o hash da imagem de disco e da imagem de memória" gtkhash -c md5,sha1,sha-256 ./20200601.mem ./CIF2020.001
}

touch $ficheiro
#escreveSecao "Calculo"
calculoHASH
