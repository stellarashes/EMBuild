FROM nvidia/cuda:10.2-runtime-ubuntu18.04
SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get install -y wget

ENV TERM=xterm

RUN wget -O ifort.sh https://registrationcenter-download.intel.com/akdlm/irc_nas/18703/l_fortran-compiler_p_2022.1.0.134_offline.sh
RUN chmod +x ifort.sh
RUN ./ifort.sh -r yes -a -s --action=install --eula=accept
RUN rm ./ifort.sh

WORKDIR /app

RUN wget http://huanglab.phys.hust.edu.cn/EMBuild/EMBuild_v1.0.tgz
RUN tar xzvf EMBuild_v1.0.tgz && rm MBuild_v1.0.tgz
RUN ulimit -s 1048576

RUN apt-get install -y python3.8 python3-pip fftw3 libgfortran3 gfortran
RUN pip3 install torch mrcfile numpy tqdm

WORKDIR /app/EMBuild_v1.0/mcp
RUN f2py -c interp3d.f90 -m interp3d

WORKDIR /app

COPY ./run.sh ./run.sh
RUN chmod +x ./run.sh

ENTRYPOINT [ "./run.sh" ]
