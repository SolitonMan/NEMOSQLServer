#FROM python:3.6
FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y libssl1.0.0 libssl-dev
RUN apt-get install -y curl

RUN apt-get install -y -q python3-pip python3-dev python3-django

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN pip3 install --upgrade pip
#ENTRYPOINT ["python3"]

# Intall NEMO (in the current directory) and Gunicorn
COPY . /nemo/

#RUN pip install --upgrade pip

RUN pip install /nemo/ gunicorn

#RUN ln -s /usr/lib/apt/methods/http /usr/lib/apt/methods/https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
#RUN curl http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb > /tmp/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb

RUN apt-get update

#RUN dpkg -i /nemo/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb

RUN ACCEPT_EULA=Y apt-get -y install msodbcsql17
#RUN ACCEPT_EULA=Y apt-get -y install mssql-tools
#RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
#RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

#RUN apt-get install g++
RUN apt-get -y install unixodbc-dev

RUN pip install --user pyodbc
RUN pip install django-pyodbc-azure

#RUN dpkg -i /nemo/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb

RUN rm --recursive --force /nemo/

RUN mkdir /nemo
ENV DJANGO_SETTINGS_MODULE "settings"
ENV PYTHONPATH "/nemo/"

EXPOSE 8000/tcp

RUN apt-get update && apt-get install -y dos2unix

COPY start_NEMO_in_Docker.sh /usr/local/bin/
RUN dos2unix /usr/local/bin/start_NEMO_in_Docker.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN chmod +x /usr/local/bin/start_NEMO_in_Docker.sh

#RUN chmod -R 777 /opt

CMD ["start_NEMO_in_Docker.sh"]
