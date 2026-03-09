// ============================================================
// Agent 1: Dərs Planlaması (Lesson Planning Agent)
// Azərbaycan dili və ədəbiyyat fənni üçün
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');
const fs = require('fs');
const path = require('path');

const DERS_DIR = path.join(__dirname, '../../../Ders_planlari');
if (!fs.existsSync(DERS_DIR)) fs.mkdirSync(DERS_DIR, { recursive: true });

class DersPlanlamasiAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async generateLessonPlan({ sinif, movzu, ders_tipi = 'Yeni mövzu', faaliyet_novu = 'Oxu', muddet = 45 }) {
        // 1. Standartları bazadan çək
        const standards = await this._getStandards(sinif, faaliyet_novu);

        // 2. Dərslikdən kontekst çək
        const chunks = await this._getChunks(sinif, movzu);

        // 3. AI prompt hazırla
        const prompt = this._buildPlanPrompt({ sinif, movzu, ders_tipi, faaliyet_novu, muddet, standards, chunks });

        // 4. AI-dan cavab al
        const result = await this.ai.complete({ prompt, maxTokens: 8192 });

        if (!result.success) {
            throw new Error('Dərs planı yaratma xətası: ' + result.error);
        }

        // 5. Faylı saxla
        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const safeTopic = movzu.replace(/[^a-zA-Z0-9əöüğıçş_-]/gi, '_').substring(0, 40);
        const fileName = `sinif${sinif}_${safeTopic}_ders_plani_${ts}.html`;
        const filePath = path.join(DERS_DIR, fileName);
        fs.writeFileSync(filePath, result.content, 'utf8');

        // 6. DB-yə yaz
        await query(`
            INSERT INTO ders_planlari (sinif, movzu, ders_tipi, faaliyet_novu, muddet, mezmun, fayl_adi)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
        `, [sinif, movzu, ders_tipi, faaliyet_novu, muddet, result.content, fileName]);

        return {
            content: result.content,
            fileName,
            filePath,
            model: result.model,
            tokensInput: result.tokensInput,
            tokensOutput: result.tokensOutput,
            latencyMs: result.latencyMs,
        };
    }

    async _getStandards(sinif, saha) {
        const sahaMap = { 'Oxu': 'oxu', 'Yazı': 'yazi', 'Qrammatika': 'qrammatika', 'Danışıq': 'danisiq', 'Ədəbiyyat': 'edebiyyat' };
        const dbSaha = sahaMap[saha] || saha;
        try {
            const result = await query(
                'SELECT standard_kodu, standard_metni FROM azdili_standartlari WHERE sinif = $1 AND saha = $2',
                [sinif, dbSaha]
            );
            return result.rows;
        } catch {
            return [];
        }
    }

    async _getChunks(sinif, movzu) {
        try {
            const result = await query(
                `SELECT movzu, metn, sehife_aralighi FROM azdili_derslikler
                 WHERE sinif = $1 AND (movzu ILIKE $2 OR metn ILIKE $2)
                 LIMIT 3`,
                [sinif, `%${movzu}%`]
            );
            return result.rows;
        } catch {
            return [];
        }
    }

    _buildPlanPrompt({ sinif, movzu, ders_tipi, faaliyet_novu, muddet, standards, chunks }) {
        const standardsText = standards.length > 0
            ? standards.map(s => `- [${s.standard_kodu}] ${s.standard_metni}`).join('\n')
            : 'Standartlar bazada tapılmadı';

        const contextText = chunks.length > 0
            ? chunks.map(c => `--- Dərslik: ${c.movzu}, seh. ${c.sehife_aralighi} ---\n${(c.metn || '').substring(0, 3000)}`).join('\n\n')
            : 'Dərslik konteksti mövcud deyil';

        const m1 = Math.round(muddet * 0.10);
        const m2 = Math.round(muddet * 0.30);
        const m3 = Math.round(muddet * 0.25);
        const m4 = Math.round(muddet * 0.25);
        const m5 = Math.round(muddet * 0.10);

        return `Sən Azərbaycan dili və ədəbiyyat müəllimisiniz. Aşağıdakı parametrlərə uyğun dərs planı hazırla.

SİNİF: ${sinif}-ci sinif
MÖVZU: ${movzu}
DƏRS TİPİ: ${ders_tipi}
FƏALİYYƏT: ${faaliyet_novu}
MÜDDƏT: ${muddet} dəqiqə

STANDARTLAR:
${standardsText}

DƏRSLİKDƏN KONTEKST:
${contextText}

DERS PLANININ STRUKTURU (5 MƏRHƏLƏ):

MƏRHƏLƏ 1: MOTİVASİYA VƏ AKTUALLAŞDIRMA (${m1} dəq)
- Gündəlik həyatdan nümunə
- Əvvəlki biliklərin aktivləşdirilməsi

MƏRHƏLƏ 2: YENİ BİLİK VƏ KƏŞF (${m2} dəq)
- Mətnlə iş / qrammatik qayda / ədəbi əsər
- Şagirdlər özü kəşf edir

MƏRHƏLƏ 3: BİRGƏ TƏTBİQ (${m3} dəq)
- MÜƏLLİM: 1 nümunə göstərir
- BİZ: Cütlüklərlə tapşırıq
- SƏN: Fərdi tapşırıq

MƏRHƏLƏ 4: MÜSTƏQIL TƏTBİQ VƏ DİFERENSİASİYA (${m4} dəq)
- BAZA səviyyə: Sadə tapşırıqlar
- ORTA səviyyə: Kontekstli tapşırıqlar
- YÜKSƏK səviyyə: Yaradıcı tapşırıqlar

MƏRHƏLƏ 5: YEKUNLAŞDIRMA VƏ REFLEKSİYA (${m5} dəq)
- Çıxış bileti
- Ev tapşırığı

Nəticəni TAM HTML formatında ver. Markdown istifadə etmə.`;
    }
}

module.exports = { DersPlanlamasiAgent };
