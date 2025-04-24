.PHONY: start deploy-http run delete-http deploy-grpc delete-grpc

CLUSTER_NAME := hexagon
NAMESPACE := hexagon

start:
	kind create cluster --name $(CLUSTER_NAME)
	kubectl create namespace $(NAMESPACE)

deploy-http:
	kubectl apply -k deploy/http/overlay
	kubectl wait --namespace $(NAMESPACE) --for=condition=Ready pods --all --timeout=120s

deploy-grpc:
	kubectl apply -k deploy/grpc/overlay
	kubectl wait --namespace $(NAMESPACE) --for=condition=Ready pods --all --timeout=120s

run:
	kubectl apply -k deploy/loadgenerator/overlay
	# Wait for the loadgenerator pod to start running
	kubectl wait --namespace $(NAMESPACE) --for=condition=complete job/loadgenerator --timeout=180s
	@timestamp=$$(date +%Y%m%d-%H%M%S); \
	kubectl logs -n $(NAMESPACE) -f job/loadgenerator > summary-$$timestamp.txt; \
	echo "Saved summary to summary-$$timestamp.txt"

delete-http:
	kubectl delete -k deploy/loadgenerator/overlay || true
	kubectl delete -k deploy/http/overlay || true

delete-grpc:
	kubectl delete -k deploy/loadgenerator/overlay || true
	kubectl delete -k deploy/grpc/overlay || true

stop:
	kind delete cluster --name $(CLUSTER_NAME)
