ifneq (,$(wildcard .env))
    include .env
    export
endif

print-env:
	@echo "$(DOCKER_IMAGE_TAR)"

build_docker_image:
	@docker build -t $(DOCKER_IMAGE_NAME) -f Dockerfile .

run_docker_image:
	@docker run --rm -d -p $(PORT):$(PORT) -e PORT=$(PORT) $(DOCKER_IMAGE_NAME)

push_docker_image:
	@docker push $(DOCKER_IMAGE_NAME)

deploy_docker_image:
	@gcloud run deploy my-api-service \
		--image=$(DOCKER_IMAGE_NAME) \
		--platform=managed \
		--region=$(LOCATION) \
		--allow-unauthenticated

test_api:
	@curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/ | grep 200

save_api:
	@docker save $(DOCKER_IMAGE_NAME) > $(DOCKER_IMAGE_TAR)

# Target to load Docker image
load_docker_image:
	@docker load < $(DOCKER_IMAGE_TAR)
