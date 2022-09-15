FROM nvidia/cuda:10.2-runtime-ubuntu18.04
SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get install -y wget

ENV TERM=xterm

RUN wget -O ifort.sh https://registrationcenter-download.intel.com/akdlm/irc_nas/18703/l_fortran-compiler_p_2022.1.0.134_offline.sh
RUN chmod +x ifort.sh
RUN ./ifort.sh -r yes -a -s --action=install --eula=accept
RUN rm ./ifort.sh

RUN apt-get install -y build-essential python3.8 python3-pip fftw3 libgfortran3 gfortran cpanminus unzip
RUN pip3 install torch mrcfile numpy tqdm

WORKDIR /app

RUN wget http://huanglab.phys.hust.edu.cn/EMBuild/EMBuild_v1.0.tgz
RUN tar xzvf EMBuild_v1.0.tgz && rm EMBuild_v1.0.tgz && mv EMBuild_v1.0/* ./

RUN wget https://www.dsimb.inserm.fr/sword/data/SWORD.tar.gz
RUN tar xzvf SWORD.tar.gz && rm SWORD.tar.gz && mv ./SWORD ./temp && mv ./temp/* ./
RUN cpanm Getopt::Long Error

# install sword and its dependencies
WORKDIR /app/SWORD-deps
RUN wget https://comp.chem.nottingham.ac.uk/parsepdb/ParsePDB.zip
RUN unzip ParsePDB.zip

WORKDIR /app/SWORD-deps/ParsePDB
# not sure if this was ran on a windows machine previously but the file in archive is Makefile.pl but
# the result makefile expects Makefile.PL
RUN mv Makefile.pl Makefile.PL && perl Makefile.PL
RUN make && make install

WORKDIR /app/stride
RUN wget http://webclu.bio.wzw.tum.de/stride/stride.tar.gz
RUN tar xzvf stride.tar.gz && rm stride.tar.gz
RUN make

WORKDIR /app/mcp
RUN f2py -c interp3d.f90 -m interp3d

WORKDIR /app

COPY ./run.sh ./run.sh
RUN chmod +x ./run.sh

ENTRYPOINT [ "./run.sh" ]
