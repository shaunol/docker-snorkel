FROM ubuntu:16.04

## Change from sh to bash
RUN ls -al /bin/sh \
	&& rm /bin/sh \
	&& ln -sf /bin/bash /bin/sh

# ??
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install deps
RUN apt-get update --fix-missing \
  && apt-get install -y unzip build-essential gcc git curl grep dpkg sed vim python wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion postgresql-client postgresql-client-common \
  && curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python

# Install miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh \
  && bash ~/miniconda.sh -b -p /opt/conda

ENV PATH /opt/conda/bin:$PATH

# Install snorkel
RUN cd /opt/ \
  && git clone https://github.com/HazyResearch/snorkel.git \
  && cd snorkel \
  && git checkout tags/v0.6.2 \
  && git submodule update --init --recursive \
  && conda install numba \
  && pip install --requirement python-package-requirement.txt \
  && pip uninstall spacy -y \
  && pip install "spacy==1.10.0" \
  && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
  && ./install-parser.sh

COPY ./jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

WORKDIR /opt/snorkel

COPY ./docker_run.sh ./

EXPOSE 8888

CMD ["./docker_run.sh"]
