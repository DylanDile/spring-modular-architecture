#!/bin/bash

# Function to delete a resource file and wait until all resources are removed
delete_resources() {
  resource_file=$1

  echo "Deleting resources defined in $resource_file..."
  kubectl delete -f $resource_file

  # Wait until all resources are fully deleted
  while kubectl get -f $resource_file > /dev/null 2>&1; do
    echo "Waiting for resources in $resource_file to stop..."
    sleep 2
  done

  echo "All resources in $resource_file stopped successfully."
}

# Stop all services by specifying their respective YAML files
delete_resources postgres.yaml
delete_resources config-server.yaml
delete_resources discovery.yaml
delete_resources gateway-service.yaml
delete_resources auth-service.yaml
delete_resources payment-service.yaml

echo "All services have been stopped."
