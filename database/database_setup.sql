-- Create the MoMo Ingestion Relational Database 
CREATE DATABASE IF NOT EXISTS momo_processor_db;
USE momo_processor_db;

-- 1. Table: transaction_categories
CREATE TABLE transaction_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    CONSTRAINT chk_category_name CHECK (category_name IN ('P2P Transfer', 'Merchant Payment', 'Bank Deposit', 'Airtime'))
) COMMENT='Lookup table for strict classification of mobile money data streams';

-- 2. Table: users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(15) NOT NULL UNIQUE COMMENT 'Formatted with country code e.g. 250791666666',
    full_name VARCHAR(100) NOT NULL DEFAULT 'Unknown Customer',
    account_status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT chk_phone_format CHECK (phone_number REGEXP '^[0-9+]+$')
) COMMENT='User profiles for senders, receivers, and utilities';

-- 3. Table: transactions
CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY COMMENT 'Unique financial reference code parsed from SMS payload',
    sender_id INT,
    receiver_id INT,
    category_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    fee DECIMAL(10,2) DEFAULT 0.00,
    post_balance DECIMAL(12,2) NOT NULL,
    transaction_date DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id),
    CONSTRAINT chk_positive_amount CHECK (amount > 0),
    CONSTRAINT chk_non_negative_fee CHECK (fee >= 0)
) COMMENT='Immutable central ledger tracking quantitative RWF flows';

-- 4. Table: system_logs
CREATE TABLE system_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    log_level VARCHAR(10) NOT NULL,
    message TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT='Operational log table tracking regex failures and ingestion health';

-- Strategic Query Performance Optimization Indexes
CREATE INDEX idx_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_user_phone ON users(phone_number);

-- ==========================================
-- SEED DATA INSERTION (5 Records Per Core Table)
-- ==========================================

INSERT INTO transaction_categories (category_name, description) VALUES
('P2P Transfer', 'Money transferred between individual mobile wallets'),
('Merchant Payment', 'Payments made to businesses or utilities directly'),
('Bank Deposit', 'Funds pushed directly from a bank account into the mobile wallet'),
('Airtime', 'Purchase of network voice or data packages');

INSERT INTO users (phone_number, full_name, account_status) VALUES
('250788110381', 'System Service Center', 'Active'),
('250791666666', 'Samuel Carter', 'Active'),
('250795963036', 'Bank Transfer Gateway', 'Active'),
('250788999999', 'Jane Smith', 'Active'),
('250788141660', 'Linda Green', 'Active');

INSERT INTO transactions (transaction_id, sender_id, receiver_id, category_id, amount, fee, post_balance, transaction_date) VALUES
('76662021700', 4, 2, 1, 2000.00, 0.00, 2000.00, '2024-05-10 16:30:51'),
('73214484437', 2, 4, 2, 1000.00, 0.00, 1000.00, '2024-05-10 16:31:39'),
('51732411227', 2, 1, 2, 600.00, 0.00, 400.00, '2024-05-10 21:32:32'),
('17818959211', 2, 1, 2, 2000.00, 0.00, 38400.00, '2024-05-11 18:48:42'),
('13913173274', 2, 1, 4, 2000.00, 0.00, 25280.00, '2024-05-12 11:41:28');

INSERT INTO system_logs (log_level, message) VALUES
('INFO', 'Successfully opened transactional text XML batch file stream.'),
('INFO', 'Extracted and normalized 5 records using regular expressions.'),
('INFO', 'Database state integrity check matched constraints.'),
('INFO', 'Performance query index routing optimized.'),
('INFO', 'Week 2 initialization data loading operation completed.');
