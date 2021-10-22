# perl solo_th.pl <archivo_de_traza.tr> <intervalo de tiempo> > archivo_de_salida.txt
# ejemplo: "perl solo_th.pl traza.txt 1 > th.txt"       
# 1 es el intervalo de tiempo en que se calculará el th (cada 1 seg se calcula el th)

$archivo=$ARGV[0];
$intt=$ARGV[1];

$sum=0;
$Acum=0;

      open (DATA,"<$archivo")|| die "Can't open $archivo $!";

  
while (<DATA>) {
             
	@x = split(' '); 
	
	#Si no se ha superado el intervalo de tiempo, entonces se suma
	#el tamaño del paquete
	#x[0] es el primer campo de cada linea del archivo (es decir el tiempo transcurrido entre el primer paquete y el que se analiza)
	if ($x[0]-$Acum <= $intt)
	{
		$sum=($sum+$x[1]);		
	}
	#si ya se superó el tamaño del intervalo, entonces se calcula el th
	else
	{   
        #se comprueba que la suma sea diferente de cero
        #si es cero es porque en ese intervalo de tiempo no llegaron paquetes
        
		if ($sum ne 0)
		{
			#Calculo del TH en el intervalo de tiempo intt. Se multiplica por 8
			#para pasarlo a bits
			$th=($sum/$intt)*8;
			print STDOUT "$x[0]    $th\n";
			
			$Acum=$Acum+$intt;
			$sum=0;
		}
		else
		{

			$Acum=$Acum+$intt;
		}

	}   
}
$th=$sum/$intt;
close DATA;
exit(0);
