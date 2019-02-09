FROM golang:alpine

RUN apk add --no-cache curl\
                       bash \
                       git

RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 && chmod +x /usr/local/bin/dep

RUN curl -L https://git.io/vp6lP | sh

RUN go get github.com/smartystreets/goconvey

RUN go get github.com/go-playground/overalls

ENV PATH=$PATH:/go/bin