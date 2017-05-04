FROM ppc64le/ubuntu:16.04
MAINTAINER Nimbix, Inc.

ENV DEBIAN_FRONTEND noninteractive
ADD https://github.com/nimbix/image-common/archive/master.zip /tmp/nimbix.zip
WORKDIR /tmp
RUN apt-get update && apt-get -y install zip unzip openssh-server ssh infiniband-diags perftest libibverbs-dev libmlx4-dev libmlx5-dev sudo iptables curl wget vim python && apt-get clean
RUN unzip nimbix.zip && rm -f nimbix.zip
RUN /tmp/image-common-master/setup-nimbix.sh

WORKDIR /tmp
ENV CUDA_REPO_URL http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/ppc64el/cuda-repo-ubuntu1604_8.0.61-1_ppc64el.deb
ENV NVML_REPO_URL http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/ppc64el/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_ppc64el.deb
RUN curl -O ${CUDA_REPO_URL} && dpkg --install *.deb && rm -rf *.deb
RUN curl -O ${NVML_REPO_URL} && dpkg --install *.deb && rm -rf *.deb
RUN apt-get update && apt-get -y install cuda-toolkit-8-0 libcudnn5-dev libcudnn6-dev && apt-get clean
ENV CUDA_REPO_URL ""
ENV NVML_REPO_URL ""

# Hack to allow builds in Docker container
# XXX: this should be okay even if the host driver is rev'd, since the JARVICE
# runtime actually binds in the host version anyway
WORKDIR /tmp
RUN apt-get download nvidia-361 && dpkg --unpack nvidia-361*.deb && rm -f nvidia-361*.deb && rm -f /var/lib/dpkg/info/nvidia-361*.postinst
RUN apt-get -yf install && apt-get clean && ldconfig -f /usr/lib/nvidia-361/ld.so.conf

# Nimbix JARVICE emulation
EXPOSE 22
RUN mkdir -p /usr/lib/JARVICE && cp -a /tmp/image-common-master/tools /usr/lib/JARVICE
RUN ln -s /usr/lib/JARVICE/tools/noVNC/images/favicon.png /usr/lib/JARVICE/tools/noVNC/favicon.png && ln -s /usr/lib/JARVICE/tools/noVNC/images/favicon.png /usr/lib/JARVICE/tools/noVNC/favicon.ico
WORKDIR /usr/lib/JARVICE/tools/noVNC/utils
RUN ln -s websockify /usr/lib/JARVICE/tools/noVNC/utils/websockify.py && ln -s websockify /usr/lib/JARVICE/tools/noVNC/utils/wsproxy.py
WORKDIR /tmp
RUN cp -a /tmp/image-common-master/etc /etc/JARVICE && chmod 755 /etc/JARVICE && rm -rf /tmp/image-common-master
RUN mkdir -m 0755 /data && chown nimbix:nimbix /data



# for building CUDA code later
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64/stubs
