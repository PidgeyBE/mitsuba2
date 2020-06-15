FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
        apt-get install -y curl libglib2.0-0 libsm6 libxext6 libxrender1 \
        libfontconfig1 mysql-client netcat s3cmd git gcc python3-dev rsync screen \
        clang-9 libc++-9-dev libc++abi-9-dev cmake ninja-build \
        libz-dev libpng-dev libjpeg-dev libxrandr-dev libxinerama-dev libxcursor-dev \
        python3-distutils python3-setuptools && rm -rf /var/lib/apt/lists/*

WORKDIR /app
#COPY environment.yml environment.yml
COPY NVIDIA-OptiX-SDK-7.0.0-linux64.sh NVIDIA-OptiX-SDK-7.0.0-linux64.sh
# using latest to make sure this one is always available
SHELL ["/bin/bash", "-c"]
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /app/miniconda3
ENV PATH /app/miniconda3/bin:$PATH
# update conda to its latest version anyways
RUN conda update -n base -c defaults conda
RUN conda create -n mitsuba2 python=3.6 jupyterlab
# initialize the bash shell for later use
RUN conda init bash
# add wheels for pytorch and tensorflow
# This command means: all next occurences of RUN in this Dockerfile use core conda env
SHELL ["conda", "run", "-n", "mitsuba2", "/bin/bash", "-c"]
RUN pip install jupyterlab

# Install optix7
RUN chmod +x NVIDIA-OptiX-SDK-7.0.0-linux64.sh && ./NVIDIA-OptiX-SDK-7.0.0-linux64.sh

# Mitsuba2 Build
RUN git clone --recursive https://github.com/mitsuba-renderer/mitsuba2 && cd mitsuba2 && git submodule update --init --recursive
WORKDIR /app/mitsuba2
RUN cp resources/mitsuba.conf.template mitsuba.conf
# Set Mitsuba flavours
RUN sed -i '0,/"scalar_spectral"/s//"scalar_spectral", "gpu_autodiff_mono", "gpu_autodiff_rgb"/' mitsuba.conf

# BUILD
RUN export CC=clang-9 && export CXX=clang++-9 && mkdir build && cd build && \
    cmake -GNinja ..-DCMAKE_CUDA_COMPILER=/usr/local/cuda/bin/nvcc && \
    ninja

RUN source setpath.sh

CMD ["/bin/bash", "-c", "eval \"$(conda shell.bash hook)\" && conda activate mitsuba2 && jupyter lab --ip=0.0.0.0 --allow-root --NotebookApp.token='' --no-browser"]