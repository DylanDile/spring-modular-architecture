#!/bin/bash

echo "Setting up config maps..."
kubectl apply -f  om-config-map.yaml

echo "Setting up pvc..."
kubectl apply -f om-pvc.yaml

echo "Deploying PostgresSQL..."
kubectl apply -f postgres.yaml

echo "Deploying Spring Boot services..."
kubectl apply -f config-server.yaml
kubectl apply -f discovery.yaml
kubectl apply -f gateway-service.yaml
kubectl apply -f auth-service.yaml
kubectl apply -f payment-service.yaml