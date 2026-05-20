import os

# Base Directories
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DATA_DIR = os.path.join(BASE_DIR, 'data', 'raw')
PROCESSED_DATA_DIR = os.path.join(BASE_DIR, 'data', 'processed')
LOGS_DIR = os.path.join(BASE_DIR, 'data', 'logs')

# File Paths
XML_INPUT_PATH = os.path.join(RAW_DATA_DIR, 'momo.xml')
JSON_OUTPUT_PATH = os.path.join(PROCESSED_DATA_DIR, 'dashboard.json')
LOG_FILE_PATH = os.path.join(LOGS_DIR, 'etl.log')

# MoMo Transaction Categories Constants
CATEGORIES = {
    'P2P': 'P2P Transfer',
    'MERCHANT': 'Merchant Payment',
    'BANK': 'Bank Deposit',
    'AIRTIME': 'Airtime'
}
