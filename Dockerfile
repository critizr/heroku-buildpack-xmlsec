FROM heroku/heroku:18-build

ARG VERSION

COPY ./xmlsec1-${VERSION}.sig ./

RUN gpg --keyserver keyserver.ubuntu.com --recv-key 9E1D829E && \
    wget https://www.aleksey.com/xmlsec/download/xmlsec1-${VERSION}.tar.gz && \
    gpg --verify xmlsec1-${VERSION}.sig xmlsec1-${VERSION}.tar.gz && \
    tar xvf xmlsec1-${VERSION}.tar.gz

WORKDIR ./xmlsec1-${VERSION}
RUN ./configure --enable-static --enable-static-linking --disable-docs --disable-shared --disable-apps-crypto-dl --disable-crypto-dl --prefix=$HOME && \
    make -j `nproc`
RUN make install prefix=$HOME
CMD tar -zcf - -C $HOME bin lib include
