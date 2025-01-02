FROM ubuntu:20.04

ARG APP_NAME=django_crm
ENV DEBIAN_FRONTEND=noninteractive

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
    net-tools \
    postgresql-client

RUN useradd -ms /bin/bash ubuntu
USER ubuntu

RUN mkdir -p /home/ubuntu/"$APP_NAME"
WORKDIR /home/ubuntu/"$APP_NAME"

COPY --chown=ubuntu:ubuntu . .
RUN python3 -m venv venv
RUN /bin/bash -c "source venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install gunicorn"

ENV PATH="/home/ubuntu/$APP_NAME/venv/bin:$PATH"
ENV PORT=8000
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

EXPOSE 8000

CMD ["/bin/bash", "-c", ". venv/bin/activate && python manage.py migrate && gunicorn crm.wsgi:application --bind 0.0.0.0:$PORT --timeout 120"]