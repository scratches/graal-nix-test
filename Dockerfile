FROM ubuntu:jammy

ARG USER
ARG USER_ID
ARG USER_GID

RUN (groupadd --gid "${USER_GID}" "${USER}" || echo "No groupadd needed") && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash ${USER}

RUN apt-get update && apt-get install -y sudo curl xz-utils && apt-get clean

RUN mkdir -p /opt/oracle-graalvm-jdk21 && \
    cd /opt/oracle-graalvm-jdk21 && \
    case `uname -m` in aarch64) \
    curl -L "https://download.oracle.com/graalvm/21/latest/graalvm-jdk-21_linux-aarch64_bin.tar.gz" | tar zx --strip-components=1 ;; \
    *) curl -L "https://download.oracle.com/graalvm/21/latest/graalvm-jdk-21_linux-x64_bin.tar.gz" | tar zx --strip-components=1 ;; esac

RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}

ENV JAVA_HOME /opt/oracle-graalvm-jdk21
ENV PATH $JAVA_HOME/bin:$PATH
ENV USER ${USER}

VOLUME /nix
RUN mkdir -pm 0755 /nix && chown ${USER_ID}:${USER_GID} /nix

WORKDIR /work
USER ${USER}

RUN curl -L https://nixos.org/nix/install | sh
