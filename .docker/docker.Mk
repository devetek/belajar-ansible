################################################################################
##@ DOCKER
################################################################################

docker-build-push-ubuntu22: ## Build and push ansible executor ubuntu 22
	@docker build -f .docker/Dockerfile.Ubuntu22.04-ansible -t prakasa1904/ansible:ubuntu-22.04 .;\
	docker push prakasa1904/ansible:ubuntu-22.04

docker-build-push-ubuntu24: ## Build and push ansible executor ubuntu 24
	@docker build -f .docker/Dockerfile.Ubuntu24.04-ansible -t prakasa1904/ansible:ubuntu-24.04 .;\
	docker push prakasa1904/ansible:ubuntu-24.04

docker-build-push-inventories:
	@docker build -f .docker/Dockerfile.Almalinux9 -t prakasa1904/sshserver:almalinux-9 .;\
	docker push prakasa1904/sshserver:almalinux-9
	@docker build -f .docker/Dockerfile.Rockylinux9 -t prakasa1904/sshserver:rockylinux-9 .;\
	docker push prakasa1904/sshserver:rockylinux-9
	@docker build -f .docker/Dockerfile.Fedora43 -t prakasa1904/sshserver:fedora-43 .;\
	docker push prakasa1904/sshserver:fedora-43
	@docker build -f .docker/Dockerfile.CentOS-stream10 -t prakasa1904/sshserver:centos-stream-10 .;\
	docker push prakasa1904/sshserver:centos-stream-10