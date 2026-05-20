-- Create the MoMo Ingestion Relational Database 
CREATE DATABASE IF NOT EXISTS momo_processor_db;
USE momo_processor_db;

-- 1. Table: TRANSACTION_CATEGORIES
CREATE TABLE transaction_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    category_code VARCHAR(20),
    description VARCHAR(255),
    direction VARCHAR(10),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='Lookup table for strict classification of mobile money data streams';

-- 2. Table: USERS
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL DEFAULT 'Unknown Customer',
    account_number VARCHAR(50),
    user_type VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
) COMMENT='User profiles for senders, receivers, and utilities';

-- 3. Table: TRANSACTIONS
CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY COMMENT 'Switched to VARCHAR to prevent INT numeric overflow',
    transaction_ref VARCHAR(100),
    sender_id INT,
    receiver_id INT,
    category_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    fee DECIMAL(10,2) DEFAULT 0.00,
    balance_after DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Completed',
    message TEXT,
    transaction_date DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id),
    CONSTRAINT chk_positive_amount CHECK (amount >= 0)
) COMMENT='Immutable central ledger tracking quantitative RWF flows';

-- 4. Table: TRANSACTION_TAGS (Your custom metadata table!)
CREATE TABLE transaction_tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(50) NOT NULL,
    tag_value VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE
) COMMENT='Flexible sub-attributes extracted from unique SMS variants';

-- 5. Table: SYSTEM_LOGS
CREATE TABLE system_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(50) NULL, -- Nullable if parsing fails completely
    log_type VARCHAR(20) NOT NULL,
    log_message TEXT NOT NULL,
    source_file VARCHAR(100),
    processing_status VARCHAR(20),
    raw_sms_body TEXT,
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    error_code VARCHAR(50),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE SET NULL
) COMMENT='Operational log table tracking regex failures and ingestion health';

-- Performance Optimization Indexes
CREATE INDEX idx_trans_date ON transactions(transaction_date);
CREATE INDEX idx_user_phone_lookup ON users(phone_number);

-- ==========================================
-- SEED DATA INSERTION (Matches your exact layout)
-- ==========================================

INSERT INTO transaction_categories (category_name, category_code, description, direction) VALUES
('P2P Transfer', 'P2P', 'Money transferred between individual mobile wallets', 'OUT'),
('Merchant Payment', 'MERCH', 'Payments made to businesses or utilities directly', 'OUT'),
('Bank Deposit', 'BANK', 'Funds pushed directly from a bank account into the mobile wallet', 'IN'),
('Airtime', 'AMK', 'Purchase of network voice or data packages', 'OUT');

INSERT INTO users (phone_number, full_name, account_number, user_type) VALUES
('250788110381', 'System Service Center', 'ACC-001', 'System'),
('250791666666', 'Samuel Carter', 'ACC-002', 'Customer'),
('250795963036', 'Bank Transfer Gateway', 'ACC-003', 'Merchant'),
('250788999999', 'Jane Smith', 'ACC-004', 'Customer'),
('250788141660', 'Linda Green', 'ACC-005', 'Customer');

INSERT INTO transactions (transaction_id, transaction_ref, sender_id, receiver_id, category_id, amount, fee, balance_after, transaction_date) VALUES
('76662021700', 'REF-01', 4, 2, 1, 2000.00, 0.00, 2000.00, '2024-05-10 16:30:51'),
('73214484437', 'REF-02', 2, 4, 2, 1000.00, 0.00, 1000.00, '2024-05-10 16:31:39'),
('51732411227', 'REF-03', 2, 1, 2, 600.00, 0.00, 400.00, '2024-05-10 21:32:32'),
('17818959211', 'REF-04', 2, 1, 2, 2000.00, 0.00, 38400.00, '2024-05-11 18:48:42'),
('13913173274', 'REF-05', 2, 1, 4, 2000.00, 0.00, 25280.00, '2024-05-12 11:41:28');

INSERT INTO transaction_tags (transaction_id, tag_value) VALUES
('76662021700', 'BivaMoMotima'),
('73214484437', 'BivaMoMotima'),
('13913173274', 'AirtimeToken');

INSERT INTO system_logs (transaction_id, log_type, log_message, processing_status) VALUES
('76662021700', 'INFO', 'Successfully parsed matching row.', 'Success'),
('73214484437', 'INFO', 'Successfully parsed matching row.', 'Success'),
(NULL, 'WARN', 'SMS body syntax variance detected on line 42.', 'Skipped'),
('17818959211', 'INFO', 'Successfully parsed matching row.', 'Success'),
('13913173274', 'INFO', 'Successfully parsed matching row.', 'Success');
