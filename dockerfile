FROM armhf/ubuntu

COPY qemu-arm-static /usr/bin/
RUN apt-get -y update && \
	apt-get install -y dialog apt-utils &&\
	apt-get install -y unzip software-properties-common python-software-properties && \
	add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
	apt-get -y update && \
	apt-get -y upgrade

RUN apt-get install -y gcc-7 g++-7 && \
	apt-get install -y wget

#RUN curl -C - -LR#OH "Cookie: oraclelicense=accept-securebackup-cookie" -k \
  #"http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-arm32-vfp-hflt.tar.gz"

COPY jdk-8u171-linux-arm32-vfp-hflt.tar.gz .

RUN mkdir /usr/java \
  && tar -vxzf jdk-8u171-linux-arm32-vfp-hflt.tar.gz -C /usr/java/ \
  && rm jdk-8u171-linux-arm32-vfp-hflt.tar.gz \
  && update-alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_171/bin/java 100 \ 
  && update-alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_171/bin/javac 100

#RUN wget https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel-0.15.0-dist.zip &&\
#	mkdir bazel && \
#	unzip bazel-0.15.0-dist.zip -d bazel/

RUN apt-get install -y unzip && \
	mkdir bazel
COPY bazel-0.15.0-dist.zip /
RUN unzip bazel-0.15.0-dist.zip -d bazel/

COPY compile.sh bazel/scripts/bootstrap/

RUN './bazel/compile.sh'
