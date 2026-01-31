# Dementicare Go Backend

A microservice backend for Dementicare web application built with Go, Gin framework, and PostgreSQL.

## Features

- **Authentication**: JWT-based authentication with user registration and login
- **Patient Management**: CRUD operations for patient records
- **Appointments**: Schedule and manage appointments
- **Prescriptions**: Manage medical prescriptions
- **Quiz System**: Store and retrieve cognitive assessment results
- **Job Listings**: Post and manage job opportunities
- **ML Integration**: Doctor recommendation using Python ML service

## Prerequisites

- Go 1.21 or higher
- PostgreSQL 12 or higher
- Python 3.8+ (for ML service)

## Setup

### 1. Database Setup

Create a PostgreSQL database:

```bash
createdb dementicare
```

### 2. Environment Variables

Copy the example environment file and update with your settings:

```bash
cp .env.example .env
```

Update the following variables in `.env`:
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `JWT_SECRET` (use a strong secret key)
- `ML_SERVICE_URL` (URL of the Python ML service)

### 3. Install Dependencies

```bash
go mod download
```

### 4. Run the Application

```bash
go run main.go
```

The server will start on port 8080 (or the port specified in `.env`).

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - User login
- `POST /auth/user/login` - Alternative login endpoint
- `POST /auth/change-password` - Change password (requires auth)

### Patients (Protected)
- `GET /api/patients` - Get all patients
- `GET /api/patients/:id` - Get patient by ID
- `POST /api/patients` - Create patient
- `PUT /api/patients/:id` - Update patient
- `DELETE /api/patients/:id` - Delete patient

### Appointments (Protected)
- `GET /api/appointments` - Get all appointments
- `GET /api/appointments/:id` - Get appointment by ID
- `POST /api/appointments` - Create appointment
- `PUT /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Delete appointment

### Prescriptions (Protected)
- `GET /api/prescriptions` - Get all prescriptions
- `GET /api/prescriptions/:id` - Get prescription by ID
- `POST /api/prescriptions` - Create prescription
- `PUT /api/prescriptions/:id` - Update prescription
- `DELETE /api/prescriptions/:id` - Delete prescription

### Quiz (Protected)
- `GET /api/quiz/results` - Get quiz results
- `POST /api/quiz/results` - Save quiz result

### Jobs (Protected)
- `GET /api/jobs` - Get all jobs
- `GET /api/jobs/:id` - Get job by ID
- `POST /api/jobs` - Create job
- `PUT /api/jobs/:id` - Update job
- `DELETE /api/jobs/:id` - Delete job

### Doctor Recommendation (Protected)
- `POST /api/recommend-doctor` - Get doctor recommendations from ML service

### Contact (Public)
- `POST /contact` - Submit contact form

## Authentication

Protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## ML Service Integration

The backend connects to the Python ML service for doctor recommendations. Make sure the ML service is running on the URL specified in `ML_SERVICE_URL`.

## Development

Run with auto-reload (requires air):

```bash
# Install air
go install github.com/cosmtrek/air@latest

# Run with air
air
```

## Testing

```bash
go test ./...
```
