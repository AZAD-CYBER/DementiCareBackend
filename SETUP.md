# Dementicare - Complete Setup Guide

This project has been migrated from Firebase to a Go backend microservice architecture with ML integration.

## Architecture

```
┌─────────────────────┐
│   React Frontend    │ (Port 3000)
│  Dementicare_Web    │
└──────────┬──────────┘
           │
           ├─────────────────────────────┐
           │                             │
           ▼                             ▼
┌─────────────────────┐      ┌──────────────────────┐
│   Go Backend API    │      │  Python ML Service   │
│   (Port 8080)       │─────▶│  (Port 5000)         │
└──────────┬──────────┘      └──────────────────────┘
           │
           ▼
┌─────────────────────┐
│    PostgreSQL DB    │
│    (Port 5432)      │
└─────────────────────┘
```

## Prerequisites

- **Go**: 1.21 or higher
- **Node.js**: 16.x or higher
- **PostgreSQL**: 12 or higher
- **Python**: 3.8 or higher

## Setup Instructions

### 1. Database Setup

```bash
# Install PostgreSQL (macOS)
brew install postgresql@14
brew services start postgresql@14

# Create database
createdb dementicare

# Or use psql
psql postgres
CREATE DATABASE dementicare;
\q
```

### 2. Go Backend Setup

```bash
# Navigate to backend directory
cd Dementi/backend

# Copy environment file
cp .env.example .env

# Edit .env with your database credentials
nano .env

# Install Go dependencies
go mod download

# Run database migrations (automatic on first run)
go run main.go
```

The Go backend will:
- Start on port 8080
- Auto-migrate database tables
- Provide REST API endpoints
- Connect to ML service

### 3. Python ML Service Setup

```bash
# Navigate to ML service directory
cd Dementi/Docter_recommendation-

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run ML service
python3 app.py
```

The ML service will:
- Start on port 5000
- Provide doctor recommendation endpoint
- Process ML requests from Go backend

### 4. React Frontend Setup

```bash
# Navigate to frontend directory
cd Dementi/Dementicare_Web

# Remove Firebase dependency and reinstall
npm uninstall firebase
npm install

# Copy environment file
cp .env.example .env

# Start React app
npm start
```

The React app will:
- Start on port 3000
- Connect to Go backend on port 8080
- Use new API service instead of Firebase

## Running the Complete System

You need to run all three services:

### Terminal 1 - PostgreSQL
```bash
# Make sure PostgreSQL is running
brew services start postgresql@14
```

### Terminal 2 - Go Backend
```bash
cd Dementi/backend
go run main.go
```

### Terminal 3 - Python ML Service
```bash
cd Dementi/Docter_recommendation-
source venv/bin/activate
python3 app.py
```

### Terminal 4 - React Frontend
```bash
cd Dementi/Dementicare_Web
npm start
```

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - User login
- `POST /auth/change-password` - Change password (protected)

### Patients (Protected)
- `GET /api/patients` - List all patients
- `POST /api/patients` - Create patient
- `PUT /api/patients/:id` - Update patient
- `DELETE /api/patients/:id` - Delete patient

### Appointments (Protected)
- `GET /api/appointments` - List appointments
- `POST /api/appointments` - Create appointment
- `PUT /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Delete appointment

### Prescriptions (Protected)
- `GET /api/prescriptions` - List prescriptions
- `POST /api/prescriptions` - Create prescription
- `PUT /api/prescriptions/:id` - Update prescription
- `DELETE /api/prescriptions/:id` - Delete prescription

### ML Service (Protected)
- `POST /api/recommend-doctor` - Get doctor recommendations

### Contact (Public)
- `POST /contact` - Submit contact form

## Environment Variables

### Go Backend (.env)
```
PORT=8080
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=dementicare
JWT_SECRET=your-super-secret-jwt-key
ML_SERVICE_URL=http://localhost:5000
```

### React Frontend (.env)
```
REACT_APP_API_URL=http://localhost:8080
REACT_APP_ML_URL=http://localhost:5000
```

## Migration from Firebase

The following changes were made:

1. **Authentication**: JWT-based auth replaced Firebase Auth
2. **Database**: PostgreSQL replaced Firestore
3. **API**: RESTful Go backend replaced Firebase SDK calls
4. **ML Integration**: Python service integrated via Go backend

### Files Modified
- `src/Auth/Login.js` - Uses API service
- `src/Auth/Registration.js` - Uses API service
- `src/Auth/ChangePassword.js` - Uses API service
- `src/pages/ContactUs.js` - Uses API service
- `src/firebase.js` - Deprecated (stub only)
- `package.json` - Firebase removed

### New Files Created
- `src/services/api.js` - API service for all backend calls
- `backend/` - Complete Go microservice
- `Docter_recommendation-/requirements.txt` - Python dependencies

## Testing

### Test Go Backend
```bash
# Health check
curl http://localhost:8080/health

# Register user
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","user_type":"doctor","name":"Test User"}'

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Test ML Service
```bash
# Health check
curl http://localhost:5000/health

# Recommend doctor
curl -X POST http://localhost:5000/recommend \
  -H "Content-Type: application/json" \
  -d '{"location":1,"experience":5}'
```

## Troubleshooting

### Database Connection Error
- Ensure PostgreSQL is running: `brew services list`
- Check database exists: `psql -l`
- Verify credentials in backend/.env

### Port Already in Use
```bash
# Find process using port
lsof -i :8080  # or :5000, :3000

# Kill process
kill -9 <PID>
```

### Go Dependencies Issues
```bash
cd backend
rm go.sum
go mod tidy
go mod download
```

### Python ML Service Errors
```bash
# Reinstall dependencies
pip install --upgrade -r requirements.txt

# Check if model.pkl exists
ls -la model.pkl
```

## Development

### Auto-reload Go Backend
```bash
# Install air
go install github.com/cosmtrek/air@latest

# Run with air
cd backend
air
```

### React Development
```bash
cd Dementicare_Web
npm start
```

## Production Deployment

### Backend
```bash
cd backend
go build -o dementicare-api main.go
./dementicare-api
```

### Frontend
```bash
cd Dementicare_Web
npm run build
# Deploy build/ folder to hosting service
```

### Database
- Use managed PostgreSQL service (AWS RDS, DigitalOcean, etc.)
- Update connection string in .env

## Security Notes

- ⚠️ Change JWT_SECRET in production
- ⚠️ Use strong database passwords
- ⚠️ Enable HTTPS in production
- ⚠️ Set CORS origins properly
- ⚠️ Never commit .env files

## Support

For issues or questions:
1. Check logs in each terminal
2. Verify all services are running
3. Check environment variables
4. Review API endpoints

## License

[Your License Here]
