FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

RUN apt-get install -y git

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

COPY ./clipspy /app/clipspy

WORKDIR /app

RUN pip install -r requirements.txt

RUN cd clipspy && \
    make install

COPY . /app

ENTRYPOINT [ "gunicorn" ]

CMD [ "app:app" ]