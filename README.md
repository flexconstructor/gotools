# Go tools

[![GitHub release](https://img.shields.io/github/release/flexconstructor/gotools.svg)](https://github.com/flexconstructor/gotools/releases) [![Build Status](https://travis-ci.org/flexconstructor/gotools.svg?branch=master)](https://travis-ci.org/flexconstructor/gotools) [![Docker Pulls](https://img.shields.io/docker/pulls/flexconstructor/gotools.svg)](https://hub.docker.com/r/flexconstructor/gotools)


Docker image, which is a "Swiss knife" for a go engineer.

## What's inside:

- [Dep](https://golang.github.io/dep/) is a dependency management tool for Go. It requires Go 1.9 or newer to compile.
- [Gometalinter](https://github.com/alecthomas/gometalinter) is concurrently run Go lint tools and normalise their output.
- [Goconvey](https://github.com/smartystreets/goconvey)  a yummy Go testing tool for gophers. Works with go test. Use it in the terminal or browser according to your viewing pleasure.
- [Overalls](https://github.com/go-playground/overalls) runs test coverage tests on all packages in each directory and finally concatenates into a single file for tools like goveralls and codecov.io.
- [Goimports](https://godoc.org/golang.org/x/tools/cmd/goimports)  Command goimports updates your Go import lines, adding missing ones and removing unreferenced ones.

## How to use this image:

### Init go project with go dep:

```
docker run -v $(PWD):/go/src/project_name -w /go/src/project_name  flexconstructor/gotools:latest dep init
```

### Manage project dependencies:

```
docker run -v $(PWD):/go/src/project_name -w /go/src/project_name flexconstructor/gotools:latest dep ensure -v
```

### Lint go code:

```
docker run -v $(PWD):/go/src/project_name -w /go/src/project_name flexconstructor/gotools:latest gometalinter ./...
```

### Unit test with  calculate coverage:

```
docker run -v $(PWD):/go/src/project_name -w /go/src/project_name flexconstructor/gotools:latest overalls [flags]

```

and

```
docker run -v $(PWD):/go/src/project_name -w /go/src/project_name flexconstructor/gotools:latest go tool cover -func=overalls.coverprofile
```

More [info](https://github.com/go-playground/overalls#usage-and-documentation).


## Image versions


### `X`

Latest version of major `X` Go branch.


### `X.Y`

Latest version of minor `X.Y` Go branch.


### `X.Y.Z`

Latest build of concrete `X.Y.Z` version of Go.


### `X.Y.Z-rN`

Concrete `N` build of concrete `X.Y.Z` version of Go.


## Issues
[GitHub issue]: https://github.com/flexconstructor/gotools/issues

I can't notice comments in the DockerHub so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact me through a [GitHub issue].

