# Quick Start Guide - Task Manager Deployment

## 🚀 Fastest Way to Deploy

### Prerequisites
- AWS Account
- EC2 instance running (IP: 3.110.31.247)
- TASKS.pem key file
- GitHub account

---

## Step 1: Connect to EC2 (1 minute)

```bash
chmod 400 TASKS.pem
ssh -i TASKS.pem ubuntu@3.110.31.247
```

---

## Step 2: Run Deployment Script (10 minutes)

```bash
# Download deployment script
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/task-manager/main/scripts/deploy.sh

# Make executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

---

## Step 3: Create RDS Database (5 minutes via AWS Console)

1. Go to: https://console.aws.amazon.com/rds/
2. Click "Create database"
3. Quick settings:
   - Engine: MySQL 8.0
   - Template: Free tier
   - DB name: taskmanager-db
   - Username: admin
   - Password: [Create strong password]
   - Database name: taskmanager
4. Click "Create database"
5. Wait 5-10 minutes
6. Copy the Endpoint URL

---

## Step 4: Configure Application (3 minutes)

```bash
# Update backend .env with RDS endpoint
nano /var/www/taskmanager/backend/.env

# Replace this line:
DB_HOST=your-rds-endpoint.region.rds.amazonaws.com

# With your actual RDS endpoint, for example:
DB_HOST=taskmanager-db.abc123.us-east-1.rds.amazonaws.com
DB_PASSWORD=your_actual_password

# Save: Ctrl+X, Y, Enter
```

---

## Step 5: Import Database Schema (2 minutes)

```bash
# Connect to RDS and import schema
mysql -h taskmanager-db.abc123.us-east-1.rds.amazonaws.com -u admin -p taskmanager < /var/www/taskmanager/backend/schema.sql

# Enter your RDS password when prompted
```

---

## Step 6: Restart Services (1 minute)

```bash
# Restart backend
pm2 restart taskmanager-backend

# Restart Nginx
sudo systemctl restart nginx

# Check status
pm2 status
```

---

## Step 7: Push to GitHub (2 minutes)

```bash
cd /var/www/taskmanager

# Initialize git
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub: https://github.com/new
# Name: task-manager

# Push to GitHub
git remote add origin https://github.com/YOUR_USERNAME/task-manager.git
git branch -M main
git push -u origin main
```

---

## ✅ Verify Deployment

1. **Frontend**: http://3.110.31.247
2. **Backend**: http://3.110.31.247:5000/api/health
3. **Test**: Create a task in the UI

---

## 🔧 Troubleshooting Commands

```bash
# Check backend logs
pm2 logs taskmanager-backend

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log

# Test RDS connection
mysql -h your-endpoint -u admin -p

# Restart everything
pm2 restart all
sudo systemctl restart nginx
```

---

## 📋 Checklist

- [ ] EC2 connected
- [ ] Deployment script run
- [ ] RDS created
- [ ] Backend .env updated
- [ ] Database schema imported
- [ ] Services restarted
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] Application accessible at http://3.110.31.247

---

## 📝 Important Files

| File | Location | Purpose |
|------|----------|---------|
| Backend .env | `/var/www/taskmanager/backend/.env` | Database credentials |
| Frontend .env | `/var/www/taskmanager/frontend/.env` | API URL |
| Nginx config | `/etc/nginx/sites-available/taskmanager` | Web server config |
| PM2 config | `pm2 status` | Process manager |

---

## 🎯 Next Steps After Deployment

1. **Custom Domain** (Optional)
   - Point domain to EC2 IP
   - Update Nginx server_name
   - Get SSL certificate

2. **Monitoring**
   - Setup CloudWatch alarms
   - Configure log aggregation
   - Monitor RDS performance

3. **Security**
   - Limit security groups
   - Setup SSL/HTTPS
   - Enable RDS encryption
   - Regular backups

---

## 💡 Quick Commands Reference

```bash
# Backend
pm2 status                     # Check backend status
pm2 logs taskmanager-backend   # View backend logs
pm2 restart taskmanager-backend # Restart backend

# Frontend
cd /var/www/taskmanager/frontend
npm run build                   # Rebuild frontend

# Nginx
sudo systemctl status nginx     # Check status
sudo systemctl restart nginx    # Restart
sudo nginx -t                   # Test config

# Database
mysql -h endpoint -u admin -p   # Connect to RDS

# Deployment
cd /var/www/taskmanager
git pull origin main            # Pull updates
./deploy.sh                     # Redeploy
```

---

**Total Time: ~25 minutes** ⏱️

🎉 **Your application is now live!**
