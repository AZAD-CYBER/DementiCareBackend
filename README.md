# Dementicare System

A comprehensive dementia care management system with Go backend microservices and ML-powered doctor recommendations.

## 🏗️ Architecture

- **Frontend**: React.js (Port 3000)
- **Backend**: Go with Gin framework (Port 8080)
- **ML Service**: Python Flask (Port 5000)
- **Database**: PostgreSQL

## 🚀 Quick Start

### Option 1: Automated Setup

```bash
cd Dementi
./setup.sh
```

### Option 2: Manual Setup

See [SETUP.md](SETUP.md) for detailed instructions.

## 📁 Project Structure

```
Dementi/
├── backend/               # Go microservice backend
│   ├── main.go           # Entry point
│   ├── config/           # Database configuration
│   ├── models/           # Data models
│   ├── controllers/      # API controllers
│   ├── routes/           # API routes
│   └── middleware/       # Auth middleware
├── Dementicare_Web/      # React frontend
│   └── src/
│       ├── Auth/         # Authentication components
│       ├── components/   # React components
│       ├── services/     # API service layer
│       └── pages/        # Page components
├── Docter_recommendation-/  # Python ML service
│   ├── app.py           # Flask application
│   ├── model.pkl        # Trained ML model
│   └── doctor.csv       # Doctor data
└── docs/
    ├── SETUP.md         # Complete setup guide
    └── MIGRATION_GUIDE.md  # Firebase migration guide
```

## 🔑 Key Features

- **Authentication**: JWT-based secure authentication
- **Patient Management**: Comprehensive patient records
- **Appointments**: Schedule and manage appointments
- **Prescriptions**: Digital prescription management
- **Cognitive Assessments**: Quiz-based dementia screening
- **Doctor Recommendations**: ML-powered doctor matching
- **Job Listings**: Caregiver job board
- **Contact Forms**: Patient inquiry system

## 🛠️ Technology Stack

### Backend (Go)
- Gin Web Framework
- GORM (ORM)
- PostgreSQL Driver
- JWT Authentication
- CORS Support

### Frontend (React)
- React 18
- React Router
- React Bootstrap
- Material-UI
- Axios

### ML Service (Python)
- Flask
- Scikit-learn
- Pandas
- NumPy

## 📚 Documentation

- [Setup Guide](SETUP.md) - Complete installation instructions
- [Migration Guide](MIGRATION_GUIDE.md) - Firebase to Go backend migration
- [Backend API](backend/README.md) - API documentation

## 🔐 Security

- JWT-based authentication
- Password hashing with bcrypt
- CORS protection
- SQL injection prevention (GORM)
- Environment-based configuration

## 🌐 API Endpoints

### Public
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /contact` - Contact form

### Protected (Requires Authentication)
- `GET /api/patients` - List patients
- `POST /api/appointments` - Create appointment
- `GET /api/prescriptions` - List prescriptions
- `POST /api/quiz/results` - Save quiz results
- `POST /api/recommend-doctor` - ML recommendations

## 🚀 Deployment

### Development
```bash
# Terminal 1: Go Backend
cd backend && go run main.go

# Terminal 2: ML Service
cd Docter_recommendation- && source venv/bin/activate && python3 app.py

# Terminal 3: React Frontend
cd Dementicare_Web && npm start
```

### Production
```bash
# Build Go binary
cd backend && go build -o dementicare-api main.go

# Build React app
cd Dementicare_Web && npm run build

# Deploy to your hosting service
```

## 🧪 Testing

```bash
# Test Go backend
curl http://localhost:8080/health

# Test ML service
curl http://localhost:5000/health

# Test frontend
open http://localhost:3000
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

[Your License Here]

## 👥 Team

[Your Team Information]

## 📞 Support

For issues or questions, please refer to:
- [Setup Guide](SETUP.md)
- [Migration Guide](MIGRATION_GUIDE.md)

## 🔄 Recent Changes

- ✅ Migrated from Firebase to Go backend
- ✅ Integrated Python ML service for doctor recommendations
- ✅ Implemented JWT authentication
- ✅ Created RESTful API architecture
- ✅ Added PostgreSQL database
- ✅ Removed Firebase dependencies

---

Made with ❤️ for better dementia care
# DementiCare
