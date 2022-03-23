source "/home/hammy97/miniconda3/etc/profile.d/conda.sh"

# activte the conda snappy env
source conda activate snappy

root_dir="/src/snap/"

SNAPPY_PATH="/home/hammy97/miniconda3/envs/snappy/bin/python"

# install module 'jpy' (A bi-directional Python-Java bridge)
if [ ! -d "${root_dir}/jpy"] 
then
  git clone https://github.com/bcdev/jpy.git /src/snap/jpy
  pip install --upgrade pip wheel
  (cd /src/snap/jpy && python setup.py bdist_wheel)
  # hack because ./snappy-conf will create this dir but also needs *.whl files...
  mkdir -p /root/.snap/snap-python/snappy
  cp /src/snap/jpy/dist/*.whl "/root/.snap/snap-python/snappy"
fi

if [ ! -f "/src/snap/response.varfile"]
then
  cp ./response.varfile $root_dir
fi