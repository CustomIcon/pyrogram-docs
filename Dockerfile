FROM python:3.8.5-slim-buster

ENV PIP_NO_CACHE_DIR 1

RUN sed -i.bak 's/us-west-2\.ec2\.//' /etc/apt/sources.list

RUN apt update && apt upgrade -y && \
    apt install --no-install-recommends -y \
    apt-utils \
    build-essential \
    debian-keyring \
    debian-archive-keyring \
    build-essential \
    latexmk \
    openssl \
    git \
    gcc \
    g++ \
    clang \
    make \
    pandoc \
    python3-dev \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp

RUN git clone https://github.com/pyrogram/pyrogram /pyrogram

RUN python -m pip install --upgrade pip

WORKDIR /pyrogram

RUN pip install -r requirements.txt \
    && pip install tgcrypto

RUN python setup.py install --user

RUN cd docs && \
    pip install -r requirements.txt &&\
    cd scripts && \
    python releases.py && \
    cd .. && \
    cd .. && \
    python setup.py generate --docs

WORKDIR /pyrogram/docs/

CMD ["make", "lhtml"]
