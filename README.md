# DementiCare - Dementia Care Management System

A comprehensive dementia care management platform with Go backend microservices, MySQL database, and ML-powered doctor recommendations.

## 🏗️ Architecture

- **Frontend**: React.js (Port 3000)
- **Backend**: Go with Gin framework (Port 8080)
- **ML Service**: Python Flask (Port 5001)
- **Database**: MySQL / MariaDB (Port 3306)

## 🚀 Quick Start

### Prerequisites
- Go 1.21+
- Node.js 18+
- MySQL 8.0 or MariaDB 10.5+
- Python 3.8+

### Setup Instructions

**1. Database Setup**
```bash
# Create database using MySQL Workbench or command line
mysql -u root -p < database/schema_final.sql
```

**2. Backend Setup**
```bash
cd backend
go mod download
# Configure .env file (see backend/.env.example)
go run main.go
```

**3. ML Service Setup**
```bash
cd Docter_recommendation-
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python3 app.py
```

**4. Frontend Setup**
```bash
cd Dementicare_Web
npm install
npm start
```

### Default Test Accounts
After running `schema_final.sql`, use these accounts (password: `password123`):
- **Doctor**: doctor1@dementicare.com
- **Patient**: patient1@dementicare.com
- **Caregiver**: caregiver1@dementicare.com

## 📁 Project Structure

```
Dementi/
├── backend/               # Go microservice backend
│   ├── main.go           # Entry point
│   ├── .env              # Environment configuration
│   ├── config/           # Database configuration
│   ├── models/           # Data models (User, Patient, Appointment, etc.)
│   ├── controllers/      # API controllers (auth, appointment, patient, etc.)
│   ├── routes/           # API route definitions
│   └── middleware/       # Auth JWT middleware
├── Dementicare_Web/      # React frontend
│   └── src/
│       ├── Auth/         # Login, Register, ChangePassword
│       ├── components/   # Dashboard, AppointmentType, DoctorsZone, etc.
│       ├── services/     # API service layer (axios)
│       └── pages/        # Page components
├── Docter_recommendation-/  # Python ML service
│   ├── app.py           # Flask application (Port 5001)
│   ├── docter.py        # ML recommendation logic
│   └── doctor.csv       # Doctor dataset
├── database/
│   ├── schema_final.sql # Complete database schema with sample data
│   └── schema.sql       # Original schema
└── README.md
```

## 🔑 Key Features

### User Management
- **JWT Authentication**: Secure token-based authentication with 7-day expiry
- **User Types**: Doctor, Patient, Caregiver, Admin
- **Registration**: Clean registration form without unnecessary fields
- **Password Security**: Bcrypt hashing with salt

### Appointment System
- **Patient Booking**: Patients select doctor from dropdown and book appointments
- **Doctor Dropdown**: Shows doctor names (not IDs) during booking
- **Auto Patient Assignment**: Backend automatically assigns patient_id from JWT token
- **View Permissions**: 
  - Doctors see appointments booked with them
  - Patients see their own appointments
  - Admin/Caregiver see all appointments
- **Status Management**: Pending, Confirmed, Completed, Cancelled
- **Dashboard**: Real-time appointment display with names (not IDs)

### Patient Management
- Comprehensive patient records
- Medical history tracking
- Diagnosis information
- Caregiver assignment

### Prescriptions
- Digital prescription management
- Medication tracking
- Dosage and frequency information

### Cognitive Assessments
- Quiz-based dementia screening
- Score tracking over time
- JSON-based answer storage

### ML Doctor Recommendations
- KNN-based doctor matching
- Based on rating and experience
- Python Flask service integration

### Job Board
- Healthcare job listings
- Caregiver opportunities
- Full CRUD operations

### Contact System
- Patient inquiry forms
- Status tracking (new, read, replied)

## 🛠️ Technology Stack

### Backend (Go)
- **Framework**: Gin v1.9.1
- **ORM**: GORM v1.30.0
- **Database Driver**: MySQL driver v1.6.0
- **Authentication**: golang-jwt/jwt/v5 v5.2.0
- **Password Hashing**: bcrypt
- **CORS**: gin-contrib/cors

### Frontend (React)
- **React**: 18.2.0
- **Router**: React Router v6
- **UI Framework**: React Bootstrap, Material-UI
- **HTTP Client**: Axios
- **State Management**: React Hooks
- **Date/Time**: HTML5 date and time pickers

### ML Service (Python)
- **Framework**: Flask
- **ML Library**: Scikit-learn 1.8.0
- **Data Processing**: Pandas, NumPy
- **Algorithm**: K-Nearest Neighbors (KNN)
- **Port**: 5001 (moved from 5000 to avoid macOS AirPlay conflict)

### Database (MySQL)
- **MySQL**: 8.0+ or MariaDB 10.5+
- **Character Set**: utf8mb4
- **Collation**: utf8mb4_unicode_ci
- **Engine**: InnoDB
- **Tables**: 7 (users, patients, appointments, prescriptions, quiz_results, contacts, jobs)

## 📚 Documentation

- **Database Schema**: [database/schema_final.sql](database/schema_final.sql) - Complete schema with sample data
- **Sample Data**: 5 users, 2 patients, 5 appointments, 2 prescriptions, 2 quiz results, 2 jobs
- **API Documentation**: See API Endpoints section above
- **Environment Setup**: See Quick Start section

## 📦 Dependencies

### Backend Go Modules
```
require (
    github.com/gin-contrib/cors v1.7.3
    github.com/gin-gonic/gin v1.9.1
    github.com/golang-jwt/jwt/v5 v5.2.0
    github.com/joho/godotenv v1.5.1
    golang.org/x/crypto v0.31.0
    gorm.io/driver/mysql v1.6.0
    gorm.io/gorm v1.30.0
)
```

### Frontend NPM Packages
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.0.0",
    "react-bootstrap": "^2.0.0",
    "@mui/material": "^5.0.0",
    "axios": "^1.0.0",
    "reactjs-popup": "^2.0.0"
  }
}
```

### Python Requirements
```
Flask==3.1.0
scikit-learn==1.8.0
pandas==2.2.3
numpy==2.2.1
flask-cors==5.0.0
```

## 🔐 Security

- **JWT Authentication**: Token-based auth with 7-day expiration
- **Password Hashing**: Bcrypt with cost factor 10
- **CORS Protection**: Configured for development and production
- **SQL Injection Prevention**: GORM parameterized queries
- **Environment Variables**: Sensitive data in .env files (not committed)
- **Authorization**: Role-based access control (patient, doctor, caregiver, admin)
- **Input Validation**: Request validation on all endpoints

## 🏛️ Database Schema

### Tables
1. **users** - All user accounts (doctors, patients, caregivers)
2. **patients** - Additional patient medical data
3. **appointments** - Appointment bookings (patient_id and doctor_id link to users)
4. **prescriptions** - Medical prescriptions
5. **quiz_results** - Cognitive assessment scores
6. **contacts** - Contact form submissions
7. **jobs** - Healthcare job postings

### Key Relationships
- `appointments.patient_id` → `users.id` (patients)
- `appointments.doctor_id` → `users.id` (doctors)
- `patients.caregiver_id` → `users.id` (caregivers)
- `prescriptions.patient_id` → `patients.id`
- `prescriptions.doctor_id` → `users.id`

## 📊 Features Implementation

### Appointment Architecture
- ✅ **Only patients can book appointments**
- ✅ Backend automatically assigns `patient_id` from JWT token
- ✅ Frontend shows doctor names in dropdown (not IDs)
- ✅ Dashboard displays patient and doctor names (not IDs)
- ✅ Doctors view appointments booked with them
- ✅ Patients view their own appointments
- ✅ Auto-refresh dashboard every 30 seconds
- ✅ Color-coded status badges
- ✅ Manual refresh button with count badge

### Registration
- ✅ Clean form without unnecessary fields
- ✅ Fields: Email, Name, Phone, User Type, Password
- ✅ No ID fields or redundant information
- ✅ Dropdown for user type selection (Patient/Doctor/Caregiver)

## 🌐 API Endpoints

### Authentication (Public)
- `POST /auth/register` - User registration (email, name, password, user_type, phone)
- `POST /auth/login` - User login (returns JWT token)
- `POST /auth/user/login` - Alternative login endpoint

### Authentication (Protected)
- `POST /auth/change-password` - Change user password

### Appointments
- `GET /api/appointments` - Get appointments (filtered by user role)
- `GET /api/appointments/:id` - Get single appointment
- `POST /api/appointments` - Create appointment (patient only)
- `PUT /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Delete appointment

### Patients
- `GET /api/patients` - List all patients
- `GET /api/patients/:id` - Get patient details
- `POST /api/patients` - Create patient record
- `PUT /api/patients/:id` - Update patient
- `DELETE /api/patients/:id` - Delete patient

### Doctors
- `GET /api/doctors` - Get list of doctors (for appointment booking dropdown)

### Prescriptions
- `GET /api/prescriptions` - List prescriptions
- `GET /api/prescriptions/:id` - Get prescription details
- `POST /api/prescriptions` - Create prescription
- `PUT /api/prescriptions/:id` - Update prescription
- `DELETE /api/prescriptions/:id` - Delete prescription

### Quiz Results
- `GET /api/quiz/results` - Get all quiz results
- `POST /api/quiz/results` - Save quiz result

### Jobs
- `GET /api/jobs` - List all jobs
- `GET /api/jobs/:id` - Get job details
- `POST /api/jobs` - Create job posting
- `PUT /api/jobs/:id` - Update job
- `DELETE /api/jobs/:id` - Delete job

### ML Recommendations
- `POST /api/recommend-doctor` - Get ML-powered doctor recommendations

### Contact (Public)
- `POST /contact` - Submit contact form

### Health Check (Public)
- `GET /health` - Backend health status

## 🚀 Deployment

### Development Mode
```bash
# Terminal 1: Start MySQL (if not running)
mysql.server start  # macOS
# or sudo service mysql start  # Linux

# Terminal 2: Go Backend
cd backend
go run main.go
# Server starts on http://localhost:8080

# Terminal 3: ML Service
cd Docter_recommendation-
source venv/bin/activate
python3 app.py
# Server starts on http://localhost:5001

# Terminal 4: React Frontend
cd Dementicare_Web
npm start
# App opens at http://localhost:3000
```

### Production Build
```bash
# Build Go binary
cd backend
go build -o dementicare-api main.go
./dementicare-api

# Build React production bundle
cd Dementicare_Web
npm run build
# Deploy 'build' folder to your hosting service

# Run ML service with gunicorn
cd Docter_recommendation-
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5001 app:app
```

### Environment Variables

**Backend (.env)**
```env
PORT=8080
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=dementicare
JWT_SECRET=your-secret-key-here
ML_SERVICE_URL=http://localhost:5001
```

**Frontend (.env)**
```env
REACT_APP_API_URL=http://localhost:8080
REACT_APP_ML_URL=http://localhost:5001
```

## 🧪 Testing

### Backend Health Check
```bash
curl http://localhost:8080/health
# Expected: {"status":"ok"}
```

### ML Service Health Check
```bash
curl http://localhost:5001/health
# Expected: {"status":"healthy"}
```

### Test Login
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"doctor1@dementicare.com","password":"password123"}'
# Expected: {"token":"<jwt_token>","user":{...},"message":"Login successful"}
```

### Test Appointment Creation
```bash
curl -X POST http://localhost:8080/api/appointments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "doctor_id": 1,
    "date": "2026-02-20T10:00:00Z",
    "time": "10:00",
    "type": "Consultation",
    "status": "pending",
    "notes": "Test appointment"
  }'
```

### Frontend
```bash
# Open browser and test
open http://localhost:3000

# Test accounts (password: password123)
# - doctor1@dementicare.com
# - patient1@dementicare.com
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🔧 Troubleshooting

### Backend won't start
- Check MySQL is running: `mysql.server status`
- Verify .env configuration
- Check port 8080 is not in use: `lsof -i :8080`

### ML Service Error (Port 5000)
- Port 5000 conflicts with macOS AirPlay
- We use port 5001 instead
- Update `.env` if needed: `ML_SERVICE_URL=http://localhost:5001`

### Login fails with "Invalid email or password"
- Verify database has sample data: `SELECT * FROM users;`
- Password for all test accounts: `password123`
- Check backend logs for bcrypt comparison errors

### Appointments not showing
- Restart backend after database changes
- Check browser console for API errors
- Verify JWT token in localStorage
- Use dashboard refresh button

### Foreign Key Constraint Errors
- Run complete `schema_final.sql` script (includes `SET FOREIGN_KEY_CHECKS=0;`)
- Don't run CREATE TABLE statements individually

## 🔄 Recent Changes

### v2.0 - Complete Rewrite (January 2026)
- ✅ **Migrated from Firebase to Go backend**
- ✅ Changed from PostgreSQL to MySQL for Workbench compatibility
- ✅ Integrated Python ML service for doctor recommendations
- ✅ Implemented JWT authentication with bcrypt
- ✅ Created complete RESTful API (8 controllers, 7 models)
- ✅ Fixed appointment architecture (patient_id from JWT, doctor selection)
- ✅ Removed all Firebase dependencies
- ✅ Added comprehensive logging for debugging
- ✅ Updated frontend to use backend API throughout
- ✅ Enhanced dashboard with real-time updates
- ✅ Moved ML service from port 5000 to 5001
- ✅ Cleaned registration form (removed unnecessary fields)
- ✅ Added doctor/patient names to UI (removed ID displays)

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contact & Support

For questions, issues, or feature requests:
- Open an issue on GitHub
- Check existing documentation in `/database` folder
- Review API endpoints in this README

---

**Made with ❤️ for better dementia care**
