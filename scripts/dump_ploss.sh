#!/bin/bash

echo "-------------------------------"
echo "dump_ploss.sh: Calculando Packet Loss"

working_folder=$1
output_folder=$2

PLoss_file="${working_folder}PackLoss.txt"
trafico_host_1_ordenado="${working_folder}trafico_host_1_ordenado"
trafico_server_1_ordenado="${working_folder}trafico_server_1_ordenado"

#Se utilizan los archivos "trafico_host_1_ordenado" y "trafico_server_1_ordenado" 
#los cuales son generados por dump_delay.sh
#wc -l cuenta el número de líneas de un archivo. salida: <#lineas>  <nombre fichero>
# entonces se toma el primer campo de la salida

recv_pack=$(wc -l ${trafico_host_1_ordenado} | awk '{print $1}')
sent_pack=$(wc -l ${trafico_server_1_ordenado} | awk '{print $1}')

#Se hace la división recv_pack/sent_pack
pack_loss=$((sent_pack-recv_pack))
echo "dump_ploss.sh: paquetes perdidos= $pack_loss"
ppack_loss=$(echo "scale=4; $pack_loss*100/$sent_pack" | bc)
echo "Paquetes enviados= $sent_pack" > ${PLoss_file}
echo "Paquetes recibidos= $recv_pack" >> ${PLoss_file}
echo "Paquetes perdidos= $pack_loss" >> ${PLoss_file}
echo "Porcentaje de Paquetes perdidos (%)= $ppack_loss" >> ${PLoss_file}

#grep IP /home/pi/graph_dump/created/trafico | grep id |awk '{print $1,$17}' | tr "," " " > /home/pi/graph_dump/created/traf_1
#sed 's/)$//' /home/pi/graph_dump/created/traf_1 > /home/pi/graph_dump/created/traf_2
#a=$(awk 'NR == 1 {print $1}' /home/pi/graph_dump/created/traf_2)
#awk -v c="${a}" '{print $1-c, $2}' /home/pi/graph_dump/created/traf_2 > /home/pi/graph_dump/created/traf_3



