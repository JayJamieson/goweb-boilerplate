FROM golang:1.16-alpine as builder

ARG PKG_NAME=github.com/goweb-boilerplate/api

# add additional arguments for use at container runtime
ARG ENVIRONMENT="local"

ARG DB_HOST=""
ARG DB_PORT=""
ARG DB_USER=""
ARG DB_PASS=""

ARG REDIS_HOST=""
ARG REDIS_PORT=""
ARG REDIS_PASS=""

# update certificates for https
RUN apk update && apk add --no-cache git ca-certificates && update-ca-certificates

# copy source files from host machine into build layer and build main.go in root directory
COPY . /go/src/${PKG_NAME}

RUN cd /go/src/${PKG_BASE}/${PKG_NAME} && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /api

FROM scratch

# copy built files into scratch docker image without source files
COPY --from=builder /api .

ENV PORT=8080

ENV DB_HOST=$DB_HOST
ENV DB_PORT=$DB_PORT
ENV DB_USER=$DB_USER
ENV DB_PASS=$DB_PASS

ENV REDIS_HOST=$REDIS_HOST
ENV REDIS_PORT=$REDIS_PORT
ENV REDIS_PASS=$REDIS_PASS

ENV ENVIRONMENT=$ENVIRONMENT

EXPOSE 8080

ENTRYPOINT [ "./api" ]