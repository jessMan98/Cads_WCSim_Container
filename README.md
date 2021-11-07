# CADS:WCSim
Herramienta para ciencia datos hecha dentro de un contenedor en Docker


## Automatización en contenedor Docker WCSim

La imagen de WCSim a utilizar: https://hub.docker.com/r/manu33/wcsim

1. Crear una carpeta en el host local que contenga el archivo.mac
2. Una vez ubicada la ruta del archivo crear un contenedor para ligar la carpeta del host al contenedor:
   * sudo docker run -v <directorio_Host> :/home/neutrino/wcsim/mac_files -d -it --name=WCSim wcsim:1.1
   
3. Hecho este paso, podemos visualizar dentro del contenedor la carpeta y el < archivo >.mac

5. Lo siguiente es correr la aplicacion con el archivo de entrada .mac
    * sudo docker exec -it <nombre_contenedor> bash -c "cd /home/neutrino/software; source run.sh; cd $SOFTWARE/WCSim_build; ./WCSim /home/neutrino/wcsim/mac_files/WCSim.mac"
  
5. Despues se genera el archivo.root
6.  Copiaremos el archivo.root a nuestra carpeta compartida:
    * sudo docker exec -it <nombre_contenedor> bash -c "cp /home/neutrino/software/WCSim_build/wcsim_output.root /home/neutrino/wcsim/mac_files"
    
7. Con el paso anterior podemos visualizar en nuestro Host local el archivo.root
8. El ultimo paso sera borrar el archivo que se acaba de generar en el contenedor:
    * sudo docker exec -it WCSim bash -c "rm /home/neutrino/software/WCSim_build/wcsim_output.root"

