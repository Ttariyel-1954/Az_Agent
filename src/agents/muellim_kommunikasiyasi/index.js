// ============================================================
// Agent 3: Müəllim Kommunikasiyası (Communication Agent)
// Valideyn məktubu, müəllimə istinad, bildiriş yaratma
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');
const fs = require('fs');
const path = require('path');

const MSG_DIR = path.join(__dirname, '../../../Mesajlar');
if (!fs.existsSync(MSG_DIR)) fs.mkdirSync(MSG_DIR, { recursive: true });

class MuellimKommunikasiyasiAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async generateMessage({ sinif, novu = 'valideyn_mektubu', mezmun_kontekst = '' }) {
        const prompt = this._buildPrompt(sinif, novu, mezmun_kontekst);
        const result = await this.ai.complete({ prompt, maxTokens: 2048 });

        if (!result.success) {
            throw new Error('Mesaj yaratma xətası: ' + result.error);
        }

        // DB-yə yaz
        await query(
            'INSERT INTO mesajlar (sinif, novu, mezmun) VALUES ($1, $2, $3)',
            [sinif, novu, result.content]
        );

        // Faylı saxla
        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const fileName = `sinif${sinif}_${novu}_${ts}.html`;
        fs.writeFileSync(path.join(MSG_DIR, fileName), result.content, 'utf8');

        return { content: result.content, fileName, model: result.model };
    }

    _buildPrompt(sinif, novu, kontekst) {
        const templates = {
            'valideyn_mektubu': `${sinif}-ci sinif şagirdinin valideynlərinə məktub hazırla.
Kontekst: ${kontekst || 'Ümumi vəziyyət haqqında məlumat'}

TƏLƏBLƏR:
- Hörmətli və peşəkar ton
- Şagirdin Azərbaycan dili fənnindəki nailiyyətləri və inkişaf sahələri
- Evdə dil bacarıqlarını inkişaf etdirmək üçün tövsiyələr
- Oxu vərdişlərinin formalaşdırılması tövsiyələri
- Görüşə dəvət (lazım olarsa)`,

            'muellime_istinad': `${sinif}-ci sinif Azərbaycan dili müəllimi üçün metodiki istinad hazırla.
Kontekst: ${kontekst || 'Ümumi metodiki dəstək'}

DAXIL ET:
- Fənnin tədris metodikası
- Effektiv oxu-yazı strategiyaları
- Qrammatika tədrisinin interaktiv yolları
- Ədəbiyyat dərslərində diskussiya metodları
- Diferensiallaşdırma yolları`,

            'bildiris': `${sinif}-ci sinif üçün bildiriş hazırla.
Kontekst: ${kontekst || 'Ümumi bildiriş'}

FORMAT: Rəsmi bildiriş formatında, aydın və qısa.`,

            'ugur_mektubu': `${sinif}-ci sinif şagirdi üçün uğur məktubu hazırla.
Kontekst: ${kontekst || 'Dil bacarıqlarında uğur'}

TON: Motivasiya edici, müsbət, ruhlandırıcı.`,

            'toplanti_protokolu': `${sinif}-ci sinif valideyn toplantısı protokolu hazırla.
Kontekst: ${kontekst || 'Rüblük nəticələr'}

DAXIL ET: Gündəm, müzakirə edilən məsələlər, qərarlar.`,
        };

        const promptText = templates[novu] || templates['valideyn_mektubu'];
        return `Sən Azərbaycan dili və ədəbiyyat müəllimisiniz. ${promptText}\n\nNəticəni HTML formatında ver.`;
    }
}

module.exports = { MuellimKommunikasiyasiAgent };
