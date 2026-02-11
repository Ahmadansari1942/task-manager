# Task Manager - PowerShell Setup Script
# This script creates the proper folder structure for your task manager project

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Task Manager - Project Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Create directory structure
Write-Host "Creating directory structure..." -ForegroundColor Yellow

$directories = @(
    "backend",
    "frontend\src",
    "frontend\public",
    "scripts",
    "docs"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Write-Host "✓ Created: $dir" -ForegroundColor Green
}

# Create backend package.json
Write-Host "`nCreating backend files..." -ForegroundColor Yellow

$backendPackageJson = @"
{
  "name": "task-manager-backend",
  "version": "1.0.0",
  "description": "Task Manager Backend API",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "mysql2": "^3.6.5",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.2"
  }
}
"@

$backendPackageJson | Out-File -FilePath "backend\package.json" -Encoding UTF8
Write-Host "✓ Created: backend\package.json" -ForegroundColor Green

# Create backend .env.example
$backendEnvExample = @"
PORT=5000
NODE_ENV=production
DB_HOST=your-rds-endpoint.region.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your_secure_password
DB_NAME=taskmanager
"@

$backendEnvExample | Out-File -FilePath "backend\.env.example" -Encoding UTF8
Write-Host "✓ Created: backend\.env.example" -ForegroundColor Green

# Create frontend package.json
Write-Host "`nCreating frontend files..." -ForegroundColor Yellow

$frontendPackageJson = @"
{
  "name": "task-manager-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test"
  },
  "proxy": "http://localhost:5000"
}
"@

$frontendPackageJson | Out-File -FilePath "frontend\package.json" -Encoding UTF8
Write-Host "✓ Created: frontend\package.json" -ForegroundColor Green

# Create frontend .env.example
$frontendEnvExample = "REACT_APP_API_URL=http://3.110.31.247:5000/api"
$frontendEnvExample | Out-File -FilePath "frontend\.env.example" -Encoding UTF8
Write-Host "✓ Created: frontend\.env.example" -ForegroundColor Green

# Create public/index.html
$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#667eea" />
    <meta name="description" content="Task Manager Application" />
    <title>Task Manager</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
"@

$indexHtml | Out-File -FilePath "frontend\public\index.html" -Encoding UTF8
Write-Host "✓ Created: frontend\public\index.html" -ForegroundColor Green

# Create .gitignore
Write-Host "`nCreating .gitignore..." -ForegroundColor Yellow

$gitignore = @"
# Dependencies
node_modules/
npm-debug.log*

# Environment variables
.env
.env.local
.env.production

# Build outputs
frontend/build/
dist/

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Keys
*.pem
*.key

# Logs
*.log

# PM2
.pm2/
"@

$gitignore | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "✓ Created: .gitignore" -ForegroundColor Green

# Create README for GitHub
Write-Host "`nCreating README.md..." -ForegroundColor Yellow

$readme = @"
# Task Manager

Full-stack task management application with React, Node.js, and MySQL on AWS.

## Repository Information
- **Owner**: Ahmadansari1942
- **Repository**: task-manager
- **URL**: https://github.com/Ahmadansari1942/task-manager

## Tech Stack
- Frontend: React
- Backend: Node.js + Express
- Database: MySQL (AWS RDS)
- Deployment: AWS EC2 + Nginx

## Quick Start

### Backend
\`\`\`bash
cd backend
npm install
# Create .env file with your database credentials
npm start
\`\`\`

### Frontend
\`\`\`bash
cd frontend
npm install
# Create .env file with API URL
npm start
\`\`\`

## Deployment
See QUICKSTART.md for deployment instructions.
"@

$readme | Out-File -FilePath "README.md" -Encoding UTF8
Write-Host "✓ Created: README.md" -ForegroundColor Green

# Create directory structure info
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Directory structure created:" -ForegroundColor Yellow
Write-Host "  task-manager/" -ForegroundColor White
Write-Host "  ├── backend/" -ForegroundColor White
Write-Host "  │   ├── package.json" -ForegroundColor Gray
Write-Host "  │   ├── .env.example" -ForegroundColor Gray
Write-Host "  │   ├── server.js (copy from downloaded files)" -ForegroundColor Cyan
Write-Host "  │   └── schema.sql (copy from downloaded files)" -ForegroundColor Cyan
Write-Host "  ├── frontend/" -ForegroundColor White
Write-Host "  │   ├── src/" -ForegroundColor White
Write-Host "  │   │   ├── App.jsx (copy from downloaded files)" -ForegroundColor Cyan
Write-Host "  │   │   ├── App.css (copy from downloaded files)" -ForegroundColor Cyan
Write-Host "  │   │   ├── index.js (copy from downloaded files)" -ForegroundColor Cyan
Write-Host "  │   │   └── index.css (copy from downloaded files)" -ForegroundColor Cyan
Write-Host "  │   ├── public/" -ForegroundColor White
Write-Host "  │   │   └── index.html" -ForegroundColor Gray
Write-Host "  │   ├── package.json" -ForegroundColor Gray
Write-Host "  │   └── .env.example" -ForegroundColor Gray
Write-Host "  ├── scripts/ (copy deploy.sh and setup-rds.sh)" -ForegroundColor Cyan
Write-Host "  ├── docs/ (copy DEPLOYMENT.md)" -ForegroundColor Cyan
Write-Host "  ├── .gitignore" -ForegroundColor Gray
Write-Host "  └── README.md" -ForegroundColor Gray
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Copy the following files from downloaded 'task-manager' folder:" -ForegroundColor White
Write-Host "   - backend/server.js" -ForegroundColor Cyan
Write-Host "   - backend/schema.sql" -ForegroundColor Cyan
Write-Host "   - frontend/src/App.jsx" -ForegroundColor Cyan
Write-Host "   - frontend/src/App.css" -ForegroundColor Cyan
Write-Host "   - frontend/src/index.js" -ForegroundColor Cyan
Write-Host "   - frontend/src/index.css" -ForegroundColor Cyan
Write-Host "   - scripts/deploy.sh" -ForegroundColor Cyan
Write-Host "   - scripts/setup-rds.sh" -ForegroundColor Cyan
Write-Host "   - docs/DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host "   - QUICKSTART.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Create .env files:" -ForegroundColor White
Write-Host "   - Copy backend\.env.example to backend\.env" -ForegroundColor Cyan
Write-Host "   - Copy frontend\.env.example to frontend\.env" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Install dependencies:" -ForegroundColor White
Write-Host "   cd backend && npm install" -ForegroundColor Cyan
Write-Host "   cd frontend && npm install" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Push to GitHub:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Cyan
Write-Host "   git commit -m 'Organize project structure'" -ForegroundColor Cyan
Write-Host "   git push origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "GitHub Repository: https://github.com/Ahmadansari1942/task-manager" -ForegroundColor Green
Write-Host ""
