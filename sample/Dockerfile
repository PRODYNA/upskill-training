FROM golang:1.22.2-alpine3.19 AS build

WORKDIR /build
COPY . .

RUN go get
RUN go build -o sample

FROM alpine:3.19

COPY --from=build /build/sample /

ENV LOGFORMAT=json
ENV STATICDIR=/static

COPY static /static

EXPOSE 8000

ENTRYPOINT ["/sample"]
