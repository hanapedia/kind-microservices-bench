# A Simple Microservices Benchmark on Kind

## Requirements
- `kind` (any recent version)
- `kubectl` (any recent version)

## Running the Benchmark Test

### Common setup
Start a kind cluster by running the following.
```sh
make start
```

### Simple REST interaction
#### 1. Deploy the microservices
```sh
make deploy-http
```
This will run two services: `gateway` and `backend`.
- `gateway` exposes `/get` HTTP GET route which calls `/get` HTTP GET route on `backend` once invoked.
- `backend` exposes `/get` HTTP GET route which runs CPU intesive task before returning a response.
    - the exact task is just applying sha256 hashing 100 times on a string.

#### 2. Start the Stress Test
```sh
make run
```
This will deploy Grafana K6 Worker to run a stress test for 1 minute. It will output the summary of the test when done.

#### 3. Remove the microservices and the load generator
```sh
make delete-http
```

### gRPC simple-RPC interaction
#### 1. Deploy the microservices
```sh
make deploy-grpc
```
This will run two services: `gateway` and `backend`.
- `gateway` exposes `/get` HTTP GET route which communicates with `backend` using gRPC simple-RPC once invoked.
- `backend` exposes `/get` HTTP GET route which runs CPU intesive task before returning a response.
    - the exact task is just applying sha256 hashing 100 times on a string.

#### 2. Start the Stress Test
```sh
make run
```
This will deploy Grafana K6 Worker to run a stress test for 1 minute. It will output the summary of the test when done. The summary will be saved as 

#### 3. Remove the microservices
```sh
make delete-http
```

### Clean up
Stop kind cluster
```sh
make stop
```
