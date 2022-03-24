#!bin/bash

# check is snap is installed
if [ -d "/usr/local/snap/bin/snap" ]; then
  echo "SNAP-ESA already installed exiting ...."
  exit
fi

SNAPVER=8

java_max_mem=10G

# set JAVA_HOME for the shell sessions
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64


# SET the user name
USERNAME=wetlands
CONDA_VERSION=anaconda3
download_dir=/src/snap

# Python conda path
SNAPPY_PATH="/home/${USERNAME}/${CONDA_VERSION}/envs/snappy/bin/python"

# source conda
source "/home/${USERNAME}/${CONDA_VERSION}/etc/profile.d/conda.sh"

# ~~~ START SETUP
if [ ! -d "${download_dir}/jpy" ]
then
  git clone https://github.com/bcdev/jpy.git /src/snap/jpy
  pip install --upgrade pip wheel
  (cd /src/snap/jpy && python setup.py bdist_wheel)
  # hack because ./snappy-conf will create this dir but also needs *.whl files...
  mkdir -p "/home/${USERNAME}/.snap/snap-python/snappy"
  cp /src/snap/jpy/dist/*.whl "/home/${USERNAME}/.snap/snap-python/snappy"
fi

# move the conf file to target
if [ ! -f "${download_dir}/response.varfile" ]; then
  cp ./response.varfile $download_dir
fi

if [ ! -d "/usr/local/snap" ]; then
  # install and update snap
  wget -q -O /src/snap/esa-snap_all_unix_${SNAPVER}_0.sh \
    "http://step.esa.int/downloads/${SNAPVER}.0/installers/esa-snap_all_unix_${SNAPVER}_0.sh"
  sh /src/snap/esa-snap_all_unix_${SNAPVER}_0.sh -q -varfile /src/snap/response.varfile

  # Current workaround for "commands hang after they are actually executed":  https://senbox.atlassian.net/wiki/spaces/SNAP/pages/30539785/Update+SNAP+from+the+command+line
  # /usr/local/snap/bin/snap --nosplash --nogui --modules --update-all
  /usr/local/snap/bin/snap --nosplash --nogui --modules --update-all 2>&1 | while read -r line; do
    echo "$line"
    [ "$line" = "updates=0" ] && sleep 2 && pkill -TERM -f "snap/jre/bin/java"
  done

  # create snappy and python binding with snappy
  /usr/local/snap/bin/snappy-conf $SNAPPY_PATH
  (cd /root/.snap/snap-python/snappy && python setup.py install)
 
  # increase the JAVA VM size to avoid NullPointer exception in Snappy during S-1 processing
  (cd /root/.snap/snap-python/snappy && sed -i "s/^java_max_mem:.*/java_max_mem: $java_max_mem/" snappy.ini)
  
  # Test python installation
  python -c 'form snappy import ProductIO' 

  # TODO pipe out path var to basrc or zshrc
