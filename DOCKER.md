# Docker Deployment Guide

This guide covers deploying Dementicare using Docker and Docker Compose.

## Prerequisites

- Docker 20.x or higher
- Docker Compose 2.x or higher

Install Docker Desktop for macOS:
```bash
brew install --cask docker
```

## Quick Start with Docker

### 1. Set Environment Variables

Create a `.env` file in the project root:

```bash
cd Dementi
cat > .env << EOF
DB_PASSWORD=your_secure_db_password
JWT_SECRET=your-super-secret-jwt-key-change-this
EOF
```

### 2. Build and Run

```bash
# Build all services
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 3. Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **ML Service**: http://localhost:5000
- **Database**: localhost:5432

### 4. Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v
```

## Services

### PostgreSQL (postgres)
- **Port**: 5432
- **Database**: dementicare
- **User**: postgres
- **Password**: Set via `DB_PASSWORD` environment variable
- **Data Volume**: `postgres_data`

### Go Backend (backend)
- **Port**: 8080
- **Dependencies**: PostgreSQL
- **Health Check**: `curl http://localhost:8080/health`

### Python ML Service (ml-service)
- **Port**: 5000
- **Health Check**: `curl http://localhost:5000/health`

### React Frontend (frontend)
- **Port**: 3000 (dev) or 80 (production)
- **Dependencies**: Backend, ML Service

## Development Mode

For development with hot-reload:

```bash
# Run only database in Docker
docker-compose up postgres -d

# Run backend locally
cd backend
go run main.go

# Run ML service locally
cd Docter_recommendation-
source venv/bin/activate
python3 app.py

# Run frontend locally
cd Dementicare_Web
npm start
```

## Production Deployment

### Using Docker Compose

```bash
# Build production images
docker-compose -f docker-compose.yml build

# Run in production mode
docker-compose -f docker-compose.yml up -d
```

### Using Docker Swarm

```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.yml dementicare

# List services
docker service ls

# View logs
docker service logs dementicare_backend
```

### Using Kubernetes

See `k8s/` directory for Kubernetes manifests.

## Environment Variables

### Backend
- `PORT`: Server port (default: 8080)
- `DB_HOST`: Database host
- `DB_PORT`: Database port
- `DB_USER`: Database user
- `DB_PASSWORD`: Database password
- `DB_NAME`: Database name
- `JWT_SECRET`: JWT signing secret
- `ML_SERVICE_URL`: ML service URL

### Frontend
- `REACT_APP_API_URL`: Backend API URL
- `REACT_APP_ML_URL`: ML service URL

## Database Migrations

Migrations run automatically on backend startup. To run manually:

```bash
# Access backend container
docker exec -it dementicare-backend sh

# Or run migrations command (if implemented)
./main migrate
```

## Backup and Restore

### Backup Database

```bash
# Create backup
docker exec dementicare-db pg_dump -U postgres dementicare > backup.sql

# Or with timestamp
docker exec dementicare-db pg_dump -U postgres dementicare > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database

```bash
# Restore from backup
docker exec -i dementicare-db psql -U postgres dementicare < backup.sql
```

## Monitoring

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend

# Last 100 lines
docker-compose logs --tail=100 backend
```

### Container Stats

```bash
# Resource usage
docker stats

# Specific container
docker stats dementicare-backend
```

## Troubleshooting

### Service Won't Start

```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs backend

# Restart service
docker-compose restart backend
```

### Database Connection Issues

```bash
# Check database is running
docker-compose ps postgres

# Test database connection
docker exec -it dementicare-db psql -U postgres -d dementicare

# Check database logs
docker-compose logs postgres
```

### Port Already in Use

```bash
# Find process using port
lsof -i :8080

# Change port in docker-compose.yml
ports:
  - "8081:8080"  # Map to different host port
```

### Reset Everything

```bash
# Stop and remove everything
docker-compose down -v

# Remove images
docker-compose down --rmi all

# Rebuild and restart
docker-compose up --build -d
```

## Performance Tuning

### PostgreSQL

Add to docker-compose.yml:
```yaml
postgres:
  environment:
    POSTGRES_SHARED_BUFFERS: 256MB
    POSTGRES_EFFECTIVE_CACHE_SIZE: 1GB
```

### Backend

Increase resources:
```yaml
backend:
  deploy:
    resources:
      limits:
        cpus: '2'
        memory: 1G
```

## Security Best Practices

1. **Never commit secrets**
   - Use `.env` files
   - Add `.env` to `.gitignore`

2. **Use strong passwords**
   - Generate secure passwords
   - Use different passwords for each service

3. **Enable HTTPS in production**
   - Use reverse proxy (nginx)
   - Add SSL certificates

4. **Limit network exposure**
   - Only expose necessary ports
   - Use internal network for service communication

5. **Regular updates**
   - Update base images
   - Update dependencies
   - Apply security patches

## Production Checklist

- [ ] Set strong `DB_PASSWORD`
- [ ] Set unique `JWT_SECRET`
- [ ] Enable HTTPS
- [ ] Configure CORS properly
- [ ] Set up database backups
- [ ] Configure logging
- [ ] Set up monitoring
- [ ] Use Docker secrets for sensitive data
- [ ] Limit container resources
- [ ] Enable container restart policies

## Advanced Configuration

### Using Docker Secrets

```bash
# Create secret
echo "my-secret-password" | docker secret create db_password -

# Update docker-compose.yml
services:
  postgres:
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    external: true
```

### Health Checks

Already configured in docker-compose.yml:
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 10s
  timeout: 5s
  retries: 5
```

## Support

For issues:
1. Check logs: `docker-compose logs -f`
2. Verify all services are running: `docker-compose ps`
3. Test individual services
4. Check network connectivity
