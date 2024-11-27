#!/bin/bash

# Set the source and destination directories
LIB_DIR="lib/features"
TEST_DIR="test/features"

# Create the test directory if it doesn't exist
mkdir -p "$TEST_DIR"

# Function to create test file with a basic main function
create_test_file() {
    local lib_file=$1
    local test_file=$2

    if [ ! -f "$test_file" ]; then
        echo "Creating test file: $test_file"
        cat <<EOL > "$test_file"
// TODO(franio): Write tests for ${lib_file##*/}

import 'package:flutter_test/flutter_test.dart';

void main() {
  // Add your tests here
}
EOL
    else
        echo "Test file already exists: $test_file"
    fi
}

# Loop through each Dart file in the lib/features directory, excluding generated files and tmp directories
find "$LIB_DIR" -type f -name "*.dart" \
    -not -name "*.freezed.dart" \
    -not -name "*.mocks.dart" \
    -not -name "*.g.dart" \
    -not -path "*/tmp/*" | while read -r lib_file; do

    # Determine the corresponding test file path
    relative_path="${lib_file#$LIB_DIR/}"
    test_file="${TEST_DIR}/${relative_path%.dart}_test.dart"

    # Create the corresponding directory in the test folder
    mkdir -p "$(dirname "$test_file")"

    # Create the test file only if it doesn't exist
    if [ ! -f "$test_file" ]; then
        create_test_file "$lib_file" "$test_file"
    else
        echo "Skipped existing test file: $test_file"
    fi
done
