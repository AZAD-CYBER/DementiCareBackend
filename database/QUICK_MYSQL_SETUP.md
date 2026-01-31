# Quick Start: MySQL Setup for Dementicare

## Step 1: Install MySQL

### macOS
```bash
brew install mysql
brew services start mysql
```

### Set Root Password
```bash
mysql_secure_installation
# Follow prompts, set a strong root password
```

## Step 2: Create Database

```bash
# Connect to MySQL
mysql -u root -p
# Enter your root password
```

In MySQL prompt:
```sql
CREATE DATABASE dementicare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit;
```

## Step 3: Import Schema

```bash
cd /Users/azadansari/Programming/Dementi
mysql -u root -p dementicare < database/schema.sql
```

## Step 4: (Optional) Import Sample Data

```bash
mysql -u root -p dementicare < database/sample_data.sql
```

## Step 5: Configure Backend

1. Update backend/.env:
```bash
cd backend
cp .env.example .env
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
JWT_SECRET=your-super-secret-jwt-key
ML_SERVICE_URL=http://localhost:5000
```

## Step 6: Install MySQL Driver

```bash
cd /Users/azadansari/Programming/Dementi/backend
go mod tidy
go mod download
```

## Step 7: Start Backend

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

## Verify in MySQL Workbench

1. Open MySQL Workbench
2. Create connection:
   - Host: localhost
   - Port: 3306
   - User: root
   - Password: your_password
3. Connect and view dementicare database
4. You should see 7 tables

## Tables Created

1. **users** - User accounts (doctors, caregivers, patients)
2. **patients** - Patient records
3. **appointments** - Medical appointments
4. **prescriptions** - Medication prescriptions
5. **quiz_results** - Cognitive assessment results
6. **contacts** - Contact form submissions
7. **jobs** - Job listings

## Test Backend

```bash
# Health check
curl http://localhost:8080/health

# Should return: {"status":"ok"}
```

## Troubleshooting

### MySQL not running
```bash
brew services list
brew services restart mysql
```

### Can't connect to database
```bash
# Check MySQL is listening
sudo lsof -i :3306

# Test connection
mysql -u root -p -e "SHOW DATABASES;"
```

### Import errors
```bash
# Check MySQL version
mysql --version

# Verify database exists
mysql -u root -p -e "SHOW DATABASES LIKE 'dementicare';"
```

## Next Steps

1. ✅ MySQL installed
2. ✅ Database created
3. ✅ Schema imported
4. ✅ Backend configured
5. ⏭️ Start ML service
6. ⏭️ Start frontend

See MYSQL_SETUP.md for detailed MySQL Workbench instructions.
