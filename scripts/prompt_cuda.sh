#!/bin/bash
# Script to prompt user for CUDA support preference and set environment for the appropriate Docker image

echo "=== CUDA Support Selection ==="
echo ""
echo "Do you want to use NVIDIA GPU (CUDA) support?"
echo "This requires an NVIDIA GPU and proper NVIDIA Docker runtime configuration."
echo ""
read -p "Use CUDA support? (y/n): " choice

# Detect system architecture
ARCH=$(uname -m)

case "$choice" in
  y|Y|yes|YES|Yes )
    echo "Selected: WITH CUDA support"
    
    # Create or update .env file with the Docker image selection
    if [ -f .env ]; then
      # Update existing file
      if grep -q "DOCKER_BACKEND_IMAGE" .env; then
        sed -i 's/^DOCKER_BACKEND_IMAGE=.*/DOCKER_BACKEND_IMAGE=wyxhhhh\/second-me-backend-cuda:latest/' .env
      else
        # Add a newline before appending new content
        echo "" >> .env
        echo "DOCKER_BACKEND_IMAGE=wyxhhhh/second-me-backend-cuda:latest" >> .env
      fi
      
      # Set USE_CUDA flag
      if grep -q "USE_CUDA" .env; then
        sed -i 's/^USE_CUDA=.*/USE_CUDA=1/' .env
      else
        echo "USE_CUDA=1" >> .env
      fi
    else
      # Create new file
      echo "DOCKER_BACKEND_IMAGE=wyxhhhh/second-me-backend-cuda:latest" > .env
      echo "USE_CUDA=1" >> .env
    fi
    
    # Create a flag file to indicate GPU use
    echo "GPU" > .gpu_selected
    
    echo "Environment set to use CUDA support"
    ;;
  * )
    echo "Selected: WITHOUT CUDA support (CPU only)"
    
    # Determine which image to use based on architecture
    if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
      BACKEND_IMAGE="wyxhhhh/second-me-backend-apple:latest"
      echo "Detected Apple Silicon/ARM64 architecture"
    else
      BACKEND_IMAGE="wyxhhhh/second-me-backend:latest"
      echo "Detected x86_64 architecture"
    fi
    
    # Create or update .env file with the Docker image selection
    if [ -f .env ]; then
      # Update existing file
      if grep -q "DOCKER_BACKEND_IMAGE" .env; then
        sed -i "s|^DOCKER_BACKEND_IMAGE=.*|DOCKER_BACKEND_IMAGE=$BACKEND_IMAGE|" .env
      else
        # Add a newline before appending new content
        echo "" >> .env
        echo "DOCKER_BACKEND_IMAGE=$BACKEND_IMAGE" >> .env
      fi
      
      # Set USE_CUDA flag
      if grep -q "USE_CUDA" .env; then
        sed -i 's/^USE_CUDA=.*/USE_CUDA=0/' .env
      else
        echo "USE_CUDA=0" >> .env
      fi
    else
      # Create new file
      echo "DOCKER_BACKEND_IMAGE=$BACKEND_IMAGE" > .env
      echo "USE_CUDA=0" >> .env
    fi
    
    # Remove any GPU flag file if it exists
    if [ -f .gpu_selected ]; then
      rm .gpu_selected
    fi
    
    echo "Environment set to use without CUDA support"
    ;;
esac

# Ask if user wants to pull the latest images
echo ""
read -p "Would you like to pull the latest Docker images now? (y/n): " pull_choice

case "$pull_choice" in
  y|Y|yes|YES|Yes )
    echo "Pulling the latest Docker images..."
    
    # Extract backend image from .env file
    BACKEND_IMAGE=$(grep "DOCKER_BACKEND_IMAGE" .env | cut -d= -f2)
    
    # Pull images
    docker pull "$BACKEND_IMAGE"
    docker pull wyxhhhh/second-me-frontend:latest
    
    echo "Docker images successfully updated"
    ;;
  * )
    echo "Skipped pulling Docker images"
    ;;
esac

echo "=== CUDA Selection Complete ==="