#================================================================================================================================================================================
# Define dependencies

APP             := portfolio-site
BASE_IMAGE_NAME := portfolio-service
SERVICE_NAME    := portfolio-api
VERSION         := 0.0.1
SERVICE_IMAGE   := $(BASE_IMAGE_NAME)/$(SERVICE_NAME):$(VERSION)
#TOKEN           :=

#================================================================================================================================================================================
# Building containers
all: portfolio-api-service

# Build the portfolio container using the Dockerfile
portfolio-api-service:
	@set "BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")" && \
	docker build \
		-f zarf/docker/dockerfile.portfolio \
		-t $(SERVICE_IMAGE) \
		--build-arg BUILD_REF=$$BUILD_DATE \
		--build-arg BUILD_DATE="$(shell date -u +"%y-%m-%dT%H:%M:%SZ")" \
		.

portfolio-api-service-labels:
	docker inspect --format '{{json .Config.Labels}}' $(SERVICE_IMAGE)


#================================================================================================================================================================================

run:
	go run app/services/portfolio-api/main.go | go run app/tooling/logfmt/main.go

#================================================================================================================================================================================
# Running with Docker-Compose

# Start the containers in detached mode
dev-up:
	docker-compose -f zarf/compose/docker-compose.yml up -d

# Stop and remove the containers
dev-down:
	docker-compose -f zarf/compose/docker-compose.yml down

# Restart the service container
dev-restart:
	docker-compose -f zarf/compose/docker-compose.yml restart $(SERVICE_NAME)

dev-logs:
	docker-compose -f zarf/compose/docker-compose.yml logs -f $(SERVICE_NAME)

# Show status of the containers
#	@echo "Use 'docker-compose ps' to inspect containers."
dev-status:
	@echo "Use 'docker-compose ps' to inspect containers."
	docker-compose -f zarf/compose/docker-compose.yml ps


#================================================================================================================================================================================
#Modules Support

tidy: 
	go mod tidy 
	go mod vendor