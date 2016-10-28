FROM localhost:5000/openjdk8 

#Install hydra dependencies
#RUN yum -y install group "Development Tools"
RUN apk add --update build-base curl nasm tar bzip2 \
        zlib-dev openssl yasm-dev lame-dev libogg-dev \
        x264-dev libvpx-dev libvorbis-dev x265-dev \
        freetype-dev libass-dev libwebp-dev rtmpdump-dev \
        libtheora-dev opus-dev imagemagick-dev nasm \
        libxml2-dev libxslt-dev yaml-dev git nasm apr-dev \
        apr-util-dev pcre-dev gdbm-dev libffi-dev \
        libvpx libtheora \
        opus libass yasm 
RUN apk --no-cache --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add fdk-aac fdk-aac-dev gnutls gnutls-dev


RUN mkdir -p /opt/install && cd /opt/install                                                              
# install FFmpeg

ENV FFMPEG_SOURCES /opt/install/ffmpeg_sources
ENV FFMPEG_HOME /opt/ffmpeg
ENV FFMPEG_BUILD /opt/install/ffmpeg_build
ENV PATH=$PATH:$FFMPEG_HOME/bin

RUN mkdir -p /opt/install/ffmpeg_sources /opt/install/ffmpeg_build

ENV FFMPEG_VERSION=3.2
# FFmpeg
RUN curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
  cd ffmpeg-${FFMPEG_VERSION} && \
  ./configure \
  --enable-gnutls --enable-version3 --enable-gpl --enable-libfdk-aac --enable-nonfree --enable-small --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx --enable-libtheora --enable-libvorbis --enable-libopus --enable-libass --enable-libwebp --enable-librtmp --enable-postproc --enable-avresample --enable-libfreetype --disable-debug && \
  make && \
  make install && \
  make distclean 
RUN hash -r

# install fits
RUN cd /opt/install && wget https://github.com/harvard-lts/fits/archive/master.zip && unzip master.zip && chmod +x fits-master/fits.sh && cp -r /opt/install/fits-master/* /usr/local/bin/ && ln -s /usr/local/bin/fits.sh /usr/local/bin/fits

# install FFmpeg


## Add symlinks
#RUN ln -s /opt/ffmpeg/bin/ffmpeg /usr/bin/ffmpeg &&  ln -s /opt/ffmpeg/bin/ffprobe /usr/bin/ffprobe
