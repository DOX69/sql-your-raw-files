# DuckDB Analytical Workspace

Welcome to your DuckDB workspace! This directory is pre-configured to keep your data, databases, and queries structured and easy to manage.

## Folder Structure

- **`data/`**: Organized subfolders for raw files. You can query them directly using format-specific functions:
  - **`csv/`**: Use `read_csv_auto('duckdb/data/csv/*.csv')`.
  - **`parquet/`**: Use `read_parquet('duckdb/data/parquet/*.parquet')`.
  - **`json/`**: Use `read_json_auto('duckdb/data/json/*.json')`.
- **`db/`**: Store your persistent DuckDB database files (`.db` or `.duckdb`). 
  - **Named Subfolder Convention**: Create a dedicated folder per database (e.g., `duckdb/db/finance/finance.db`) to keep projects organized.
- **`query_editor/`**: Write and store your `.sql` query scripts here.
  - **Named Subfolder Convention**: Group your scripts by database name (e.g., `duckdb/query_editor/finance/exploration.sql`).
  - Check the `_template/guide.sql` file for quick examples on how to query these files and attach databases.

## Installation

If you haven't installed DuckDB yet:
- **Windows**: `winget install DuckDB.DuckDB`
- **macOS**: `brew install duckdb`
- **Linux**: Download the binary from [duckdb.org](https://duckdb.org/)

## Usage

### 1. Quick In-Memory Session
Best for one-off exploration of files without saving state:
```bash
duckdb
```

### 2. Persistent Database Management
To save your tables and schemas for future use, specify a database file path:

**Create or Open a Database**
```bash
# This creates the file if it doesn't exist, or opens it if it does
duckdb duckdb/db/public/raw_data.db
```

**Import Files into Persistent Tables**
Run these commands inside the DuckDB prompt:
```sql
-- Create tables from different file formats
CREATE TABLE stg_products AS SELECT * FROM read_csv_auto('duckdb/data/csv/product.csv');
CREATE TABLE stg_events AS SELECT * FROM read_parquet('duckdb/data/parquet/events.parquet');
CREATE TABLE stg_metadata AS SELECT * FROM read_json_auto('duckdb/data/json/metadata.json');
```

**Retrieve Existing Tables**
When you restart DuckDB with the same `.db` file, your data is already there:
```sql
-- List all tables in the current database
SHOW TABLES;

-- Query your saved data
SELECT * FROM stg_products LIMIT 10;
```

### 3. Running SQL Scripts
Execute a specific script directly from your terminal:
```bash
duckdb duckdb/db/public/raw_data.db -c ".read duckdb/query_editor/explore.sql"
```

# Bonus: 🦆 DuckDB VS Code Workflow: Run SQL with Shift+Enter
This setup allows you to write your queries in a standard .sql file (benefiting from syntax highlighting, formatting, and extensions like GitHub Copilot) and send them directly to the DuckDB CLI running in your integrated terminal using a simple keyboard shortcut.

## Prerequisites
1. Install DuckDB: Ensure the DuckDB CLI binary is installed on your machine and available in your system path.
2. VS Code: Have Visual Studio Code (or a similar IDE) installed.
## Step 1: Open Keyboard Shortcuts (JSON)
To configure the shortcut, you need to add a custom keybinding in VS Code:
1. Open VS Code.
2. Open the Command Palette (Ctrl+Shift+P on Windows/Linux or Cmd+Shift+P on macOS).
3. Type and select Preferences: Open Keyboard Shortcuts (JSON).
## Step 2: Add the Keybinding
Add the following JSON block to the file to map Shift+Enter (or Ctrl+Enter) to the command that sends the selected editor text to the terminal:
```json
[
  {
    "key": "shift+enter",
    "command": "workbench.action.terminal.runSelectedText",
    "when": "editorTextFocus && editorLangId == 'sql'"
  }
]
```
(Note: You can change "shift+enter" to "ctrl+enter" or any other preferred combination).
## Step 3: Run the Workflow
Now that your environment is set up, you can execute queries seamlessly:
1. Open a SQL File: Create or open a .sql file in your VS Code editor.
2. Open the Terminal: Open the integrated terminal in VS Code (Ctrl+\` or Cmd+\`) so it sits side-by-side or below your editor.
3. Launch DuckDB: Type duckdb in the terminal and press Enter to start the in-memory DuckDB CLI process. (Optional: specify a file like duckdb my_database.db for persistent storage).
4. Run Queries: Highlight the SQL query you want to run in your editor (or just place your cursor on the line) and press your configured shortcut (Shift+Enter).
The query will immediately be injected into the terminal and executed by DuckDB
