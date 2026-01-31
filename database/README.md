# Database Documentation

This folder contains all database-related files for the Dementicare application using MySQL.

## 📁 Files

| File | Description |
|------|-------------|
| **schema.sql** | Complete database schema with all tables and indexes |
| **sample_data.sql** | Sample data for testing and development |
| **MYSQL_SETUP.md** | Detailed MySQL and MySQL Workbench setup guide |
| **QUICK_MYSQL_SETUP.md** | Quick start guide for MySQL setup |
| **WORKBENCH_GUIDE.md** | Visual guide for using MySQL Workbench |

## 🚀 Quick Start

### 1. Install MySQL
```bash
# macOS
brew install mysql
brew services start mysql
mysql_secure_installation
```

### 2. Create Database & Import Schema
```bash
mysql -u root -p
# In MySQL: CREATE DATABASE dementicare;
# Exit MySQL

cd /Users/azadansari/Programming/Dementi
mysql -u root -p dementicare < database/schema.sql
```

### 3. (Optional) Import Sample Data
```bash
mysql -u root -p dementicare < database/sample_data.sql
```

### 4. Configure Backend
```bash
cd backend
cp .env.example .env
# Edit .env with your MySQL credentials
```

## 📊 Database Schema

### Tables Overview

#### 1. **users** 
User accounts for doctors, caregivers, and patients
- Primary Key: `id`
- Unique: `email`
- Fields: email, password (hashed), user_type, name, phone

#### 2. **patients**
Patient records with medical information
- Primary Key: `id`
- Foreign Key: `caregiver_id` → users(id)
- Fields: name, age, gender, phone, address, diagnosis

#### 3. **appointments**
Medical appointments between patients and doctors
- Primary Key: `id`
- Foreign Keys: 
  - `patient_id` → patients(id)
  - `doctor_id` → users(id)
- Fields: date, time, type, status, notes

#### 4. **prescriptions**
Medication prescriptions for patients
- Primary Key: `id`
- Foreign Keys:
  - `patient_id` → patients(id)
  - `doctor_id` → users(id)
- Fields: medication, dosage, frequency, duration, instructions

#### 5. **quiz_results**
Cognitive assessment quiz results
- Primary Key: `id`
- Foreign Key: `patient_id` → patients(id)
- Fields: score, max_score, answers (JSON)

#### 6. **contacts**
Contact form submissions
- Primary Key: `id`
- Fields: name, email, message, status

#### 7. **jobs**
Job listings for caregivers
- Primary Key: `id`
- Foreign Key: `posted_by` → users(id)
- Fields: title, company, location, type, description, requirements, salary, status

### Entity Relationships

```
users (1) ----< (∞) patients [caregiver_id]
users (1) ----< (∞) appointments [doctor_id]
patients (1) ----< (∞) appointments [patient_id]
patients (1) ----< (∞) prescriptions [patient_id]
users (1) ----< (∞) prescriptions [doctor_id]
patients (1) ----< (∞) quiz_results [patient_id]
users (1) ----< (∞) jobs [posted_by]
```

## 🔐 Security Features

- **Password Hashing**: User passwords are hashed using bcrypt
- **Soft Deletes**: All tables support soft deletes with `deleted_at` timestamp
- **Indexes**: Optimized with indexes on frequently queried columns
- **Foreign Keys**: Referential integrity with ON DELETE CASCADE/SET NULL

## 🔧 MySQL Workbench Usage

### Connect to Database
1. Open MySQL Workbench
2. Create new connection (localhost:3306)
3. Enter root credentials
4. Connect to dementicare database

### Run Schema
1. File → Open SQL Script
2. Select `schema.sql`
3. Click Execute (⚡)

### View ERD
1. Database → Reverse Engineer
2. Select dementicare database
3. Generate visual diagram

For detailed instructions, see [WORKBENCH_GUIDE.md](WORKBENCH_GUIDE.md)

## 📝 Useful Queries

### View all tables
```sql
USE dementicare;
SHOW TABLES;
```

### Count records in all tables
```sql
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'patients', COUNT(*) FROM patients
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL
SELECT 'quiz_results', COUNT(*) FROM quiz_results
UNION ALL
SELECT 'contacts', COUNT(*) FROM contacts
UNION ALL
SELECT 'jobs', COUNT(*) FROM jobs;
```

### View table structure
```sql
DESCRIBE users;
SHOW CREATE TABLE users;
```

### View appointments with details
```sql
SELECT 
    a.id,
    p.name as patient_name,
    u.name as doctor_name,
    a.date,
    a.time,
    a.type,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.id
JOIN users u ON a.doctor_id = u.id
ORDER BY a.date DESC;
```

### View prescriptions with patient info
```sql
SELECT 
    pr.id,
    p.name as patient_name,
    u.name as doctor_name,
    pr.medication,
    pr.dosage,
    pr.frequency,
    pr.created_at
FROM prescriptions pr
JOIN patients p ON pr.patient_id = p.id
JOIN users u ON pr.doctor_id = u.id
ORDER BY pr.created_at DESC;
```

## 💾 Backup & Restore

### Backup
```bash
# Full backup
mysqldump -u root -p dementicare > backup.sql

# With timestamp
mysqldump -u root -p dementicare > backup_$(date +%Y%m%d_%H%M%S).sql

# Compressed backup
mysqldump -u root -p dementicare | gzip > backup.sql.gz
```

### Restore
```bash
# From SQL file
mysql -u root -p dementicare < backup.sql

# From compressed file
gunzip < backup.sql.gz | mysql -u root -p dementicare
```

### Automated Backup Script
```bash
#!/bin/bash
BACKUP_DIR="~/dementicare_backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
mysqldump -u root -p dementicare > $BACKUP_DIR/backup_$DATE.sql
echo "Backup created: $BACKUP_DIR/backup_$DATE.sql"
```

## 🧪 Testing

### Verify Schema
```sql
-- Check all tables exist
SELECT COUNT(*) as table_count 
FROM information_schema.tables 
WHERE table_schema = 'dementicare';
-- Should return 7

-- Check foreign keys
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dementicare'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### Verify Sample Data
```sql
SELECT 
    (SELECT COUNT(*) FROM users) as users,
    (SELECT COUNT(*) FROM patients) as patients,
    (SELECT COUNT(*) FROM appointments) as appointments,
    (SELECT COUNT(*) FROM prescriptions) as prescriptions,
    (SELECT COUNT(*) FROM quiz_results) as quiz_results,
    (SELECT COUNT(*) FROM contacts) as contacts,
    (SELECT COUNT(*) FROM jobs) as jobs;
```

## 🐛 Troubleshooting

### Can't connect to MySQL
```bash
# Check if MySQL is running
brew services list  # macOS
sudo systemctl status mysql  # Linux

# Start MySQL
brew services start mysql
```

### Access denied
```bash
# Reset root password
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
EXIT;
```

### Import errors
```bash
# Check MySQL version
mysql --version

# Verify file exists
ls -la database/schema.sql

# Import with verbose output
mysql -u root -p dementicare < database/schema.sql -v
```

### Foreign key constraint fails
```bash
# Temporarily disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;
-- Run your queries
SET FOREIGN_KEY_CHECKS = 1;
```

## 📚 Additional Resources

- **MySQL Documentation**: https://dev.mysql.com/doc/
- **MySQL Workbench Manual**: https://dev.mysql.com/doc/workbench/en/
- **GORM MySQL Guide**: https://gorm.io/docs/connecting_to_the_database.html#MySQL
- **SQL Tutorial**: https://www.mysqltutorial.org/

## 🔄 Migration from PostgreSQL

The system has been updated from PostgreSQL to MySQL. Key changes:

1. **Driver**: Changed from `gorm.io/driver/postgres` to `gorm.io/driver/mysql`
2. **DSN Format**: Updated connection string format
3. **Port**: Changed from 5432 to 3306
4. **Data Types**: JSON columns for flexible data storage
5. **Timestamps**: Using MySQL TIMESTAMP with auto-update

## 📞 Support

For database-related issues:
1. Check MySQL error logs
2. Verify connection settings in `backend/.env`
3. Test connection in MySQL Workbench
4. Review [MYSQL_SETUP.md](MYSQL_SETUP.md) for detailed troubleshooting

---

**Database Version**: MySQL 8.0  
**Character Set**: utf8mb4  
**Collation**: utf8mb4_unicode_ci  
**Engine**: InnoDB
