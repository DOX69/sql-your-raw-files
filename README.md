# SQL Your Raw Files: DuckDB Analytical Workspace

A structured environment designed to streamline data exploration and analysis using [DuckDB](https://duckdb.org/). This workspace provides a robust folder structure and a management script to help you organize raw data files, persistent databases, and SQL queries.

## 🚀 Features

- **Automated DB Management**: Use the `db-manager.sh` script to create, rename, move, and delete databases.
- **Organized Structure**: Pre-defined directories for CSV, Parquet, and JSON files.
- **Query Editor Templates**: Ready-to-use SQL templates for data exploration.
- **CI Integrated**: GitHub Actions workflow to ensure the integrity of the workspace management tools.

## 📋 Prerequisites

Before using this workspace, ensure you have the following installed:

1.  **DuckDB CLI**:
    - **Windows**: `winget install DuckDB.DuckDB`
    - **macOS**: `brew install duckdb`
    - **Linux**: Download the binary from [duckdb.org](https://duckdb.org/)
2.  **Bash Environment**: 
    - Required to run the management scripts (`.sh`).
    - **Windows** users can use Git Bash, WSL, or a similar terminal.

## 🛠️ Installation

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/DOX69/sql-your-raw-files.git
    cd sql-your-raw-files
    ```

2.  **Verify DuckDB Installation**:
    ```bash
    duckdb --version
    ```

3.  **Set Script Permissions** (Linux/macOS/WSL):
    ```bash
    chmod +x scripts/*.sh
    ```

## 📂 Folder Structure

- **`duckdb/data/`**: Place your raw files here (`csv/`, `parquet/`, `json/`).
- **`duckdb/db/`**: Contains your persistent DuckDB database files (`.db`).
- **`duckdb/query_editor/`**: Store your SQL scripts here, organized by project/database name.

## 🛠️ Usage: Database Manager

The `db-manager.sh` script provides an interactive menu (or CLI commands) to manage your workspace:

```bash
./scripts/db-manager.sh
```

**CLI Commands**:
- **Create**: `./scripts/db-manager.sh create <db_name> <folder_name>`
- **Rename**: `./scripts/db-manager.sh rename <old_name> <new_name> <folder>`
- **Move**: `./scripts/db-manager.sh move <db_name> <old_folder> <new_folder>`
- **Delete**: `./scripts/db-manager.sh delete <db_name> <folder> --force`

## 🧪 Testing

To verify the workspace management tools locally, run:
```bash
./scripts/test_db-manager.sh
```

---
Happy Querying! 🦆
