# flask-docker-celery-rabbitmq

This repository is for running a simple dummy flask application in a docker environment.

It uses:
- Flask
- Celery
- Flower
- Rabbitmq
- PostgreSQL (not doing anything, though)


## Prerequisites
Make sure you have docker and docker-compose installed.

## Running
Clone this repository and navigate into it in your terminal.
Run in development mode, so set APP_ENV environment to Dev

APP_ENV=Dev docker-compose up --build

It will expose 2 ports, one for the flask application (8000) and one for the RabbitMQ management interface (15672)
It will also start 2 worker containers.

When it runs, you can test it with several curl POST request and check it running in the Flower interface.

    for value in {1..50}
    do
        curl --data '{json}' -H 'Content-Type: application/json' 0.0.0.0:8000/api/process_data
    done

    OR

    Postman >> POST >> 0.0.0.0:8000/api/process_data

    example response :

    {
        "task_id": "671edfeb-d186-4b3a-ae45-74144f25e137"
    } 


This will run 50 tasks, you can see in the flower [http://localhost:8888](http://0.0.0.0:8888/tasks) 
how the tasks are distributed between the worker instances.

The RabbitMQ interface [http://localhost:15672](http://0.0.0.0:15672/) with login:
- username: rabbit_user
- password: rabbit_password

#####  auto deployment on EKS cluster using jenkins


###### EKS cluster #######

eksctl create cluster --name flask-gunicorn-celery-rabbitmq-docker --region ap-south-1 --nodegroup-name my-nodes --node-type t2.micro --managed --nodes 2 

eksctl get cluster flask-gunicorn-celery-rabbitmq-docker --region ap-south-1

sudo cat ~/.kube/config

# add ~/.kube/config in jenkins K8s credentials  Enter ID as K8S and choose enter directly and paste the above file content and save.

kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous

eksctl get cluster --name flask-gunicorn-celery-rabbitmq-docker --region ap-south-1

kubectl get nodes

kubectl get ns

#kubectl create deployment flask-gunicorn-celery-rabbitmq-docker --image=755345766251.dkr.ecr.ap-south-1.amazonaws.com/flaskapi-gunicorn:latest

cd k8s

# create

kubectl apply -f namespace.yaml
kubectl apply -f ingress.yaml
kubectl apply -f service.yaml
kubectl apply -f deployment.yaml

# view
kubectl get events
kubectl get pods --namespace=flaskapi-ns
kubectl get replicaset --namespace=flaskapi-ns
kubectl get deployment --namespace=flaskapi-ns
kubectl get service --namespace=flaskapi-ns

## delete 
kubectl delete -f deployment.yaml
kubectl delete -f ingress.yaml
kubectl delete -f namespace.yaml
kubectl delete -f service.yaml

#eksctl delete cluster --name flask-gunicorn-celery-rabbitmq-docker --region ap-south-1

### Referance link for this project https://www.coachdevops.com/2020/12/deploy-python-app-docker-container-into.html



