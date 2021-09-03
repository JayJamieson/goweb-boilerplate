# goweb-boilerplate (WIP)

boilerplate project Go api project

## Requirements

- Make
- Go >=1.16
- Docker

## Notes

- <https://pkg.go.dev/github.com/lib/pq>

## TODO

- [x] Makefile
- [x] Dockerfile
- [x] docker-compose.yml
- [ ] update docker file with db parameters
- [ ] add minimal endpoint for health check
- [ ] add minimal db drivers for postrgesql
- [ ] add minimal db drivers for redis
- [ ] add minimal endpoints testing db drivers
  - [ ] get/post redis
  - [ ] get/post postgresql
- [ ] github action to build and push image to registry
- [ ] IaC for creating aws or google or azure container instances and deploy
