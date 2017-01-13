









ARCHIVOS 

/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -print y


/home/rafael/searchF.sh /home -t f -c molo -p r-- -r y -print y

 0 -r-------- 1 rafael rafael     0 ene 10 16:32 thisfilehas_r--_for_rafael_CONTIENE:MOLO.txt



/home/rafael/searchF.sh /home -t f -c teta -p rw- -r y -print y

 0 -rw------- 1 rafael rafael     0 ene 10 16:33 thisfilehas_rw-_for_rafaelCONTIENE:TETA.txt



/home/rafael/searchF.sh /home -t f -c tengo -p rwx -r y -print y

 0 -rwx------ 1 rafael rafael     0 ene 10 16:34 thisfilehas_rwx_for_rafaelCONTIENE:TENGO



 /home/rafael/searchF.sh /home -t f -c ejecutable -p r-x -r y -print y

 0 -r-xr-x--- 1 rafael rafael     0 ene 10 16:36 thisfilehas_r-x_for_rafaelCONTIENE:EJECUTABLE.txt



/home/rafael/searchF.sh /home -t f -c echo -p rwx -r y -print y


#sino recursivo no muestro carpeta
/home/rafael/searchF.sh /home/rafael -t f -n you -p rwx -print y






DIRECTORIOS

/home/rafael/searchF.sh /home -t d -n sc -p rwx -r y -print y

/home/rafael/searchF.sh /home -t d -n s -p rwx -r y -print y

sudo /home/rafael/searchF.sh / -t d -n kernel -p rwx -r y -print y






PIPES 

/home/rafael/searchF.sh /home/rafael -t f -n you -p rwx -print y

/home/rafael/searchF.sh /home/rafael -t f -n you -p rwx -pipe sort -r

/home/rafael/searchF.sh /home/rafael -t f -n you -p rwx -pipe grep 4

/home/rafael/searchF.sh /home/rafael -t d -n you -p rwx -print y

/home/rafael/searchF.sh /home/rafael -t d -n you -p rwx -pipe sort -r




EXEC

/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -exec wc

/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -exec wc -w

#/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -exec cat





PERMISOS
#( En funcion de quien ejecuta se muestran los permisos correspondientes)
#
#
#Buscar el archivo owner, sino lo ejecuto como el propietario del archivo no me aparece
#ya que no tengo permisos rwx como rafael 

/home/rafael/searchF.sh /home -t f -n owner -p rwx -r y -print y

#Si busco un archivo owner para el que no tengo permisos me lo enseña

/home/rafael/searchF.sh /home -t f -n owner -p --- -r y -print y

#Si lo ejecuto como root buscando archivos con permisos rwx  me lo enseña

sudo /home/rafael/searchF.sh /home -t f -n owner -p rwx -r y -print y

#Permisos en carpeta bin
#archivos binarios
/home/rafael/searchF.sh /bin -t f -c echo -p rwx -print y

sudo /home/rafael/searchF.sh /bin -t f -n sys -p rwx -print y




ERRORES


1 "Cannot read '$DIR'"
/home/rafael/searchF.sh /homer -t f -n you -p rwx -print y -r y

2 "Specify type to search for"
/home/rafael/searchF.sh /home -n you -p rwx -print y -r y

3 "Not valid tyoe option: $TYPE"
/home/rafael/searchF.sh /home -t g -n you -p rwx -print y -r y

4 "Specify permissions to search for"
/home/rafael/searchF.sh /home -t f -n you -print y -r y

6 "Specify name of file/directory (-n) or string(-c) to search for"
/home/rafael/searchF.sh /homer -t f -p rwx -print y -r y


5 "Perms option not valid: $PERM"
/home/rafael/searchF.sh /home -t f -n you -p ewx -print y -r y

7 "Cannot use string search for directories, change type (-t) to files (f)"
/home/rafael/searchF.sh /bin -t d -c sys -p rwx -print y

8 "Cannot use -exec and -pipe at the same time"
/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -pipe grep a -exec d

9 "Last line of file specified as non-opt/last argument:"
/home/rafael/searchF.sh /home -t f -n d -p rwx -pipe

10 "No se puede leer el archivo ${ALL_NAMES[i]}"
/home/rafael/searchF.sh / -t d -n kernel -p rwx -r y -print y

11 "Using recursive you must run the script specifying absolute path"
./searchF.sh /home -t f -n you -p rwx -r y -print y

12 "Timeout"
export TIMEOUT=0
/home/rafael/searchF.sh /bin -t f -c echo -p rwx -exec wc

13 "TIMEOUT environment variable not setted, use from shell: export TIMEOUT=VALUE"
/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -exec wc

14 "Cannot continue, $finalcommand is not a valid command"
/home/rafael/searchF.sh /home -t f -n you -p rwx -r y -exec wcs

