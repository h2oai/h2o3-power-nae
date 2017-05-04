#!/bin/bash

cp /etc/JARVICE/nodes /opt/flatfile.txt
sed -e 's/$/:54321/' -i /opt/flatfile.txt
