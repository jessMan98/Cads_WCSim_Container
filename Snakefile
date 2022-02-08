CORRIDA = range(0,2)

singularity: 'library://many33/default/wcsim:1.2'


rule all:
  input:
    expand('/home/many/SNAKEMAKE/event_dump/IWCDgrid_varyR_mu-_200MeV_1000evts_{l_corrida}.npz', l_corrida=CORRIDA),
    expand('/home/many/SNAKEMAKE/NPZ_to_image/IMAGES_IWCDgrid_varyR_mu-_200MeV_1000evts_{l_corrida}.npy', l_corrida=CORRIDA)

rule ROOT_to_event_dump:
  input:
    '/home/many/SNAKEMAKE/event_dump/IWCDgrid_varyR_mu-_200MeV_1000evts_{l_corrida}.npz'
                                    
  output:
    '/home/many/SNAKEMAKE/NPZ_to_image/IMAGES_IWCDgrid_varyR_mu-_200MeV_1000evts_{l_corrida}.npy'
  
  message: 'Generando archivo {output} ....'

  params:
    i = '/home/shared-folder/event_dump/IWCDgrid_varyR_mu-_200MeV_1000evts_{l_corrida}.npz',
    o = '/home/shared-folder/NPZ_to_image/IMAGES_IWCDgrid_varyR_mu-_200MeV_1000evts_{l_corrida}.npy'

  shell:
    """
      echo "Funcionando"
      python3 /home/Tools_HKM/npz_to_image.py -m /home/shared-folder/Geometry/IWCD_geometry_mPMT.npy -f {params.i}; mv ~/*.npy {params.o} 
    
    """
