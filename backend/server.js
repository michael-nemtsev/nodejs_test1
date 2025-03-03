const express = require('express');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

// Enable CORS for frontend
app.use(cors());

// Test API endpoint
app.get('/api/test', (req, res) => {
    res.json({
        message: 'Hello from the backend!',
        timestamp: new Date().toISOString()
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
}); 