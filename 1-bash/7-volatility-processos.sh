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



comandos() {
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"

cd /media/sdb1

executa "Pslist - Lista de processos a correr no sistema" vol.py -f 20200601.mem --profile=Win10x64_10586 pslist
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"
executa "Pstree - Lista de processos, e mostra adicionalmente os processos escondidos no sistema" vol.py -f 20200601.mem --profile=Win10x64_10586 pstree
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"
executa "Dlllist - Lista as livrarias carregadas em memória" vol.py -f 20200601.mem --profile=Win10x64_10586 dlllist
mkdir /media/sdc1/dll
executa "Dlldump - Grava as dll numa pasta, com o objetivo de pesquisar malware" vol.py -f 20200601.mem --profile=Win10x64_10586 dllist --dump-dir /media/sdc1/dll
executa "Handles - Handles abertas pelos processos" vol.py -f 20200601.mem --profile=Win10x64_10586 handles
executa "GetSids - Obtem os security Identifiers, com o objetivo de relacionar os processos de sistema com os utilizadores" vol.py -f 20200601.mem --profile=Win10x64_10586 getsids
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"
executa "Cmdscan - Obtem os comandos introduzidos na consola (cmd.exe). Este é um dos comandos mais importantes para determinar se um atacante introduziu comandos, quer através do cmd.exe em RDP ou através de uma backdoor." vol.py -f 20200601.mem --profile=Win10x64_10586 cmdscan
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"
executa "Consoles - Obtem os inputs e os outputs dos comandos" vol.py -f 20200601.mem --profile=Win10x64_10586 consoles
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"
executa "Privs - Obtem os privilégios dos processos" vol.py -f 20200601.mem --profile=Win10x64_10586 privs
declare ficheiro="/media/sdc1/volatility_"$disco$(date +"%Y-%m-%d_%H-%M-%S")"_lista_processos.txt"
executa "envars - Obtem as variáveis de ambiente" vol.py -f 20200601.mem --profile=Win10x64_10586 envars
mkdir /media/sdc1/processos
executa "Procdump - Grava os processos numa pasta, com o objetivo de pesquisar malware" vol.py -f 20200601.mem --profile=Win10x64_10586 procdump --dump-dir /media/sdc1/processos
mkdir /media/sdc1/ficheiros
executa "dumpfiles - Grava os ficheiros numa pasta, com o objetivo de pesquisar malware" vol.py -f 20200601.mem --profile=Win10x64_10586 dllist --dump-dir /media/sdc1/ficheiros

}

touch $ficheiro
escreveSecao "Processos e livrarias a correr no sistema. Análise de ficheiros em memória"
comandos
