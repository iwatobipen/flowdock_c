FROM nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    wget \
    git \
    vim \
    sudo \
    build-essential
    
WORKDIR /opt


RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    # accept all terms and install to the default location
    bash Miniforge3-$(uname)-$(uname -m).sh  -b -p /opt/Mambaforge && \ 
    # (optionally) remove installer after using it
    rm Miniforge3-$(uname)-$(uname -m).sh  && \
    # alternatively, one can restart their shell session to achieve the same result
    source ~/.bashrc  


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
    cd ../ && \
    wget https://zenodo.org/records/14478459/files/flowdock_checkpoints.tar.gz && \
    tar -xzf flowdock_checkpoints.tar.gz && \
    rm flowdock_checkpoints.tar.gz && \
    # cached input data for training/validation/testing
  　wget "https://mailmissouri-my.sharepoint.com/:u:/g/personal/acmwhb_umsystem_edu/ER1hctIBhDVFjM7YepOI6WcBXNBm4_e6EBjFEHAM1A3y5g?download=1" && \
 　 tar -xzf flowdock_data_cache.tar.gz && \
    rm flowdock_data_cache.tar.gz && \

    # cached data for PDBBind, Binding MOAD, DockGen, and the PDB-based van der Mers (vdM) dataset
    wget https://zenodo.org/records/14478459/files/flowdock_pdbbind_data.tar.gz && \
    tar -xzf flowdock_pdbbind_data.tar.gz && \
    rm flowdock_pdbbind_data.tar.gz && \

    wget https://zenodo.org/records/14478459/files/flowdock_moad_data.tar.gz && \
    tar -xzf flowdock_moad_data.tar.gz && \
    rm flowdock_moad_data.tar.gz && \

   wget https://zenodo.org/records/14478459/files/flowdock_dockgen_data.tar.gz && \
   tar -xzf flowdock_dockgen_data.tar.gz && \
   rm flowdock_dockgen_data.tar.gz && \

   wget https://zenodo.org/records/14478459/files/flowdock_pdbsidechain_data.tar.gz && \
   tar -xzf flowdock_pdbsidechain_data.tar.gz && \
   rm flowdock_pdbsidechain_data.tar.gz
    

SHELL ["conda", "run", "-n", "FlowDock", "/bin/bash", "-c"]

RUN  echo "conda activate FlowDock" >> ~/.bashrc

ENV PATH /opt/Mambaforge/envs/FlowDock/bin:$PATH
#RUN git clone https://github.com/jwohlwend/boltz.git && \
#cd boltz && \
#touch setup.cfg && \
#pip install -e .
