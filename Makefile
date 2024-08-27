gcloud-login:
	gcloud auth login
	gcloud auth application-default login                                                              

gcloud-kubectl:
	gcloud container clusters get-credentials development-cluster --region us-central1

build:
	docker build --platform linux/amd64 -t gcp-gke-demo application/
	docker tag gcp-gke-demo:latest us-central1-docker.pkg.dev/$(GOOGLE_PROJECT)/applications/gcp-gke-demo:latest

push:
	docker push us-central1-docker.pkg.dev/$(GOOGLE_PROJECT)/applications/gcp-gke-demo:latest

apply:
	cd terraform/ && \
	terraform init && \
	terraform validate && \
	terraform apply -auto-approve

destroy:
	cd terraform/ && \
	terraform init && \
	terraform validate && \
	terraform destroy -auto-approve

plan:
	cd terraform/ && \
	terraform init && \
	terraform validate && \
	terraform plan
