FROM golang:1.21-alpine AS build

WORKDIR /build
COPY . .

RUN go get
RUN go build -o sample

FROM alpine

COPY --from=build /build/sample /

ENV LOGFORMAT=json
ENV STATICDIR=/static

COPY static /static

EXPOSE 8000

ENTRYPOINT ["/sample"]
