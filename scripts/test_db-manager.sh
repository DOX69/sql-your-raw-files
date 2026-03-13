#!/bin/bash

# Atom One Colors (approximate)
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m'

# Test Helper: check if file or directory exists
assert_exists() {
  if [ -e "$1" ]; then
    echo -e "${GREEN}  ✓ PASS: $1 exists${NC}"
  else
    echo -e "${RED}  ✗ FAIL: $1 does not exist${NC}"
    exit 1
  fi
}

# Test Helper: check if file or directory does not exist
assert_not_exists() {
  if [ ! -e "$1" ]; then
    echo -e "${GREEN}  ✓ PASS: $1 does not exist${NC}"
  else
    echo -e "${RED}  ✗ FAIL: $1 exists${NC}"
    exit 1
  fi
}

echo -e "${CYAN}--- Starting db-manager.sh Tests ---${NC}"

# Setup: Remove any existing test data
rm -rf duckdb/db/test_folder duckdb/db/new_folder duckdb/db/public/public_test.db duckdb/db/public/renamed_test.db
rm -rf duckdb/query_editor/test_folder duckdb/query_editor/new_folder duckdb/query_editor/public/public_test_exploration.sql

# Test 1: Create a database with a folder
echo -e "${GRAY}Test 1: Create a database with a folder...${NC}"
./scripts/db-manager.sh create test_db test_folder
assert_exists "duckdb/db/test_folder/test_db.db"
assert_exists "duckdb/query_editor/test_folder"

# Test 2: Create a database without a folder (defaults to public)
echo -e "${GRAY}Test 2: Create a database without a folder (defaults to public)...${NC}"
./scripts/db-manager.sh create public_test
assert_exists "duckdb/db/public/public_test.db"
assert_exists "duckdb/query_editor/public"

# Test 3: Rename a database
echo -e "${GRAY}Test 3: Rename a database...${NC}"
./scripts/db-manager.sh rename public_test renamed_test public
assert_exists "duckdb/db/public/renamed_test.db"
assert_not_exists "duckdb/db/public/public_test.db"

# Test 4: Move a database to a folder
echo -e "${GRAY}Test 4: Move a database to a folder...${NC}"
./scripts/db-manager.sh move renamed_test public new_folder
assert_exists "duckdb/db/new_folder/renamed_test.db"
assert_exists "duckdb/query_editor/new_folder"
assert_not_exists "duckdb/db/public/renamed_test.db"

# Test 5: Delete a database (non-interactive mode for testing)
echo -e "${GRAY}Test 5: Delete a database...${NC}"
./scripts/db-manager.sh delete renamed_test new_folder --force
assert_not_exists "duckdb/db/new_folder/renamed_test.db"

echo -e "${GREEN}--- All Tests Passed! ---${NC}"
