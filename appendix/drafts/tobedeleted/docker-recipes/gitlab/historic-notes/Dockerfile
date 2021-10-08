FROM ruby:2.5.1
MAINTAINER James Zhan

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.163.com/debian stretch main" | tee -a /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian-security stretch/updates main" | tee -a /etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian stretch-updates main" | tee -a /etc/apt/sources.list

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get install -yq --no-install-recommends apt-utils \
    ca-certificates \
    openssh-server \
    wget \
    apt-transport-https \
    vim \
    nano \
    gnupg2 \
    apache2-utils \
    cmake \
    supervisor \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.10.3

RUN set -eux; \
	\
# this "case" statement is generated via "update.sh"
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		amd64) goRelArch='linux-amd64'; goRelSha256='fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035' ;; \
		armhf) goRelArch='linux-armv6l'; goRelSha256='d3df3fa3d153e81041af24f31a82f86a21cb7b92c1b5552fb621bad0320f06b6' ;; \
		arm64) goRelArch='linux-arm64'; goRelSha256='355128a05b456c9e68792143801ad18e0431510a53857f640f7b30ba92624ed2' ;; \
		i386) goRelArch='linux-386'; goRelSha256='3d5fe1932c904a01acb13dae07a5835bffafef38bef9e5a05450c52948ebdeb4' ;; \
		ppc64el) goRelArch='linux-ppc64le'; goRelSha256='f3640b2f0990a9617c937775f669ee18f10a82e424e5f87a8ce794a6407b8347' ;; \
		s390x) goRelArch='linux-s390x'; goRelSha256='34385f64651f82fbc11dc43bdc410c2abda237bdef87f3a430d35a508ec3ce0d' ;; \
		*) goRelArch='src'; goRelSha256='567b1cc66c9704d1c019c50bef946272e911ec6baf244310f87f4e678be155f2'; \
			echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;; \
	esac; \
	\
	url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
	wget -O go.tgz "$url"; \
	echo "${goRelSha256} *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	if [ "$goRelArch" = 'src' ]; then \
		echo >&2; \
		echo >&2 'error: UNIMPLEMENTED'; \
		echo >&2 'TODO install golang-any from jessie-backports for GOROOT_BOOTSTRAP (and uninstall after build)'; \
		echo >&2; \
		exit 1; \
	fi; \
	\
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends yarn

RUN git clone https://github.com/google/re2.git --progress && \
    cd re2 && \
    git checkout tags/2018-07-01 -b re2_version && \
    make && \
    make test && \
    make install && \
    make testinstall && \
    cd .. && \
    rm -fr re2

RUN git clone https://github.com/nodejs/node.git --progress && \
    cd node && \
    git checkout tags/v10.7.0 -b node_version && \
    ./configure && \
    make && \
    make install &&\
    cd .. && \
    rm -fr node

RUN groupadd --gid 666 --system deploy \
    && useradd --uid 888 --groups deploy --shell /bin/bash --user-group --home-dir /home/git --create-home git

USER git
WORKDIR /home/git

RUN git clone https://github.com/gitlabhq/gitlabhq.git --progress -b 11-0-stable gitlab

RUN echo 2.5.1 | tee gitlab/.ruby-version && \
    echo 7.1.5 | tee gitlab/GITLAB_SHELL_VERSION && \
    echo '_0.113.0-ruby-2.5' | tee gitlab/GITALY_SERVER_VERSION

COPY Gemfile.example gitlab/Gemfile
COPY config/gitlab.yml.example gitlab/config/gitlab.yml
COPY config/database.yml.example gitlab/config/database.yml
COPY config/redis.cache.yml.example gitlab/config/redis.cache.yml
COPY config/redis.queues.yml.example gitlab/config/redis.queues.yml
COPY config/redis.shared_state.yml.example gitlab/config/redis.shared_state.yml
COPY config/resque.yml.example gitlab/config/resque.yml
COPY config/unicorn.rb.example gitlab/config/unicorn.rb
COPY lib/tasks/gitlab/gitaly.rake.example gitlab/lib/tasks/gitlab/gitaly.rake


RUN cd gitlab && \
    gem install bundler &&  \
    bundle update

# RAILS_ENV=production bundle exec rails generate mousetrap:install Don't use this

RUN cd gitlab && \
    bundle exec rails gitlab:shell:install SKIP_STORAGE_VALIDATION=true RAILS_ENV=production

RUN cd gitlab && \
    bundle exec rails gitlab:workhorse:install[/home/git/gitlab-workhorse] RAILS_ENV=production

RUN cd gitlab && \
    bundle exec rails gitlab:gitaly:install[/home/git/gitaly] RAILS_ENV=production

RUN cd gitlab && \
    bundle install && \
    bundle exec rails gitlab:gitaly:storage_config RAILS_ENV=production

# CMD ["gitlab/bin/rails", "s", "-e", "production"]
WORKDIR /home/git/gitlab

RUN bundle exec rails gitlab:assets:clean RAILS_ENV=production && \
    bundle exec rails yarn:install RAILS_ENV=production && \
    bundle exec rails yarn:check RAILS_ENV=production

COPY start_rails.sh start_rails.sh
COPY /etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER root
RUN mkdir /var/run/sshd && chmod 777 /var/run

CMD ["/usr/bin/supervisord"]
# CMD ["./start_rails.sh"]

## Install required packages
#RUN apt-get update -q \
#    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#      ca-certificates \
#      openssh-server \
#      wget \
#      apt-transport-https \
#      vim \
#      nano \
#      gnupg2
#
## Manage SSHD through runit
#RUN mkdir -p /opt/gitlab/sv/sshd/supervise \
#    && mkfifo /opt/gitlab/sv/sshd/supervise/ok \
#    && printf "#!/bin/sh\nexec 2>&1\numask 077\nexec /usr/sbin/sshd -D" > /opt/gitlab/sv/sshd/run \
#    && chmod a+x /opt/gitlab/sv/sshd/run \
#    && ln -s /opt/gitlab/sv/sshd /opt/gitlab/service \
#    && mkdir -p /var/run/sshd
#
## Disabling use DNS in ssh since it tends to slow connecting
#RUN echo "UseDNS no" >> /etc/ssh/sshd_config
#
## Prepare default configuration
#RUN ( \
#  echo "" && \
#  echo "# Docker options" && \
#  echo "# Prevent Postgres from trying to allocate 25% of total memory" && \
#  echo "postgresql['shared_buffers'] = '1MB'" ) >> /etc/gitlab/gitlab.rb && \
#  mkdir -p /assets/ && \
#  cp /etc/gitlab/gitlab.rb /assets/gitlab.rb
#
## Expose web & ssh
#EXPOSE 443 80 22
#
## Define data volumes
#VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
#
## Copy assets
#COPY assets/wrapper /usr/local/bin/
#
## Wrapper to handle signal, trigger runit and reconfigure GitLab
#CMD ["/usr/local/bin/wrapper"]