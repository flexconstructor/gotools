FROM golang:1.11.5-stretch

ENV PATH=$PATH:/go/bin
ENV DEP_VERSION=v0.5.0

RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/${DEP_VERSION}/dep-linux-amd64 \
 && chmod +x /usr/local/bin/dep \
 && curl -L https://git.io/vp6lP | sh \
 && go get github.com/smartystreets/goconvey \
 && go get github.com/go-playground/overalls \
 && go get golang.org/x/tools/cmd/goimports
