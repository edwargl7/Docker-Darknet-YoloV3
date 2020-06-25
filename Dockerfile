FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04

RUN apt-get update && apt-get upgrade -y

# Instalar dependencias requeridas por OpenCV
RUN apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        pkg-config \
        libgtk-3-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libxvidcore-dev \
        libx264-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        gfortran \
        openexr \
        libatlas-base-dev \
        python3-dev \
        python3-numpy \
        libtbb2 \
        libtbb-dev \
        libdc1394-22-dev

# Otros paquetes necesarios
RUN apt-get install -y \
        vim \
        wget \

WORKDIR /opt
RUN wget https://github.com/opencv/opencv_contrib/archive/3.4.0.tar.gz --no-check-certificate && tar -xf 3.4.0.tar.gz && rm 3.4.0.tar.gz
RUN wget https://github.com/opencv/opencv/archive/3.4.0.tar.gz --no-check-certificate && tar -xf 3.4.0.tar.gz && rm 3.4.0.tar.gz

WORKDIR opencv-3.4.0
RUN mkdir build && cd build && \
        cmake 	-D CMAKE_BUILD_TYPE=RELEASE \
                -D BUILD_NEW_PYTHON_SUPPORT=ON \
                -D CMAKE_INSTALL_PREFIX=/usr/local \
                -D INSTALL_C_EXAMPLES=OFF \
                -D INSTALL_PYTHON_EXAMPLES=OFF \
                -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-3.4.0/modules \
                -D BUILD_EXAMPLES=OFF /opt/opencv-3.4.0 && \
        make -j8 && \
        make install && \
        ldconfig && \
        rm -rf /opt/opencv*

WORKDIR /
RUN wget https://github.com/AlexeyAB/darknet/archive/darknet_yolo_v3_optimal.tar.gz --no-check-certificate && \
        tar -xf darknet_yolo_v3_optimal.tar.gz && \
        rm darknet_yolo_v3_optimal.tar.gz && \
        mv ./darknet-darknet_yolo_v3_optimal ./darknet
WORKDIR /darknet
RUN mkdir build-release && cd build-release && \
        cmake .. && \
        make && \
        make install

CMD ["/bin/bash"]