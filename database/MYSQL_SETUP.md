# MySQL Workbench Setup Guide

This guide will help you set up the Dementicare database using MySQL Workbench.

## Prerequisites

- MySQL Server 8.0 or higher
- MySQL Workbench (download from https://dev.mysql.com/downloads/workbench/)

## Installation

### macOS
```bash
# Install MySQL using Homebrew
brew install mysql

# Start MySQL service
brew services start mysql

# Secure MySQL installation (set root password)
mysql_secure_installation
```

### Linux
```bash
sudo apt update
sudo apt install mysql-server mysql-workbench
sudo systemctl start mysql
sudo mysql_secure_installation
```

### Windows
Download and install from: https://dev.mysql.com/downloads/installer/

## MySQL Workbench Setup

### 1. Launch MySQL Workbench

Open MySQL Workbench from your Applications folder or Start menu.

### 2. Create Connection

1. Click the **+** button next to "MySQL Connections"
2. Enter connection details:
   - **Connection Name**: Dementicare Local
   - **Hostname**: localhost (or 127.0.0.1)
   - **Port**: 3306
   - **Username**: root
   - **Password**: (click "Store in Keychain" and enter your MySQL root password)
3. Click **Test Connection** to verify
4. Click **OK** to save

### 3. Connect to MySQL Server

Double-click the "Dementicare Local" connection to open it.

### 4. Create Database and Tables

#### Option 1: Using SQL Script

1. Open the SQL script file:
   - Click **File** → **Open SQL Script**
   - Navigate to: `/Users/azadansari/Programming/Dementi/database/schema.sql`
   - Click **Open**

2. Execute the script:
   - Click the **lightning bolt** icon (⚡) or press `Cmd+Shift+Enter` (Mac) / `Ctrl+Shift+Enter` (Windows)
   - Wait for the script to complete

3. Verify tables were created:
   - In the **Navigator** panel (left side), click **Schemas**
   - Find `dementicare` database
   - Expand it to see the tables

#### Option 2: Manual Creation

Copy and paste this SQL into a new query tab:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS dementicare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dementicare;
```

Then run the rest of the schema from `schema.sql`.

## Database Schema

### Tables Overview

The Dementicare database contains 7 main tables:

| Table | Description | Key Fields |
|-------|-------------|------------|
| **users** | User accounts (doctors, caregivers, patients) | email, password, user_type, name |
| **patients** | Patient records | name, age, gender, diagnosis, caregiver_id |
| **appointments** | Medical appointments | patient_id, doctor_id, date, time, status |
| **prescriptions** | Medication prescriptions | patient_id, doctor_id, medication, dosage |
| **quiz_results** | Cognitive assessment results | patient_id, score, answers (JSON) |
| **contacts** | Contact form submissions | name, email, message, status |
| **jobs** | Job listings for caregivers | title, company, location, posted_by |

### Relationships

```
users (1) ----< (many) patients (caregiver_id)
users (1) ----< (many) appointments (doctor_id)
patients (1) ----< (many) appointments (patient_id)
patients (1) ----< (many) prescriptions (patient_id)
users (1) ----< (many) prescriptions (doctor_id)
patients (1) ----< (many) quiz_results (patient_id)
users (1) ----< (many) jobs (posted_by)
```

### Entity Relationship Diagram (ERD)

To view the ERD in MySQL Workbench:

1. Click **Database** → **Reverse Engineer**
2. Select your connection and database
3. Follow the wizard to generate the ERD
4. The visual diagram will show all tables and relationships

## Verify Installation

Run these queries to verify the setup:

```sql
-- Show all databases
SHOW DATABASES;

-- Select the dementicare database
USE dementicare;

-- Show all tables
SHOW TABLES;

-- Check users table structure
DESCRIBE users;

-- Count tables (should return 7)
SELECT COUNT(*) as table_count 
FROM information_schema.tables 
WHERE table_schema = 'dementicare';

-- View table sizes
SELECT 
    table_name,
    table_rows,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'dementicare'
ORDER BY (data_length + index_length) DESC;
```

## Update Go Backend Configuration

1. Update the `.env` file in the backend directory:

```bash
cd /Users/azadansari/Programming/Dementi/backend
nano .env
```

2. Set these values:

```
PORT=8080
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_root_password
DB_NAME=dementicare
JWT_SECRET=your-super-secret-jwt-key-change-this
ML_SERVICE_URL=http://localhost:5000
```

3. Install MySQL driver:

```bash
cd /Users/azadansari/Programming/Dementi/backend
go mod tidy
go mod download
```

## Test Connection from Go Backend

```bash
cd /Users/azadansari/Programming/Dementi/backend
go run main.go
```

You should see:
```
Database connected successfully
Database migration completed
Server starting on port 8080
```

## Common MySQL Commands

### Connection
```sql
-- Connect to MySQL
mysql -u root -p

-- Show current user
SELECT USER();

-- Show current database
SELECT DATABASE();
```

### Database Management
```sql
-- Show all databases
SHOW DATABASES;

-- Use database
USE dementicare;

-- Show tables
SHOW TABLES;

-- Describe table structure
DESCRIBE users;
SHOW CREATE TABLE users;
```

### Data Management
```sql
-- View all users
SELECT * FROM users;

-- View all patients
SELECT * FROM patients;

-- Count records
SELECT COUNT(*) FROM users;

-- View recent appointments
SELECT * FROM appointments ORDER BY created_at DESC LIMIT 10;
```

### Backup
```bash
# Backup database
mysqldump -u root -p dementicare > dementicare_backup.sql

# Backup with timestamp
mysqldump -u root -p dementicare > dementicare_backup_$(date +%Y%m%d_%H%M%S).sql

# Restore database
mysql -u root -p dementicare < dementicare_backup.sql
```

## Troubleshooting

### Cannot Connect to MySQL

```bash
# Check if MySQL is running
brew services list  # macOS
sudo systemctl status mysql  # Linux

# Start MySQL if not running
brew services start mysql  # macOS
sudo systemctl start mysql  # Linux
```

### Access Denied Error

```bash
# Reset MySQL root password
mysql.server stop
mysqld_safe --skip-grant-tables &
mysql -u root

# In MySQL prompt:
USE mysql;
UPDATE user SET authentication_string=PASSWORD('new_password') WHERE User='root';
FLUSH PRIVILEGES;
EXIT;

# Restart MySQL
mysql.server start
```

### Table Already Exists Error

```sql
-- Drop and recreate database
DROP DATABASE IF EXISTS dementicare;
CREATE DATABASE dementicare;
-- Then run schema.sql again
```

### Connection Timeout

1. Check firewall settings
2. Verify MySQL is listening on port 3306:
   ```bash
   sudo lsof -i :3306
   ```
3. Check MySQL configuration:
   ```bash
   mysql -u root -p -e "SHOW VARIABLES LIKE 'port';"
   ```

## Performance Optimization

### Indexing

The schema already includes indexes on frequently queried columns. Monitor query performance:

```sql
-- Show slow queries
SHOW VARIABLES LIKE 'slow_query_log%';

-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

### Configuration

Edit MySQL configuration file (`my.cnf` or `my.ini`):

```ini
[mysqld]
# Connection settings
max_connections = 200
connect_timeout = 10

# Buffer settings
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M

# Query cache (MySQL 5.7 and earlier)
query_cache_type = 1
query_cache_size = 64M
```

## MySQL Workbench Tips

### 1. Create ERD Diagram
- Database → Reverse Engineer
- Select your connection
- Generate visual schema

### 2. Export Data
- Server → Data Export
- Select database and tables
- Choose export options

### 3. Import Data
- Server → Data Import
- Select import file
- Choose database

### 4. Run Queries
- File → New Query Tab (Cmd+T / Ctrl+T)
- Write SQL
- Execute (⚡ icon or Cmd+Enter)

### 5. View Query Results
- Click on table name in Navigator
- Click the table icon with cursor
- Results appear in bottom panel

## Next Steps

1. ✅ MySQL installed and running
2. ✅ Database and tables created
3. ✅ Backend configured to use MySQL
4. ⏭️ Start the Go backend
5. ⏭️ Test API endpoints
6. ⏭️ Start frontend development

## Additional Resources

- MySQL Documentation: https://dev.mysql.com/doc/
- MySQL Workbench Manual: https://dev.mysql.com/doc/workbench/en/
- GORM MySQL Driver: https://gorm.io/docs/connecting_to_the_database.html#MySQL

## Support

If you encounter issues:
1. Check MySQL error log: `/usr/local/var/mysql/*.err` (macOS)
2. Verify connection settings in `.env`
3. Test connection in MySQL Workbench
4. Check backend logs when starting the server
