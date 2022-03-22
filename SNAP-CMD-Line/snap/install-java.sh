#!bin\bash

sudo apt install -y open-jdk-11-jdk

# set java home to path
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# add java to path
export PATH=$PATH:$JAVA_HOME/bin

# Insall maven
sudo apt update
sudo apt install -y maven

