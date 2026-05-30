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
- **High-Level System Architecture Design Link**: [PASTE YOUR DRAW.IO OR MIRO LINK HERE]

## System Directory Roadmap

* `api/`: Backend routing, server logic, and API endpoints.
* `data/raw/`: Backup destination for original incoming XML log structures.
* `data/processed/`: Normalized and cleaned data pending database insertion.
* `database/`: Storage framework scripts holding DDL/DML table rules.
* `docs/`: Project documentation and API specifications.
* `etl/`: Pipeline modules managing extraction, XML parsing, currency cleaning, and database loading.
* `examples/`: Layout references mapping tables to API schema frames.
* `frontend/`: User interface and data visualization dashboards.
* `tests/`: Unit and integration testing suites.
