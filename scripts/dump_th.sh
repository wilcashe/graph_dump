#!/bin/bash
working_folder=$1
output_folder=$2
echo "-------------------------------"
echo "dump_th.sh: Calculando Throughput"
echo "dump_th.sh: working folder= ${working_folder}"
echo "dump_th.sh: output folder= $output_folder"
server_traffic="${working_folder}trafico_server"
echo "dump_th.sh: server traffic file= ${server_traffic}"

#Se seleccionan todas las líneas que tengan IP y id y luego 
#se extrae con awk el campo 1 y 17 (tiempo y tamaño del paquete)
#con tr se reemplaza la , por un espacio en blanco
#se guardan los registros filtrados en un archivo llamado: created/traf_1
#cada línea es un paquete
#ejemplo del resultado del filtro: 1550703628.643515 52)
traf_1_file="${working_folder}traf_1"
grep IP ${server_traffic} | grep id |awk '{print $1,$17}' | tr "," " " > ${traf_1_file}

#Con sed se elimina el paréntesis final
#ejemplo de la salida: 1542604538.398428 52   --> donde el primer dato es el tiempo y el segundo es el tamaño de paquete
traf_2_file="${working_folder}traf_2"
sed 's/)$//' ${traf_1_file} > ${traf_2_file}

#Se extrae la primera línea del archivo traf_2, y se extrae de dicha línea el primer campo (tiempo) y se almacena en la variable "a"
#Es decir, "a" almacenará el tiempo de recepción del primer paquete
a=$(awk 'NR == 1 {print $1}' ${traf_2_file})
#echo $a

#----------------------------
#Se pasa la variable c (que contiene el valor de a) a AWK para que 
#reste el tiempo de llegada de cada paquete menos el tiempo en que llegó el paquete 1
#es decir: $1-c 
#se imprime en el archivo traf_3 la diferencia de tiempo y el tamaño de cada paquete
#ejemplo de la primera línea: 0 60  
#ejemplo de la segunda: 0.00132418 60 --> quiere decir que el segundo paquete llegó
#0.00132 seg después del primero
traf_3_file="${working_folder}traf_3"
awk -v c="${a}" '{print $1-c, $2}' ${traf_2_file} > ${traf_3_file}

#CALCULO DEL THROUGHPUT
# se hace con el script de perl "solo_th.pl"
#perl solo_th.pl archivo_de_traza intervalo_de_tiempo > archivo_de_salida
#Dicho script suma todos los tamaños de los paquetes que llegaron dentro del
#intervalo de tiempo definido en el segundo argumento (intervalo_de_tiempo)
#si intervalo_de_tiempo=5, se suman los tamaños de los paquetes que llegaron en 5 segundos y se divide entre 5 para calcular el throughput en bps cada 5 segundos
#th=(sum_pak_size/time_interval)*8;
#ejemplo salida: 
#189.06    3328
#192.15    2080 

i=`date +"%Y%m%d%H%M%S"`
#echo ${i}
#i es un numero de identificación creado a partir de la fecha y hora actual, para nombrar los archivos de salida
th_file="${output_folder}${i}_solo_th.txt"
perl solo_th.pl ${traf_3_file} 1 > ${th_file}

#Ejecutar GNUPLOT para generar la gráfica
gnuplot_th_file="${output_folder}trafico.plt"
if [ -f ${gnuplot_th_file} ];
then
 echo "dump_th.sh: Borrando gnuplot_th_file"
 rm -r ${gnuplot_th_file}
fi

echo "#!/usr/bin/gnuplot -persist" >> ${gnuplot_th_file}
#echo "set terminal png"  >>trafico.plt
echo "set output '${output_folder}${i}_th_.png' "  >>${gnuplot_th_file}
echo "set title \"Throughput\"" >> ${gnuplot_th_file}
echo "set xlabel \"Tiempo (s)\"" >> ${gnuplot_th_file}
echo "set ylabel \"bits/s \"" >> ${gnuplot_th_file}

echo "set xtics font \", 6\"" >> ${gnuplot_th_file}
echo "plot \"${th_file}\" with linespoints" >> ${gnuplot_th_file} 

gnuplot -p "${gnuplot_th_file}"
