# **Docker** 

## **Convertir archivo _.mac_ a _.root_** 

La imágen de WCSim a utilizar: [Dockerhub](https://hub.docker.com/r/manu33/wcsim "manu33/wcsim")

1. Descargar la imágen: 
    ```
    sudo docker pull manu33/wcsim:1.2
    ```
2. Dentro del directorio **data/mac_files** se encuentra el archivo **.mac** de ejemplo a procesar.
 
3. Una vez ubicada la ruta del archivo, crear el contenedor para vincular el directorio local **/data** dentro del contenedor:
    
    ```
    sudo docker run -v /home/user/Cads_WCSim_Container/data/:/home/neutrino/data/ -d -it --name=WCSim manu33/wcsim:1.2  
    ```

    * **/home/user/Cads_WCSim_Container/data/**: Ruta del directorio local a vincular. Cambiar la ruta de acuerdo a tu usuario.  
    * **/home/neutrino/data/**: Ruta del directorio compartido dentro del contenedor.
    * **--name= WCSim**: Nombre del contenedor.

4. Hecho este paso, podemos visualizar dentro del contenedor la carpeta compartida **data**.

    ```
    sudo docker exec -it WCSim bash -c "ls /home/neutrino"
    ```

5. Lo siguiente es correr la aplicación con el archivo de entrada **.mac**:

    ```
    sudo docker exec -it WCSim bash -c "cd /home/neutrino/software; source run.sh; rm /home/neutrino/data/mac_files/wcsim_output.root;./WCSim /home/neutrino/data/mac_files/WCSim.mac; mv /home/neutrino/software/WCSim_build/wcsim_output.root /home/neutrino/data/root_files"
    ```

    **Nota**: El nombre que se genera por defecto del archivo de salida .root es: **wcsim_output.root** el nombre puede cambiar dependiendo la configuración
    del archivo **".mac"**. Puedes modificar el nombre en la linea **147** dentro del archivo **".mac"**. Si lo modificas, en la instrucción anterior reemplaza
    **wcsim_output.root** por el nuevo nombre.

    La instrucción anterior hace lo siguiente:
    * Ejecuta el archivo .sh que contiene las variables de entorno para correr WCSim.
    * Borra el archivo de salida **.root** (si es que hay, esto para obtener un nuevo archivo de salida).
    * Ejecuta el archivo de **< entrada >.mac**, con esto se genera nuestro nuevo **< archivo >.root**. 
    * Por último movemos ese archivo al directorio **root_files** que contendrá todos los archivos **.root** generados.

Efectuando el paso anterior podemos visualizar en el directorio **/data/root_files** de nuestra máquina local el archivo **.root**.
___
## **Convertir archivo _.root_ a _.npz_ con rutina de python**
La imágen de WCSim a utilizar: [Dockerhub](https://hub.docker.com/r/manu33/wcsim "manu33/wcsim")

1. Descargar la imágen: 
    ```
    sudo docker pull manu33/wcsim:1.2
    ```
2. El directorio **data/root_files** contiene los archivos .**root** de prueba, si no los hay, ejecutar el proceso **mac a root** o agregar tus archivos **.root** a procesar.

3. Una vez ubicada la ruta del archivo, crear un contenedor para vincular el directorio local **/data** al contenedor:
    
    ```
    sudo docker run -v /home/user/Cads_WCSim_Container/data/:/home/neutrino/data/ -d -it --name=WCSim manu33/wcsim:1.2  
    ```
    * **/home/user/Cads_WCSim_Container/data/**: Ruta del directorio local a vincular. Cambiar la ruta de acuerdo a tu usuario.  
    * **/home/neutrino/data/**: Ruta del directorio compartido dentro del contenedor.
    * **--name= WCSim**: Nombre del contenedor.

4. Hecho este paso, podemos visualizar dentro del contenedor la carpeta compartida.

    ```
    sudo docker exec -it WCSim bash -c "ls /home/neutrino"
    ```

    * Los módulos de python para ejecutar la rutina se encuentra en la siguiente ruta dentro del contenedor: **/home/WatChMal/DataTools**

        El módulo de python a utilizar es **"event_dump.py"**.

**Ejecutamos la instrucción:**

    sudo docker exec -it WCSim bash -c "cd /home/neutrino/software; source run.sh; cd /home/WatChMal/DataTools; time python3 event_dump.py /home/neutrino/data/root_files/wcsim_output.root -d /home/neutrino/data/Npz_files"
  
Enseguida si visualizamos en nuestra máquina local el directorio **/data/root_files/** aparecerá un archivo comprimido **".npz"** resultado de la rutina ejecutada en python.
___
## **Convertir archivo .npz a .npy (Npz_to_Image)**

La imágen de WCSim a utilizar: [Dockerhub](https://hub.docker.com/r/manu33/wcsim "manu33/wcsim")

1. Descargar la imágen: 
    ```
    sudo docker pull manu33/wcsim:1.2
    ```
2. Dentro del directorio **data/Npz_files** se encuentran 3 archivos **.npz** de prueba a ejecutar. Puedes sustituirlos por tus propios archivos **.npz**.

3. El directorio **data/Geometry** se encuentrar un script **npy** necesario para ejecutar la rutina de python.

4. Una vez ubicada la ruta del paso 2 y 3, crear un contenedor para vincular el directorio local **/data** al contenedor 
    
    ```
    sudo docker run -v /home/user/Cads_WCSim_Container/data/:/home/neutrino/data/ -d -it --name=WCSim manu33/wcsim:1.2  
    ```

    * **/home/user/Cads_WCSim_Container/data/**: Ruta del directorio local a vincular. Cambiar la ruta de acuerdo a tu usuario.
    * **/home/neutrino/data/**: Ruta del directorio compartido dentro del contenedor.
    * **--name= WCSim**: Nombre del contenedor.

5. Corremos la instrucción que convertirá los archivos **.npz** a **.npy**.

  * La instrucción toma 3 parámetros:
  
      * **npz_to_image.py** : se encuentra en la siguiente carpeta dentro del contenedor **_"/home/Tools_HKM/npz_to_image.py"_**.
      * **IWCD_geometry_mPMT.npy** : se encuentra en nuestra carpeta compartida dentro del contenedor **_"/home/neutrino/data/Geometry"_**.
      * **< archivos >.npz** : se encuentran en nuestra carpeta compatida dentro del contenedor **_"/home/neutrino/data/Npz_files"_**.
      
    ```
    sudo docker exec -it WCSim bash -c "rm /home/neutrino/software/WCSim_build/*.npy;python3 /home/Tools_HKM/npz_to_image.py -m /home/neutrino/data/Geometry/IWCD_geometry_mPMT.npy -d /home/neutrino/data/Npz_files/; mv /home/neutrino/software/WCSim_build/*.npy /home/neutrino/data/Npy_files" 
    ```

    #### **Nota:** En la intruccón que se ejecuta, podemos procesar también un solo archivo **npz**, cambiando el argumento **-d** por **-f** seguido de la ruta del archivo **npz**.

Después de este paso podemos visualizar en nuestro directorio **data/Npy_files** los archivos de salida **.npy**
___

# **Docker Compose**
**Docker compose** se instala al momento de descargar **Docker Engine** en la página oficial. La versión de **Docker compose** utilizada es **2.6.0**. 
___

## **Convertir archivo .mac a .root**
1. El directorio **data/mac_files** contiene un archivo **.mac** de prueba para ejecutar el proceso. 

2. Moverse al directorio **docker_compose/process_mac** ahi se encuentra el archivo **mac_root.yaml** que contiene la configuración. Si tienes conocimientos de Docker compose puedes cambiar a tu manera el archivo **.yaml**.

3. Ejecutar el siguiente comando para levantar el servicio:

    ```
    sudo docker compose -f mac_root.yaml up
    ```
4. Una vez ejecutado el comando y finalizado el proceso, visualizar el directorio local **data/root_files** que contiene el archivo(s) **.root** generado(s).

___
## **Convertir archivo .root a .npz con rutina de pyhton**

1. El directorio **data/root_files** está creado para almacenar archivos **.root**, si no tienes ninguno de prueba, ejecuta el proceso **Convertir archivo .mac a .root**.   

2. Moverse al directorio **docker_compose/process_root** ahi se encuentra el archivo **root_npz.yaml** que contiene la configuración. Si tienes conocimientos de Docker compose puedes cambiar a tu manera el archivo **.yaml**.

3. Ejecutar el siguiente comando para levantar el servicio:

    ```
    sudo docker compose -f root_npz.yaml up
    ```
4. Una vez ejecutado el comando y finalizado el proceso, visualizar el directorio local **data/Npz_files** que contiene el archivo(s) **.npz** generado(s).
___
## **Convertir archivo .npz a .npy (Npz_to_Image)**

1. El directorio **data/Npz_files** está creado para almacenar archivos **.npz**, dentro del directorio hay 3 archivos de prueba para ser utilizados. 

2. Moverse al directorio **docker_compose/process_npz** ahi se encuentra el archivo **npz_npy.yaml** que contiene la configuración. Si tienes conocimientos de Docker compose puedes cambiar a tu manera el archivo **.yaml**.

3. Ejecutar el siguiente comando para levantar el servicio:

    ```
    sudo docker compose -f npz_npy.yaml up
    ```
    
    Este proceso tarda algunos minutos, en finalizar.

4. Una vez ejecutado el comando y finalizado el proceso, visualizar el directorio local **data/Npy_files** que contiene el archivo(s) **.npy** generado(s).
___
# **Singularity** 

Versión de Singularity utilizada: [instalación versión 3.5.3](https://github.com/NIH-HPC/Singularity-Tutorial/tree/2020-03-10/00-installation) procedemos a realizar lo siguiente:

Podemos utilizar la imágen de WCSim que se encuentra en [Dockerhub](https://hub.docker.com/r/manu33/wcsim), o la imágen que se encuentra en el Repositorio de Singularity [Library](https://cloud.sylabs.io/library/many33/default/wcsim)
___
## **Convertir archivo _.mac_ a _.root_** 

  **Nota**:
        En singularity es importante utilizar sudo en cada instrucción, esto para poder tener permisos de superusuario dentro del contenedor.

1. Al momento de descargar la imágen la convertiremos en un _directory sandbox_ (directorio de lectura y escritura) para poder modificar nuestro contenedor. Nos posicionamos en el mismo nivel de nuestro repositorio.

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
    * **wcsim-dir** es el nombre del directorio _sandbox_ (puedes cambiar el nombre si lo deseas). 
    
        Una vez ejecutada la instrucción, podemos visualizar en nuestra máquina local el directorio **wcsim-dir**.

2. Dentro del directorio **data/mac_files/** en nuestra máquina local, se encuentra el archivo **.mac** de prueba. 

3. Creamos un directorio dentro del contenedor llamado **shared-folder** el cual lo vincularemos con el directorio **data** de nuestra máquina local. Puedes cambiarle el nombre si lo deseas. 
    ```
    sudo singularity exec --writable wcsim-dir/ /bin/bash -c "mkdir /home/shared-folder"
    ```

    Para este ejemplo el nombre de la carpeta es: **'shared-folder'** y se encuentra en **/home** dentro del contenedor.

4. En seguida procedemos a ejecutar WCSim con el siguiente comando:
    ```
    sudo singularity exec --writable --bind /home/user/Cads_WCSim_Container/data:/home/shared-folder wcsim-dir/ /bin/bash -c "cd /home/neutrino/software; source run.sh;./WCSim /home/shared-folder/mac_files/WCSim.mac; mv /home/neutrino/software/WCSim_build/wcsim_output.root /home/shared-folder/root_files"
    ```
    
    En la instrucción anterior:
    *  **exec** se utiliza para ejecutar comandos desde fuera del contenedor.
    * **--writable** se utiliza para poder hacer modificaciones dentro del contenedor.
    * **--bind** nos permite vincular la carpeta de nuestra máquina local al contenedor.
    * Donde: **_/home/user/Cads_WCSim_Container/data_** (ruta máquina local):**_/home/shared-folder_** (ruta contenedor). Cambiar la ruta local de acuerdo a tu usuario.
    * **wcsim-dir** es el sandbox(contenedor) creado en el paso 1.

Una vez finalizado el paso anterior podremos visualizar nuestro archivo **.root** dentro de la carpeta **_data/root_files_**.
___

## **Convertir archivo _.root_ a _.npz_ con rutina de python**
1. Al momento de descargar la imágen la convertiremos en un _directory sandbox_(directorio de lectura y escritura) para poder modificar nuestro contenedor.

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
    **wcsim-dir** es el nombre del directorio _sandbox_ (puedes cambiar el nombre si lo deseas). 
    
    Una vez ejecutada la instrucción, podemos visualizar en nuestra máquina local el directorio **wcsim-dir**.

2. El directorio **data/root_files/** contiene los archivos **.root**, si no hay ninguno puedes ejecutar el paso **Convertir archivo .mac a .root**, o de lo contrario agrega tus archivos **.root** personalizados.  

3. Creamos un directorio en nuestro contenedor el cual lo utilizaremos como carpeta compartida.
    ```
    sudo singularity exec --writable wcsim-dir/ /bin/bash -c "mkdir /home/shared-folder"
    ```

    Para este ejemplo el nombre de la carpeta es: **'shared-folder'** y se encuentra en **/home** dentro del contenedor.

4. Ejecutamos la rutina:
    ```
    sudo singularity exec --writable --bind /home/user/Cads_WCSim_Container/data:/home/shared-folder wcsim-dir/ /bin/bash -c "cd /home/neutrino/software; source run.sh; cd /home/WatChMal/DataTools; time python3 event_dump.py /home/shared-folder/root_files/wcsim_output.root -d /home/shared-folder/Npz_files"
    ```
    En la instrucción anterior:
    *  **exec** se utiliza para ejecutar comandos desde fuera del contenedor.
    * **--writable** se utiliza para poder hacer modificaciones dentro del contenedor.
    * **--bind** nos permite vincular la carpeta de nuestra máquina local al contenedor.
    * Donde: **/home/user/Cads_WCSim_Container/data** (ruta máquina local):**/home/shared-folder** (ruta contenedor). Cambiar la ruta local de acuerdo a tu usuario.
    * **wcsim-dir** es el sandbox(contenedor) creado en el paso 1.
    * Rutina de python que se ejecuta **_event_dump.py_**

   Una vez finalizado el paso anterior podremos visualizar nuestro archivo **.npz** dentro del directorio **data/Npz_files** en nuestra máquina local.
___
## **Convertir archivo .npz a .npy (Npz_to_Image)**

1. Al momento de descargar la imágen la convertiremos en un _directory sandbox_(directorio de lectura y escritura) para poder modificar nuestro contenedor.

    ```
    sudo singularity build --sandbox wcsim-dir/ docker://manu33/wcsim:1.2
    ```
    **wcsim-dir** es el nombre del directorio _sandbox_ (puedes cambiar el nombre si lo deseas). 
    
    Una vez ejecutada la instrucción, podemos visualizar en nuestra máquina local el directorio **wcsim-dir**.

2. En el directorio **data/Npz_files** se encuentran archivos **_.npz_** de ejemplo. Puedes sustituirlos por tus archivos **_.npz_**. 

3. El directorio **data/Geometry** se encuentrar un script **.npy** necesario para ejecutar la rutina de python

4. Creamos un directorio en nuestro contenedor el cual lo utilizaremos como carpeta compartida.
    ```
    sudo singularity exec --writable wcsim-dir/ /bin/bash -c "mkdir /home/shared-folder"
    ```

    Para este ejemplo el nombre de la carpeta es: **'shared-folder'** y se encuentra en **/home** dentro del contenedor.

5. Ejecutamos la instrucción:
    ```
    sudo singularity exec --writable --bind /home/user/Cads_WCSim_Container/data:/home/shared-folder wcsim-dir/ /bin/bash -c "python3 /home/Tools_HKM/npz_to_image.py -m /home/shared-folder/Geometry/IWCD_geometry_mPMT.npy -d /home/shared-folder/Npz_files/; mv ~/*.npy /home/shared-folder/Npy_files"
    ```
    En la instrucción anterior:
    *  **exec** se utiliza para ejecutar comandos desde fuera del contenedor.
    * **--writable** se utiliza para poder hacer modificaciones dentro del contenedor.
    * **--bind** nos permite vincular la carpeta de nuestra máquina local al contenedor.
    * Donde: **/home/user/Cads_WCSim_Container/data** (ruta máquina local):**/home/shared-folder** (ruta contenedor). Cambiar la ruta local de acuerdo a tu usuario.
    * **wcsim-dir** es el sandbox(contenedor) creado en el paso 1.
    * Rutina de python que se ejecuta **_npz_to_image.py_**

    Una vez finalizada la instrucción, podremos visualizar nuestros archivos **_.npy_** dentro del directorio **data/Npy_files**  en nuestra máquina local.
___
## **Estructura de carpetas dentro del contenedor**

* **/home/neutrino:** _usuario_.
* **/home/neutrino/software/run.sh:**  _script que ejecuta las variables de entorno_.
* **/home/WatChMal/DataTools/*.py:** _modulos de python_.
* **/home/Tools_HKM/npz_to_image.py:** script para ejecutar proceso **npz a npy**.
* **/home/neutrino/software/WCSim_build :** _ruta donde se guardan por defecto archivos de salida ".root" y ".npy"_
___
## **Maintained by:**
Jesús Manuel Alemán González (Many) (CADS) 

