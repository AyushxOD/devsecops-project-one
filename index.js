import express from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/data', (req, res) => {
  res.json({ message: 'data endpoint' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});