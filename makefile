.DEFAULT_GOAL := build

clean:
	docker image prune -f

build-test:
	cd ./frontend && npm run build
	docker build -t willp/forecaster:latest -f Dockerfile.x86 .

build-dist:
	cd ./frontend && npm run build
	docker build -t willp/forecaster:latest -f Dockerfile.armv6 .

run:
	docker run -d -p 80:80 willp/forecaster:latest

dev:
	docker run -it --rm -p 80:80 willp/forecaster:latest

push:
	docker push willp/forecaster:latest
