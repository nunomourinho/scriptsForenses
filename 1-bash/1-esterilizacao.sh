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



esterlizacao() {
echo "Disco a esterilizar"
read disco

executa "Lista todos os discos presentes no sistema, para escolha do disco a esterilizar" lshw -C disk
executa "Confirmação da identidade do disco a esterilizar, através do comando lsblk" lsblk $disco
executa "Nova confirmação da identidade do disco a esterilizar, através do comando fdisk" fdisk -lu $disco
executa "Validação do estado de integridade física do disco a esterilizar, através do comando smartctl" smartctl $disco -i

echo "Confirme a identidade do disco a esterilizar:"
read disco2

if [ "$disco2" != "$disco" ]; then
    echo "A identidade do disco não a esterilizar não foi confirmada. Abortando."
    exit 1
fi

executa "Esterilização do disco, através da escrita de zeros em toda a superfície do disco" dc3dd wipe=$disco

executa "Validação e confirmação do processo de esterilização do disco. A soma de todos os bytes do ficheiro deve ser apenas vários zeros" od $disco

executa "Criação da tabela inicial de partições, do tipo GPT " parted $disco mklabel gpt

executa "Criação de uma única partição no disco esterilizado que ocupa toda a área disponível" parted -a opt $disco mkpart primary ext4 0% 100%

echo "Intoduza o nome do label do disco a inicializar(formatar):"
read labelname
executa "Formatação da partição do disco esterilizado com o sistema de ficheiros ext4, atribuição do nome $labelname" mkfs.ext4 -L $labelname $disco'1'



executa "Lista todos os discos presentes no sistema, para confirmação final das acções realizadas" lshw -C disk
executa "Confirmação da identidade do disco esterilizado, através do comando lsblk" lsblk $disco
executa "Nova confirmação da identidade do disco esterilizado, através do comando fdisk" fdisk -lu $disco
executa "Validação do estado de integridade física do disco esterilizado, através do comando smartctl" smartctl $disco -i

executa "Lista todos os discos presentes no sistema, após a ação de esterlização do disco $disco" lshw -C disk
}

touch $ficheiro
escreveSecao "Esterlização do suporte digital para recolha de evidências"
esterlizacao
