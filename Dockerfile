FROM python:3.5-slim 

MAINTAINER Roberto Sánchez Ávalos <r.sanchezavalos@gmail.com>

ENV LUIGI_HOME /etc/luigi

RUN apt-get update && \
	apt-get -y update -yq && \
	apt-get -y install build-essential && \
	apt-get -y install poppler-utils && \
	apt-get -y install -yqq ssh git build-essential 

RUN  apt-get -y  install curl

RUN  curl -L \
	 https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m) \
	-o /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

# Docker-machine

RUN curl -L https://github.com/docker/machine/releases/download/v0.9.0/docker-machine-`uname -s`-`uname -m` \
	> /usr/local/bin/docker-machine && \
	chmod +x /usr/local/bin/docker-machine

RUN apt install make

RUN apt-get -y install make  libssl-dev zlib1g-dev libbz2-dev \
	libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
	xz-utils tk-dev virtualenvwrapper

RUN apt-get update && \
	apt-get -y install golang-go && \
	apt-get -y update && \
	apt-get -y install silversearcher-ag python-pip

#RUN git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper

# Install pyenv
# RUN cd &&\
#    git clone git://github.com/yyuu/pyenv.git ~/.pyenv && \
#    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
#    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
#    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
#    echo 'pyenv virtualenvwrapper' >> ~/.bashrc
# RUN /bin/bash -c "source ~/.bashrc"
# RUN /bin/bash -c "exec $SHELL"
# RUN pyenv install 3.5.2

RUN pip install --upgrade pip

# HUB
RUN wget https://github.com/github/hub/releases/download/v2.2.5/hub-linux-amd64-2.2.5.tgz &&\
	tar zvxvf hub-linux-amd64-2.2.5.tgz &&\
	./hub-linux-amd64-2.2.5/install

# Setup autocomplete for zsh:
RUN mkdir -p ~/.zsh/completions && \
	mv ./hub-linux-amd64-2.2.5/etc/hub.zsh_completion ~/.zsh/completions/_hub && \
	echo "fpath=(~/.zsh/completions $fpath)" >> ~/.zshrc && \
	echo "autoload -U compinit && compinit" >> ~/.zshrc

# Add alias
RUN  echo "eval "$(hub alias -s)"" >> ~/.zshrc

# Cleanup
RUN rm -rf hub-linux-amd64-2.2.5


RUN apt-get --yes install libxss1 libappindicator1 libindicator7 

# Core
RUN apt-get update; \
    apt-get update -yq && \
    apt-get install -y build-essential && \
    apt-get install -y poppler-utils && \
    apt-get install -yqq ssh git build-essential

# ADD . /${PROJECT_NAME}/
# WORKDIR /${PROJECT_NAME}
# RUN curl -LOk https://github.com/rsanchezavalos/compranet/archive/master.zip
# RUN unzip master.zip

ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# ENTRYPOINT [ "python", "get_rita.py" ]
# CMD [ "/bin/sh", "-c", "while true; do echo hello world; sleep 1; done"]
# make deploy
