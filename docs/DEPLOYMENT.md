# Deployment Guide - Task Manager Application

Complete step-by-step guide for deploying React frontend and Node.js backend on AWS EC2 with RDS MySQL database.

## Table of Contents
1. [AWS RDS Setup](#1-aws-rds-setup)
2. [EC2 Instance Preparation](#2-ec2-instance-preparation)
3. [Application Deployment](#3-application-deployment)
4. [GitHub Repository Setup](#4-github-repository-setup)
5. [Post-Deployment Configuration](#5-post-deployment-configuration)
6. [Testing & Verification](#6-testing--verification)

---

## 1. AWS RDS Setup

### Create RDS MySQL Instance

1. **Login to AWS Console**
   - Navigate to RDS service
   - Click "Create database"

2. **Database Configuration**
   ```
   Engine options:
   - Engine type: MySQL
   - Version: MySQL 8.0.35 (or latest 8.0.x)
   
   Templates:
   - Choose: Free tier (for learning/development)
   - Or: Production (for live applications)
   
   Settings:
   - DB instance identifier: taskmanager-db
   - Master username: admin
   - Master password: [Create strong password, e.g., TaskMgr2024!Secure]
   
   DB instance class:
   - db.t3.micro (free tier eligible)
   
   Storage:
   - Allocated storage: 20 GB
   - Storage autoscaling: Enable
   - Maximum storage threshold: 100 GB
   
   Connectivity:
   - VPC: Default VPC
   - Public access: Yes (for development - use No for production)
   - VPC security group: Create new
     - Name: taskmanager-rds-sg
   - Availability Zone: No preference
   
   Database authentication:
   - Password authentication
   
   Additional configuration:
   - Initial database name: taskmanager
   - DB parameter group: default.mysql8.0
   - Backup retention: 7 days
   - Encryption: Enable (recommended)
   ```

3. **Create Database**
   - Review all settings
   - Click "Create database"
   - Wait 5-10 minutes for creation to complete
   - Note the endpoint once available

4. **Configure RDS Security Group**
   ```bash
   # Go to EC2 → Security Groups
   # Find: taskmanager-rds-sg
   
   Inbound Rules:
   Type: MySQL/Aurora
   Protocol: TCP
   Port: 3306
   Source: [EC2-Security-Group-ID] or 3.110.31.247/32
   Description: Allow EC2 to connect
   ```

### Import Database Schema

```bash
# SSH to EC2 first
ssh -i TASKS.pem ubuntu@3.110.31.247

# Install MySQL client
sudo apt update
sudo apt install -y mysql-client

# Connect to RDS and create schema
mysql -h taskmanager-db.xxxxxxxxxx.region.rds.amazonaws.com -u admin -p

# In MySQL prompt, run:
CREATE DATABASE IF NOT EXISTS taskmanager;
USE taskmanager;

CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status ENUM('pending', 'in-progress', 'completed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_status (status),
  INDEX idx_created_at (created_at)
);

# Insert sample data
INSERT INTO tasks (title, description, status) VALUES
('Deploy Application', 'Deploy React frontend and Node.js backend to EC2', 'in-progress'),
('Setup RDS Database', 'Configure MySQL RDS instance', 'completed');

# Exit
EXIT;
```

---

## 2. EC2 Instance Preparation

### Connect to EC2

```bash
# Make key file secure
chmod 400 TASKS.pem

# SSH into instance
ssh -i TASKS.pem ubuntu@3.110.31.247
```

### Install Required Software

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 20.x LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installations
node -v  # Should show v20.x.x
npm -v   # Should show 10.x.x

# Install PM2 (Process Manager)
sudo npm install -g pm2

# Install Nginx (Web Server)
sudo apt install -y nginx

# Install MySQL client
sudo apt install -y mysql-client

# Install Git
sudo apt install -y git
```

### Configure EC2 Security Group

```bash
# In AWS Console → EC2 → Security Groups
# Edit inbound rules for EC2 instance:

Inbound Rules:
1. SSH
   - Port: 22
   - Source: My IP (your IP address)
   
2. HTTP
   - Port: 80
   - Source: 0.0.0.0/0 (Anywhere IPv4)
   
3. Custom TCP (Backend API)
   - Port: 5000
   - Source: 0.0.0.0/0 (Anywhere IPv4)
```

---

## 3. Application Deployment

### Setup Application Directory

```bash
# Create application directory
sudo mkdir -p /var/www/taskmanager
sudo chown -R ubuntu:ubuntu /var/www/taskmanager
cd /var/www/taskmanager
```

### Option A: Deploy from GitHub

```bash
# Clone your repository
git clone https://github.com/YOUR_USERNAME/task-manager.git .

# Or if you haven't created repo yet, see Section 4 first
```

### Option B: Upload Files Manually

```bash
# From your local machine, upload files using SCP:

# Upload backend
scp -i TASKS.pem -r ./backend ubuntu@3.110.31.247:/var/www/taskmanager/

# Upload frontend
scp -i TASKS.pem -r ./frontend ubuntu@3.110.31.247:/var/www/taskmanager/
```

### Deploy Backend

```bash
cd /var/www/taskmanager/backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
PORT=5000
NODE_ENV=production
DB_HOST=taskmanager-db.xxxxxxxxxx.region.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=TaskMgr2024!Secure
DB_NAME=taskmanager
EOF

# IMPORTANT: Replace the DB_HOST with your actual RDS endpoint
# Find it in RDS Console → Databases → taskmanager-db → Endpoint

# Start backend with PM2
pm2 start server.js --name taskmanager-backend

# Save PM2 process list
pm2 save

# Setup PM2 to start on system boot
pm2 startup
# Copy and run the command it outputs

# Check status
pm2 status
pm2 logs taskmanager-backend
```

### Deploy Frontend

```bash
cd /var/www/taskmanager/frontend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
REACT_APP_API_URL=http://3.110.31.247:5000/api
EOF

# Build production version
npm run build

# Verify build completed
ls -la build/
```

### Configure Nginx

```bash
# Create Nginx configuration
sudo tee /etc/nginx/sites-available/taskmanager > /dev/null << 'EOF'
server {
    listen 80;
    server_name 3.110.31.247;

    # Frontend - React app
    location / {
        root /var/www/taskmanager/frontend/build;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # Backend API - Node.js
    location /api {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/taskmanager /etc/nginx/sites-enabled/

# Remove default site
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# If test passes, restart Nginx
sudo systemctl restart nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Check Nginx status
sudo systemctl status nginx
```

---

## 4. GitHub Repository Setup

### Initialize Git Repository

```bash
# On EC2 or local machine
cd /var/www/taskmanager  # or your local project directory

# Initialize git if not already done
git init
```

### Create .gitignore

```bash
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

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
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# PEM files
*.pem

# PM2
.pm2/
EOF
```

### Create GitHub Repository

1. **Go to GitHub**: https://github.com/new

2. **Repository Details**:
   ```
   Repository owner: [YOUR_USERNAME]
   Repository name: task-manager
   Description: Full-stack task management app with React, Node.js, and MySQL on AWS
   Visibility: Public (or Private)
   
   ✓ Add a README file (optional, we have one)
   □ Add .gitignore (we created custom one)
   □ Choose a license (optional: MIT)
   ```

3. **Create Repository**

### Push Code to GitHub

```bash
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/task-manager.git

# Stage all files
git add .

# Commit
git commit -m "Initial commit: Task Manager application with React, Node.js, and MySQL"

# Push to GitHub
git branch -M main
git push -u origin main
```

### Add GitHub SSH Key (Optional but Recommended)

```bash
# Generate SSH key on EC2
ssh-keygen -t ed25519 -C "your_email@example.com"

# Display public key
cat ~/.ssh/id_ed25519.pub

# Copy the output and add to GitHub:
# GitHub → Settings → SSH and GPG keys → New SSH key

# Test connection
ssh -T git@github.com

# Update remote to use SSH
git remote set-url origin git@github.com:YOUR_USERNAME/task-manager.git
```

---

## 5. Post-Deployment Configuration

### Setup Automatic Deployment (Optional)

```bash
# Create deployment script on EC2
cat > /var/www/taskmanager/deploy.sh << 'EOF'
#!/bin/bash
cd /var/www/taskmanager

# Pull latest code
git pull origin main

# Update backend
cd backend
npm install
pm2 restart taskmanager-backend

# Update frontend
cd ../frontend
npm install
npm run build

# Restart Nginx
sudo systemctl restart nginx

echo "Deployment completed!"
EOF

# Make executable
chmod +x /var/www/taskmanager/deploy.sh

# To deploy updates in future:
./deploy.sh
```

### Enable HTTPS (Optional - Recommended for Production)

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificate (requires domain name)
sudo certbot --nginx -d yourdomain.com

# Auto-renewal is configured by default
# Test renewal
sudo certbot renew --dry-run
```

### Setup Monitoring

```bash
# Monitor with PM2
pm2 monit

# View logs
pm2 logs taskmanager-backend

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

---

## 6. Testing & Verification

### Test Backend API

```bash
# Health check
curl http://3.110.31.247:5000/api/health

# Get tasks
curl http://3.110.31.247:5000/api/tasks

# Create task
curl -X POST http://3.110.31.247:5000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Testing API","status":"pending"}'
```

### Test Frontend

1. Open browser: http://3.110.31.247
2. Verify UI loads correctly
3. Try creating a task
4. Update task status
5. Delete a task

### Verify Database Connection

```bash
# Connect to RDS
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p

# Check data
USE taskmanager;
SELECT * FROM tasks;
```

### Common Issues & Solutions

**Backend not starting:**
```bash
pm2 logs taskmanager-backend
# Check for DB connection errors in logs
# Verify .env file has correct RDS endpoint
```

**Frontend shows errors:**
```bash
# Check browser console (F12)
# Verify .env has correct API URL
# Rebuild: cd frontend && npm run build
```

**Database connection failed:**
```bash
# Test RDS connection
mysql -h endpoint -u admin -p
# Check RDS security group allows EC2
# Verify .env credentials are correct
```

**Nginx not serving site:**
```bash
sudo nginx -t  # Test config
sudo systemctl status nginx  # Check status
sudo tail -f /var/log/nginx/error.log  # View errors
```

---

## File Structure Summary

```
task-manager/
├── backend/
│   ├── server.js              # Main backend server
│   ├── package.json           # Backend dependencies
│   ├── .env                   # Database credentials (not in git)
│   └── schema.sql             # Database schema
├── frontend/
│   ├── src/
│   │   ├── App.jsx            # Main React component
│   │   ├── App.css            # Styles
│   │   ├── index.js           # Entry point
│   │   └── index.css          # Global styles
│   ├── public/
│   │   └── index.html         # HTML template
│   ├── package.json           # Frontend dependencies
│   └── .env                   # API URL (not in git)
├── scripts/
│   ├── deploy.sh              # EC2 deployment script
│   └── setup-rds.sh           # RDS setup guide
├── docs/
│   └── DEPLOYMENT.md          # This file
├── .gitignore                 # Git ignore rules
└── README.md                  # Project documentation
```

---

## Repository Information

### GitHub Repository
- **Owner**: YOUR_USERNAME
- **Repository**: task-manager
- **URL**: https://github.com/YOUR_USERNAME/task-manager

### AWS Resources
- **EC2 IP**: 3.110.31.247
- **RDS Endpoint**: taskmanager-db.xxxxxxxxxx.region.rds.amazonaws.com
- **Key File**: TASKS.pem

### Access URLs
- **Frontend**: http://3.110.31.247
- **Backend API**: http://3.110.31.247:5000/api
- **Health Check**: http://3.110.31.247:5000/api/health

---

## Next Steps

1. ✅ Deploy application to EC2
2. ✅ Setup RDS database
3. ✅ Configure Nginx
4. ✅ Push code to GitHub
5. ⬜ Setup custom domain (optional)
6. ⬜ Enable HTTPS with SSL certificate (optional)
7. ⬜ Setup CI/CD pipeline (optional)
8. ⬜ Configure CloudWatch monitoring (optional)

---

**Deployment completed successfully! 🎉**

Your application is now live at: **http://3.110.31.247**
