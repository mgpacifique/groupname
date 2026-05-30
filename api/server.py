from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import base64
import time

# --- seeded data from sql shema ---
TRANSACTIONS_DATA = [
    {
        "transaction_id": "76662021700",
        "timestamp": "2024-05-10T16:30:51Z",
        "financials": {"amount": 2000.00, "fee": 0.00, "currency": "RWF", "post_transaction_balance": 2000.00},
        "category": {"category_id": 1, "name": "P2P Transfer", "description": "Money transferred between individual mobile wallets"},
        "parties": {
            "sender": {"user_id": 4, "full_name": "Jane Smith", "phone_number": "250788999999", "status": "Active"},
            "receiver": {"user_id": 2, "full_name": "Samuel Carter", "phone_number": "250791666666", "status": "Active"}
        }
    },
    {
        "transaction_id": "73214484437",
        "timestamp": "2024-05-10T16:31:39Z",
        "financials": {"amount": 1000.00, "fee": 0.00, "currency": "RWF", "post_transaction_balance": 1000.00},
        "category": {"category_id": 2, "name": "Merchant Payment", "description": "Payments made to businesses directly"},
        "parties": {
            "sender": {"user_id": 2, "full_name": "Samuel Carter", "phone_number": "250791666666", "status": "Active"},
            "receiver": {"user_id": 4, "full_name": "Jane Smith", "phone_number": "250788999999", "status": "Active"}
        }
    }
]
