FROM eclipse/che-theia-endpoint-runtime:nightly

ARG GO_VERSION=1.10.7

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		bash \
		gcc \
		musl-dev \
		openssl \
		go \
        git \
	; \
	export \
		GOROOT_BOOTSTRAP="$(go env GOROOT)" \
		GOOS="$(go env GOOS)" \
		GOARCH="$(go env GOARCH)" \
		GOHOSTOS="$(go env GOHOSTOS)" \
		GOHOSTARCH="$(go env GOHOSTARCH)" \
	; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) export GOARM='6' ;; \
		x86) export GO386='387' ;; \
	esac; \
	\
    wget -qO- https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | tar xvz -C /usr/local; \
	\
	cd /usr/local/go/src; \
	./make.bash; \
	\
	rm -rf \
		/usr/local/go/pkg/bootstrap \
		/usr/local/go/pkg/obj \
	; \
    export GOPATH="/go"; \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"; \
    mkdir -p "/.cache" && chmod -R 777 "/.cache"; \
    export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"; \
    go get -u -v github.com/ramya-rao-a/go-outline && \
    go get -u -v github.com/acroca/go-symbols &&  \ 
    go get -u -v github.com/mdempsky/gocode && \ 
    go get -u -v github.com/rogpeppe/godef && \ 
    go get -u -v golang.org/x/tools/cmd/godoc && \
    go get -u -v github.com/zmb3/gogetdoc && \
    go get -u -v golang.org/x/lint/golint && \
    go get -u -v github.com/fatih/gomodifytags &&  \
    go get -u -v golang.org/x/tools/cmd/gorename && \
    go get -u -v sourcegraph.com/sqs/goreturns && \
    go get -u -v golang.org/x/tools/cmd/goimports && \
    go get -u -v github.com/cweill/gotests/... && \
    go get -u -v golang.org/x/tools/cmd/guru && \
    go get -u -v github.com/josharian/impl && \
    go get -u -v github.com/haya14busa/goplay/cmd/goplay && \
    go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs && \
    go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct && \
    go get -u -v github.com/alecthomas/gometalinter && \ 
    go get -u -v github.com/go-delve/delve/cmd/dlv && \
    gometalinter --install \
    # Disabling build-deps deletion
    # ; \
	# apk del .build-deps \
    ; \
    go version

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH
