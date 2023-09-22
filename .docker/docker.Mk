################################################################################
##@ DOCKER
################################################################################

docker-build-push: ## Build and push ansible master
	@docker build -f .docker/Dockerfile.Ubuntu22.04 -t prakasa1904/ansible:ubuntu-22.04 .;\
	docker push prakasa1904/ansible:ubuntu-22.04