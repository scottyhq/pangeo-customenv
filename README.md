# pangeo-customenv

use this template repository to build a custom environment for pangeo dask workers

this uses the Repo2Docker Github Action to push an image to DockerHub that you can use with dask-gateway
https://github.com/jupyterhub/repo2docker-action#push-repo2docker-image-to-dockerhub

1. add your DockerHub username and password as [repository secrets](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository). For your DOCKER_PASSWORD you should create an access token rather than using your sign-in password: https://www.docker.com/blog/docker-hub-new-personal-access-tokens/
```
DOCKER_USERNAME=xxxxx
DOCKER_PASSWORD=xxxxx
```

1. check which pangeo-dask package is installed in your notebook environment
`conda list | grep pangeo-dask`
# pangeo-dask               2020.10.08                    0    conda-forge

1. modify [environment.yml](environment.yml) to include the same version of pangeo-dask and other packages you need

1. a new image will be built via GitHub Actions and pushed to your DockerHub accont
