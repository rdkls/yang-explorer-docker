build:
	docker rmi -f yang-explorer 2>/dev/null
	docker build --tag yang-explorer .

run:
	docker run -p 8000:8000 --rm -ti --name yang-explorer yang-explorer

all: build run
