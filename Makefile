all: install

REBUILD:
	@touch debug*.go

dependencies:
	go get -u github.com/dvyukov/go-fuzz/go-fuzz
	go get -u github.com/dvyukov/go-fuzz/go-fuzz-build
	go get -u github.com/uplo-tech/fastrand
	go get -u github.com/uplo-tech/errors
	go get -u github.com/alecthomas/gometalinter
	gometalinter --install

install: REBUILD
	go install

lint:
	gometalinter --disable-all --enable=errcheck --enable=vet --enable=gofmt ./...

test: REBUILD
	go test -v -tags='debug' -timeout=600s

test-short: REBUILD
	go test -short -v -tags='debug' -timeout=6s

cover: REBUILD
	go test -coverprofile=coverage.out -v -race -tags='debug' ./...

fuzz: REBUILD
	go install -tags='debug gofuzz'
	go-fuzz-build github.com/uplo-tech/merkletree
	go-fuzz -bin=./merkletree-fuzz.zip -workdir=fuzz

.PHONY: all REBUILD dependencies install test test-short cover fuzz benchmark
