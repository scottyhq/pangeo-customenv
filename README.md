# pangeo-customenv

use this template repository to build a custom environment for pangeo dask workers

this uses the Repo2Docker Github Action to push an image to DockerHub that you can use with dask-gateway
https://github.com/jupyterhub/repo2docker-action#push-repo2docker-image-to-dockerhub

    
1. add your DockerHub username and password as [repository secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository). For your DOCKER_PASSWORD you should create an access token rather than using your sign-in password: https://www.docker.com/blog/docker-hub-new-personal-access-tokens/
   ```
   DOCKER_USERNAME=xxxxx
   DOCKER_PASSWORD=xxxxx
   ```

1. check which Docker image tag is being used on the hub currently and make sure it matches the tag in this repo [Dockerfile](Dockerfile). Add a RUN command to install extra packages
    * AWS: https://github.com/pangeo-data/pangeo-cloud-federation/blob/prod/deployments/icesat2/image/binder/Dockerfile
    * GCP: https://github.com/pangeo-data/pangeo-cloud-federation/blob/prod/deployments/gcp-uscentral1b/image/binder/Dockerfile
   ```
   FROM pangeo/pangeo-notebook:2020.10.27
   RUN conda install -y -c conda-forge parcels
   ```

1. check which pangeo-dask package is installed in your notebook environment `conda list | grep pangeo-dask`
   ```
   pangeo-dask               2020.10.08                    0    conda-forge
   ```

1. modify [environment.yml](environment.yml) to include the same version of pangeo-dask (2020.10.08 following example above) and other packages you need, it will look something like this:    
   ```
   name: notebook
   channels:
     - conda-forge
   dependencies:
     - python=3.8*
     - pangeo-dask=2020.10.08
     - parcels
     - xarray
   ```

1. a new image will be built via GitHub Actions and pushed to your DockerHub account with the following name:
   ```
   DOCKER_USERNAME/pangeo-customenv:COMMIT_SHA
   ```

1. specify your custom image name from the last step when configuring a [dask gateway cluster](https://gateway.dask.org/usage.html#configure-a-cluster). For example, with this repository:
   ```python
   from dask_gateway import Gateway
   gateway = Gateway()
   options = gateway.cluster_options()
   options.image = 'scottyhq/pangeo-customenv:6a50eda562eb'
   cluster = gateway.new_cluster(options)
   ```


### Troubleshooting:
You might see warnings like:
```
/srv/conda/envs/notebook/lib/python3.8/site-packages/distributed/client.py:1129: VersionMismatchWarning: Mismatched versions found

+---------+--------+-----------+---------+
| Package | client | scheduler | workers |
+---------+--------+-----------+---------+
| blosc   | 1.9.2  | None      | None    |
| lz4     | 3.1.0  | None      | None    |
| numpy   | 1.19.2 | 1.19.4    | 1.19.4  |
| tornado | 6.0.4  | 6.1       | 6.1     |
+---------+--------+-----------+---------+
  warnings.warn(version_module.VersionMismatchWarning(msg[0]["warning"]))
```
If you're using those packages consider pinning the version numbers for 'client' in the environment.yml file in this repository

