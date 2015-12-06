FROM debian:jessie

RUN apt-get update --fix-missing && apt-get install -y \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    ca-certificates busybox gcc wget && \
    busybox --install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV PATH /opt/conda/bin:$PATH
ENV LANG C.UTF-8
ENV MINICONDA Miniconda3-latest-Linux-x86_64.sh
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget -q https://repo.continuum.io/miniconda/$MINICONDA \
            https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip \
            https://raw.githubusercontent.com/Tsutomu-KKE/py3sci/master/notebook.json \
            http://dl.ipafont.ipa.go.jp/IPAexfont/ipaexg00301.zip && \
    bash /$MINICONDA -b -p /opt/conda && \
    conda install -y conda && \
    conda update -y conda && \
    conda install -y matplotlib networkx scikit-learn jupyter blist bokeh \
                  statsmodels ncurses seaborn dask flask markdown sympy && \
    pip install blaze pulp pyjade && \
    unzip -q ipaexg00301.zip && \
    mv /ipaexg00301/ipaexg.ttf /opt/conda/lib/python3.5/site-packages/matplotlib/mpl-data/fonts/ttf/ && \
    unzip -q master.zip && \
    mkdir -p /root/.local/share/jupyter /root/.jupyter/nbconfig && \
    mv notebook.json /root/.jupyter/nbconfig/ && \
    cd IPython-notebook-extensions-master && \
    python setup.py install && \
    rm -rf /$MINICONDA /IPython-notebook-extensions-master /master.zip /ipaexg00301* /opt/conda/pkgs/*
CMD ["/bin/bash"]
