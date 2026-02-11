# آپ کے GitHub Repository کو ٹھیک کرنے کے لیے ہدایات
# Instructions to Fix Your GitHub Repository

## GitHub Repository Information
- **Your Repository**: https://github.com/Ahmadansari1942/task-manager
- **Owner**: Ahmadansari1942
- **EC2 IP**: 3.110.31.247

---

## Method 1: PowerShell استعمال کریں (آسان طریقہ)

### Step 1: نیا فولڈر بنائیں
```powershell
# کہیں بھی نیا فولڈر بنائیں
mkdir task-manager
cd task-manager
```

### Step 2: PowerShell Script چلائیں
```powershell
# Downloaded Setup-Project.ps1 کو چلائیں
# پہلے اجازت دینی ہوگی:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# پھر script چلائیں:
.\Setup-Project.ps1
```

### Step 3: فائلیں Copy کریں
Downloaded `task-manager` folder سے یہ فائلیں copy کریں:

**Backend میں:**
- `server.js` → `backend\server.js` میں copy کریں
- `schema.sql` → `backend\schema.sql` میں copy کریں

**Frontend میں:**
- `App.jsx` → `frontend\src\App.jsx` میں copy کریں
- `App.css` → `frontend\src\App.css` میں copy کریں
- `index.js` → `frontend\src\index.js` میں copy کریں
- `index.css` → `frontend\src\index.css` میں copy کریں

**Scripts میں:**
- `deploy.sh` → `scripts\deploy.sh` میں copy کریں
- `setup-rds.sh` → `scripts\setup-rds.sh` میں copy کریں

**Docs میں:**
- `DEPLOYMENT.md` → `docs\DEPLOYMENT.md` میں copy کریں

**Root میں:**
- `QUICKSTART.md` کو root میں copy کریں
- `FILE_STRUCTURE.md` کو root میں copy کریں

### Step 4: Environment Files بنائیں

**Backend .env بنائیں:**
```powershell
cd backend
cp .env.example .env
notepad .env
```
اس میں اپنی RDS details ڈالیں

**Frontend .env بنائیں:**
```powershell
cd frontend
cp .env.example .env
notepad .env
```

### Step 5: GitHub پر Push کریں
```powershell
cd task-manager  # root folder میں جائیں

# Git initialize
git init
git add .
git commit -m "Organize project with proper structure"

# آپ کی repository سے connect کریں
git remote add origin https://github.com/Ahmadansari1942/task-manager.git

# Push کریں
git branch -M main
git push -f origin main  # -f کیونکہ آپ نے پہلے files ڈالی تھیں
```

---

## Method 2: Manual طریقہ (اگر PowerShell کام نہ کرے)

### Step 1: فولڈر بنائیں
Windows Explorer میں یہ folders بنائیں:
```
task-manager/
├── backend/
├── frontend/
│   ├── src/
│   └── public/
├── scripts/
└── docs/
```

### Step 2: ایک ایک کر کے فائلیں Copy کریں

Downloaded folder سے نئے folders میں copy کریں:

**backend folder میں:**
- server.js
- schema.sql
- package.json
- .env.example

**frontend/src folder میں:**
- App.jsx
- App.css
- index.js
- index.css

**frontend/public folder میں:**
- index.html

**frontend root میں:**
- package.json
- .env.example

**scripts folder میں:**
- deploy.sh
- setup-rds.sh

**docs folder میں:**
- DEPLOYMENT.md

**Root folder میں:**
- README.md
- QUICKSTART.md
- FILE_STRUCTURE.md
- .gitignore

### Step 3: Git سے Push کریں
```bash
cd task-manager
git init
git add .
git commit -m "Proper folder structure"
git remote add origin https://github.com/Ahmadansari1942/task-manager.git
git push -f origin main
```

---

## Method 3: اگر Git سے پرانی files delete کرنی ہوں

اگر آپ چاہتے ہیں پوری طرح صاف شروعات:

```bash
# GitHub پر جائیں
# Settings → Delete Repository → task-manager delete کریں
# پھر نئی repository بنائیں

# Local folder میں:
cd task-manager
git init
git add .
git commit -m "Initial commit with proper structure"
git remote add origin https://github.com/Ahmadansari1942/task-manager.git
git branch -M main
git push -u origin main
```

---

## صحیح Structure کیسا ہونا چاہیے

GitHub پر یہ نظر آنا چاہیے:
```
task-manager/
├── backend/
│   ├── server.js
│   ├── package.json
│   ├── schema.sql
│   └── .env.example
├── frontend/
│   ├── src/
│   │   ├── App.jsx
│   │   ├── App.css
│   │   ├── index.js
│   │   └── index.css
│   ├── public/
│   │   └── index.html
│   ├── package.json
│   └── .env.example
├── scripts/
│   ├── deploy.sh
│   └── setup-rds.sh
├── docs/
│   └── DEPLOYMENT.md
├── README.md
├── QUICKSTART.md
├── FILE_STRUCTURE.md
└── .gitignore
```

---

## Quick Commands (Copy-Paste کریں)

### اگر Windows Command Prompt استعمال کر رہے ہیں:
```cmd
mkdir task-manager
cd task-manager
mkdir backend frontend\src frontend\public scripts docs

REM اب manually files copy کریں پھر:
git init
git add .
git commit -m "Project structure"
git remote add origin https://github.com/Ahmadansari1942/task-manager.git
git push -f origin main
```

### اگر PowerShell استعمال کر رہے ہیں:
```powershell
# Setup-Project.ps1 script چلائیں
# پھر files copy کریں
# پھر:
git init
git add .
git commit -m "Project structure"
git remote add origin https://github.com/Ahmadansari1942/task-manager.git
git push -f origin main
```

---

## ضروری نوٹس:

1. **.env files GitHub پر نہیں ڈالنی** - .gitignore میں ہیں
2. **TASKS.pem file محفوظ رکھیں** - GitHub پر نہیں ڈالنی
3. **node_modules folders** خود بن جائیں گے `npm install` سے

---

## مدد کے لیے:

اگر کوئی مسئلہ آئے:
1. Check: git status
2. Check: ls یا dir (files دیکھنے کے لیے)
3. Repository URL check کریں: git remote -v

---

## EC2 پر Deployment کے بعد:

```bash
ssh -i TASKS.pem ubuntu@3.110.31.247

cd /var/www/taskmanager
git pull origin main

# Backend restart
pm2 restart taskmanager-backend

# Frontend rebuild
cd frontend && npm run build
sudo systemctl restart nginx
```

**آپ کی application یہاں چلے گی:** http://3.110.31.247

---

**کوئی سوال؟ QUICKSTART.md دیکھیں!**
