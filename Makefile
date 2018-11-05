SERVICE_NAME      := ancient-texts-api

.PHONY: all ensure install run compose-deps compose-integration-test compose-up compose-down proto

all:
	go build ./...

ensure:
	retool do dep ensure

proto:
	retool do protoc --go_out=plugins=grpc:. ./rpc/hello/hello.proto

install:
	go install ./...

run: install
	$(SERVICE_NAME)

compose-deps:
	docker-compose up -d cache
	docker-compose up -d db

compose-integration-test: compose-deps
	docker-compose build api
	docker-compose run --entrypoint "make integration-test" api

compose-up: compose-deps
	docker-compose up -d --build api

compose-down:
	docker-compose down
