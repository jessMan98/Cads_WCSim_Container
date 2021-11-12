# CADS:WCSim
Herramienta para ciencia datos hecha dentro de un contenedor en Docker

## Automatización en contenedor Docker WCSim

La imágen de WCSim a utilizar: https://hub.docker.com/r/manu33/wcsim/tags

* Para descargar la imágen ejecutamos lo siguiente: **docker pull manu33/wcsim:1.1**

1. Creamos una carpeta en nuestra máquina local que contenga el archivo.mac, puedes utilizar como ejemplo la carpeta que se encuentra en este repositorio:
   wcsim/mac_files/WCSim.mac (puedes cambiarle el nombre).

3. Una vez ubicada la ruta del archivo crear un contenedor para ligar la carpeta creada en el paso 1 al contenedor:
   * sudo docker run -v <directorio_local> :/home/neutrino/wcsim/mac_files -d -it --name=WCSim wcsim:1.1
   
3. Hecho este paso, podemos visualizar dentro del contenedor la carpeta y el < archivo >.mac

4. Lo siguiente es correr la aplicación con el archivo de entrada .mac
    * sudo docker exec -it <nombre_contenedor> bash -c "cd /home/neutrino/software; source run.sh; cd $SOFTWARE/WCSim_build; rm /home/neutrino/wcsim/mac_files/wcsim_output.root;./WCSim /home/neutrino/wcsim/mac_files/WCSim.mac; mv /home/neutrino/software/WCSim_build/wcsim_output.root /home/neutrino/wcsim/mac_files "

5. La instrucción anterior lo primero que hace borra el archivo de salida .root (si es que hay, esto para obtener un nuevo archivo de salida), luego ejecuta el archivo de entrada .mac, con esto se genera nuestro nuevo archivo .root y por último movemos ese archivo a nuestra carpeta compartida.

6. Efectuando el paso anterior podemos visualizar en nuestra carpeta de nuestra máquina local el archivo .root
