# goweb-boilerplate (WIP)

boilerplate project Go api project

## Requirements

- Make
- Go >=1.16
- Docker

## Setup

- `make up` to start redis and postgres
- `make run` to start non container'd version of application, runs on host

## Notes

- <https://pkg.go.dev/github.com/lib/pq>

## TODO

- [x] Makefile
- [x] Dockerfile
- [x] docker-compose.yml
- [x] update docker file with db parameters
- [x] add minimal endpoint for health check
  - [ ] move healthcheck to own file
- [ ] add minimal db drivers for postrgesql
- [ ] add minimal db drivers for redis
- [ ] add minimal endpoints testing db drivers
  - [ ] get/post redis
  - [ ] get/post postgresql
- [ ] github action to build and push image to registry
- [ ] IaC for creating aws or google or azure container instances and - deploy
- [ ] convert makefile to bashscript, make is bad usage here