// ============================================================
// Agent: Ədəbi Təhlil (Literary Analysis Agent)
// Azərbaycan ədəbiyyatı üçün 10 elementli dərin təhlil
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');
const fs = require('fs');
const path = require('path');

const DERS_DIR = path.join(__dirname, '../../../Ders_planlari');
if (!fs.existsSync(DERS_DIR)) fs.mkdirSync(DERS_DIR, { recursive: true });

class EdebiTahlilAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async analyzeLiteraryText({
        sinif, muellif = '', eser = '', analiz_novu = 'Tam ədəbi təhlil (bütün elementlər)',
        rubrika_edebi = true, muqayise = false
    }) {
        const standards = await this._getStandards(sinif);
        const chunks = await this._getChunks(sinif, eser || muellif);

        const prompt = this._buildAnalysisPrompt({
            sinif, muellif, eser, analiz_novu,
            rubrika_edebi, muqayise, standards, chunks
        });

        const result = await this.ai.complete({ prompt, maxTokens: 8192 });

        if (!result.success) {
            throw new Error('Ədəbi təhlil xətası: ' + result.error);
        }

        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const safeWork = (eser || muellif).replace(/[^a-zA-Z0-9əöüğıçş_-]/gi, '_').substring(0, 40);
        const fileName = `sinif${sinif}_${safeWork}_edebi_tehlil_${ts}.html`;
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
                "SELECT standard_kodu, standard_metni, pisa_saviyyesi, blooms_seviyyesi FROM azdili_standartlari WHERE sinif = $1 AND saha = 'edebiyyat'",
                [sinif]
            );
            return result.rows;
        } catch { return []; }
    }

    async _getChunks(sinif, searchTerm) {
        try {
            const result = await query(
                `SELECT movzu, metn, sehife_aralighi FROM azdili_derslikler
                 WHERE sinif = $1 AND (movzu ILIKE $2 OR metn ILIKE $2) LIMIT 3`,
                [sinif, `%${searchTerm}%`]
            );
            return result.rows;
        } catch { return []; }
    }

    _buildAnalysisPrompt({ sinif, muellif, eser, analiz_novu, rubrika_edebi, muqayise, standards, chunks }) {
        const standardsText = standards.length > 0
            ? standards.map(s => `- [${s.standard_kodu}] ${s.standard_metni}`).join('\n')
            : '';

        const contextText = chunks.length > 0
            ? chunks.map(c => `--- ${c.movzu}, seh. ${c.sehife_aralighi} ---\n${(c.metn || '').substring(0, 3000)}`).join('\n\n')
            : '';

        const analizInstructions = {
            'Tam ədəbi təhlil (bütün elementlər)': 'BÜTÜN 10 elementi tam şəkildə təhlil et.',
            'Kompozisiya və süjet təhlili': '2-ci elementi (Süjetin strukturu) ətraflı təhlil et.',
            'Obraz sistemi təhlili': '3-cü elementi (Obraz sistemi) ətraflı təhlil et.',
            'Bədii təsvir vasitələri': '5-ci elementi (Bədii təsvir vasitələri) ətraflı, cədvəl ilə təhlil et.',
            'Müqayisəli ədəbi təhlil': '7-ci elementi (Müqayisəli təhlil) ətraflı yaz.',
            'Dil və üslub təhlili': '6-cı elementi (Dil və üslub) ətraflı təhlil et.',
            'Tənqidi düşüncə sualları (PISA)': '8-ci elementi (Şagird tənqidi düşüncə sualları) PISA formatında ətraflı yaz.',
            'Müəllim üçün metodiki qeydlər': '9-cu elementi (Müəllim üçün metodiki qeydlər) ətraflı yaz.',
        };

        return `Sən Azərbaycan ədəbiyyatını dərindən bilən ekspert ədəbiyyatşünas AI-san.
${sinif}-ci sinif səviyyəsində ədəbi təhlil hazırla.

ƏSƏR: ${eser}
MÜƏLLİF: ${muellif}
SİNİF: ${sinif}-ci sinif
ANALİZ NÖVÜ: ${analiz_novu}
${standardsText ? `\nSTANDARTLAR:\n${standardsText}` : ''}
${contextText ? `\nDƏRSLİKDƏN KONTEKST:\n${contextText}` : ''}

${analizInstructions[analiz_novu] || analizInstructions['Tam ədəbi təhlil (bütün elementlər)']}

ƏDƏBİ MƏTNİN TƏHLİLİ — 10 ELEMENT:

1. BİBLİOQRAFİK MƏLUMAT
- Müəllif haqqında: həyatı, dövrü, əsas əsərləri (3-4 cümlə)
- Əsərin yazılma tarixi və tarixi kontekst
- Janr və forma xüsusiyyətləri

2. SÜJETİN STRUKTURU (cədvəl şəklində):
| Kompozisiya elementi | Məzmun | Əhəmiyyəti |
|---------------------|--------|------------|
| Ekspozisiya | | |
| Düyün | | |
| İnkişaf | | |
| Kulminasiya | | |
| Çözüm | | |

3. OBRAZ SİSTEMİ
- Baş qəhrəman(lar): ad, xarakter cizgiləri, inkişaf, simvolik məna
- İkinci dərəcəli obrazlar: rolu, əsas qəhrəmanla münasibəti
- Müəllifin obraz sistemi vasitəsilə ifadə etdiyi ideya

4. MÖVZU VƏ İDEYA
- Əsas mövzu, alt mövzular
- Əsas ideya (müəllifin oxucuya çatdırmaq istədiyi əsas fikir)
- Aktuallıq: bu gün üçün nə dərəcədə aktualdır

5. BƏDİİ TƏSVİR VASİTƏLƏRİ (cədvəl şəklində):
| Vasitə | Mətn nümunəsi | Funksiyası |
|--------|--------------|------------|
| Metafora | "..." | |
| Epitet | "..." | |
| Bənzətmə | "..." | |
| Təzad | "..." | |
| Hiperbola | "..." | |
| Alliterasiya | "..." | |

6. DİL VƏ ÜSLUB
- Leksik xüsusiyyətlər: arxaizmlər, dialektizmlər, neologizmlər
- Sintaktik xüsusiyyətlər: cümlə quruluşu
- Ton: lirik/dramatik/ironik/elegik
- Bədii dil effektləri

7. MÜQAYİSƏLİ TƏHLİL
${muqayise ? '- Eyni mövzuda başqa əsərlərlə müqayisə\n- Eyni dövrün digər müəllifləri ilə paralellər\n- Dünya ədəbiyyatında analoqlar' : '- Qısa müqayisəli qeydlər'}

8. ŞAGİRD TƏNQİDİ DÜŞÜNCƏ SUALLARI

Məzmun anlama (PIRLS — birbaşa):
1. Əsərdə baş verən hadisələri ardıcıllıqla sadalayın.
2. Baş qəhrəman hansı problemi həll etməyə çalışır?

Şərhetmə (PIRLS — çıxarım):
3. Müəllif niyə əsəri belə bitirdi? Başqa son mümkün idimi?
4. Qəhrəmanın hərəkətlərinin səbəbini izah edin.

Qiymətləndirmə (PISA Səv.4-5):
5. Siz qəhrəmanın yerində olsaydınız, eyni addımı atardınızmı? Niyə?
6. Bu əsərin ən güclü və ən zəif tərəfi sizin fikrinizlə nədir?

Yaratma (Blum — yüksək səviyyə):
7. Əsərə alternativ son yazın.
8. Əsərin müasir versiyasını necə yazardınız?

9. MÜƏLLİM ÜÇÜN METODİK QEYDLƏR
- Dərsdə istifadə üçün 3 fəal təlim üsulu
- Fənlərarası əlaqə: tarix/musiqi/rəsm/coğrafiya
- Yaradıcı tapşırıq: inşa/şeir/rol oyunu/layihə

${rubrika_edebi ? `10. QİYMƏTLƏNDİRMƏ RUBRİKASI — İNŞA / ŞİFAHİ TƏHLİL
| Meyar | 4 — Əla | 3 — Yaxşı | 2 — Kafi | 1 — Qeyri-kafi |
|-------|---------|-----------|----------|----------------|
| Mövzu uyğunluğu | Tam uyğun, dərin | Uyğun | Qismən | Uyğun deyil |
| İdeyaların inkişafı | Ətraflı, nümunəli | Kifayət qədər | Az inkişaf | İnkişafsız |
| Bədii təsvir | Zəngin, yerli | Var, az | Cüzi | Yoxdur |
| Dil və üslub | Zəngin, səlis | Düzgün | Bəzi səhvlər | Çox səhv |
| Struktur | Mükəmməl | Yaxşı | Var | Yoxdur |` : ''}

Nəticəni TAM HTML formatında ver. Markdown istifadə etmə.
HƏR element ətraflı və konkret olmalıdır — səthi təhlil QƏBUL EDİLMİR.`;
    }
}

module.exports = { EdebiTahlilAgent };
