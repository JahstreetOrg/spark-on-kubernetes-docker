# https://github.com/jupyter-incubator/sparkmagic/tree/0.12.6
# FROM jupyter/base-notebook:ae885c0a6226 <-- old

FROM jupyter/base-notebook:87210526f381

USER root

# This is needed because requests-kerberos fails to install on debian due to missing linux headers
RUN conda install requests-kerberos -y

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

USER root
RUN chown $NB_USER /home/$NB_USER/.sparkmagic/config.json

COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/
COPY Dockerfile.base-notebook /my_docker/
RUN chmod +x /opt/*.sh && \
    mkdir -p /home/$NB_USER/notebooks && \
    chmod -R 777 /home/$NB_USER/notebooks

ENTRYPOINT [ "/opt/entrypoint.sh" ]

USER $NB_USER