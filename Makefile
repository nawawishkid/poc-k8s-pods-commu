APP1_IMAGE_NAME=poc-k8s-pods-commu--app1
APP2_IMAGE_NAME=poc-k8s-pods-commu--app2
NAMESPACE=mynamespace
DELAY=5
LOCAL_PORT=8080

build:
	docker build -t $(APP1_IMAGE_NAME) -f app1/Dockerfile ./app1
	docker build -t $(APP2_IMAGE_NAME) -f app2/Dockerfile ./app2


deploy:
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/app1-deploy.yaml -n $(NAMESPACE)
	kubectl apply -f k8s/app2-deploy.yaml -n $(NAMESPACE)
	kubectl apply -f k8s/app1-service.yaml -n $(NAMESPACE)
	kubectl apply -f k8s/app2-service.yaml -n $(NAMESPACE)

port-forward:
	@echo "Waiting for app1 pods to be ready..."
	@while ! kubectl get pods -n $(NAMESPACE) -l app=app1 -o jsonpath='{.items[*].status.phase}' | grep Running > /dev/null; do \
		echo "Waiting for app1 pods to be running..."; \
		sleep 2; \
	done
	@kubectl port-forward service/app1-service $(LOCAL_PORT):80 -n $(NAMESPACE) &

test:
	sleep $(DELAY)
	curl -X POST http://localhost:$(LOCAL_PORT)/send -H "Content-Type: application/json" -d '{"message": "Hello, App2!"}'

all: build push deploy port-forward test

clean:
	kubectl delete -f k8s/app1-deploy.yaml -n $(NAMESPACE)
	kubectl delete -f k8s/app2-deploy.yaml -n $(NAMESPACE)
	kubectl delete -f k8s/app1-service.yaml -n $(NAMESPACE)
	kubectl delete -f k8s/app2-service.yaml -n $(NAMESPACE)
	kubectl delete -f k8s/namespace.yaml

help:
	@echo "Makefile for building and deploying FastAPI apps in Kubernetes"
	@echo ""
	@echo "Usage:"
	@echo "  make build         Build Docker images for both apps"
	@echo "  make deploy        Apply Kubernetes configuration files"
	@echo "  make port-forward  Forward port from app1-service to localhost"
	@echo "  make test          Test app1 with curl"
	@echo "  make all           Run all steps"
	@echo "  make clean         Clean up Kubernetes resources"
	@echo "  make help          Show this help message"

.PHONY: build push deploy port-forward test all clean help

