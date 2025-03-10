FROM ubuntu

RUN apt-get update && apt-get install -y curl \
                                         unzip \
                                         openssh-server \ 
                                         ca-certificates

ENV TERM=xterm

RUN /bin/bash -c "curl -fsSL https://fnm.vercel.app/install" | bash && \
    export PATH="/root/.local/share/fnm:$PATH" && \
    fnm install 22

RUN /bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.3)"


RUN mkdir /deploy

COPY . /laravel_app

WORKDIR /laravel_app