// ============================================================
// Agent: Aylıq Plan (Monthly Plan Agent)
// Həftəlik cədvəl, PISA/PIRLS uyğunluğu ilə
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');
const fs = require('fs');
const path = require('path');

const DERS_DIR = path.join(__dirname, '../../../Ders_planlari');
if (!fs.existsSync(DERS_DIR)) fs.mkdirSync(DERS_DIR, { recursive: true });

class AylikPlanAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async generateMonthlyPlan({
        sinif, ay, heftelik_saat = 3,
        pisa_uygun = true, qiymet_noqte = true
    }) {
        const standards = await this._getStandards(sinif);
        const topics = await this._getTopics(sinif);

        const prompt = this._buildMonthlyPrompt({
            sinif, ay, heftelik_saat, pisa_uygun,
            qiymet_noqte, standards, topics
        });

        const result = await this.ai.complete({ prompt, maxTokens: 8192 });

        if (!result.success) {
            throw new Error('Aylıq plan xətası: ' + result.error);
        }

        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const fileName = `sinif${sinif}_${ay}_ayliq_plan_${ts}.html`;
        const filePath = path.join(DERS_DIR, fileName);
        fs.writeFileSync(filePath, result.content, 'utf8');

        return {
            content: result.content, fileName, filePath,
            model: result.model, tokensInput: result.tokensInput,
            tokensOutput: result.tokensOutput, latencyMs: result.latencyMs,
        };
    }

    async _getStandards(sinif) {
        try {
            const result = await query(
                'SELECT standard_kodu, standard_metni, saha, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi FROM azdili_standartlari WHERE sinif = $1',
                [sinif]
            );
            return result.rows;
        } catch { return []; }
    }

    async _getTopics(sinif) {
        try {
            const result = await query(
                'SELECT movzu_adi, saat_sayi, saha FROM azdili_movzular WHERE sinif = $1 ORDER BY id',
                [sinif]
            );
            return result.rows;
        } catch { return []; }
    }

    _buildMonthlyPrompt({ sinif, ay, heftelik_saat, pisa_uygun, qiymet_noqte, standards, topics }) {
        const standardsText = standards.length > 0
            ? standards.map(s => `[${s.standard_kodu}] (${s.saha}) ${s.standard_metni} — PISA: ${s.pisa_saviyyesi || '?'}, Blum: ${s.blooms_seviyyesi || '?'}`).join('\n')
            : '';

        const topicsText = topics.length > 0
            ? topics.map(t => `- ${t.movzu_adi} (${t.saat_sayi || '?'} saat, ${t.saha || '?'})`).join('\n')
            : '';

        let pisaSection = '';
        if (pisa_uygun) {
            pisaSection = `
PISA/PIRLS UYĞUNLUĞU:
Hər həftə üçün göstər:
- Hansı PISA oxu prosesini inkişaf etdirir (məlumat alma / şərh / qiymətləndirmə)
- PIRLS kateqoriyası (birbaşa anlama / çıxarım / şərh / inteqrasiya)
- Blum taksonomiya səviyyəsi`;
        }

        let qiymetSection = '';
        if (qiymet_noqte) {
            qiymetSection = `
QİYMƏTLƏNDİRMƏ NÖQTƏLƏRİ:
- Hər 2 həftədən bir formativ qiymətləndirmə
- Ayın sonunda summativ qiymətləndirmə
- Qiymətləndirmə növləri: test, inşa, şifahi, layihə, portfel`;
        }

        return `Sən Azərbaycan dili və ədəbiyyat müəllimisiniz. ${sinif}-ci sinif üçün ${ay} ayı aylıq tematik plan hazırla.

SİNİF: ${sinif}-ci sinif
AY: ${ay}
HƏFTƏLİK SAAT: ${heftelik_saat}
${standardsText ? `\nSTANDARTLAR:\n${standardsText}` : ''}
${topicsText ? `\nMÖVZULAR:\n${topicsText}` : ''}
${pisaSection}
${qiymetSection}

AYLIQ PLAN CƏDVƏLİ (HTML CƏDVƏLİ):

Hər həftə üçün aşağıdakı sütunlar:
| Həftə | Tarixlər | Mövzu | Saat | Fəaliyyət növü | Standart kodu | PISA/Blum | Qiymətləndirmə | Resurs | Ev tapşırığı | Qeydlər |

PLAN TƏLƏBLƏRI:
1. Oxu, yazı, qrammatika, danışıq, ədəbiyyat sahələri arasında balans olsun
2. Hər həftə minimum 2 fərqli sahəni əhatə etsin
3. Mövzular məntiqi ardıcıllıqla düzülsün
4. Dərslik səhifə istinadları olsun
5. Həftəlik saat bölgüsü düzgün olsun

Nəticəni TAM HTML formatında ver. Markdown istifadə etmə.
Sonda aylıq yekun analizi əlavə et (sahə balansı, PISA uyğunluğu, qiymətləndirmə cədvəli).`;
    }
}

module.exports = { AylikPlanAgent };
