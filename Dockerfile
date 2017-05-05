FROM nimbix/ubuntu-cuda-ppc64le:latest

ADD url.txt /etc/NAE/url.txt
ADD screenshot.png /etc/NAE/screenshot.png
ADD help.html /etc/NAE/help.html
ADD AppDef.json /etc/NAE/AppDef.json
RUN wget --post-file=/etc/NAE/AppDef.json --no-verbose https://api.jarvice.com/jarvice/validate -O -
ADD scripts/start-h2o3.sh /opt/start-h2o3.sh
ADD scripts/start-cluster.sh /opt/start-cluster.sh
ADD scripts/sssh /opt/sssh

# Install H2o
RUN \
  wget -quiet http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
  wget -quiet --no-check-certificate -i latest -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
  cp h2o.jar /opt

