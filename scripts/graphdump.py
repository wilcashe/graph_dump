#Autor: Juan Gabriel Bustos . Eduardo Castellanos
import Tkinter as tk
import tkFileDialog
import Pmw, sys, os

Borrar_working_folder=0 #1-> si, 0-no
user_folder=os.path.expanduser("~")
print(user_folder)

#Se crea una carpeta temporal
if os.path.exists(user_folder +'/graph_dump/temp/'):
    print("carpeta temp ya existe, borrando...")
    os.system("rm -r " +user_folder +"/graph_dump/temp/")
    print("creando carpeta temp")
    os.system("mkdir "+ user_folder+"/graph_dump/temp/")

else:
    print("creando carpeta temp")
    os.system("mkdir "+ user_folder+"/graph_dump/temp/")
    
working_folder=user_folder +"/graph_dump/temp/"
print("Carpeta temporal es: " +working_folder)

#Se crea la carpeta de salida
if os.path.exists(user_folder +'/graph_dump/output_files/'):
    print("carpeta de salida ya existe")
else:
    print("creando carpeta de salida")
    os.system("mkdir "+ user_folder+"/graph_dump/output_files/")
output_folder=user_folder +"/graph_dump/output_files/"
print("Carpeta de salida es: " +output_folder)

def suma():
    i=0
    while i < 5 :
        print (i)
        i=i+1
    root = tk.Tk()
    root.title("suma")
    text = tk.Label(root, text=i)
    text.pack()

def buscar_tp_server():
    file = tkFileDialog.askopenfile(parent=root,mode='rb',title='Choose a file')
    if file != None:
        data = file.read()
        file.close()
        print "I got %d bytes from this file." % len(data)
	#print (file.name)

	file_dir=file.name
        current_dir=os.getcwd()
	print ("Archivo Cargado "+file_dir)
	#print (current_dir)
	os.system("cp " + file_dir +" " + user_folder +"/graph_dump/temp/trafico_server")
	print(file_dir +" " + user_folder +"/graph_dump/temp/trafico_server")



def tp():

    os.system("sh dump_th.sh "+working_folder+" "+output_folder)

def buscar_cliente():
    file = tkFileDialog.askopenfile(parent=root,mode='rb',title='Choose a file')
    if file != None:
        data = file.read()
	#name = file.name()
        file.close()
        print "I got %d bytes from this file." % len(data)
	#print (file.name)

	file_dir=file.name
        current_dir=os.getcwd()
	print ("Archivo cargado: "+file_dir)
	#print (current_dir)
	os.system("cp " + file_dir +" " + user_folder +"/graph_dump/temp/trafico_host")
	print("Archivo copidado FROM: "+file_dir +"  TO:" + user_folder +"/graph_dump/temp/trafico_host")
	
def delay():
    os.system("sh dump_delay.sh "+working_folder+" "+output_folder)
    #os.system("sh dump_delay.sh")


def estadisticas():
    #Se calcula el porcentaje de paquetes perdidos
    #los resultados se guardan en el archivo PackLoss.txt en el output folder
    os.system("sh dump_ploss.sh "+working_folder+" "+output_folder)
    
    #se pasa el archivo traf_3  al script statistics.pl, traf_3 es un archivo generado 
    #cuando se procesa el trafico del server y contiene el listado de paquetes enviados (tiempo  size[Bytes])
    os.system("perl statistics.pl " +working_folder+"traf_3 > "+working_folder+"statistics_temp.txt")
    os.system("cat "+working_folder+"statistics_temp.txt "+working_folder+"PackLoss.txt > "+output_folder+"statistics.txt")
    os.system("xdg-open "+output_folder+"statistics.txt")


def salir():
    root.destroy()
    if Borrar_working_folder==1:
	print("Borrando carpeta temp")
	os.system("rm -r " +working_folder)

root = tk.Tk()

root.title("Graph Dump v0.3")

text = tk.Label(root, text="Analizador de trafico")
text.config(font=("Arial", 15))
text.pack(padx=20,pady=10)

text1 = tk.Label(root, text="NOTA: Ejecute los pasos de forma secuencial")
text1.config(font=("Arial", 9))
text1.pack(padx=20,pady=10)

text11 = tk.Label(root, text="1. Cargar las capturas de trafico")
text11.config(font=("Arial", 8))
text11.pack(padx=20,pady=10)

boton_buscar_tp=tk.Button(root, text='Cargar la captura de trafico del servidor', command=buscar_tp_server)
boton_buscar_tp.place(x=5,y=20)
boton_buscar_tp.pack(pady=5)

boton_buscar_delay=tk.Button(root, text='Cargar la captura de trafico del cliente', command=buscar_cliente)
boton_buscar_delay.place(x=5,y=20)
boton_buscar_delay.pack(pady=5)
text1 = tk.Label(root, text="__________________________________________")
text1.config(font=("Arial", 8))
text1.pack(padx=20,pady=10)

boton_tp=tk.Button(root, text='2. Graficar throughput', command=tp)
boton_tp.place(x=5,y=40)
boton_tp.pack(pady=5)

boton_delay=tk.Button(root, text='3. Graficar retardo', command=delay)
boton_delay.place(x=5,y=40)
boton_delay.pack(pady=5)

text2 = tk.Label(root, text="__________________________________________")
text2.config(font=("Arial", 8))
text2.pack(padx=20,pady=10)

text3 = tk.Label(root, text="Antes de dar click en el siguiente boton \n asegurese de haber generado las graficas de retardo y throughput")
text3.config(font=("Arial", 7))
text3.pack(padx=20,pady=10)

boton_estadisticas = tk.Button(root, text="4. Calcular el porcentaje de paquetes perdidos \n y otras estadisticas", command=estadisticas)
boton_estadisticas.place(x=5, y=60)
boton_estadisticas.pack(pady=5)

boton_salir = tk.Button(root, text="S A L I R",command=salir) #command=funcion, cuando se presione el boton, se ejecutara la funcion "suma"
boton_salir.place(x=5,y=80)
boton_salir.pack(pady=5)

text22 = tk.Label(root, text="Desarrollado por: Juan Gabriel Bustos, Fran Sanabria, Eduardo Castellanos")
text22.config(font=("Arial", 8))
text22.pack(padx=20,pady=10)

root.mainloop()
