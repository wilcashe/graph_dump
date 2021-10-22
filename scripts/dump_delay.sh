#!/bin/bash
working_folder=$1
output_folder=$2
echo "-------------------------------"
echo "dump_delay.sh: Calculando Retardo"
echo "dump_delay.sh: working_folder: ${working_folder}"
echo "dump_delay.sh: output folder: ${output_folder}"
host_traffic="${working_folder}trafico_host"
echo "dump_delay.sh: host traffic file: $host_traffic"
server_traffic="${working_folder}trafico_server"
echo "dump_delay.sh: server traffic file: $server_traffic"

#filtramos el tráfico recibido por el host las lineas que tengan IP e id, y nos quedamos con los campos $8 (id del paquete) y $1 (tiempo de reccepción del paquete) 
trafico_host_1="${working_folder}trafico_host_1"
grep IP ${host_traffic}  | grep id |awk '{print $8,$1}' | tr "," " " > ${trafico_host_1}

#filtramos el tráfico recibido por el host las lineas que tengan IP e id, y nos quedamos con los campos $8 (id del paquete) y $1 (tiempo de envío del paquete) 
trafico_server_1="${working_folder}trafico_server_1"
grep IP ${server_traffic} | grep id |awk '{print $8,$1}' | tr "," " " > ${trafico_server_1}

trafico_host_1_ordenado="${working_folder}trafico_host_1_ordenado"
trafico_server_1_ordenado="${working_folder}trafico_server_1_ordenado"
#se ordena el listado de paquetes segun su id 
sort ${trafico_host_1} > ${trafico_host_1_ordenado}
sort ${trafico_server_1} > ${trafico_server_1_ordenado}

#join busca lineas que empiecen con el mismo id y crea una salida única para dicho id agregando los tiempos de llegada y de envio
#ejemplo: 30736 1542604491.923973 1542604491.929275
#           id         send_time       recv_time
combinado="${working_folder}combinado"
join ${trafico_server_1_ordenado} ${trafico_host_1_ordenado} > ${combinado}

#nl agrega número de linea al archivo cominado
# $1-->numero de linea $4-->recv_time  $3-->send_time
#se usa la formula sqrt(($4-$3)*($4-$3)) --> para evitar problemas de signo, pero el la resta de recv_time-send_time
i=`date +"%Y%m%d%H%M%S"`
delay_file="${output_folder}${i}_delay.txt"
nl ${combinado} | awk '{print $1, sqrt(($4-$3)*($4-$3))}' > ${delay_file}

#Ejecutar GNUPLOT para generar la gráfica
gnuplot_file="${output_folder}retardo.plt"
if [ -f ${gnuplot_file} ];
then
 echo "dump_delay.sh: Borrando gnuplot_file"
 rm -r ${gnuplot_file}
fi


echo "#!/usr/bin/gnuplot -persist" >> ${gnuplot_file}
#echo "set terminal png"  >>retardo.plt
echo "set output '${output_folder}${i}_retardo.png' "  >>${gnuplot_file}

echo "set title \"Delay\"" >>${gnuplot_file}
echo "set xlabel \"Paquetes\"" >>${gnuplot_file}
echo "set ylabel \"Delay (s)\"" >>${gnuplot_file}

echo "set xtics font \", 6\"" >>${gnuplot_file}

echo "plot \"${delay_file}\" with linespoints" >> ${gnuplot_file}
gnuplot -p "${gnuplot_file}"
