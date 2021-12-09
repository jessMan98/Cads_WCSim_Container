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
# **Singularity** 

Una vez instalado Singularity [instalación versión 3.5.3](https://github.com/NIH-HPC/Singularity-Tutorial/tree/2020-03-10/00-installation) procedemos a realizar lo siguiente:

Utilizaremos la imagen de WCSim que se encuentra en [Dockerhub](https://hub.docker.com/r/manu33/wcsim).
___
## **Convertir archivo _.mac_ a _.root_** 

  Nota:
        En singularity es importante utilizar sudo en cada instrucción, esto para poder tener permisos de superusuario dentro del contenedor.

1. Al momento de descargar la imagen la convertiremos en un _directory sandbox_(directorio de lectura y escritura) para poder modificar nuestro contenedor.

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
    **wcsim-dir** es el nombre del directorio _sandbox_ (puedes cambiar el nombre si lo deseas). 
    
    Una vez ejecutada la instrucción, podemos visualizar en nuestra máquina local el directorio **wcsim-dir**.

2. Ubicar el archivo .mac a convertir y almacenarlo en una carpeta. En este ejemplo el archivo .mac se encuentra en la carpeta **wcsim/mac_files/WCSim.mac** en nuestra máquina local.

3. Creamos un directorio dentro del contenedor el cual lo utilizaremos como carpeta compartida.
    ```
    sudo singularity exec --writable wcsim-dir/ /bin/bash -c "mkdir /home/shared-folder"
    ```

    Para este ejemplo el nombre de la carpeta es: **'shared-folder'** y se encuentra en **/home** dentro del contenedor.

4. En seguida procedemos a ejecutar WCSim con el siguiente comando:
    ```
    sudo singularity exec --writable --bind /home/many/Escritorio/wcsim:/home/shared-folder wcsim-dir/ /bin/bash -c "cd /home/neutrino/software; source run.sh; cd $SOFTWARE/WCSim_build; ./WCSim /home/shared-folder/mac_files/WCSim.mac; mv /home/neutrino/software/WCSim_build/wcsim_output.root /home/shared-folder/mac_files"
    ```
    
    En la instrucción anterior:
    *  **exec** se utiliza para ejecutar comandos desde fuera del contenedor.
    * **--writable** se utiliza para poder hacer modificaciones dentro del contenedor.
    * **--bind** nos permite vincular la carpeta de nuestra máquina local al contenedor.
    * _/home/many/Escritorio/wcsim_(ruta maquina local):_/home/shared-folder_(ruta contenedor).
    * **wcsim-dir** es el sandbox(contenedor) creado en el paso 1.

Una vez finalizado el paso anterior podremos visualizar nuestro archivo _.root_ dentro de la carpeta comapartida en nuestra máquina local (**_wcsim/mac_files_**).
___

## **Convertir archivo _.root_ a _.npz_ con rutina de python**
1. Al momento de descargar la imagen la convertiremos en un _directory sandbox_(directorio de lectura y escritura) para poder modificar nuestro contenedor.

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
    **wcsim-dir** es el nombre del directorio _sandbox_ (puedes cambiar el nombre si lo deseas). 
    
    Una vez ejecutada la instrucción, podemos visualizar en nuestra máquina local el directorio **wcsim-dir**.

2. Ubicar el archivo **.root** a convertir y almacenarlo en una carpeta. En este ejemplo el archivo **.root** se encuentra en la carpeta **wcsim/mac_files/** en nuestra máquina local.

3. Creamos un directorio en nuestro contenedor el cual lo utilizaremos como carpeta compartida.
    ```
    sudo singularity exec --writable wcsim-dir/ /bin/bash -c "mkdir /home/shared-folder"
    ```

    Para este ejemplo el nombre de la carpeta es: **'shared-folder'** y se encuentra en **/home** dentro del contenedor.

4. Ejecutamos la rutina:
    ```
    sudo singularity exec --writable --bind /home/many/Escritorio/wcsim:/home/shared-folder wcsim-dir/ /bin/bash -c "cd /home/neutrino/software; source run.sh; cd /home/WatChMal/DataTools; time python3 event_dump.py /home/shared-folder/mac_files/wcsim_output.root /home/shared-folder/mac_files"
    ```
    En la instrucción anterior:
    *  **exec** se utiliza para ejecutar comandos desde fuera del contenedor.
    * **--writable** se utiliza para poder hacer modificaciones dentro del contenedor.
    * **--bind** nos permite vincular la carpeta de nuestra máquina local al contenedor.
    * **_/home/many/Escritorio/wcsim_**(ruta máquina local):**_/home/shared-folder_**(ruta dentro del contenedor).
    * **wcsim-dir** es el sandbox(contenedor) creado en el paso 1.
    * rutina de python que se ejecuta **_event_dump.py_**

   Una vez finalizado el paso anterior podremos visualizar nuestro archivo _.npz_ dentro de la carpeta compartida en nuestra máquina local (**_wcsim/mac_files_**).
___
## **Npz_to_Image**

1. Al momento de descargar la imágen la convertiremos en un _directory sandbox_(directorio de lectura y escritura) para poder modificar nuestro contenedor.

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
    **wcsim-dir** es el nombre del directorio _sandbox_ (puedes cambiar el nombre si lo deseas). 
    
    Una vez ejecutada la instrucción, podemos visualizar en nuestra máquina local el directorio **wcsim-dir**.

2. Descargar los directorios **Npz_files** y **Geometry** que se encuentran en el repositorio. 

    *   En el directorio **Npz_files** se encuentran archivos _.npz_ de ejemplo (sustituirlos por archivos tus archivos _.npz_). 

    *   Crear un directorio llamado **IMAGE-DATA** (puedes cambiarle el nombre) y almacenar los dos directorios anteriores.

3. Creamos un directorio en nuestro contenedor el cual lo utilizaremos como carpeta compartida.
    ```
    sudo singularity exec --writable wcsim-dir/ /bin/bash -c "mkdir /home/shared-folder"
    ```

    Para este ejemplo el nombre de la carpeta es: **'shared-folder'** y se encuentra en **/home** dentro del contenedor.

4. Ejecutamos la instrucción:
    ```
    sudo singularity exec --writable --bind /home/many/Escritorio/IMAGE-DATA:/home/shared-folder wcsim-dir/ /bin/bash -c "python3 /home/Tools_HKM/npz_to_image.py -m /home/shared-folder/Geometry/IWCD_geometry_mPMT.npy -d /home/shared-folder/Npz_files/; mv ~/*.npy /home/shared-folder"
    ```
    En la instrucción anterior:
    *  **exec** se utiliza para ejecutar comandos desde fuera del contenedor.
    * **--writable** se utiliza para poder hacer modificaciones dentro del contenedor.
    * **--bind** nos permite vincular la carpeta de nuestra máquina local al contenedor.
    * **_/home/many/Escritorio/IMAGE-DATA_**(ruta máquina local):**_/home/shared-folder_**(ruta dentro del contenedor).
    * **wcsim-dir** es el sandbox(contenedor) creado en el paso 1.
    * Rutina de python que se ejecuta **_npz_to_image.py_**

    Una vez finalizada la instrucción, podremos visualizar nuestros archivos _.npy_ dentro de la carpeta compartida en nuestra máquina local (**_IMAGE-DATA_**).
___



