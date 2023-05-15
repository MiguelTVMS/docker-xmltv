FROM ubuntu:22.04
LABEL maintainer="João Miguel Tabosa Vaz Marques Silva <joao@miguel.ms>"

ARG APP_FOLDER=/app
ARG XMLTV_FOLDER=/xmltv
ARG CRONTAB_FILE=/etc/cron.d/xmltv

# Environment variables
ENV APP_FOLDER=${APP_FOLDER}
ENV XMLTV_FOLDER=${XMLTV_FOLDER}
ENV XMLTV_CONFIG_FOLDER=${XMLTV_FOLDER}/config
ENV XMLTV_DATA_FOLDER=${XMLTV_FOLDER}/data
ENV CRONTAB_FILE=${CRONTAB_FILE}

# Configurable variables
ENV GRABBER=""
ENV GRABBER_ARGS=""

# Grabber variables
ENV OUTPUT=${XMLTV_DATA_FOLDER}/guide.xml
ENV DAYS=""
ENV OFFSET=""
ENV CONFIG_FILE=${XMLTV_CONFIG_FOLDER}/grabber.conf

RUN apt update && \
    apt upgrade --yes && \
    apt install --yes \
    xmltv \
    && apt clean \
    && apt autoremove --yes

RUN mkdir -p ${APP_FOLDER} && \
    mkdir -p ${XMLTV_CONFIG_FOLDER} && \
    mkdir -p ${XMLTV_DATA_FOLDER}

ADD ./start.sh ${APP_FOLDER}
RUN chmod +x ${APP_FOLDER}/start.sh

CMD ${APP_FOLDER}/start.sh