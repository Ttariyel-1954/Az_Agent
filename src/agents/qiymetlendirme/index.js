// ============================================================
// Agent 2: Qiymətləndirmə (Assessment Agent)
// Azərbaycan dili və ədəbiyyat fənni üçün
// Test tipləri: çoxseçimli, açıq sual, diktant, inşa rubrikası, şifahi
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

    async generateTest({ sinif, movzu, test_tipi = 'Çoxseçimli', sual_sayi = 10, cetinlik = 'Orta' }) {
        const standards = await this._getStandards(sinif);
        const chunks = await this._getChunks(sinif, movzu);

        const prompt = this._buildTestPrompt({ sinif, movzu, test_tipi, sual_sayi, cetinlik, standards, chunks });

        const result = await this.ai.complete({ prompt, maxTokens: 8192 });

        if (!result.success) {
            throw new Error('Test yaratma xətası: ' + result.error);
        }

        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const safeTopic = movzu.replace(/[^a-zA-Z0-9əöüğıçş_-]/gi, '_').substring(0, 40);
        const fileName = `sinif${sinif}_${safeTopic}_test_${ts}.html`;
        const filePath = path.join(TEST_DIR, fileName);
        fs.writeFileSync(filePath, result.content, 'utf8');

        await query(`
            INSERT INTO testler (sinif, movzu, test_tipi, cetinlik, sual_sayi, mezmun, fayl_adi)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
        `, [sinif, movzu, test_tipi, cetinlik, sual_sayi, result.content, fileName]);

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

    async _getStandards(sinif) {
        try {
            const result = await query(
                'SELECT standard_kodu, standard_metni, saha FROM azdili_standartlari WHERE sinif = $1',
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

    _buildTestPrompt({ sinif, movzu, test_tipi, sual_sayi, cetinlik, standards, chunks }) {
        const standardsText = standards.length > 0
            ? standards.map(s => `- [${s.standard_kodu}] (${s.saha}) ${s.standard_metni}`).join('\n')
            : 'Standartlar bazada tapılmadı';

        const contextText = chunks.length > 0
            ? chunks.map(c => `--- ${c.movzu}, seh. ${c.sehife_aralighi} ---\n${(c.metn || '').substring(0, 2000)}`).join('\n\n')
            : '';

        const testTypeInstructions = {
            'Çoxseçimli': `Hər sual 4 variant (A, B, C, D) olmalıdır. Düzgün cavab və izah yazılmalıdır.
Distraktorlar (səhv variantlar) üçün niyə səhv olduğu izah olunmalıdır.`,
            'Açıq sual': `Açıq cavablı suallar. Hər sual üçün rubrika (0-3 bal skalası) və nümunə cavab yazılmalıdır.`,
            'Diktant': `Diktant mətni hazırla. Mətndən sonra qrammatik tapşırıqlar ver:
- Sözləri hərflərə ayırma
- Cümlələrin təhlili
- Boşluq doldurma`,
            'İnşa rubrikası': `İnşa mövzuları və qiymətləndirmə rubrikası hazırla:
- Məzmun (0-5 bal)
- Quruluş (0-3 bal)
- Dil düzgünlüyü (0-3 bal)
- Yaradıcılıq (0-2 bal)
- Orfoqrafiya (0-2 bal)`,
            'Şifahi': `Şifahi qiymətləndirmə sualları. Hər sual üçün:
- Gözlənilən cavab
- Qiymətləndirmə meyarları
- Əlavə suallar (follow-up)`,
        };

        return `Sən Azərbaycan dili və ədəbiyyat fənninin qiymətləndirmə mütəxəssisisən.

SİNİF: ${sinif}-ci sinif
MÖVZU: ${movzu}
TEST TİPİ: ${test_tipi}
SUAL SAYI: ${sual_sayi}
ÇƏTİNLİK: ${cetinlik}

STANDARTLAR:
${standardsText}

${contextText ? `DƏRSLİKDƏN KONTEKST:\n${contextText}\n` : ''}

TEST TİPİ XÜSUSİYYƏTLƏRİ:
${testTypeInstructions[test_tipi] || testTypeInstructions['Çoxseçimli']}

Nəticəni TAM HTML formatında ver. Markdown istifadə etmə.
Sonda test statistikasını əlavə et (Bloom paylanması, çətinlik balansı).`;
    }
}

module.exports = { QiymetlendirmeAgent };
