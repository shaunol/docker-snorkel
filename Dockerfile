FROM ubuntu:16.04

## Change from sh to bash
RUN ls -al /bin/sh \
	&& rm /bin/sh \
	&& ln -sf /bin/bash /bin/sh

# ??
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install deps
RUN apt-get update --fix-missing \
  && apt-get install -y unzip build-essential gcc git curl grep dpkg sed vim python wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 mercurial subversion  \
  && curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python \
  && pip install psycopg2

# Install miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh \
  && bash ~/miniconda.sh -b -p /opt/conda

ENV PATH /opt/conda/bin:$PATH

# Install snorkel
RUN cd /opt/ \
  && git clone https://github.com/HazyResearch/snorkel.git \
  && cd snorkel \
  && git checkout tags/v0.6.2 \
  && conda install numba \
  && pip install --requirement python-package-requirement.txt \
  && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
  && ./set_env.sh \
  && cd "$SNORKELHOME" \
  && git submodule update --init --recursive \
  && ./install-parser.sh

EXPOSE 8888

ENTRYPOINT jupyter notebook --ip=0.0.0.0 --allow-root