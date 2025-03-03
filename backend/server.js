const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Enable CORS for frontend with more specific configuration
app.use(cors({
    origin: '*', // In production, you should specify your frontend domain
    methods: ['GET', 'POST'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

// Basic health check endpoint for Azure
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy', environment: process.env.WEBSITE_SITE_NAME || 'local' });
});

// Test API endpoint
app.get('/api/test', (req, res) => {
    res.json({
        message: 'Hello from the backend!',
        timestamp: new Date().toISOString(),
        node_version: process.version,
        env: process.env.NODE_ENV || 'development'
    });
});

// Handle root path
app.get('/', (req, res) => {
    res.json({
        message: 'Backend API is running',
        version: '1.0.0',
        endpoints: [
            '/health',
            '/api/test'
        ]
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
    console.log(`Node.js version: ${process.version}`);
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
}); 