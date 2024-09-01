# ?= by default read from env, otherwise use provided value
TAG ?= $(shell grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')

.PHONY: install
install:
	poetry install

.PHONY: generate
generate:
	poetry export --format requirements.txt --output requirements.txt

.PHONY: docker-build
docker-build: clean generate
	docker build --tag docker.io/niesmaczne/searchengine-crawler:$(TAG) .

# - will ignore errors
.PHONY: clean
clean:
	-rm requirements.txt
