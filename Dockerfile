FROM pangeo/pangeo-notebook:2020.10.27

RUN /srv/conda/condabin/conda install -n notebook -c conda-forge parcels
