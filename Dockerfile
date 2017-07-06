FROM nimbix/ubuntu-cuda-ppc64le:latest

# Notebook Common
ADD https://raw.githubusercontent.com/nimbix/notebook-common/master/install-ubuntu.sh /tmp/install-ubuntu.sh
RUN \
  bash /tmp/install-ubuntu.sh 3 && \
  rm -f /tmp/install-ubuntu.sh

# Install H2o
RUN \
  wget --quiet --no-check-certificate http://h2o-release.s3.amazonaws.com/h2o/rel-vajda/3/h2o-3.10.5.3.zip -O /opt/h2o-latest.zip && \
  unzip -d /opt /opt/h2o-latest.zip && \
  rm /opt/h2o-latest.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
  cp h2o.jar /opt

# Install R Dependancies
RUN \  
  apt-get update && \
  apt-get install -y \
    apt-utils \
    software-properties-common \
    python-software-properties

# Install Python Dependancies
RUN \
  /usr/bin/pip3 install --upgrade pip && \
  apt-get install -y \
    python3-pandas \
    python3-numpy \
    python3-matplotlib \
    python3-sklearn && \
  cd /opt && \
  /usr/bin/pip3 install `find . -name "*.whl"` && \
  apt-get clean && \
  rm -rf /var/cache/apt/*

# Add start script
ADD scripts/start-h2o3.sh /opt/start-h2o3.sh
ADD scripts/start-notebook.sh /opt/start-notebook.sh

# Set executable on scripts
RUN \
  chown -R nimbix:nimbix /opt && \
  chmod +x /opt/start-h2o3.sh

ADD NAE/screenshot.png /etc/NAE/screenshot.png
ADD NAE/AppDef.json /etc/NAE/AppDef.json
