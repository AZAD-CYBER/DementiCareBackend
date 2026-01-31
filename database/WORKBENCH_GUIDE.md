# MySQL Workbench Visual Guide

## Opening MySQL Workbench

After installation, you'll see the main screen:

![MySQL Workbench Home]

## Creating a New Connection

1. Click the **[+]** button next to "MySQL Connections"

2. Fill in the connection details:
   ```
   Connection Name: Dementicare Local
   Connection Method: Standard (TCP/IP)
   Hostname: localhost
   Port: 3306
   Username: root
   Password: [Click "Store in Keychain/Vault"]
   ```

3. Click **[Test Connection]** - should show "Successfully made the MySQL connection"

4. Click **[OK]** to save

## Connecting and Running Schema

1. **Double-click** the "Dementicare Local" connection

2. You'll see the main SQL editor window

3. Click **File → Open SQL Script**
   - Navigate to: `/Users/azadansari/Programming/Dementi/database/schema.sql`
   - Click **Open**

4. The SQL script will appear in the editor

5. Click the **lightning bolt icon** (⚡) or press **Cmd+Shift+Enter**

6. Wait for "Action Output" panel to show completion

## Viewing the Database

In the left **Navigator** panel:

1. Click **Schemas** tab
2. Find **dementicare** database
3. Click the **▶** arrow to expand
4. You'll see **Tables** folder
5. Expand **Tables** to see all 7 tables:
   - appointments
   - contacts  
   - jobs
   - patients
   - prescriptions
   - quiz_results
   - users

## Viewing Table Structure

Right-click any table → Select **Table Inspector**

You'll see:
- **Info**: Basic table information
- **Columns**: All columns with data types
- **Indexes**: Table indexes
- **Foreign Keys**: Relationships
- **Triggers**: (if any)

## Viewing Table Data

1. Right-click a table
2. Select **Select Rows - Limit 1000**
3. Data appears in the **Result Grid** at bottom

Or use SQL:
```sql
USE dementicare;
SELECT * FROM users;
```

## Running Queries

### Creating a New Query Tab

- Click **File → New Query Tab** (or Cmd+T)
- Type your SQL
- Click **⚡ Execute** (or Cmd+Enter)

### Example Queries

```sql
-- Use the database
USE dementicare;

-- View all users
SELECT * FROM users;

-- Count patients
SELECT COUNT(*) as total_patients FROM patients;

-- View appointments with patient names
SELECT 
    a.id,
    p.name as patient_name,
    a.date,
    a.time,
    a.type,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.id
ORDER BY a.date DESC;

-- View prescriptions with patient names
SELECT 
    pr.id,
    p.name as patient_name,
    pr.medication,
    pr.dosage,
    pr.frequency
FROM prescriptions pr
JOIN patients p ON pr.patient_id = p.id;
```

## Creating Entity Relationship Diagram (ERD)

1. Click **Database** menu
2. Select **Reverse Engineer...**
3. Select your connection → **Next**
4. Enter password → **Next**  
5. Select **dementicare** database → **Next**
6. Select all tables → **Execute**
7. Click **Next** through remaining screens
8. Click **Close**

You'll see a visual diagram showing:
- All tables as boxes
- Relationships as lines between tables
- Primary keys highlighted
- Foreign keys with connecting lines

## Exporting Data

1. Click **Server** → **Data Export**
2. Select **dementicare** database
3. Select tables to export
4. Choose export format:
   - **Export to Dump Project Folder**: Separate files for each table
   - **Export to Self-Contained File**: Single SQL file
5. Check **Include Create Schema**
6. Click **Start Export**

## Importing Data

1. Click **Server** → **Data Import**
2. Choose **Import from Self-Contained File**
3. Browse to your SQL file
4. Select **dementicare** as Default Target Schema
5. Click **Start Import**

## Color Coding in MySQL Workbench

- **Blue keywords**: SQL keywords (SELECT, FROM, WHERE)
- **Green**: String values
- **Orange**: Numbers
- **Red**: Comments
- **Purple**: System functions

## Useful Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|--------|-------|---------------|
| New Query Tab | Cmd+T | Ctrl+T |
| Execute Query | Cmd+Enter | Ctrl+Enter |
| Execute All | Cmd+Shift+Enter | Ctrl+Shift+Enter |
| Comment Line | Cmd+/ | Ctrl+/ |
| Format Query | Cmd+B | Ctrl+B |
| Auto-complete | Tab | Tab |

## Table Icons in Navigator

- 🔑 Gold key icon: Primary Key column
- 🔗 Blue diamond: Foreign Key relationship
- 📊 Table icon: Regular table
- ⚡ Lightning: Index
- 🔍 Magnifying glass: View

## Common Tasks

### Add New User (Example)

```sql
INSERT INTO users (email, password, user_type, name, phone)
VALUES ('newdoctor@dementicare.com', 'hashed_password', 'doctor', 'Dr. New Doctor', '+1-555-9999');
```

### Update Patient

```sql
UPDATE patients 
SET diagnosis = 'Updated diagnosis'
WHERE id = 1;
```

### Delete Record (Soft delete - sets deleted_at)

```sql
UPDATE appointments 
SET deleted_at = NOW()
WHERE id = 5;
```

### View Record Count per Table

```sql
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
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

## Performance Monitor

1. Click **Performance** icon in left sidebar
2. View:
   - Connection status
   - Query statistics
   - Server health
   - InnoDB status

## Backup Database

### Using MySQL Workbench UI

1. Click **Server** → **Data Export**
2. Select **dementicare**
3. Select **Export to Self-Contained File**
4. Choose location: `dementicare_backup_[date].sql`
5. Check **Include Create Schema**
6. Click **Start Export**

### Using Command Line (Faster)

```bash
mysqldump -u root -p dementicare > ~/Desktop/dementicare_backup.sql
```

## Restore Database

### Using MySQL Workbench UI

1. Click **Server** → **Data Import**
2. Select **Import from Self-Contained File**
3. Browse to backup file
4. Default Target Schema: **dementicare**
5. Click **Start Import**

### Using Command Line

```bash
mysql -u root -p dementicare < ~/Desktop/dementicare_backup.sql
```

## Tips for Large Datasets

1. **Limit Results**: Always use LIMIT in SELECT queries
   ```sql
   SELECT * FROM appointments LIMIT 100;
   ```

2. **Use Indexes**: Check if queries use indexes
   ```sql
   EXPLAIN SELECT * FROM appointments WHERE patient_id = 1;
   ```

3. **Filter Early**: Use WHERE clauses to reduce result set
   ```sql
   SELECT * FROM patients WHERE caregiver_id = 3;
   ```

## Getting Help

- **MySQL Workbench Help**: Press F1 or Help menu
- **SQL Reference**: Right-click in editor → SQL Additions
- **Online Docs**: https://dev.mysql.com/doc/workbench/en/

## Next Steps After Setup

1. ✅ Connect to database
2. ✅ Run schema.sql
3. ✅ View tables and structure
4. ✅ Run sample queries
5. ⏭️ Import sample_data.sql
6. ⏭️ Create backup schedule
7. ⏭️ Start using with Go backend

Happy database management! 🗄️
