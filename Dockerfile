FROM nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    wget \
    git \
    vim \
    sudo \
    build-essential
WORKDIR /opt

RUN wget https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-x86_64.sh && \
    git clone https://github.com/jwohlwend/boltz.git && \
    sh Mambaforge-24.3.0-0-Linux-x86_64.sh -b -p /opt/Mambaforge && \
    rm -r Mambaforge-24.3.0-0-Linux-x86_64.sh
RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3-$(uname)-$(uname -m).sh  -b -p /opt/Mambaforge && \ # accept all terms and install to the default location
    rm Miniforge3-$(uname)-$(uname -m).sh  && \# (optionally) remove installer after using it
    source ~/.bashrc  # alternatively, one can restart their shell session to achieve the same result


ENV PATH /opt/Mambaforge/bin:$PATH
WORKDIR /opt && \
    git clone https://github.com/BioinfoMachineLearning/FlowDock && \
    cd FlowDock && \
    mamba env create -f environments/flowdock_environment.yaml && \
    conda activate FlowDock && \
    pip3 install -e . && \
    cd checkpoints/ && \
    wget https://zenodo.org/records/10373581/files/neuralplexermodels_downstream_datasets_predictions.zip && \
    unzip neuralplexermodels_downstream_datasets_predictions.zip && \
    rm neuralplexermodels_downstream_datasets_predictions.zip && \
    wget https://zenodo.org/records/14478459/files/flowdock_checkpoints.tar.gz && \
    tar -xzf flowdock_checkpoints.tar.gz && \
    rm flowdock_checkpoints.tar.gz && \
    cd ../
    

RUN mamba create -n boltz python=3.10 -y && \
    conda init
SHELL ["conda", "run", "-n", "boltz", "/bin/bash", "-c"]

RUN touch setup.cfg && \
    conda clean --all -y && \ 
    pip cache purge && \
    pip install -e . && \
    echo "conda activate openfe_env" >> ~/.bashrc

ENV PATH /opt/Mambaforge/envs/boltz/bin:$PATH
#RUN git clone https://github.com/jwohlwend/boltz.git && \
#cd boltz && \
#touch setup.cfg && \
#pip install -e .
