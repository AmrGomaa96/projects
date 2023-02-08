# Project OverView
#### The Purpose of the project is to deploy python-app with redis as a database on a GKE cluster using Terraform to create the environment.

## Project Architecture

<img src=https://user-images.githubusercontent.com/116598689/217510894-8f702fd8-a24d-48f4-9772-6903f38e08d6.png>

#

## components

#### - VPC
#### - Two Subnets :
##### Management-Subnet 
##### Restricted-Subnet
#### - NAT gateway (Management-subnet)
#### - Private VM  (Management-subnet)
#### - Private standard GKE cluster (Restricted-Subnet)
#



## 1) Building the Environment using Terraform
### Apply the code using :
```
terraform plan 
terraform init
terraform apply
```
<img src=https://user-images.githubusercontent.com/116598689/217511480-0595cb78-03f9-4f35-b14a-85566f33dea2.png width=1000>

#
## 2) Building & Push app Image
### Add the Docker File:

```
FROM python:3.7

COPY . /usr/app

WORKDIR /usr/app

RUN pip install -r requirements.txt

ENV ENVIRONMENT=DEV
ENV HOST=localhost
ENV PORT=8000
ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV REDIS_DB=0

EXPOSE 8000

CMD ["python", "hello.py"]
```

### Apply the code using :
```
docker build -t gcp-python .
docker tag gcp-python gcr.io/my-project-377103/gcp-python
docker push gcr.io/my-project-377103/gcp-python
```
### Output:
<img src=https://user-images.githubusercontent.com/116598689/217513954-9e04f99d-de61-4462-aac8-14ce4ed4d62f.png>
<img src=https://user-images.githubusercontent.com/116598689/217514052-882f9854-7296-4053-890e-e2a6b65331d0.png>

#
## 3) Pull & Push Redis Image
### Apply the code using :
```
docker pull redis
docker tag redis gcr.io/my-project-377103/redis-gcr
docker push gcr.io/my-project-377103/redis-gcr
```
### Output:
<img src=https://user-images.githubusercontent.com/116598689/217512611-c149ce56-7a49-4a9c-9fdc-355731000fcf.png>
<img src=https://user-images.githubusercontent.com/116598689/217512873-48006282-3dfd-4132-9c48-5e35f0d1c532.png>

#
## 4) Shh to the private instance 
### Connect to the Gke Cluster:

```
gcloud container clusters get-credentials private-cluster --zone asia-east1-a --project my-project-377103
```
<img src=https://user-images.githubusercontent.com/116598689/217515033-d3fa7255-b7cf-44a5-91b1-9d0b69f7c30e.png>

#
## 5) Create and apply Kubernetes yml files 
### deployment-redis.yml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  replicas: 1
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: gcr.io/my-project-377103/redis-gcr:latest
        ports:
        - containerPort: 6379

```
### redis-service.yml

```
apiVersion: v1
kind: Service
metadata:
  name: redis
spec:
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379

```
### app-deployment.yml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      name: my-app
  template:
    metadata:
      labels:
        name: my-app
    spec:
      containers:
      - name: my-app
        image: gcr.io/my-project-377103/gcp-python:latest
        env:
        - name: REDIS_PORT
          value: "6379"
        - name: REDIS_HOST
          value: redis
        - name: ENVIRONMENT
          value: DEV
        - name: PORT
          value: "8000"
        - name: REDIS_DB
          value: "0"
        ports:
        - containerPort: 80

```
### Load-balancer.yml

```
apiVersion: v1
kind: Service
metadata:
  name: loadbalancer
spec:
  selector:
    name: my-app
  ports:
  - port: 80
    targetPort: 8000
  type: LoadBalancer

```
## Using:
```
Kubectl apply -f <fileName>
```
## Outputs:

### Deployments
<img src=https://user-images.githubusercontent.com/116598689/217519641-34984210-ef0a-4f9f-a30c-40a0f247a5cb.png>

### Services
<img src=https://user-images.githubusercontent.com/116598689/217519914-bfe49a50-d8d9-4d25-9dc4-a5874a9bbc72.png>



#
## 6) Access using Loadbalancer 
## output:
<img src=https://user-images.githubusercontent.com/116598689/217520401-e435421b-1599-4ab9-8cca-0b976bda318c.png>

### Check the counter
<img src=https://user-images.githubusercontent.com/116598689/217529314-54109dcb-1231-4046-9024-0f6e201622ed.jpeg>

#
## 7) Ingress

#### Disable the Loadbalancer and create a nodeport service and ingress using the following yml files
### nodeport.yml
```
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  type: NodePort
  selector:
    name: my-app
  ports:
    - port: 80
      targetPort: 8000
      nodePort: 30002

```
### ingress.yml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80

```
## outputs:
### Services

<img src=https://user-images.githubusercontent.com/116598689/217527855-fc067a6e-35a4-414b-971a-38c42ba9cd95.png>

### Ingress
<img src=https://user-images.githubusercontent.com/116598689/217528077-6ea75094-3162-4ac4-9a41-3b631d4b17fa.png>

### Accesing using ingress address
<img src=https://user-images.githubusercontent.com/116598689/217528297-ad240cc2-47a7-417e-aae6-94b02df7bcae.png>
