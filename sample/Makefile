build:
	go build -o sample

run: build
	go run .

docker:
	docker build -t sample .

clean:
	rm -f sample
	go clean