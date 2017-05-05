FROM nimbix/ubuntu-cuda-ppc64le:latest

# Notebook Common
ADD https://raw.githubusercontent.com/nimbix/notebook-common/master/install-ubuntu.sh /tmp/install-ubuntu.sh
RUN \
  bash /tmp/install-ubuntu.sh 3 && \
  rm -f /tmp/install-ubuntu.sh

# Install H2o
RUN \
  wget --quiet http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
  wget --quiet --no-check-certificate -i latest -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
  cp h2o.jar /opt

ADD scripts/start-h2o3.sh /opt/start-h2o3.sh

ADD NAE/screenshot.png /etc/NAE/screenshot.png
ADD NAE/AppDef.json /etc/NAE/AppDef.json
