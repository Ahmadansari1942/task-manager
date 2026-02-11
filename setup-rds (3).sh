#!/bin/bash

# RDS Setup Guide Script
# This script provides commands to set up Amazon RDS MySQL instance

echo "=========================================="
echo "Amazon RDS MySQL Setup Guide"
echo "=========================================="

cat << 'EOF'

STEP 1: CREATE RDS INSTANCE (AWS Console)
==========================================
1. Go to AWS RDS Console: https://console.aws.amazon.com/rds/
2. Click "Create database"
3. Choose "Standard create"
4. Engine options:
   - Engine type: MySQL
   - Version: MySQL 8.0.x (latest)
5. Templates: Free tier (or Production if needed)
6. Settings:
   - DB instance identifier: taskmanager-db
   - Master username: admin
   - Master password: [Create a strong password]
7. Instance configuration:
   - DB instance class: db.t3.micro (free tier) or db.t3.small
8. Storage:
   - Allocated storage: 20 GB
   - Enable storage autoscaling: Yes
9. Connectivity:
   - VPC: Default VPC
   - Public access: Yes (for development)
   - VPC security group: Create new
   - Security group name: taskmanager-rds-sg
10. Additional configuration:
    - Initial database name: taskmanager
    - Enable automated backups: Yes
    - Backup retention period: 7 days
11. Click "Create database"
12. Wait for status to become "Available" (5-10 minutes)


STEP 2: CONFIGURE SECURITY GROUP
=================================
1. Go to EC2 Console > Security Groups
2. Find "taskmanager-rds-sg"
3. Edit inbound rules:
   - Type: MySQL/Aurora
   - Protocol: TCP
   - Port: 3306
   - Source: [Your EC2 Security Group ID] or [EC2 Private IP]
   - Description: Allow EC2 to connect to RDS
4. Save rules


STEP 3: CONNECT TO RDS FROM EC2
================================
# SSH into your EC2 instance first
ssh -i TASKS.pem ubuntu@3.110.31.247

# Install MySQL client if not already installed
sudo apt update
sudo apt install -y mysql-client

# Connect to RDS (replace with your RDS endpoint)
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p

# When prompted, enter your master password


STEP 4: IMPORT DATABASE SCHEMA
===============================
# From EC2, import the schema
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p taskmanager < /var/www/taskmanager/backend/schema.sql

# Or connect and run manually:
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p

# Then paste the contents of schema.sql


STEP 5: UPDATE BACKEND .ENV FILE
=================================
# Edit the .env file with your RDS details
nano /var/www/taskmanager/backend/.env

# Update with your actual RDS endpoint:
PORT=5000
NODE_ENV=production
DB_HOST=taskmanager-db.xxxxxxxxxx.region.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your_actual_password
DB_NAME=taskmanager

# Save and exit (Ctrl+X, then Y, then Enter)


STEP 6: RESTART BACKEND
========================
pm2 restart taskmanager-backend
pm2 logs taskmanager-backend


STEP 7: TEST CONNECTION
========================
# Test the API health endpoint
curl http://localhost:5000/api/health

# Test fetching tasks
curl http://localhost:5000/api/tasks


FINDING YOUR RDS ENDPOINT
==========================
1. Go to RDS Console
2. Click on your database instance
3. Copy the "Endpoint" under "Connectivity & security"
   Example: taskmanager-db.abc123xyz.us-east-1.rds.amazonaws.com


SECURITY BEST PRACTICES
========================
1. Use strong passwords for RDS master user
2. Limit RDS security group to only allow EC2 instance
3. Enable encryption at rest
4. Enable automated backups
5. Use SSL/TLS for database connections
6. For production: Disable public access and use VPC peering


MONITORING
==========
1. CloudWatch metrics: Monitor CPU, connections, storage
2. Enable Enhanced Monitoring for detailed insights
3. Set up CloudWatch alarms for critical metrics
4. Review RDS logs regularly


COST OPTIMIZATION
=================
1. Use db.t3.micro for development (free tier eligible)
2. Enable storage autoscaling
3. Delete unnecessary snapshots
4. Stop RDS instance when not in use (development only)


TROUBLESHOOTING
===============
Connection timeout:
  - Check security group rules
  - Verify RDS is publicly accessible (for development)
  - Check VPC routing tables

Access denied:
  - Verify username and password
  - Check user privileges

Database not found:
  - Ensure database was created during RDS setup
  - Or create manually: CREATE DATABASE taskmanager;

EOF

echo ""
echo "=========================================="
echo "Setup guide displayed above ✅"
echo "=========================================="
