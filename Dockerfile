FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git python3
ENV PYTHONIOENCODING=UTF-8

RUN apt-get install -y hugo

RUN apt-get autoremove -y
