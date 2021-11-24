# CADS:WCSim
Herramienta para ciencia datos hecha dentro de un contenedor en Docker

## Automatización en contenedor Docker WCSim

La imágen de WCSim a utilizar: [Dockerhub](https://hub.docker.com/r/manu33/wcsim "manu33/wcsim")

* Para descargar la imágen ejecutamos lo siguiente: 
    ```Docker
    sudo docker pull manu33/wcsim:1.2
    ```

1. Creamos una carpeta en nuestra máquina local que contenga el archivo.mac.

    * Puedes utilizar como ejemplo la carpeta que se encuentra en este          repositorio:     
        **wcsim/mac_files/WCSim.mac**, este directorio es de prueba asi como el archivo.mac, puedes cambiarle el nombre a las carpetas, lo importante es que dentro de    ellas contenga el **archivo.mac** que se va a utilizar. 

2. Una vez ubicada la ruta del archivo, crear un contenedor para ligar la carpeta creada en el paso 1 al contenedor:
    
        sudo docker run -v <directorio_local>:/home/neutrino/wcsim/mac_files -d -it --name=WCSim manu33/wcsim:1.2  
   
3. Hecho este paso, podemos visualizar dentro del contenedor la carpeta y el < archivo >.mac

4. Lo siguiente es correr la aplicación con el archivo de entrada .mac:

    ```
    sudo docker exec -it <nombre_contenedor> bash -c "cd /home/neutrino/software; source run.sh; cd $SOFTWARE/WCSim_build; rm /home/neutrino/wcsim/mac_files/wcsim_output.root;./WCSim /home/neutrino/wcsim/mac_files/WCSim.mac; mv /home/neutrino/software/WCSim_build/wcsim_output.root /home/neutrino/wcsim/mac_files"
    ```

    **Nota**: El nombre que se genera por defecto del archivo de salida .root es: **wcsim_output.root** el nombre puede cambiar dependiendo la configuración
    del archivo ".mac". Puedes modificar el nombre en la linea 147 dentro del archivo ".mac". Si lo modificas, en la instrucción anterior reemplaza
    **wcsim_output.root** por el nuevo nombre.

5. La instrucción anterior hace lo siguiente:
  * Ejecuta el archivo .sh que contiene las variables de entorno para correr WCSim.
  * Borra el archivo de salida .root (si es que hay, esto para obtener un nuevo archivo de salida).
  * Ejecuta el archivo de < entrada >.mac, con esto se genera nuestro nuevo < archivo >.root 
  * Por último movemos ese archivo a nuestra carpeta compartida.

6. Efectuando el paso anterior podemos visualizar en la carpeta de nuestra máquina local el archivo .root
___
## Ejecutar rutina de python en WCSim
Una vez ejecutados los pasos anteriores procedemos a convertir el archivo.root a archivo ".npz".

Los módulos de python para ejecutar la rutina se encuentra en la siguiente ruta dentro del contenedor:

**/home/WatChMal/DataTools**

Seguiremos utilizando la carpeta creada en los pasos anteriores, puesto que utilizaremos como entrada el archivo ".root".

El módulo de python a utilizar es "event_dump.py".

**Ejecutamos la instrucción:**

    sudo docker exec -it <nombre_contenedor> bash -c "cd /home/neutrino/software; source run.sh; cd /home/WatChMal/DataTools; time python3 event_dump.py /home/neutrino/wcsim/mac_files/wcsim_output.root /home/neutrino/wcsim/mac_files"
  
Enseguida si visualizamos en nuestra máquina local la carpeta **/wcsim/mac_ files/** aparecerá un archivo comprimido ".npz" resultado de la rutina ejecutada en python.
___
## Convertir archivo .npz a .npy

1. Descargamos los archivos: "Npz_files" y "Geometry" que se encuentran en este repositorio.
2. Creamos un directorio en nuestra máquina local que contenga los 2 archivos anteriores, puedes llamarlo como prefieras.
3. Una vez ubicada la ruta de nuestro directorio, creamos un nuevo contenedor para compartir nuestra carpeta creada en el paso 1 con el contenedor.

        sudo docker run -v <directorio_local>:<directorio_dentro_del_contenedor> -d -it --name="WCSim2" manu33/wcsim:1.2
    
* **<directorio_local>** = directorio creado en el paso 1.
* **<directorio_dentro_del_contenedor>** = puedes crearlo en cualquier ruta, de preferencia en /home/neutrino.

  Por ejemplo:
        
      sudo docker run -v /home/many/ImageData/:/home/neutrino/ImageData -d -it --name="WCSim2" manu33/wcsim:1.2
     
4. Corremos la instrucción que convertirá los archivos .npz del directorio Npz_files a ".npy"
  * La instrucción toma 3 archivos:
  
      * **npz_to_image.py** : se encuentra en la siguiente carpeta dentro del contenedor -> _"/home/Tools_HKM/npz_to_image.py"_
      * **IWCD_geometry_mPMT.npy** : se encuentra en nuestra carpeta compartida dentro del contenedor -> _"/home/neutrino/ImageData/Geometry"_
      * **< archivos >.npz** : se encuentran en nuestra carpeta compatida dentro del contenedor -> _"/home/neutrino/ImageData/Npz_files"_

      
    ```
    sudo docker exec -it <nombre_contenedor> bash -c "rm /home/neutrino/software/WCSim_build/*.npy;python3 /home/Tools_HKM/npz_to_image.py -m /home/neutrino/ImageData/Geometry/IWCD_geometry_mPMT.npy -d /home/neutrino/ImageData/Npz_files/; mv /home/neutrino/software/WCSim_build/*.npy /home/neutrino/ImageData/" 
    ```
5. Después de este paso podemos visualizar en nuestra máquina local los archivos de salida **.npy**
___

## Estructura de carpetas dentro del contenedor

* **/home/neutrino:** _usuario_
* **/home/neutrino/software/run.sh:**  _script que ejecuta las variables de entorno_
* **/home/WatChMal/DataTools/*.py:** _modulos de python_
* **/home/Tools_HKM/npz_to_image.py**
* **/home/neutrino/software/WCSim_build :** _ruta donde se guardan por defecto archivos de salida ".root" y ".npy"_

## Directorios de prueba
* **/wcsim/mac_files/WCSim.mac:** _archivo .mac de prueba_. 

  **Nota:** (se puede cambiar el nombre del directorio si el usuario lo desea), (el archivo .mac de prueba quitarlo y poner un .mac personalizado).
* **/Npz_files :** archivos _.npz_ de prueba.
* **/Geometry/IWCD_geometry_mPMT.npy**
___

# Singularity
Utilizaremos la imagen que se encuentra en Dockerhub [Dockerhub](https://hub.docker.com/r/manu33/wcsim "manu33/wcsim") la version de la imagen es la 1.2

1. Creamos un directorio en nuestra maquina local llamado: **wcsim-dir**, puedes nombrarlo como quieras y crearlo en cualquier ruta. En este ejemplo, el directorio esta creado en la carpeta personal. Lo que haremos sera crear un **_sandbox_** (un directorio raiz de escritura) para poder manejar las herramientas y archivos que se encuentran en el contenedor.

2. Una vez creado el directorio, procedemos a ejecutar la siguiente instruccion:

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
  * En la instruccion anterior el comando build construira la imagen de docker a una imagen de singularity.
  * La opcion **_--sandbox_** nos permite crear el directorio raiz de escritura.
  * **_wcsim-dir_** es el directorio que creamos en el paso 1.
  * Por ultimo, lo que resta de la instruccion es la imagen a descargar de la plataforma de Dockerhub.

    _Este paso puede tardar algunos minutos dependiendo los recursos de tu maquina._
  

3. Creamos una instancia de nuestro contenedor con el siguiente comando:

    ```
    sudo singularity instance start wcsim-dir/ WCSim
    ```
## **Nota:**

Una de los aspectos clave de **Singularity** es que debemos ingresar al contenedor con permisos de superusuario, ya que si no lo hacemos no vamos a poder instalar programas o hacer cualquier accion que involucre privilegios dentro del contenedor. 

Para resolver esto necesitamos agregar **sudo** y la opcion **--writable**, esta opcion nos permite modificar el contenedor.




