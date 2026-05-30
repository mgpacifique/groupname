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

TRANSACTIONS_DICT = {t["transaction_id"]: t for t in TRANSACTIONS_DATA}

# Valid Credentials for Basic Auth
VALID_USER = "admin"
VALID_PASS = "admin123"

class MoMoAPIHandler(BaseHTTPRequestHandler):
    
    def check_auth(self):
        """Validates Basic Authentication headers."""
        auth_header = self.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Basic '):
            return False
        
        try:
            encoded_credentials = auth_header.split(' ')[1]
            decoded_bytes = base64.b64decode(encoded_credentials)
            decoded_str = decoded_bytes.decode('utf-8')
            username, password = decoded_str.split(':', 1)
            return username == VALID_USER and password == VALID_PASS
        except Exception:
            return False

    def send_unauthorized(self):
        self.send_response(401)
        self.send_header('WWW-Authenticate', 'Basic realm="MoMo API"')
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"error": "Unauthorized", "message": "Invalid or missing credentials."}).encode())

    def send_json(self, data, status_code=200):
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def do_GET(self):
        if not self.check_auth():
            return self.send_unauthorized()

        # Route: GET /transactions
        if self.path == '/transactions' or self.path == '/transactions/':
            return self.send_json(TRANSACTIONS_DATA)

        # Route: GET /transactions/{id}
        if self.path.startswith('/transactions/'):
            tx_id = self.path.split('/')[-1]
            
            # --- DSA Performance Evaluation Check ---
            # Linear Search
            start_linear = time.perf_counter_ns()
            linear_result = None
            for tx in TRANSACTIONS_DATA:
                if tx["transaction_id"] == tx_id:
                    linear_result = tx
                    break
            end_linear = time.perf_counter_ns()
            
            # Dictionary Lookup
            start_dict = time.perf_counter_ns()
            dict_result = TRANSACTIONS_DICT.get(tx_id)
            end_dict = time.perf_counter_ns()
            
            print(f"[DSA METRIC] Linear Search: {end_linear - start_linear}ns | Dict Lookup: {end_dict - start_dict}ns")

            if dict_result:
                return self.send_json(dict_result)
            else:
                return self.send_json({"error": "Not Found", "message": f"Transaction {tx_id} not found"}, 404)

        self.send_json({"error": "Bad Request", "message": "Invalid Endpoint"}, 400)
