# WCSim_Cads_Docker
Herramienta para Ciencia de Datos

Creacion de la imgen de WCSim en Docker


Archivo de Entrada a ejecutar dentro del contenedor.
La imagen de WCSim a utilizar se creo desde cero: 

1. Crear una carpeta en el host local que contenga el archivo.mac
2. Una vez ubicada la ruta del archivo crear un contenedor para ligar la carpeta del host al contenedor:
   * sudo docker run -v /home/many/wcsim/mac_files/:/home/neutrino/wcsim/mac_files -d -it --name=WCSim wcsim:1.1
3. Hecho este paso, podemos visualizar dentro del contenedor la carpeta y el archivo .mac
4. Lo siguiente es correr la aplicacion con el archivo de entrada .mac
    * sudo docker exec -it WCSim bash -c "cd /home/neutrino/software; source run.sh; cd $SOFTWARE/WCSim_build; ./WCSim /home/neutrino/wcsim/mac_files/WCSim.mac"
5. Despues. se genera el archivo.root
6.  Copiaremos el archivo.root a nuestra carpeta compartida:
    * sudo docker exec -it WCSim bash -c "cp /home/neutrino/software/WCSim_build/wcsim_output.root /home/neutrino/wcsim/mac_files"
7. Con el paso anterior podemos visualizar en nuestro Host local el archivo.root
8. El ultimo paso sera borrar el archivo que se acaba de generar en el contenedor:
    * sudo docker exec -it WCSim bash -c "rm /home/neutrino/software/WCSim_build/wcsim_output.root"

