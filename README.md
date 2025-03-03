# Node.js Azure Web App with Static Frontend

This project consists of two parts:
1. A Node.js backend designed for deployment to Azure Web App (Windows)
2. A static HTML frontend that can be hosted separately

## Project Structure

```
├── backend/
│   ├── server.js        # Express server with test API
│   ├── package.json     # Node.js dependencies
│   └── web.config       # Azure Web App configuration
└── frontend/
    └── index.html       # Static frontend page
```

## Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the server:
   ```bash
   npm start
   ```

The server will run on http://localhost:3000 by default.

## Frontend Setup

The frontend is a static HTML file that can be opened directly in a browser or hosted on any static hosting service.

Before deploying:
1. Update the API URL in `frontend/index.html` to point to your Azure Web App URL
2. Replace `http://localhost:3000` with your actual backend URL

## Deployment

### Backend (Azure Web App)
1. Create a new Azure Web App (Windows) with Node.js runtime
2. Deploy only the contents of the `backend` folder
3. Make sure the application starts successfully

### Frontend
1. Host the `frontend/index.html` file on your preferred static hosting service
2. Update the API URL in the JavaScript code to point to your Azure Web App URL 