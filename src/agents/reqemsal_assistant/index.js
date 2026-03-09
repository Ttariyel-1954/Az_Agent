// ============================================================
// Agent 6: Rəqəmsal Assistant (Digital Assistant / Free Q&A)
// Azad sual-cavab assistenti
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');

class ReqemsalAssistantAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async askQuestion({ sual, sinif = null }) {
        const sinifContext = sinif ? `\nKONTEKST: ${sinif}-ci sinif Azərbaycan dili və ədəbiyyat fənni\n` : '';

        const prompt = `${sinifContext}

SUAL: ${sual}

CAVAB TƏLƏBLƏRI:
- Azərbaycan dilində cavab ver
- Ətraflı və dəqiq izah
- Nümunələr ver
- Dərslik və kurikuluma istinad et (mümkün olduqda)
- Müəllim üçün faydalı olsun

Nəticəni HTML formatında ver.`;

        const result = await this.ai.complete({ prompt, maxTokens: 4096 });
        if (!result.success) throw new Error('Sual-cavab xətası: ' + result.error);
        return { content: result.content, model: result.model };
    }

    async generateMonthlyPlan({ sinif, ay, heftelik_saat = 3 }) {
        const standards = await this._getStandards(sinif);
        const topics = await this._getTopics(sinif);

        const prompt = `Sən Azərbaycan dili və ədəbiyyat müəllimisiniz. ${sinif}-ci sinif üçün ${ay} ayı aylıq plan hazırla.

Həftəlik saat: ${heftelik_saat}

${standards.length > 0 ? `STANDARTLAR:\n${standards.map(s => `[${s.standard_kodu}] ${s.standard_metni}`).join('\n')}` : ''}

${topics.length > 0 ? `MÖVZULAR:\n${topics.map(t => `- ${t.movzu_adi} (${t.saat_sayi || '?'} saat)`).join('\n')}` : ''}

PLAN FORMATI (HTML CƏDVƏLİ):
- Həftə nömrəsi
- Tarixlər
- Mövzu
- Fəaliyyət növü (Oxu/Yazı/Qrammatika/Danışıq/Ədəbiyyat)
- Standart kodu
- Saat sayı
- Qiymətləndirmə üsulu
- Ev tapşırığı
- Qeydlər

Nəticəni HTML cədvəl formatında ver.`;

        const result = await this.ai.complete({ prompt, maxTokens: 4096 });
        if (!result.success) throw new Error('Aylıq plan xətası: ' + result.error);
        return { content: result.content, model: result.model };
    }

    async analyzeLiteraryText({ sinif, muellif_eser, analiz_novu = 'Məzmun' }) {
        const prompt = `Sən Azərbaycan ədəbiyyatı mütəxəssisisən. ${sinif}-ci sinif səviyyəsində ədəbi təhlil hazırla.

MÜƏLLİF/ƏSƏR: ${muellif_eser}
ANALİZ NÖVÜ: ${analiz_novu}

ANALİZ DAXIL ETMƏLİDİR:

${analiz_novu === 'Məzmun' ? `
- Əsərin mövzusu və ideyası
- Süjet xətti (başlanğıc-kulminasiya-sonluq)
- Əsas hadisələr
- Müəllifin mesajı
- Şagirdlər üçün müzakirə sualları (5-7 sual)` : ''}

${analiz_novu === 'Şəxsiyyət' ? `
- Əsas və epizodik obrazlar
- Xarakter xüsusiyyətləri
- Obrazların inkişafı
- Obrazlar arası münasibətlər
- Müqayisəli xarakteristika tapşırığı` : ''}

${analiz_novu === 'Dil-üslub' ? `
- Müəllifin dil xüsusiyyətləri
- Bədii təsvir vasitələri (epitet, metafora, təşbeh, mübaliğə)
- Üslub xüsusiyyətləri
- Leksik tərkib
- Şagirdlər üçün dil analizi tapşırıqları` : ''}

${analiz_novu === 'Mövzu-ideya' ? `
- Əsərin əsas mövzusu
- İdeya və mesaj
- Tarixi-ictimai kontekst
- Müasir aktuallıq
- Əsərin dəyərləndirmə rubrikası` : ''}

Nəticəni HTML formatında ver. Şagirdlər üçün tapşırıqlar əlavə et.`;

        const result = await this.ai.complete({ prompt, maxTokens: 4096 });
        if (!result.success) throw new Error('Ədəbi təhlil xətası: ' + result.error);
        return { content: result.content, model: result.model };
    }

    async _getStandards(sinif) {
        try {
            const result = await query(
                'SELECT standard_kodu, standard_metni FROM azdili_standartlari WHERE sinif = $1',
                [sinif]
            );
            return result.rows;
        } catch { return []; }
    }

    async _getTopics(sinif) {
        try {
            const result = await query(
                'SELECT movzu_adi, saat_sayi FROM azdili_movzular WHERE sinif = $1 ORDER BY id',
                [sinif]
            );
            return result.rows;
        } catch { return []; }
    }
}

module.exports = { ReqemsalAssistantAgent };
