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

# Intall NEMO (in the current directory) and Gunicorn
COPY . /nemo/


RUN pip install /nemo/ gunicorn

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update


RUN ACCEPT_EULA=Y apt-get -y install msodbcsql17

RUN apt-get -y install unixodbc-dev

RUN pip install --user pyodbc
RUN pip install django-pyodbc-azure


RUN rm --recursive --force /nemo/

RUN mkdir /nemo
ENV DJANGO_SETTINGS_MODULE "settings"
ENV PYTHONPATH "/nemo/"

EXPOSE 8000/tcp

RUN apt-get update && apt-get install -y dos2unix

COPY start_NEMO_in_Docker.sh /usr/local/bin/
RUN dos2unix /usr/local/bin/start_NEMO_in_Docker.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN chmod +x /usr/local/bin/start_NEMO_in_Docker.sh

CMD ["start_NEMO_in_Docker.sh"]
