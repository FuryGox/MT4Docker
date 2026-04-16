FROM ubuntu:focal

# Add WineHQ repository key
ADD https://dl.winehq.org/wine-builds/winehq.key /winehq.key

# Disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Wine from official WineHQ repository
RUN apt-get update && \
    apt-get install -y gnupg apt-utils && \
    echo "deb http://dl.winehq.org/wine-builds/ubuntu/ focal main" >> /etc/apt/sources.list && \
    apt-key add /winehq.key && \
    mv /winehq.key /usr/share/keyrings/winehq-archive.key && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y -q --install-recommends winehq-devel && \
    apt-get install -y xvfb && \
    rm -rf /var/lib/apt/lists/*

# Add a non-root wine user
# NOTE: Change UID/GID if the host MetaTrader directory requires different ownership.
RUN groupadd -g 1000 wine \
    && useradd -g wine -u 1000 wine \
    && mkdir -p /home/wine/.wine && chown -R wine:wine /home/wine

# MetaTrader 4/5 needs WINEARCH=win32
ENV WINEARCH=win32
ENV WINEPREFIX=/home/wine/.wine
ENV DISPLAY=:99

WORKDIR /app

COPY ./mt4_source /app/mt4
COPY ./templates /app/templates
COPY entrypoint.sh /app/entrypoint.sh

RUN chown -R wine:wine /app && chmod +x /app/entrypoint.sh

# Pre-initialise the Wine prefix as the wine user
USER wine
RUN xvfb-run -a wineboot --init && \
    while pgrep wineserver > /dev/null; do sleep 1; done

ENTRYPOINT ["/app/entrypoint.sh"]