// ============================================================
// API Routes - Az Müəllim Agent
// RESTful API for all 6 agents
// ============================================================
const express = require('express');
const router = express.Router();
const { authenticate, authorize, login, setupMFA, enableMFA, auditMiddleware } = require('../middleware/auth');

// Import agents
const { DersPlanlamasiAgent } = require('../agents/ders_planlamasi');
const { QiymetlendirmeAgent } = require('../agents/qiymetlendirme');
const { MuellimKommunikasiyasiAgent } = require('../agents/muellim_kommunikasiyasi');
const { ShagirdInkishafiAgent } = require('../agents/shagird_inkishafi');
const { MetodikiKomekAgent } = require('../agents/metodiki_komek');
const { ReqemsalAssistantAgent } = require('../agents/reqemsal_assistant');

// Initialize agents
const dersPlanAgent = new DersPlanlamasiAgent();
const qiymetAgent = new QiymetlendirmeAgent();
const kommunikasiyaAgent = new MuellimKommunikasiyasiAgent();
const shagirdAgent = new ShagirdInkishafiAgent();
const metodikiAgent = new MetodikiKomekAgent();
const reqemsalAgent = new ReqemsalAssistantAgent();

// ═══════════════════════════════════════════════
// AUTH ROUTES
// ═══════════════════════════════════════════════
router.post('/auth/login', login);
router.post('/auth/mfa/setup', authenticate, setupMFA);
router.post('/auth/mfa/enable', authenticate, enableMFA);

// ═══════════════════════════════════════════════
// 1. DƏRS PLANI
// ═══════════════════════════════════════════════
router.post('/ders-plani', async (req, res) => {
    try {
        const result = await dersPlanAgent.generateLessonPlan(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 2. TEST YARAT
// ═══════════════════════════════════════════════
router.post('/test-yarat', async (req, res) => {
    try {
        const result = await qiymetAgent.generateTest(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 3. İNŞA RUBRİKA
// ═══════════════════════════════════════════════
router.post('/insha-rubrika', async (req, res) => {
    try {
        const result = await qiymetAgent.generateTest({
            ...req.body,
            test_tipi: 'İnşa rubrikası'
        });
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 4. DİKTANT HAZIRLA
// ═══════════════════════════════════════════════
router.post('/diktant-hazirla', async (req, res) => {
    try {
        const result = await qiymetAgent.generateTest({
            ...req.body,
            test_tipi: 'Diktant'
        });
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 5. ƏDƏBİ TƏHLİL
// ═══════════════════════════════════════════════
router.post('/edebi-tahlil', async (req, res) => {
    try {
        const result = await reqemsalAgent.analyzeLiteraryText(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 6. AYLIK PLAN
// ═══════════════════════════════════════════════
router.post('/aylik-plan', async (req, res) => {
    try {
        const result = await reqemsalAgent.generateMonthlyPlan(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 7. MESAJ YAZ
// ═══════════════════════════════════════════════
router.post('/mesaj-yaz', async (req, res) => {
    try {
        const result = await kommunikasiyaAgent.generateMessage(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 8. ŞAGİRD ANALİZ
// ═══════════════════════════════════════════════
router.post('/shagird-analiz', async (req, res) => {
    try {
        const result = await shagirdAgent.analyzeStudent(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 9. METODİKİ KÖMƏK
// ═══════════════════════════════════════════════
router.post('/metodiki-komek', async (req, res) => {
    try {
        const result = await metodikiAgent.suggestMethod(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// 10. AZAD SUAL-CAVAB
// ═══════════════════════════════════════════════
router.post('/sual-cavab', async (req, res) => {
    try {
        const result = await reqemsalAgent.askQuestion(req.body);
        res.json({ success: true, data: result });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ═══════════════════════════════════════════════
// ARXİV ROUTES
// ═══════════════════════════════════════════════
const { query: dbQuery } = require('../../config/database');

router.get('/arxiv/ders-planlari', async (req, res) => {
    try {
        const result = await dbQuery(
            'SELECT id, sinif, movzu, ders_tipi, faaliyet_novu, muddet, yaradilma_tarixi, fayl_adi FROM ders_planlari ORDER BY yaradilma_tarixi DESC LIMIT 50'
        );
        res.json({ success: true, data: result.rows });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

router.get('/arxiv/testler', async (req, res) => {
    try {
        const result = await dbQuery(
            'SELECT id, sinif, movzu, test_tipi, cetinlik, sual_sayi, yaradilma_tarixi, fayl_adi FROM testler ORDER BY yaradilma_tarixi DESC LIMIT 50'
        );
        res.json({ success: true, data: result.rows });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// ─── Health Check ───────────────────────────────────────
router.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        service: 'Az Müəllim Agent API',
        version: '1.0.0',
        timestamp: new Date().toISOString(),
        agents: ['ders_planlamasi', 'qiymetlendirme', 'muellim_kommunikasiyasi', 'shagird_inkishafi', 'metodiki_komek', 'reqemsal_assistant']
    });
});

module.exports = router;
