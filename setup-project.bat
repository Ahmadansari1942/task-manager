@echo off
echo ==========================================
echo Task Manager - Quick Project Setup
echo ==========================================
echo.

REM Create main directories
mkdir backend
mkdir frontend\src
mkdir frontend\public
mkdir scripts
mkdir docs

echo Creating backend files...
cd backend

REM Create package.json
(
echo {
echo   "name": "task-manager-backend",
echo   "version": "1.0.0",
echo   "main": "server.js",
echo   "scripts": {
echo     "start": "node server.js"
echo   },
echo   "dependencies": {
echo     "express": "^4.18.2",
echo     "cors": "^2.8.5",
echo     "mysql2": "^3.6.5",
echo     "dotenv": "^16.3.1"
echo   }
echo }
) > package.json

echo Created backend/package.json

REM Create .env.example
(
echo PORT=5000
echo NODE_ENV=production
echo DB_HOST=your-rds-endpoint.region.rds.amazonaws.com
echo DB_USER=admin
echo DB_PASSWORD=your_secure_password
echo DB_NAME=taskmanager
) > .env.example

echo Created backend/.env.example

cd ..

echo.
echo Creating frontend files...
cd frontend

REM Create package.json
(
echo {
echo   "name": "task-manager-frontend",
echo   "version": "1.0.0",
echo   "private": true,
echo   "dependencies": {
echo     "react": "^18.2.0",
echo     "react-dom": "^18.2.0",
echo     "react-scripts": "5.0.1"
echo   },
echo   "scripts": {
echo     "start": "react-scripts start",
echo     "build": "react-scripts build"
echo   }
echo }
) > package.json

echo Created frontend/package.json

REM Create .env.example
echo REACT_APP_API_URL=http://3.110.31.247:5000/api > .env.example

echo Created frontend/.env.example

cd public
echo ^<!DOCTYPE html^>^<html^>^<head^>^<title^>Task Manager^</title^>^</head^>^<body^>^<div id="root"^>^</div^>^</body^>^</html^> > index.html
echo Created frontend/public/index.html

cd ..
cd ..

REM Create .gitignore
(
echo node_modules/
echo .env
echo .env.local
echo *.pem
echo *.key
echo frontend/build/
echo .DS_Store
echo npm-debug.log*
) > .gitignore

echo Created .gitignore

echo.
echo ==========================================
echo Setup Complete!
echo ==========================================
echo.
echo Next steps:
echo 1. Copy server.js to backend folder
echo 2. Copy schema.sql to backend folder
echo 3. Copy App.jsx, App.css, index.js, index.css to frontend/src folder
echo 4. Create .env files in backend and frontend
echo 5. Run: cd backend ^&^& npm install
echo 6. Run: cd frontend ^&^& npm install
echo 7. Push to GitHub
echo.
pause
