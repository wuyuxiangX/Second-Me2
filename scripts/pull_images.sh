#!/bin/bash
# Script to pull the latest Docker images based on environment configuration

echo "=== Pulling Second-Me Docker Images ==="

# Check if .env file exists
if [ ! -f .env ]; then
  echo "Error: .env file not found. Please run scripts/prompt_cuda.sh first to configure your environment."
  exit 1
fi

# Source the .env file to get configuration
source .env

# Determine which backend image to pull
BACKEND_IMAGE=${DOCKER_BACKEND_IMAGE:-wyxhhhh/second-me-backend:latest}

echo "Pulling backend image: $BACKEND_IMAGE"
docker pull "$BACKEND_IMAGE"

echo "Pulling frontend image: wyxhhhh/second-me-frontend:latest"
docker pull wyxhhhh/second-me-frontend:latest

echo "Docker images successfully updated"
echo "=== Pull Complete ==="