FROM python:3.9.1-slim-buster

ENV PIP_NO_CACHE_DIR 1

RUN sed -i.bak 's/us-west-2\.ec2\.//' /etc/apt/sources.list

RUN apt update && apt upgrade -y && \
    pandoc \
    latexmk \
    openssh \
    git \
    gcc \
    g++ \
    clang \
    make \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp

RUN git clone https://github.com/pyrogram/pyrogram /app

WORKDIR /app

RUN pip install -r requirements.txt \
    && pip install tgcrypto && \
    cd docs && \
    pip install -r requirements.txt

RUN cd scripts && python releases.py && cd .. && cd .. && python setup.py generate --docs

CMD ["docs/make", "lhtml"]
