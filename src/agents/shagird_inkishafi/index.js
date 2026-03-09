// ============================================================
// Agent 4: Şagird İnkişafı (Student Development Agent)
// Oxu-yazı inkişafını təhlil edir, fərdi tövsiyələr verir
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');

class ShagirdInkishafiAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async analyzeStudent({ sinif, zeif_terefler = [], elave_melumat = '' }) {
        const standards = await this._getStandards(sinif);

        const prompt = this._buildAnalysisPrompt(sinif, zeif_terefler, elave_melumat, standards);
        const result = await this.ai.complete({ prompt, maxTokens: 4096 });

        if (!result.success) {
            throw new Error('Şagird analizi xətası: ' + result.error);
        }

        return { content: result.content, model: result.model };
    }

    async generateParentLetter({ sinif, zeif_terefler = [], guclu_terefler = [] }) {
        const prompt = `Sən Azərbaycan dili və ədəbiyyat müəllimisiniz. ${sinif}-ci sinif şagirdinin valideynlərinə məktub hazırla.

GÜCLÜ TƏRƏFLƏRİ: ${guclu_terefler.join(', ') || 'Qeyd olunmayıb'}
ZƏİF TƏRƏFLƏRİ: ${zeif_terefler.join(', ') || 'Qeyd olunmayıb'}

MƏKTUB DAXIL ETMƏLİDİR:
1. Şagirdin güclü tərəflərini vurğulama
2. İnkişaf sahələrini həssas şəkildə qeyd etmə
3. Evdə dil bacarıqlarını inkişaf etdirmək üçün konkret tövsiyələr:
   - Oxu vərdişi (hansı kitabları oxumaq)
   - Yazı təcrübəsi (gündəlik yazma)
   - Qrammatika möhkəmləndirmə
   - Danışıq bacarıqları
4. Müəllimlə əməkdaşlıq planı

Nəticəni HTML formatında ver.`;

        const result = await this.ai.complete({ prompt, maxTokens: 2048 });
        if (!result.success) throw new Error('Valideyn məktubu xətası: ' + result.error);
        return { content: result.content, model: result.model };
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

    _buildAnalysisPrompt(sinif, zeif_terefler, elave_melumat, standards) {
        const saheMap = {
            'Oxu': 'Oxu bacarıqları — mətni başa düşmə, tələffüz, sürətli oxu',
            'Yazı': 'Yazı bacarıqları — inşa, esse, məktub, orfoqrafiya',
            'Qrammatika': 'Qrammatik biliklər — nitq hissələri, cümlə quruluşu, durğu işarələri',
            'Nitq': 'Nitq və danışıq — şifahi ifadə, diskussiya, təqdimat',
            'Ədəbiyyat': 'Ədəbiyyat — əsər təhlili, janr bilgisi, müəllif haqqında bilik',
        };

        const zeifText = zeif_terefler.length > 0
            ? zeif_terefler.map(z => `- ${z}: ${saheMap[z] || z}`).join('\n')
            : 'Qeyd olunmayıb';

        const standardsText = standards.length > 0
            ? standards.map(s => `[${s.standard_kodu}] (${s.saha}) ${s.standard_metni}`).join('\n')
            : '';

        return `Sən təcrübəli Azərbaycan dili və ədəbiyyat müəllimisiniz. Şagirdin inkişafını təhlil et.

SİNİF: ${sinif}-ci sinif

ZƏİF TƏRƏFLƏRİ:
${zeifText}

${elave_melumat ? `ƏLAVƏ MƏLUMAT: ${elave_melumat}` : ''}

${standardsText ? `STANDARTLAR:\n${standardsText}` : ''}

ANALİZ ET VƏ TÖVSİYƏ VER:
1. Hər zəif sahə üzrə konkret inkişaf planı
2. Təcrübə tapşırıqları (hər sahə üçün 3-5 tapşırıq)
3. Oxu materialları tövsiyəsi (yaşa uyğun kitablar)
4. Haftalıq iş planı
5. Müəllim üçün fərdi yanaşma strategiyaları
6. Valideyn üçün ev tapşırığı tövsiyələri
7. 1 aylıq inkişaf hədəfləri

Nəticəni HTML formatında ver.`;
    }
}

module.exports = { ShagirdInkishafiAgent };
