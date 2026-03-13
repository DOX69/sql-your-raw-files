#!/bin/bash

# Atom One Colors (approximate)
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
GRAY='\033[0;90m'
NC='\033[0m'

# Named Subfolder Convention Paths
DB_ROOT="duckdb/db"
QE_ROOT="duckdb/query_editor"

# Function to display a styled message
styled_msg() {
  local type=$1
  local msg=$2
  case $type in
    "info") echo -e "${CYAN}➜  ${NC}${msg}" ;;
    "success") echo -e "${GREEN}✔  ${NC}${msg}" ;;
    "warn") echo -e "${YELLOW}⚠  ${NC}${msg}" ;;
    "error") echo -e "${RED}✖  ${NC}${msg}" ;;
    "dim") echo -e "${GRAY}${msg}${NC}" ;;
    *) echo -e "${msg}" ;;
  esac
}

# Function to list available databases
list_databases() {
  find "${DB_ROOT}" -name "*.db" | sed "s|${DB_ROOT}/||" | sed "s|.db$||"
}

# Function to create a database
create_db() {
  local db_name=$1
  local folder_name=$2
  [ -z "$folder_name" ] && folder_name="public"

  local db_path="${DB_ROOT}/${folder_name}"
  local qe_path="${QE_ROOT}/${folder_name}"

  mkdir -p "${db_path}" "${qe_path}"
  
  if [ ! -f "${db_path}/${db_name}.db" ]; then
    duckdb "${db_path}/${db_name}.db" "VACUUM;" 
    styled_msg "success" "Database created at ${db_path}/${db_name}.db"
    styled_msg "success" "Query editor folder created at ${qe_path}"
  else
    styled_msg "warn" "Database ${db_name}.db already exists at ${db_path}."
  fi
}

# Function to rename a database
rename_db() {
  local old_name=$1
  local new_name=$2
  local folder=$3
  [ -z "$folder" ] && folder="public"

  local db_dir="${DB_ROOT}/${folder}"
  
  if [ -f "${db_dir}/${old_name}.db" ]; then
    mv "${db_dir}/${old_name}.db" "${db_dir}/${new_name}.db"
    styled_msg "success" "Renamed ${old_name}.db to ${new_name}.db in ${folder}"
  else
    styled_msg "error" "Database ${old_name}.db not found in ${folder}"
    return 1
  fi
}

# Function to move a database
move_db() {
  local db_name=$1
  local old_folder=$2
  local new_folder=$3

  local old_db_path="${DB_ROOT}/${old_folder}/${db_name}.db"
  local new_db_dir="${DB_ROOT}/${new_folder}"
  local old_qe_dir="${QE_ROOT}/${old_folder}"
  local new_qe_root="${QE_ROOT}"

  if [ -f "$old_db_path" ]; then
    mkdir -p "$new_db_dir"
    mv "$old_db_path" "${new_db_dir}/${db_name}.db"
    
    # Move QE folder if it exists and is not the same as public/root
    if [ -d "$old_qe_dir" ] && [ "$old_folder" != "public" ] && [ "$old_folder" != "." ]; then
      mkdir -p "$new_qe_root"
      mv "$old_qe_dir" "${new_qe_root}/${new_folder}"
      styled_msg "success" "Moved query editor folder from ${old_folder} to ${new_folder}"
    else
      mkdir -p "${QE_ROOT}/${new_folder}"
      styled_msg "info" "Created new query editor folder at ${new_folder}"
    fi

    styled_msg "success" "Moved ${db_name}.db from ${old_folder} to ${new_folder}"
  else
    styled_msg "error" "Database ${db_name}.db not found in ${old_folder}"
    return 1
  fi
}

# Function to delete a database
delete_db() {
  local db_name=$1
  local folder=$2
  local force=$3

  local db_path="${DB_ROOT}/${folder}/${db_name}.db"

  if [ ! -f "$db_path" ]; then
    styled_msg "error" "Database not found at ${db_path}"
    return 1
  fi

  if [ "$force" != "--force" ]; then
    styled_msg "warn" "CRITICAL: You are about to delete the database!"
    echo -e "To confirm, please type exactly: ${RED}${folder}/${db_name}${NC}"
    read -r -p "> " confirm
    confirm=$(echo "$confirm" | tr -d '\r')
    if [ "$confirm" != "${folder}/${db_name}" ]; then
      styled_msg "error" "Confirmation failed. Deletion aborted."
      return 1
    fi
  fi

  rm "$db_path"
  styled_msg "success" "Database ${db_name}.db deleted from ${folder}"
}

# Function to use a database
use_db() {
  local db_name=$1
  local folder=$2
  local db_path="${DB_ROOT}/${folder}/${db_name}.db"

  if [ -f "$db_path" ]; then
    styled_msg "info" "Launching DuckDB for ${folder}/${db_name}..."
    duckdb "$db_path"
  else
    styled_msg "error" "Database not found at ${db_path}"
  fi
}

# CLI Argument handling (for testing and direct use)
case "$1" in
  "create") create_db "$2" "$3"; exit 0 ;;
  "rename") rename_db "$2" "$3" "$4"; exit 0 ;;
  "move")   move_db "$2" "$3" "$4"; exit 0 ;;
  "delete") delete_db "$2" "$3" "$4"; exit 0 ;;
  "use")    use_db "$2" "$3"; exit 0 ;;
esac

# Interactive Menu Loop
while true; do
  echo -e "\n${CYAN}--- DuckDB Manager ---${NC}"
  echo -e "1. ${CYAN}Create${NC} a new database"
  echo -e "2. ${CYAN}Rename${NC} a database"
  echo -e "3. ${CYAN}Move${NC} a database to a folder"
  echo -e "4. ${CYAN}Use${NC} a database"
  echo -e "5. ${RED}Delete${NC} a database"
  echo -e "6. ${GRAY}Exit${NC}"

  read -r -p "Select an option: " opt
  # Strip any carriage returns (Windows compatibility)
  opt=$(echo "$opt" | tr -d '\r')

  case $opt in
    1)
      read -r -p "Database Name: " db_name
      db_name=$(echo "$db_name" | tr -d '\r')
      while [ -z "$db_name" ]; do
        styled_msg "error" "Database name is required."
        read -r -p "Database Name: " db_name
        db_name=$(echo "$db_name" | tr -d '\r')
      done
      read -r -p "Folder Name (press Enter for public): " folder_name
      folder_name=$(echo "$folder_name" | tr -d '\r')
      create_db "$db_name" "$folder_name"
      ;;
    2)
      styled_msg "dim" "Available databases:"
      list_databases
      read -r -p "Folder: " folder
      folder=$(echo "$folder" | tr -d '\r')
      read -r -p "Current DB Name: " old_name
      old_name=$(echo "$old_name" | tr -d '\r')
      read -r -p "New DB Name: " new_name
      new_name=$(echo "$new_name" | tr -d '\r')
      rename_db "$old_name" "$new_name" "$folder"
      ;;
    3)
      styled_msg "dim" "Available databases:"
      list_databases
      read -r -p "DB Name: " db_name
      db_name=$(echo "$db_name" | tr -d '\r')
      read -r -p "Current Folder: " old_folder
      old_folder=$(echo "$old_folder" | tr -d '\r')
      read -r -p "New Folder: " new_folder
      new_folder=$(echo "$new_folder" | tr -d '\r')
      move_db "$db_name" "$old_folder" "$new_folder"
      ;;
    4)
      styled_msg "dim" "Available databases:"
      list_databases
      read -r -p "Folder: " folder
      folder=$(echo "$folder" | tr -d '\r')
      read -r -p "DB Name: " db_name
      db_name=$(echo "$db_name" | tr -d '\r')
      use_db "$db_name" "$folder"
      ;;
    5)
      styled_msg "dim" "Available databases:"
      list_databases
      read -r -p "Folder: " folder
      folder=$(echo "$folder" | tr -d '\r')
      read -r -p "DB Name: " db_name
      db_name=$(echo "$db_name" | tr -d '\r')
      delete_db "$db_name" "$folder"
      ;;
    6)
      styled_msg "dim" "Goodbye!"
      exit 0
      ;;
    *)
      styled_msg "error" "Invalid option: $opt"
      ;;
  esac
done
