FROM ubuntu:18.04
ARG INSTALLPATH=/root
EXPOSE 8000

RUN apt-get update
RUN apt-get install -y \
        python2.7 \
        python-pip \
        python-virtualenv \
        python-dev \
        graphviz \
        git \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev
RUN pip install --upgrade pip setuptools virtualenv

WORKDIR ${INSTALLPATH}
RUN git clone https://github.com/CiscoDevNet/ydk-py.git -b yam
WORKDIR ydk-py/core
RUN python setup.py sdist
RUN pip install dist/ydk*.gz
WORKDIR ../ietf
RUN python setup.py sdist
RUN pip install dist/ydk*.gz
WORKDIR ../openconfig
RUN python setup.py sdist
RUN pip install dist/ydk*.gz
WORKDIR ../cisco-ios-xr
RUN python setup.py sdist
RUN pip install dist/ydk*.gz

WORKDIR ${INSTALLPATH}
RUN git clone https://github.com/rdkls/yang-explorer.git
#RUN git clone https://github.com/CiscoDevNet/yang-explorer.git
WORKDIR yang-explorer
RUN virtualenv v
RUN . v/bin/activate
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

WORKDIR ${INSTALLPATH}/yang-explorer/server
RUN mkdir -p data/users
RUN mkdir -p data/session
RUN mkdir -p data/collections
RUN mkdir -p data/annotation
RUN python manage.py migrate
RUN python manage.py setupdb
CMD python manage.py runserver 0.0.0.0:8000
