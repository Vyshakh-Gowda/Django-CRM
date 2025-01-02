FROM ubuntu:20.04

# Invalidate cache and set a default value for APP_NAME
ARG APP_NAME=myapp

# Test ARG
RUN test -n "$APP_NAME"

# Install system packages
RUN apt-get update -y
RUN apt-get install -y \
  python3-pip \
  python3-venv \
  build-essential \
  libpq-dev \
  libmariadbclient-dev \
  libjpeg62-dev \
  zlib1g-dev \
  libwebp-dev \
  curl \
  vim \
  net-tools

# Setup user
RUN useradd -ms /bin/bash ubuntu
USER ubuntu

# Install app
RUN mkdir -p /home/ubuntu/"$APP_NAME"/"$APP_NAME"
WORKDIR /home/ubuntu/"$APP_NAME"/"$APP_NAME"
COPY . .
RUN python3 -m venv ../venv
RUN . ../venv/bin/activate
RUN /home/ubuntu/"$APP_NAME"/venv/bin/pip install -U pip
RUN /home/ubuntu/"$APP_NAME"/venv/bin/pip install -r requirements.txt
RUN /home/ubuntu/"$APP_NAME"/venv/bin/pip install gunicorn

# Setup path
ENV PATH="${PATH}:/home/ubuntu/$APP_NAME/$APP_NAME/scripts"

USER ubuntu
