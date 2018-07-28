#!/bin/bash
# Autor: Sergei Armando Martao
# Data:  05/09/2017
#
# Descricao 
# Script que utiliza o pacote nmap para testar uma lista de IPs e portas e adiciona o resultado em um arquivo
# O arquivo de IPs deve ter o mesmo numero de linhas que o arquivo de portas

# ARQIP, variavel que recebe o arquivo que contem a lista de IPs
# Por padrao le o arquivo "ips" que deve estar no mesmo diretorio
# Exemplo do formato:
#200.147.67.142
#8.8.4.4
#8.8.8.8
ARQIP="ips"

# ARQPORTA, variavel que recebe o arquivo que contem a lista de portas
# Por padrao le o arquivo "portas" que deve estar no mesmo diretorio
# Caso haja mais de uma porta separe usando virgula e espaco Ex: 
#80, 113
#22
#53, 21, 80
ARQPORTA="portas"

# ARQRESULT, variavel que contem o arquivo onde sera armazenando o resultado
# O padrao do nome do arquivo: resultado-ANO-MES-DIA-HORA-MINUTO
# Exemplo de saida do arquivo
#200.147.67.142 - 80/tcp open - 113/tcp closed
#8.8.4.4 - 22/tcp filtered
#8.8.8.8 - 53/tcp open - 21/tcp filtered - 80/tcp filtered
#
# Sendo:
# OPEN = Uma aplicação está ativamente aceitando conexões.
# CLOSED = Uma porta fechada está acessível (ela recebe e responde a pacotes de sondagens do Nmap), mas não há nenhuma aplicação ouvindo nela. 
# FILTERED = O Nmap não consegue determinar se a porta está aberta porque uma filtragem de pacotes impede que as sondagens alcancem a porta.
# Fonte: https://nmap.org/man/pt_BR/man-port-scanning-basics.html 
ARQRESULT="resultado-`date "+%y-%m-%d-%H-%M"`"
echo "" > $ARQRESULT

NUMIPS=`wc -l $ARQIP | cut -d" " -f 1`

for((s=1;s<=$NUMIPS;s++));
do
	IP=`cat $ARQIP | head -n $s | tail -n 1`
	for i in `cat $ARQPORTA | head -n $s | tail -n 1`
	do
		PORTA=`echo $i | cut -d, -f1`
		RESULTADO=`nmap $IP -sT -Pn -p $PORTA | grep $PORTA\/tcp | cut -d" " -f1-2`
		RPORTA="$RPORTA - $RESULTADO"
	done
	echo "$IP$RPORTA" >> $ARQRESULT
	unset RPORTA
done
