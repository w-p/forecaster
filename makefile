.DEFAULT_GOAL := build

clean:
	docker image prune -f

build-x86:
	cd ./frontend && npm run build
	docker build -t willp/forecaster:x86 -f Dockerfile.x86 .

build-arm:
	docker build -t willp/forecaster:arm32v6 -f Dockerfile.arm32v6 .

run-x86:
	docker run -d -p 80:80 willp/forecaster:x86

run-arm:
	docker run -d -p 80:80 willp/forecaster:arm32v6

push-x86:
	docker push willp/forecaster:x86

push-arm:
	docker push willp/forecaster:arm32v6
