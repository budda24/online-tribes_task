#!/bin/bash

# Define base directory
BASE_DIR="../lib/features"

# Ensure base directory exists
mkdir -p "$BASE_DIR"

# Function to create feature directories
create_feature_structure() {
  local feature_name=$1

  # Define the directory structure
  local dirs=(
    "$BASE_DIR/$feature_name/data/models"
    "$BASE_DIR/$feature_name/data/repositories"
    "$BASE_DIR/$feature_name/data/datasources"
    "$BASE_DIR/$feature_name/domain/entities"
    "$BASE_DIR/$feature_name/domain/repositories"
    "$BASE_DIR/$feature_name/domain/usecases"
    "$BASE_DIR/$feature_name/presentation/bloc"
    "$BASE_DIR/$feature_name/presentation/pages"
    "$BASE_DIR/$feature_name/presentation/widgets"
  )

  # Create each directory
  for dir in "${dirs[@]}"; do
    mkdir -p "$dir"
    echo "Created: $dir"
  done
}

# Check if a feature name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <feature-name>"
  exit 1
fi

# Call the function with the provided feature name
create_feature_structure "$1"
