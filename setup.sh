#!/bin/bash

# Dementicare Setup Script
# This script helps you set up the entire Dementicare system

set -e

echo "🏥 Dementicare Setup Script"
echo "============================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command_exists go; then
    echo -e "${RED}❌ Go is not installed. Please install Go 1.21 or higher.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Go is installed: $(go version)${NC}"
fi

if ! command_exists node; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js 16.x or higher.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Node.js is installed: $(node --version)${NC}"
fi

if ! command_exists mysql; then
    echo -e "${YELLOW}⚠️  MySQL is not installed. Installing via Homebrew...${NC}"
    brew install mysql
    brew services start mysql
else
    echo -e "${GREEN}✅ MySQL is installed${NC}"
fi

if ! command_exists python3; then
    echo -e "${RED}❌ Python 3 is not installed. Please install Python 3.8 or higher.${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Python 3 is installed: $(python3 --version)${NC}"
fi

echo ""

# Setup database
echo "🗄️  Setting up database..."
echo "Enter MySQL root password (press Enter if no password):"
read -s DB_PASSWORD

# Create database using MySQL
mysql -u root -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS dementicare CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null && echo -e "${GREEN}✅ Database 'dementicare' created${NC}" || echo -e "${YELLOW}⚠️  Database 'dementicare' already exists or check password${NC}"

# Import schema if exists
if [ -f "database/schema.sql" ]; then
    echo "Importing database schema..."
    mysql -u root -p"$DB_PASSWORD" dementicare < database/schema.sql 2>/dev/null && echo -e "${GREEN}✅ Database schema imported${NC}" || echo -e "${YELLOW}⚠️  Schema import failed or already exists${NC}"
fi

echo ""

# Setup Go backend
echo "🔧 Setting up Go backend..."
cd backend

if [ ! -f ".env" ]; then
    cp .env.example .env
    # Update password in .env file
    if [ -n "$DB_PASSWORD" ]; then
        sed -i.bak "s/DB_PASSWORD=\"\"/DB_PASSWORD=\"$DB_PASSWORD\"/" .env
        rm .env.bak
    fi
    echo -e "${GREEN}✅ Created .env file${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists${NC}"
fi

echo "📦 Installing Go dependencies..."
go mod download
echo -e "${GREEN}✅ Go dependencies installed${NC}"

cd ..

echo ""

# Setup Python ML service
echo "🤖 Setting up Python ML service..."
cd Docter_recommendation-

if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✅ Virtual environment created${NC}"
fi

source venv/bin/activate
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt
deactivate
echo -e "${GREEN}✅ Python dependencies installed${NC}"

cd ..

echo ""

# Setup React frontend
echo "⚛️  Setting up React frontend..."
cd Dementicare_Web

if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ Created .env file${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists${NC}"
fi

echo "📦 Installing Node.js dependencies..."
npm install
echo -e "${GREEN}✅ Node.js dependencies installed${NC}"

cd ..

echo ""
echo "✨ Setup complete!"
echo ""
echo "To start the application, run these commands in separate terminals:"
echo ""
echo "Terminal 1 - Go Backend:"
echo -e "  ${GREEN}cd backend && go run main.go${NC}"
echo ""
echo "Terminal 2 - Python ML Service (Port 5001):"
echo -e "  ${GREEN}cd Docter_recommendation- && source venv/bin/activate && python3 app.py${NC}"
echo ""
echo "Terminal 3 - React Frontend (Port 3000):"
echo -e "  ${GREEN}cd Dementicare_Web && npm start${NC}"
echo ""
echo "📖 For more information, see SETUP.md"
echo ""
echo "⚠️  Note: If port 5000 conflicts with macOS AirPlay, the ML service uses port 5001 instead."
