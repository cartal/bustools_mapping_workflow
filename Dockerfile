FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system libraries required for python and R installations
RUN apt-get update && apt-get install -y build-essential \
                                         apt-utils \
                                         ca-certificates \
                                         gfortran \
                                         locales \
                                         libtool \
                                         bison \
                                         byacc \
                                         flex \
                                         zlib1g-dev \
                                         libxml2-dev \
                                         libcurl4-gnutls-dev \
                                         libssl-dev \
                                         libgsl-dev \
                                         libzmq3-dev \
                                         libreadline6-dev \
                                         xorg-dev \
                                         libcairo-dev \
                                         libpango1.0-dev \
                                         libbz2-dev \
                                         liblzma-dev \
                                         libffi-dev \
                                         libsqlite3-dev \
                                         libhdf5-dev \
                                         libgit2-dev \
                                         nodejs \
                                         npm

# Install common linux tools
RUN apt-get update && apt-get install -y --no-install-recommends wget \
                                                                 curl \
                                                                 vim \
                                                                 git

# Create some basic directories for binding ICB storages
RUN mkdir -p /storage/groups/ /storage/scratch/

# Download & Install SRA toolkit for fasterq-dump
WORKDIR /opt
RUN wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz
RUN tar -vxzf sratoolkit.tar.gz
RUN rm sratoolkit.tar.gz
ENV PATH="/opt/sratoolkit.3.0.0-ubuntu64/bin:${PATH}"
RUN which fastq-dump

# Configure default locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

# Download and compile python from source
WORKDIR /opt/python
RUN wget https://www.python.org/ftp/python/3.7.7/Python-3.7.7.tgz
RUN tar zxfv Python-3.7.7.tgz && rm Python-3.7.7.tgz
WORKDIR /opt/python/Python-3.7.7
RUN ./configure --enable-optimizations --with-lto --prefix=/opt/python/
RUN make && make install

# Create softlinks for python and add it to PATH
WORKDIR /opt/python
RUN rm -rf /opt/python/Python-3.7.7
RUN ln -s /opt/python/bin/python3 /opt/python/bin/python
RUN ln -s /opt/python/bin/pip3 /opt/python/bin/pip
RUN echo ${PATH}
ENV PATH="/opt/python/bin:${PATH}"

# Install python packages
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -U kb-python==0.27.1

# Copy environment file (for Charliecloud)
COPY environment /environment

RUN apt-get clean -y && apt-get autoremove -y