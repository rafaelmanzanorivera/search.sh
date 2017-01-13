









ARCHIVOS 

/home/rafael/search2.1.E.sh /home -t f -n you -p rwx -r y -print y


/home/rafael/search2.1.E.sh /home -t f -c molo -p r-- -r y -print y

 0 -r-------- 1 rafael rafael     0 ene 10 16:32 thisfilehas_r--_for_rafael_CONTIENE:MOLO.txt



/home/rafael/search2.1.E.sh /home -t f -c teta -p rw- -r y -print y

 0 -rw------- 1 rafael rafael     0 ene 10 16:33 thisfilehas_rw-_for_rafaelCONTIENE:TETA.txt



/home/rafael/search2.1.E.sh /home -t f -c tengo -p rwx -r y -print y

 0 -rwx------ 1 rafael rafael     0 ene 10 16:34 thisfilehas_rwx_for_rafaelCONTIENE:TENGO



 /home/rafael/search2.1.E.sh /home -t f -c ejecutable -p r-x -r y -print y

 0 -r-xr-x--- 1 rafael rafael     0 ene 10 16:36 thisfilehas_r-x_for_rafaelCONTIENE:EJECUTABLE.txt



/home/rafael/search2.1.E.sh /home -t f -c echo -p rwx -r y -print y


#sino recursivo no muestro carpeta
/home/rafael/search2.1.E.sh /home/rafael -t f -n you -p rwx -print y






DIRECTORIOS

/home/rafael/search2.1.E.sh /home -t d -n sc -p rwx -r y -print y

/home/rafael/search2.1.E.sh /home -t d -n s -p rwx -r y -print y

sudo /home/rafael/search2.1.E.sh / -t d -n kernel -p rwx -r y -print y






PIPES 

/home/rafael/search2.1.E.sh /home/rafael -t f -n you -p rwx -print y

/home/rafael/search2.1.E.sh /home/rafael -t f -n you -p rwx -pipe sort -r

/home/rafael/search2.1.E.sh /home/rafael -t f -n you -p rwx -pipe grep 4

/home/rafael/search2.1.E.sh /home/rafael -t d -n you -p rwx -print y

/home/rafael/search2.1.E.sh /home/rafael -t d -n you -p rwx -pipe sort -r




EXEC

/home/rafael/search2.1.E.sh /home -t f -n you -p rwx -r y -exec wc

/home/rafael/search2.1.E.sh /home -t f -n you -p rwx -r y -exec wc -w

#/home/rafael/search2.1.E.sh /home -t f -n you -p rwx -r y -exec cat





PERMISOS
#( En funcion de quien ejecuta se muestran los permisos correspondientes)
#
#
#Buscar el archivo owner, sino lo ejecuto como el propietario del archivo no me aparece
#ya que no tengo permisos rwx como rafael 

/home/rafael/search2.1.E.sh /home -t f -n owner -p rwx -r y -print y

#Si busco un archivo owner para el que no tengo permisos me lo enseña

/home/rafael/search2.1.E.sh /home -t f -n owner -p --- -r y -print y

#Si lo ejecuto como root buscando archivos con permisos rwx  me lo enseña

sudo /home/rafael/search2.1.E.sh /home -t f -n owner -p rwx -r y -print y

#Permisos en carpeta bin
#archivos binarios
/home/rafael/search2.1.E.sh /bin -t f -c echo -p rwx -print y

sudo /home/rafael/search2.1.E.sh /bin -t f -n sys -p rwx -print y






TODO

#error si buscas caddena en directorios
/home/rafael/search2.1.E.sh /bin -t d -c sys -p rwx -print y


#error si tipo de archivo o permiso no existe

/home/rafael/search2.1.E.sh /home -t g -n you -p rwx -print y -r y

/home/rafael/search2.1.E.sh /home -t f -n you -p ewx -print y -r y


#Si directorio no existe
/home/rafael/search2.1.E.sh /homer -t f -n you -p ewx -print y -r y

#Si usas grep y exec a la vez
/home/rafael/search2.1.E.sh /home -t f -n you -p rwx -r y -pipe grep a -exec d

#Si el commmando pasado por grep o pipe no existe

/home/rafael/search2.1.E.sh /home -t f -n you -p rwx -r y -exec wcs

#Si excede timeout







ERRORES

 1 "Cannot read '$DIR'"

 2 "Specify type to search for"
 3 "Not valid tyoe option: $TYPE"
 
 4 "Specify permissions to search for"
 5 "Perms option not valid: $PERM"
 
 6 "Specify name of file/directory (-n) or string(-c) to search for"
 7 "Cannot use string search for directories, change type (-t) to files (f)"

 8 "Cannot use -exec and -pipe at the same time"
 
 8 "Last line of file specified as non-opt/last argument:"
 

 
 10 "No se puede leer el archivo ${ALL_NAMES[i]}"
 
 11 "Cannot continue, $finalcommand is not a valid command"

 12 "Timeout"
 13 "TIMEOUT environment variable not setted, use from shell: export TIMEOUT=VALUE"