groupname - MOMO SMS Data processing system. 

An enterprise grade fullstack system built to ingest, normalize, categorize, and visualize mobile money transaction metrics extracted directly from raw mobile SMS XML backups.

##  Team Setup
- **Team Name**: groupname
- **Project Role Assignation**:
  - Paci: Team lead & Backend Architect 
  - Miracle: Database engineering & Front end.
  - Hedrick: Data processing, Documentation & Visualization.
  - David: API, ETL & testing. 

## Agile Management Controls
- **Scrum Board Tracking Workspace**: https://trello.com/b/jNaGcVft/momo-sms-etl
- **High-Level System Architecture Design Link**: https://drive.google.com/file/d/1MR7c1AUgzeddNcCrs4eOUZl5QO72C0DU/view?usp=sharing

## Directory Roadmap
* `api/`: Backend routing, server logic (`server.py`), and REST endpoints.
* `data/raw/`: Backup destination for original incoming XML log structures (`modified_sms_v2.xml`).
* `database/`: Storage framework scripts holding DDL/DML table rules (`database_setup.sql`).
* `docs/`: Project documentation, ERD, API specifications, and PDF reports.
* `dsa/`: Standalone algorithms and search efficiency comparisons.
* `etl/`: Pipeline modules managing extraction and XML parsing (`parse_xml.py`).
* `examples/`: Layout references mapping tables to API JSON schema frames (`json_schemas.json`).
* `frontend/`: User interface and data visualization dashboards.
* `tests/`: Unit testing suites and Postman execution screenshots.

## Database Design & JSON Mapping
The system utilizes a relational MySQL database designed to track mobile money flows immutably. The schema strictly dictates how data is serialized for API consumption:
* **`users` table**: Maps to the `parties.sender` and `parties.receiver` objects in the JSON payload.
* **`transaction_categories` table**: Maps to the `category` object, dictating the financial direction (IN/OUT).
* **`transactions` table**: The core ledger. Maps to the root `transaction_id`, `timestamp`, and the `financials` object in the JSON output.
* **`transaction_tags` table**: A junction table linking transactions to unique metadata tags, output as an array in JSON.
* **`system_logs` table**: Tracks ingestion health and regex failures.

## Setup & Execution

### 1. Database Initialization
Execute the SQL script to build the schema and seed the initial test data.
```bash
mysql -u your_username -p < database/database_setup.sql

