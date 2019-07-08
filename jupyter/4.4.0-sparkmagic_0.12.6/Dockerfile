# https://github.com/jupyter-incubator/sparkmagic/tree/0.12.6
# https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile

FROM jupyter/base-notebook:ae5f7e104dd5

USER root

# This is needed because requests-kerberos fails to install on debian due to missing linux headers
RUN conda install requests-kerberos -y

RUN apt-get update && apt-get install --yes \
    git && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

RUN pip install --upgrade pip
RUN pip install --upgrade --ignore-installed setuptools

RUN pip install sparkmagic

RUN mkdir /home/$NB_USER/.sparkmagic
COPY sparkmagic/example_config.json /home/$NB_USER/.sparkmagic/config.json

RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkkernel
RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pysparkkernel
RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pyspark3kernel
RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkrkernel
RUN jupyter serverextension enable --py sparkmagic

RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix
# Uncomment the line below to make nbgitpuller default to start up in JupyterLab
#ENV NBGITPULLER_APP=lab

USER root
RUN chown $NB_USER /home/$NB_USER/.sparkmagic/config.json

COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/
COPY Dockerfile.base-notebook /my_docker/
RUN chmod +x /opt/*.sh && \
    mkdir -p /home/$NB_USER/notebooks && \
    chmod -R 777 /home/$NB_USER/notebooks

ENTRYPOINT ["tini", "-g", "--"]
CMD [ "/opt/entrypoint.sh" ]

USER $NB_USER