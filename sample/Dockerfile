FROM golang:1.21-alpine

WORKDIR /build
COPY . .

RUN go get
RUN go build -o sample

FROM alpine

COPY --from=0 /build/sample /

ENV LOGFORMAT=json

EXPOSE 8000

ENTRYPOINT ["/sample"]
