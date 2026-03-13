// ============================================================
// AZ MÜƏLLİM AGENT - Main Server
// ARTI 2026 - Azərbaycan Respublikası Təhsil İnstitutu
// ============================================================
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const path = require('path');
const fs = require('fs');

const { testConnection } = require('../config/database');
const routes = require('./api/routes');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Security ───────────────────────────────────────────
app.use(helmet());
app.use(cors({
    origin: process.env.CORS_ORIGIN || '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: { error: 'Çox sayda sorğu. 15 dəqiqə gözləyin.' },
});
app.use('/api/', limiter);

// AI endpoint rate limiting
const aiLimiter = rateLimit({
    windowMs: 60 * 1000,
    max: 10,
    message: { error: 'AI sorğu limiti aşılıb. 1 dəqiqə gözləyin.' },
});
app.use('/api/v1/ders-plani', aiLimiter);
app.use('/api/v1/test-yarat', aiLimiter);

// ─── Middleware ──────────────────────────────────────────
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined'));

// Ensure directories exist
const dirs = ['./uploads', './Ders_planlari', './Testler', './Mesajlar'];
dirs.forEach(dir => {
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
});

// ─── Routes ─────────────────────────────────────────────
app.use('/api/v1', routes);

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        name: '📚 Az Müəllim Agent - ARTI 2026',
        description: 'Azərbaycan dili və ədəbiyyat müəllimləri üçün AI agent sistemi',
        version: '1.0.0',
        agents: {
            '1. Dərs Planlaması': '/api/v1/ders-plani',
            '2. Test və Qiymətləndirmə': '/api/v1/test-yarat',
            '3. İnşa Rubrikası': '/api/v1/insha-rubrika',
            '4. Diktant': '/api/v1/diktant-hazirla',
            '5. Ədəbi Təhlil': '/api/v1/edebi-tahlil',
            '6. Aylıq Plan': '/api/v1/aylik-plan',
            '7. Mesaj Yazma': '/api/v1/mesaj-yaz',
            '8. Şagird Analizi': '/api/v1/shagird-analiz',
        },
        endpoints: {
            health: '/api/v1/health',
            arxiv_planlar: '/api/v1/arxiv/ders-planlari',
            arxiv_testler: '/api/v1/arxiv/testler',
        },
    });
});

// ─── Error Handling ─────────────────────────────────────
app.use((err, req, res, next) => {
    console.error('❌ Server xətası:', err);
    res.status(err.status || 500).json({
        success: false,
        error: process.env.NODE_ENV === 'production' ? 'Daxili server xətası' : err.message,
    });
});

// 404
app.use((req, res) => {
    res.status(404).json({ success: false, error: 'Endpoint tapılmadı' });
});

// ─── Start Server ───────────────────────────────────────
async function start() {
    console.log('╔══════════════════════════════════════════╗');
    console.log('║   📚 AZ MÜƏLLİM AGENT - ARTI 2026      ║');
    console.log('║   AI Agent for Az Language Teachers       ║');
    console.log('╚══════════════════════════════════════════╝');

    const dbConnected = await testConnection();
    if (!dbConnected) {
        console.warn('⚠️  Verilənlər bazası əlçatan deyil. Demo rejimində işləyir.');
    }

    app.listen(PORT, () => {
        console.log(`\n🚀 Server işləyir: http://localhost:${PORT}`);
        console.log(`📊 API: http://localhost:${PORT}/api/v1`);
        console.log(`💚 Health: http://localhost:${PORT}/api/v1/health`);
        console.log(`\n📋 8 Agent aktiv:`);
        console.log('   1️⃣  Dərs Planlaması (PISA/Blum)');
        console.log('   2️⃣  Qiymətləndirmə (PISA formatı)');
        console.log('   3️⃣  Müəllim Kommunikasiyası');
        console.log('   4️⃣  Şagird İnkişafı');
        console.log('   5️⃣  Metodiki Kömək');
        console.log('   6️⃣  Rəqəmsal Assistant');
        console.log('   7️⃣  Ədəbi Təhlil (10 element)');
        console.log('   8️⃣  Aylıq Plan (PISA/PIRLS)');
    });
}

start().catch(console.error);

module.exports = app;
