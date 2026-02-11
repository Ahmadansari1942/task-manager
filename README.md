# Task Manager - Full Stack Application

A full-stack task management application with React frontend, Node.js/Express backend, and MySQL database deployed on AWS EC2 and RDS.

## 🚀 Live Application

- **Frontend & Backend**: http://3.110.31.247
- **API Base URL**: http://3.110.31.247:5000/api

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Local Development](#local-development)
- [AWS Deployment](#aws-deployment)
- [API Documentation](#api-documentation)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- ✅ Create, read, update, and delete tasks
- ✅ Task status management (Pending, In Progress, Completed)
- ✅ Responsive design for mobile and desktop
- ✅ Real-time task updates
- ✅ RESTful API architecture
- ✅ MySQL database with connection pooling
- ✅ Production-ready deployment on AWS

## 🛠️ Tech Stack

### Frontend
- React 18
- CSS3 with modern styling
- Fetch API for HTTP requests

### Backend
- Node.js
- Express.js
- MySQL2 (with promise support)
- CORS middleware
- dotenv for environment variables

### Database
- MySQL 8.0 (Amazon RDS)

### Infrastructure
- AWS EC2 (Ubuntu 24.04)
- AWS RDS (MySQL)
- Nginx (reverse proxy)
- PM2 (process manager)

## 🏗️ Architecture

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   React     │────────▶│   Nginx     │────────▶│   Node.js   │
│  Frontend   │         │   :80       │         │   :5000     │
└─────────────┘         └─────────────┘         └──────┬──────┘
                                                        │
                                                        ▼
                                                ┌─────────────┐
                                                │   AWS RDS   │
                                                │   MySQL     │
                                                └─────────────┘
```

## 📁 Project Structure

```
task-manager/
├── backend/
│   ├── server.js           # Express server
│   ├── schema.sql          # Database schema
│   ├── package.json        # Backend dependencies
│   ├── .env.example        # Environment variables template
│   └── .env                # Environment variables (create this)
├── frontend/
│   ├── public/
│   │   └── index.html      # HTML template
│   ├── src/
│   │   ├── App.jsx         # Main React component
│   │   ├── App.css         # Styles
│   │   ├── index.js        # React entry point
│   │   └── index.css       # Global styles
│   ├── package.json        # Frontend dependencies
│   ├── .env.example        # Frontend environment template
│   └── .env                # Frontend environment (create this)
├── scripts/
│   ├── deploy.sh           # EC2 deployment script
│   └── setup-rds.sh        # RDS setup guide
├── docs/
│   └── DEPLOYMENT.md       # Detailed deployment guide
├── .gitignore              # Git ignore file
└── README.md               # This file
```

## 📦 Prerequisites

### For Local Development
- Node.js 18+ and npm
- MySQL 8.0+

### For AWS Deployment
- AWS Account
- EC2 instance (Ubuntu 24.04)
- RDS MySQL instance
- EC2 key pair (TASKS.pem)

## 💻 Local Development

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd task-manager
```

### 2. Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Update .env with your local MySQL credentials
nano .env

# Create database and import schema
mysql -u root -p < schema.sql

# Start backend server
npm run dev
```

Backend will run on http://localhost:5000

### 3. Setup Frontend

```bash
cd ../frontend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Update .env with backend URL
nano .env

# Start development server
npm start
```

Frontend will run on http://localhost:3000

## 🌐 AWS Deployment

### Step 1: EC2 Instance Setup

1. **Connect to EC2**:
```bash
chmod 400 TASKS.pem
ssh -i TASKS.pem ubuntu@3.110.31.247
```

2. **Run deployment script**:
```bash
# Make script executable
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

### Step 2: RDS Database Setup

1. **Create RDS Instance** (see `scripts/setup-rds.sh` for detailed guide):
   - Engine: MySQL 8.0
   - Instance: db.t3.micro
   - Database name: taskmanager
   - Master username: admin

2. **Configure Security Group**:
   - Allow inbound MySQL (3306) from EC2 security group

3. **Import Database Schema**:
```bash
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p taskmanager < backend/schema.sql
```

### Step 3: Configure Application

1. **Update Backend .env**:
```bash
nano /var/www/taskmanager/backend/.env
```

Update with your RDS credentials:
```env
PORT=5000
NODE_ENV=production
DB_HOST=your-rds-endpoint.region.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your_secure_password
DB_NAME=taskmanager
```

2. **Update Frontend .env**:
```bash
nano /var/www/taskmanager/frontend/.env
```

```env
REACT_APP_API_URL=http://3.110.31.247:5000/api
```

3. **Rebuild Frontend**:
```bash
cd /var/www/taskmanager/frontend
npm run build
```

4. **Restart Services**:
```bash
pm2 restart taskmanager-backend
sudo systemctl restart nginx
```

### Step 4: Configure EC2 Security Group

Add inbound rules:
- HTTP (80): 0.0.0.0/0
- Custom TCP (5000): 0.0.0.0/0
- SSH (22): Your IP

## 📚 API Documentation

### Base URL
```
http://3.110.31.247:5000/api
```

### Endpoints

#### Health Check
```
GET /api/health
```
Response:
```json
{
  "status": "ok",
  "message": "Server is running"
}
```

#### Get All Tasks
```
GET /api/tasks
```
Response:
```json
[
  {
    "id": 1,
    "title": "Task Title",
    "description": "Task Description",
    "status": "pending",
    "created_at": "2024-02-10T10:30:00.000Z",
    "updated_at": "2024-02-10T10:30:00.000Z"
  }
]
```

#### Create Task
```
POST /api/tasks
Content-Type: application/json

{
  "title": "New Task",
  "description": "Task description",
  "status": "pending"
}
```

#### Update Task
```
PUT /api/tasks/:id
Content-Type: application/json

{
  "title": "Updated Task",
  "description": "Updated description",
  "status": "completed"
}
```

#### Delete Task
```
DELETE /api/tasks/:id
```

## 🔐 Environment Variables

### Backend (.env)
```env
PORT=5000
NODE_ENV=production
DB_HOST=your-rds-endpoint.region.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your_secure_password
DB_NAME=taskmanager
```

### Frontend (.env)
```env
REACT_APP_API_URL=http://3.110.31.247:5000/api
```

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check PM2 logs
pm2 logs taskmanager-backend

# Check if port 5000 is in use
sudo lsof -i :5000

# Restart PM2
pm2 restart taskmanager-backend
```

### Database connection failed
```bash
# Test RDS connection
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p

# Check security group rules
# Verify .env credentials
# Check RDS status in AWS Console
```

### Nginx not serving frontend
```bash
# Check Nginx status
sudo systemctl status nginx

# Test Nginx configuration
sudo nginx -t

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Restart Nginx
sudo systemctl restart nginx
```

### CORS errors
- Verify backend CORS middleware is configured
- Check that API_URL in frontend .env is correct
- Ensure backend is running on port 5000

## 📝 Useful Commands

### PM2 Commands
```bash
pm2 status                    # Check status
pm2 logs taskmanager-backend  # View logs
pm2 restart all               # Restart all apps
pm2 stop all                  # Stop all apps
pm2 delete all                # Delete all apps
```

### Nginx Commands
```bash
sudo systemctl status nginx   # Check status
sudo systemctl restart nginx  # Restart
sudo nginx -t                 # Test config
sudo tail -f /var/log/nginx/access.log  # Access logs
sudo tail -f /var/log/nginx/error.log   # Error logs
```

### MySQL Commands
```bash
# Connect to RDS
mysql -h endpoint -u admin -p

# Common queries
SHOW DATABASES;
USE taskmanager;
SHOW TABLES;
SELECT * FROM tasks;
```

## 🚀 Performance Tips

1. **Enable Gzip in Nginx** for faster load times
2. **Use PM2 cluster mode** for load balancing
3. **Enable RDS performance insights** for monitoring
4. **Set up CloudWatch alarms** for critical metrics
5. **Use CDN** for static assets in production

## 🔒 Security Best Practices

1. Use environment variables for sensitive data
2. Keep RDS in private subnet for production
3. Enable SSL/TLS certificates (Let's Encrypt)
4. Regular security updates: `sudo apt update && sudo apt upgrade`
5. Use strong passwords for database
6. Limit security group access to specific IPs
7. Enable AWS CloudTrail for audit logging

## 📄 License

MIT License - feel free to use this project for learning and development.

## 👥 Contributing

Pull requests are welcome! For major changes, please open an issue first.

## 📞 Support

For issues and questions:
- Create an issue in GitHub
- Check the troubleshooting section
- Review deployment logs with PM2 and Nginx

---

**Built with ❤️ using React, Node.js, and AWS**
