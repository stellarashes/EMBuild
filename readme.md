# Description

Dockerized version of EMBuild at http://huanglab.phys.hust.edu.cn/EMBuild/

# Setup

* Install docker and NVIDIA container toolkit https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
* Install docker-compose (`sudo apt install docker-compose`)
* Create a folder named `data` in this directory, and place input file(s) in it
* Build with `docker-compose build`
* Run with `docker-compose run embuild /data/file` where `file` is the file in the `data` folder from above
* To run more steps, modify `run.sh` and run `docker-compose build`
