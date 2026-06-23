# MOMO SMS Data Processing System

An enterprise-grade full-stack system built to ingest, normalize, categorize, and visualize mobile money transaction metrics extracted directly from raw mobile SMS XML backups.

---

## Table of Contents

- [Overview](#overview)
- [Team](#team)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Setup & Installation](#setup--installation)
- [Running the System](#running-the-system)
- [API Reference](#api-reference)
- [Agile Management](#agile-management)

---

## Overview

The system parses raw SMS XML backup files exported from Android devices, extracts structured mobile money transaction data, stores it in a relational MySQL database, exposes it via a REST API, and presents it through an interactive frontend dashboard with data visualizations.

Key capabilities:

- XML ingestion and regex-based transaction parsing (`etl/parse_xml.py`)
- Relational data model tracking users, transactions, categories, tags, and ingestion logs
- REST API serving JSON-normalized transaction records (`api/server.py`)
- Frontend dashboard with charts and tabular views (`frontend/`)
- Unit tests and Postman-verified endpoint coverage (`tests/`)

---

## Team

| Member   | Role                                     |
|----------|------------------------------------------|
| Paci     | Team Lead & Backend Architect            |
| Miracle  | Database Engineering & Frontend          |
| Hedrick  | Data Processing, Documentation & Visualization |
| David    | API, ETL & Testing                       |

---

## Tech Stack

| Layer     | Technology                        |
|-----------|-----------------------------------|
| Parsing   | Python, `lxml`, `python-dateutil` |
| Validation| `pydantic`                        |
| Database  | MySQL                             |
| Backend   | Python (server.py)                |
| Frontend  | HTML/CSS/JS, data visualization   |

Python dependencies (see `requirements.txt`):

```
lxml==5.1.0
python-dateutil==2.9.0
pydantic==2.6.1
```

---

## Project Structure

```
groupname/
├── api/            # Backend server and REST endpoint routing (server.py)
├── data/
│   └── raw/        # Original XML SMS backup files (modified_sms_v2.xml)
├── database/       # DDL/DML schema scripts (database_setup.sql)
├── docs/           # ERD diagrams, API specs, PDF reports
├── etl/            # XML parsing and ETL pipeline (parse_xml.py)
├── examples/       # JSON schema reference frames (json_schemas.json)
├── frontend/       # Dashboard UI and visualizations
├── tests/          # Unit test suites and Postman screenshots
├── .env.example    # Environment variable template
└── requirements.txt
```

---

## Database Schema

The relational schema tracks mobile money flows immutably across five tables:

| Table                  | Purpose                                                                 |
|------------------------|-------------------------------------------------------------------------|
| `users`                | Sender and receiver party records; maps to `parties.sender` / `parties.receiver` in API JSON |
| `transaction_categories` | Financial direction (IN/OUT); maps to the `category` object in API JSON |
| `transactions`         | Core ledger: `transaction_id`, `timestamp`, and `financials` object     |
| `transaction_tags`     | Junction table linking transactions to metadata tags (array in JSON output) |
| `system_logs`          | Ingestion health tracking and regex failure records                     |

Full schema design: [Architecture Diagram](https://drive.google.com/file/d/1MR7c1AUgzeddNcCrs4eOUZl5QO72C0DU/view?usp=sharing)

---

## Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/mgpacifique/groupname.git
cd groupname
```

### 2. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure environment variables

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```env
DATABASE_URL=mysql://root:your_secure_password@localhost:3306/momo_processor_db
ENVIRONMENT=development
LOG_LEVEL=INFO
```

### 4. Initialize the database

```bash
mysql -u your_username -p < database/database_setup.sql
```

---

## Running the System

### Run the ETL pipeline

```bash
python etl/parse_xml.py
```

Parses `data/raw/modified_sms_v2.xml`, extracts transactions, and loads them into the database.

### Start the API server

```bash
python api/server.py
```

The server will be available at `http://localhost:5000` (or the configured port).

### Open the frontend

Open `frontend/index.html` in your browser, or serve it via a local HTTP server:

```bash
python -m http.server 8080 --directory frontend
```

---

## API Reference

Detailed endpoint specifications are in `docs/`. JSON schema examples are in `examples/json_schemas.json`.

Example response shape for a transaction record:

```json
{
  "transaction_id": "TXN-001",
  "timestamp": "2024-01-15T10:30:00Z",
  "category": { "direction": "IN" },
  "financials": { "amount": 5000, "currency": "RWF" },
  "parties": {
    "sender": { "id": 1, "name": "Alice" },
    "receiver": { "id": 2, "name": "Bob" }
  },
  "tags": ["salary", "recurring"]
}
```

---

## Agile Management

- **Scrum Board**: [Trello – MOMO SMS ETL](https://trello.com/b/jNaGcVft/momo-sms-etl)
- **Architecture Diagram**: [Google Drive](https://drive.google.com/file/d/1MR7c1AUgzeddNcCrs4eOUZl5QO72C0DU/view?usp=sharing)
