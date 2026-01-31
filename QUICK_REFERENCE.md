# Dementicare Quick Reference

## 🚀 Quick Start Commands

### Setup (First Time)
```bash
cd /Users/azadansari/Programming/Dementi
./setup.sh
```

### Start All Services (Development)
```bash
# Terminal 1: Go Backend
cd backend && go run main.go

# Terminal 2: ML Service  
cd Docter_recommendation- && source venv/bin/activate && python3 app.py

# Terminal 3: Frontend
cd Dementicare_Web && npm start
```

### Start with Docker
```bash
cd /Users/azadansari/Programming/Dementi
docker-compose up -d
docker-compose logs -f  # View logs
```

## 🔗 URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **ML Service**: http://localhost:5000
- **Database**: localhost:5432

## 🔑 Default Credentials

### Database
- Host: localhost
- Port: 5432
- Database: dementicare
- User: postgres
- Password: (set in .env)

## 📡 API Quick Reference

### Auth (Public)
```bash
# Register
POST /auth/register
Body: { "email", "password", "user_type", "name" }

# Login
POST /auth/login  
Body: { "email", "password" }
Returns: { "token", "user" }
```

### Protected Endpoints
```bash
# Add header to all requests:
Authorization: Bearer <token>

# Patients
GET    /api/patients
POST   /api/patients
PUT    /api/patients/:id
DELETE /api/patients/:id

# Appointments
GET    /api/appointments
POST   /api/appointments
PUT    /api/appointments/:id
DELETE /api/appointments/:id

# Prescriptions
GET    /api/prescriptions
POST   /api/prescriptions

# Doctor Recommendation
POST   /api/recommend-doctor
Body: { "location": 1, "experience": 5 }
```

## 🛠️ Common Tasks

### Reset Database
```bash
dropdb dementicare
createdb dementicare
cd backend && go run main.go  # Auto-migrates
```

### Update Dependencies
```bash
# Go
cd backend && go mod tidy

# Python
cd Docter_recommendation- && pip install -r requirements.txt --upgrade

# React
cd Dementicare_Web && npm update
```

### View Logs
```bash
# Docker
docker-compose logs -f

# Specific service
docker-compose logs -f backend
```

### Rebuild Docker
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Find and kill process
lsof -i :8080  # or :5000, :3000
kill -9 <PID>
```

### Database Connection Error
```bash
# Check PostgreSQL is running
brew services list
brew services start postgresql@14

# Test connection
psql -U postgres -d dementicare
```

### Go Module Issues
```bash
cd backend
rm go.sum
go mod tidy
go mod download
```

### Python Virtual Environment
```bash
cd Docter_recommendation-
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### React Build Issues
```bash
cd Dementicare_Web
rm -rf node_modules package-lock.json
npm install
```

## 📝 Environment Variables

### backend/.env
```
PORT=8080
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=dementicare
JWT_SECRET=your-secret-key
ML_SERVICE_URL=http://localhost:5000
```

### Dementicare_Web/.env
```
REACT_APP_API_URL=http://localhost:8080
REACT_APP_ML_URL=http://localhost:5000
```

## 🧪 Testing

### Health Checks
```bash
curl http://localhost:8080/health
curl http://localhost:5000/health
```

### Test Registration
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123","user_type":"doctor","name":"Test"}'
```

### Test Login
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123"}'
```

## 📚 Documentation Files

- `README.md` - Main overview
- `SETUP.md` - Detailed setup guide
- `MIGRATION_GUIDE.md` - Component migration guide
- `MIGRATION_SUMMARY.md` - Complete migration summary
- `DOCKER.md` - Docker deployment guide
- `backend/README.md` - Backend API documentation

## 🔄 Component Migration

### Still Using Firebase (Need Migration):
1. src/Patients.js
2. src/App1.js  
3. src/Caregiver.js
4. src/Prescription.js
5. src/ScoreChart.js
6. src/components/Quiz.js
7. src/components/Dashboard/Dashboard.js
8. src/components/DoctorsZone/DoctorsZone.js
9. src/components/MainPage/MainPage.js
10. src/components/AppointmentType/AppointmentType.js

### Migration Pattern:
```javascript
// Remove
import { db } from './firebase';

// Add
import apiService from './services/api';

// Replace db calls with apiService methods
```

See MIGRATION_GUIDE.md for details.

## 🎯 Next Steps

1. ✅ Go backend created
2. ✅ PostgreSQL setup
3. ✅ ML service integrated
4. ✅ Auth components migrated
5. ⏳ Migrate remaining components
6. ⏳ Add tests
7. ⏳ Deploy to production

## 🆘 Get Help

1. Check logs: `docker-compose logs -f`
2. Verify services: `docker-compose ps`
3. Check environment: `cat .env`
4. Review docs in repo
5. Test endpoints: `curl http://localhost:8080/health`

---
Quick Reference v1.0 | Updated: Jan 31, 2026
