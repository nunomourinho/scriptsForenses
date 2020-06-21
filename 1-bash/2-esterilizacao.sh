timestamp() {
	echo "\textbf{" `date +"%Y-%m-%d_%H-%M-%S"` "}"
}

esterlizacao() {
echo "Disco a esterilizar"
read disco

echo "Comando executado para obter a confirmação dos dados do disco a esterlizar:"
echo "\begin{bashcode}"
echo "lsblk" $disco:
echo "\end{bashcode}"

echo "Resultado do comando executado:"
echo "\begin{bashcode}"
lsblk $disco
echo "\end{bashcode}"

echo "Comando executado para obter a confirmação dos dados do disco a esterlizar:"
echo "\begin{bashcode}"
echo 'fdisk -lu'$disco
echo "\end{bashcode}"

echo "Resultado do comando executado:"
echo "\begin{bashcode}"
fdisk -lu $disco
echo "\end{bashcode}"

echo "Comando executado para obter informação sobre o estado do disco a esterilisar:"
echo 'smartctl' $disco '-i'

echo "Resultado do comando executado:"
echo "\begin{bashcode}"
smartctl $disco -i
echo "\end{bashcode}"

echo "Ctrl+C para cancelar"
echo "Ou então o disco $disco vai ser apagado"
read cancelar

timestamp

echo "Comando executado para esterilizar o disco:" $disco

echo "\begin{bashcode}"
echo "dc3dd wipe=" $disco
echo "\end{bashcode}"

echo "Resultado da esterilização:"
echo "\begin{bashcode}"
dc3dd wipe=$disco
echo "\end{bashcode}"

echo "\textbf{Data de fim da esterilização}"
timestamp

echo "\textbf{Comando executado para validação do processo de esterilização}"
echo "\begin{bashcode}"
echo "cat $disco | pv -s `lsblk $disco | awk '{ print $4 }' | tail -n 1` | od"
echo "\end{bashcode}"
timestamp
echo "\textbf{Comando executado para validação do processo de esterilização}"
echo "\begin{bashcode}"
cat $disco | pv -s `lsblk $disco | awk '{ print $4 }' | tail -n 1` | od
echo "\end{bashcode}"
timestamp
echo "\textbf{Fim da validação do processo de esterilização}"
timestamp

echo "Criação da particao"
parted $disco mklabel gpt
parted -a opt $disco mkpart primary ext4 0% 100%
echo "intoduza o nome do label do disco a formatar"
read labelname
mkfs.ext4 -L $labelname $disco'1'

lshw -C disk
}

echo "\section{Esterlização do suporte digital para recolha de evididências}"
esterlizacao | tee "esterilizacao_"$disco$(date +"%Y-%m-%d_%H-%M-%S")".txt"
