# DementiCare Go Backend API

A microservice backend for DementiCare web application built with Go, Gin framework, and MySQL database.

## 🚀 Features

- **JWT Authentication**: Secure token-based authentication with bcrypt password hashing
- **Role-Based Access**: Patient, Doctor, Caregiver, and Admin user types
- **Patient Management**: CRUD operations for patient medical records
- **Smart Appointments**: Patients book with doctors, auto-assigned patient_id from JWT
- **Prescriptions**: Digital prescription management
- **Cognitive Assessments**: Quiz system with JSON storage
- **Job Board**: Healthcare job postings with full CRUD
- **ML Integration**: Doctor recommendation via Python Flask service
- **CORS Support**: Configured for cross-origin requests

## 📋 Prerequisites

- **Go**: 1.21 or higher
- **MySQL**: 8.0+ or MariaDB 10.5+
- **Python**: 3.8+ (for ML service)

## 🔧 Setup

### 1. Database Setup

Create MySQL database using the provided schema:

```bash
# Using MySQL command line
mysql -u root -p < ../../database/schema_final.sql

# Or using MySQL Workbench
# Open and execute: database/schema_final.sql
```

This creates:
- 7 tables (users, patients, appointments, prescriptions, quiz_results, contacts, jobs)
- Sample data with test accounts (password: `password123`)

### 2. Environment Configuration

Create `.env` file in the backend directory:

```bash
PORT=8080
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=dementicare
JWT_SECRET=your-secret-key-here-change-this
ML_SERVICE_URL=http://localhost:5001
```

**Important**: Change `JWT_SECRET` to a strong random string!

### 3. Install Dependencies

```bash
go mod download
```

### 4. Run the Server

```bash
go run main.go
```

Server starts on `http://localhost:8080`

## 🌐 API Endpoints

### Authentication (Public)
- `POST /auth/register` - Register new user
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe",
    "user_type": "patient",
    "phone": "+1-555-0123"
  }
  ```
- `POST /auth/login` - User login
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- `POST /auth/user/login` - Alternative login endpoint

### Authentication (Protected)
- `POST /auth/change-password` - Change password
  ```json
  {
    "old_password": "current123",
    "new_password": "newpass123"
  }
  ```

### Doctors
- `GET /api/doctors` - Get list of doctors (for appointment booking dropdown)
  - Returns: `{"doctors": [{id, email, name, phone}]}`

### Appointments (Protected)
- `GET /api/appointments` - Get appointments (filtered by user role)
  - **Doctors**: See appointments booked with them
  - **Patients**: See their own appointments
  - **Admin/Caregiver**: See all appointments
  - Returns: Patient and doctor names (not just IDs)
  
- `GET /api/appointments/:id` - Get single appointment
- `POST /api/appointments` - Create appointment (patients only)
  - Backend auto-assigns `patient_id` from JWT token
  ```json
  {
    "doctor_id": 1,
    "date": "2026-02-20T10:00:00Z",
    "time": "10:00",
    "type": "Consultation",
    "status": "pending",
    "notes": "Optional notes"
  }
  ```
- `PUT /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Delete appointment

### Patients (Protected)
- `GET /api/patients` - Get all patients
- `GET /api/patients/:id` - Get patient by ID
- `POST /api/patients` - Create patient record
- `PUT /api/patients/:id` - Update patient
- `DELETE /api/patients/:id` - Delete patient

### Prescriptions (Protected)
- `GET /api/prescriptions` - Get all prescriptions
- `GET /api/prescriptions/:id` - Get prescription by ID
- `POST /api/prescriptions` - Create prescription
- `PUT /api/prescriptions/:id` - Update prescription
- `DELETE /api/prescriptions/:id` - Delete prescription

### Quiz Results (Protected)
- `GET /api/quiz/results` - Get quiz results
- `POST /api/quiz/results` - Save quiz result

### Jobs (Protected)
- `GET /api/jobs` - Get all jobs
- `GET /api/jobs/:id` - Get job by ID
- `POST /api/jobs` - Create job posting
- `PUT /api/jobs/:id` - Update job
- `DELETE /api/jobs/:id` - Delete job

### ML Doctor Recommendations (Protected)
- `POST /api/recommend-doctor` - Get ML-powered doctor recommendations
  - Proxies request to Python ML service on port 5001

### Contact (Public)
- `POST /contact` - Submit contact form

### Health Check (Public)
- `GET /health` - Server health status
  - Returns: `{"status": "ok"}`

## 🔐 Authentication

All protected endpoints require a JWT token in the Authorization header:

```bash
Authorization: Bearer <your-jwt-token>
```

**Getting a Token:**
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"doctor1@dementicare.com","password":"password123"}'
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "doctor1@dementicare.com",
    "user_type": "doctor",
    "name": "Dr. Sarah Johnson"
  },
  "message": "Login successful"
}
```

**Token Claims:**
- `user_id`: User ID
- `email`: User email
- `user_type`: Role (patient/doctor/caregiver/admin)
- `exp`: Expiration (7 days from issue)

## 📦 Project Structure

```
backend/
├── main.go              # Entry point, server setup
├── .env                 # Environment variables (not committed)
├── go.mod               # Go module dependencies
├── go.sum               # Dependency checksums
├── config/
│   └── database.go      # GORM MySQL connection
├── models/
│   ├── user.go          # User model
│   ├── patient.go       # Patient model
│   ├── appointment.go   # Appointment model
│   ├── prescription.go  # Prescription model
│   ├── quiz.go          # Quiz result model
│   ├── job.go           # Job model
│   └── contact.go       # Contact model
├── controllers/
│   ├── auth.go          # Registration, login, password change
│   ├── doctor.go        # Get doctors list
│   ├── patient.go       # Patient CRUD
│   ├── appointment.go   # Appointment CRUD with name joins
│   ├── prescription.go  # Prescription CRUD
│   ├── quiz.go          # Quiz result operations
│   ├── job.go           # Job posting CRUD
│   ├── contact.go       # Contact form handler
│   └── ml.go            # ML service proxy
├── routes/
│   └── routes.go        # Route definitions
└── middleware/
    └── auth.go          # JWT authentication middleware
```

## 🛠️ Tech Stack

- **Framework**: Gin v1.9.1
- **ORM**: GORM v1.30.0
- **Database Driver**: MySQL driver v1.6.0
- **Authentication**: golang-jwt/jwt/v5 v5.2.0
- **Password**: bcrypt (golang.org/x/crypto)
- **CORS**: gin-contrib/cors
- **Environment**: godotenv v1.5.1

## 🧪 Testing

### Test Health Endpoint
```bash
curl http://localhost:8080/health
```

### Test Authentication
```bash
# Register
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123!",
    "name": "Test User",
    "user_type": "patient",
    "phone": "+1-555-1234"
  }'

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!"}'
```

### Test Protected Endpoint
```bash
# Get appointments (requires token)
curl -X GET http://localhost:8080/api/appointments \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Test Accounts (from schema_final.sql)
All passwords: `password123`
- **Doctor**: doctor1@dementicare.com
- **Patient**: patient1@dementicare.com
- **Caregiver**: caregiver1@dementicare.com

## 🔄 Development

### Auto-reload with Air
```bash
# Install air
go install github.com/cosmtrek/air@latest

# Run with air
air
```

### Run Tests
```bash
go test ./...
```

### Build for Production
```bash
go build -o dementicare-api main.go
./dementicare-api
```

## 🐛 Troubleshooting

### Database Connection Failed
- Verify MySQL is running: `mysql.server status` (macOS) or `sudo service mysql status` (Linux)
- Check credentials in `.env` file
- Test connection: `mysql -u root -p dementicare`

### Port Already in Use
- Check what's using port 8080: `lsof -i :8080`
- Kill the process or change `PORT` in `.env`

### JWT Token Invalid
- Token expires after 7 days
- Re-login to get a new token
- Check `JWT_SECRET` matches across restarts

### Appointment Creation Fails
- Only patients can create appointments
- Ensure user_type is "patient" in JWT token
- `patient_id` is auto-assigned from token, don't send it

### ML Service Connection Error
- ML service must be running on port 5001
- Check `ML_SERVICE_URL` in `.env`
- Verify: `curl http://localhost:5001/health`

## 📊 Database Schema

### Key Tables
1. **users** - All user accounts (doctors, patients, caregivers, admins)
2. **patients** - Additional patient medical data
3. **appointments** - Bookings between patients and doctors
4. **prescriptions** - Medical prescriptions
5. **quiz_results** - Cognitive assessment scores
6. **contacts** - Contact form submissions
7. **jobs** - Job postings

### Important Relationships
- `appointments.patient_id` → `users.id` (patient users)
- `appointments.doctor_id` → `users.id` (doctor users)
- `patients.user_id` → `users.id` (optional link)
- `patients.caregiver_id` → `users.id` (caregiver)

## 🚀 Deployment

### Environment Setup
```bash
# Production .env
PORT=8080
DB_HOST=your-db-host.com
DB_PORT=3306
DB_USER=production_user
DB_PASSWORD=strong_password_here
DB_NAME=dementicare_prod
JWT_SECRET=very-long-random-secret-key
ML_SERVICE_URL=http://ml-service:5001
```

### Using Docker (Optional)
```dockerfile
FROM golang:1.21-alpine
WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o main .
EXPOSE 8080
CMD ["./main"]
```

### Systemd Service (Linux)
```ini
[Unit]
Description=DementiCare Backend API
After=network.target mysql.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/dementicare/backend
ExecStart=/opt/dementicare/backend/dementicare-api
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

## 📝 API Response Formats

### Success Response
```json
{
  "appointments": [...],
  "patients": [...],
  "jobs": [...]
}
```

### Error Response
```json
{
  "error": "Error message here"
}
```

### Authentication Response
```json
{
  "token": "jwt-token",
  "user": {...},
  "message": "Login successful"
}
```

## 🔒 Security Best Practices

1. **Always use HTTPS in production**
2. **Change JWT_SECRET** to a strong random value
3. **Use environment variables** for sensitive data
4. **Enable rate limiting** for auth endpoints
5. **Regular security updates**: `go get -u ./...`
6. **Database backups**: Schedule regular MySQL dumps
7. **Log monitoring**: Track failed login attempts

## 📚 Additional Resources

- [Gin Framework Documentation](https://gin-gonic.com/docs/)
- [GORM Documentation](https://gorm.io/docs/)
- [JWT Best Practices](https://tools.ietf.org/html/rfc7519)
- [Go Security Checklist](https://github.com/Checkmarx/Go-SCP)

## 📄 License

MIT License - See LICENSE file for details

## 👥 Support

For issues or questions:
- Check main project README: `../README.md`
- Review database schema: `../database/schema_final.sql`
- Check frontend integration: `../Dementicare_Web/src/services/api.js`

---

**Part of the DementiCare platform - Making dementia care better through technology**
