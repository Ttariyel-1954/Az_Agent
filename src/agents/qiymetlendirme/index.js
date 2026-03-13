// ============================================================
// Agent 2: Qiymətləndirmə (Assessment Agent)
// Azərbaycan dili və ədəbiyyat fənni üçün
// PISA formatı ilə test yaratma
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');
const fs = require('fs');
const path = require('path');

const TEST_DIR = path.join(__dirname, '../../../Testler');
if (!fs.existsSync(TEST_DIR)) fs.mkdirSync(TEST_DIR, { recursive: true });

class QiymetlendirmeAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async generateTest({
        sinif, movzu, test_tipi = 'Çoxseçimli (standart)', sual_sayi = 15,
        cetinlik = 'Orta (PISA Səv.3-4)', metn_novu = 'Bədii mətn',
        rubrika_elave = true
    }) {
        const standards = await this._getStandards(sinif);
        const chunks = await this._getChunks(sinif, movzu);

        const prompt = this._buildTestPrompt({
            sinif, movzu, test_tipi, sual_sayi, cetinlik,
            metn_novu, rubrika_elave, standards, chunks
        });

        const result = await this.ai.complete({ prompt, maxTokens: 8192 });

        if (!result.success) {
            throw new Error('Test yaratma xətası: ' + result.error);
        }

        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const safeTopic = movzu.replace(/[^a-zA-Z0-9əöüğıçş_-]/gi, '_').substring(0, 40);
        const fileName = `sinif${sinif}_${safeTopic}_test_${ts}.html`;
        const filePath = path.join(TEST_DIR, fileName);
        fs.writeFileSync(filePath, result.content, 'utf8');

        // PISA səviyyəsini çətinlikdən çıxar
        const pisaMap = { 'Asan (PISA Səv.1-2)': '2', 'Orta (PISA Səv.3-4)': '3', 'Çətin (PISA Səv.5-6)': '5', 'Qarışıq (bütün səviyyələr)': '3' };
        const pisaSev = pisaMap[cetinlik] || '3';

        await query(`
            INSERT INTO testler (sinif, movzu, test_tipi, cetinlik, sual_sayi, mezmun, pisa_saviyyesi, fayl_adi)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        `, [sinif, movzu, test_tipi, cetinlik, sual_sayi, result.content, pisaSev, fileName]);

        return {
            content: result.content, fileName, filePath,
            model: result.model, tokensInput: result.tokensInput,
            tokensOutput: result.tokensOutput, latencyMs: result.latencyMs,
        };
    }

    async _getStandards(sinif) {
        try {
            const result = await query(
                'SELECT standard_kodu, standard_metni, saha, pisa_saviyyesi, blooms_seviyyesi FROM azdili_standartlari WHERE sinif = $1',
                [sinif]
            );
            return result.rows;
        } catch { return []; }
    }

    async _getChunks(sinif, movzu) {
        try {
            const result = await query(
                `SELECT movzu, metn, sehife_aralighi FROM azdili_derslikler
                 WHERE sinif = $1 AND (movzu ILIKE $2 OR metn ILIKE $2) LIMIT 3`,
                [sinif, `%${movzu}%`]
            );
            return result.rows;
        } catch { return []; }
    }

    _buildTestPrompt({ sinif, movzu, test_tipi, sual_sayi, cetinlik, metn_novu, rubrika_elave, standards, chunks }) {
        const standardsText = standards.length > 0
            ? standards.map(s => `- [${s.standard_kodu}] (${s.saha}) ${s.standard_metni} [PISA: ${s.pisa_saviyyesi || '?'}, Blum: ${s.blooms_seviyyesi || '?'}]`).join('\n')
            : 'Standartlar bazada tapılmadı';

        const contextText = chunks.length > 0
            ? chunks.map(c => `--- ${c.movzu}, seh. ${c.sehife_aralighi} ---\n${(c.metn || '').substring(0, 2000)}`).join('\n\n')
            : '';

        let rubrikaInst = '';
        if (rubrika_elave) {
            rubrikaInst = `
AÇIQ SUALLAR ÜÇÜN QİYMƏTLƏNDİRMƏ RUBRİKASI:
| Bal | Meyar |
|-----|-------|
| 4 | Əsaslandırılmış, nümunəli, strukturlu cavab |
| 3 | Düzgün, lakin az əsaslandırılmış |
| 2 | Qismən düzgün |
| 1 | Cüzi anlama nümayiş etdirir |
| 0 | Cavab yoxdur / tamamilə yanlış |`;
        }

        return `Sən Azərbaycan dili və ədəbiyyat fənninin PISA formatında qiymətləndirmə mütəxəssisisən.

SİNİF: ${sinif}-ci sinif
MÖVZU: ${movzu}
TEST TİPİ: ${test_tipi}
SUAL SAYI: ${sual_sayi}
ÇƏTİNLİK: ${cetinlik}
MƏTN NÖVÜ: ${metn_novu}

STANDARTLAR:
${standardsText}

${contextText ? `DƏRSLİKDƏN KONTEKST:\n${contextText}\n` : ''}

TEST STRUKTURU (PISA FORMATI):

I HİSSƏ — OXUMA MƏTNİ:
Kontekstual mətn hazırla (150-300 söz, ${metn_novu} növündə, sinif səviyyəsinə uyğun)

II HİSSƏ — ÇOXSEÇIMLI SUALLAR (hər sual 1 bal):
- Hər sual üçün PISA səviyyəsini göstər (Səv.1-6)
- 4 variant (A, B, C, D)
- Düzgün cavab + izah
- Distraktorların niyə səhv olduğunu izah et

III HİSSƏ — QISA CAVABLI SUALLAR (hər sual 2 bal):
- Blum taksonomiya səviyyəsini göstər
- Gözlənilən cavab
- Qiymətləndirmə meyarı: nə yazsa 2 bal, nə yazsa 1 bal

IV HİSSƏ — AÇIQ SUALLAR (hər sual 4 bal):
- PISA Səv.4-6 sualları
- Geniş cavab tələb edən kritik düşüncə sualları
${rubrikaInst}

SUAL PAYLANMASI:
- Sualların 30%-i Səv.1-2 (asan)
- Sualların 50%-i Səv.3-4 (orta)
- Sualların 20%-i Səv.5-6 (çətin)

Ümumi bal: ___/20
PISA uyğunluğunu sonda göstər.

Nəticəni TAM HTML formatında ver. Markdown istifadə etmə.
Sonda test statistikasını əlavə et (Bloom paylanması, çətinlik balansı, PISA uyğunluğu).`;
    }
}

module.exports = { QiymetlendirmeAgent };
