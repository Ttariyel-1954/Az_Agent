// ============================================================
// Agent 1: Dərs Planlaması (Lesson Planning Agent)
// Azərbaycan dili və ədəbiyyat fənni üçün
// PISA/PIRLS/Blum/CEFR beynəlxalq çərçivələri ilə
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

    async generateLessonPlan({
        sinif, movzu, ders_tipi = 'Yeni mövzu', faaliyet_novu = 'Oxu',
        muddet = 45, beynelxalq = ['pisa', 'blooms'],
        diferensial = true, rubrika = true
    }) {
        const standards = await this._getStandards(sinif, faaliyet_novu);
        const chunks = await this._getChunks(sinif, movzu);

        const prompt = this._buildPlanPrompt({
            sinif, movzu, ders_tipi, faaliyet_novu, muddet,
            standards, chunks, beynelxalq, diferensial, rubrika
        });

        const result = await this.ai.complete({ prompt, maxTokens: 8192 });

        if (!result.success) {
            throw new Error('Dərs planı yaratma xətası: ' + result.error);
        }

        const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
        const safeTopic = movzu.replace(/[^a-zA-Z0-9əöüğıçş_-]/gi, '_').substring(0, 40);
        const fileName = `sinif${sinif}_${safeTopic}_ders_plani_${ts}.html`;
        const filePath = path.join(DERS_DIR, fileName);
        fs.writeFileSync(filePath, result.content, 'utf8');

        const beynelxalqData = { pisa: beynelxalq.includes('pisa'), pirls: beynelxalq.includes('pirls'),
            blooms: beynelxalq.includes('blooms'), cefr: beynelxalq.includes('cefr') };

        await query(`
            INSERT INTO ders_planlari (sinif, movzu, ders_tipi, faaliyet_novu, muddet, mezmun, beynelxalq_standartlar, fayl_adi)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        `, [sinif, movzu, ders_tipi, faaliyet_novu, muddet, result.content, JSON.stringify(beynelxalqData), fileName]);

        return {
            content: result.content, fileName, filePath,
            model: result.model, tokensInput: result.tokensInput,
            tokensOutput: result.tokensOutput, latencyMs: result.latencyMs,
        };
    }

    async _getStandards(sinif, saha) {
        const sahaMap = { 'Oxu': 'oxu', 'Yazı': 'yazi', 'Qrammatika': 'qrammatika', 'Danışıq': 'danisiq', 'Ədəbiyyat': 'edebiyyat', 'Qarışıq': 'oxu' };
        const dbSaha = sahaMap[saha] || saha;
        try {
            const result = await query(
                'SELECT standard_kodu, standard_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi FROM azdili_standartlari WHERE sinif = $1 AND saha = $2',
                [sinif, dbSaha]
            );
            return result.rows;
        } catch { return []; }
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
        } catch { return []; }
    }

    _buildPlanPrompt({ sinif, movzu, ders_tipi, faaliyet_novu, muddet, standards, chunks, beynelxalq, diferensial, rubrika }) {
        const standardsText = standards.length > 0
            ? standards.map(s => `- [${s.standard_kodu}] ${s.standard_metni} (PISA: ${s.pisa_saviyyesi || '?'}, Blum: ${s.blooms_seviyyesi || '?'})`).join('\n')
            : 'Standartlar bazada tapılmadı';

        const contextText = chunks.length > 0
            ? chunks.map(c => `--- Dərslik: ${c.movzu}, seh. ${c.sehife_aralighi} ---\n${(c.metn || '').substring(0, 3000)}`).join('\n\n')
            : 'Dərslik konteksti mövcud deyil';

        const m1 = Math.round(muddet * 0.12);
        const m2 = Math.round(muddet * 0.35);
        const m3 = Math.round(muddet * 0.25);
        const m4 = Math.round(muddet * 0.10);
        const m5 = Math.round(muddet * 0.08);

        let beynelxalqSection = '';
        if (beynelxalq && beynelxalq.length > 0) {
            beynelxalqSection = `
BEYNƏLXALQ STANDART UYĞUNLUĞU (MÜTLƏQ daxil et):
${beynelxalq.includes('pisa') ? '- PISA oxu prosesi: məlumat alma / şərh / qiymətləndirmə — hansı prosesi inkişaf etdirir' : ''}
${beynelxalq.includes('pirls') ? '- PIRLS kateqoriyası: birbaşa anlama / çıxarım / şərh / inteqrasiya' : ''}
${beynelxalq.includes('blooms') ? '- Blum taksonomiyası: hər məqsədin taksonomiya səviyyəsini göstər' : ''}
${beynelxalq.includes('cefr') ? '- CEFR dil səviyyəsi: A1/A2/B1/B2/C1/C2' : ''}`;
        }

        let diferensialSection = '';
        if (diferensial) {
            diferensialSection = `
DİFERENSİAL TAPŞIRIQLAR (3 SƏVİYYƏ — cədvəl şəklində):
| Səviyyə | Tapşırıq | Məqsəd |
|---------|---------|--------|
| Zəif şagird | sadə, dəstəkli tapşırıq | anlama |
| Orta şagird | müstəqil tapşırıq | tətbiq |
| Güclü şagird | yaradıcı, analitik tapşırıq | yaratma |`;
        }

        let rubrikaSection = '';
        if (rubrika) {
            rubrikaSection = `
QİYMƏTLƏNDİRMƏ METRİKASI (cədvəl şəklində):
| Meyar | 4 (əla) | 3 (yaxşı) | 2 (kafi) | 1 (qeyri-kafi) |
|-------|---------|-----------|----------|----------------|
| Anlama | ... | ... | ... | ... |
| Tətbiq | ... | ... | ... | ... |
| Nitq | ... | ... | ... | ... |
| İştirak | ... | ... | ... | ... |

ÖZÜNÜQIYMƏTLƏNDIRMƏ (şagird üçün):
□ Mövzunu başa düşdüm
□ Nümunə gətirə bilərəm
□ Hələ anlamadığım var: ___________`;
        }

        return `Sən Azərbaycan dili və ədəbiyyat müəllimisiniz. Aşağıdakı parametrlərə uyğun ƏTRAFLY dərs planı hazırla.

SİNİF: ${sinif}-ci sinif
MÖVZU: ${movzu}
DƏRS TİPİ: ${ders_tipi}
FƏALİYYƏT: ${faaliyet_novu}
MÜDDƏT: ${muddet} dəqiqə

STANDARTLAR:
${standardsText}

DƏRSLİKDƏN KONTEKST:
${contextText}
${beynelxalqSection}

TƏLİM NƏTİCƏLƏRİ (Blum Taksonomiyasına görə):
Dərsin sonunda şagirdlər:
- Bilik səviyyəsi: nəyi xatırlayacaq
- Anlama səviyyəsi: nəyi izah edəcək
- Tətbiq səviyyəsi: nəyi tətbiq edəcək
- Təhlil səviyyəsi: nəyi təhlil edəcək
- Qiymətləndirmə: nəyi qiymətləndirəcək
- Yaratma: nə yaradacaq (yüksək siniflərdə)

RESURSLAR VƏ HAZIRLIIQ:
- Dərslik: sinif, səhifə nömrəsi
- Əlavə materiallar: vizual, audio, kart və s.

DƏRSİN GEDİŞATI:

I. MOTİVASİYA VƏ FƏALLAŞDIRMA (${m1} dəq)
- Əvvəlki biliklərin aktivləşdirilməsi
- Açar suallar
- Gözlənti: şagirdlərin mövzu haqqında fərziyyələri

II. YENİ MATERİALIN İZAHI (${m2} dəq)
- Müəllim izahı
- Dərslik mətni ilə iş
- Nümunə təhlil
${diferensialSection}

III. MƏŞQ VƏ TƏTBİQ (${m3} dəq)
- Qrup işi / cütlük işi
- Fəal təlim üsulu: Düşün-Cütləş-Paylaş və s.
- Tapşırıq məzmunu

IV. FORMATIV QİYMƏTLƏNDİRMƏ (${m4} dəq)
- Yoxlama üsulu: Çıxış bileti / Baş barmaq / Mini test / Sual-cavab
- Uğur meyarları
${rubrikaSection}

V. ÜMUMILƏŞDIRMƏ VƏ EV İŞİ (${m5} dəq)
- Dərsin xülasəsi
- Ev tapşırığı: diferensial — iki səviyyə
- Növbəti dərsin elanı

Nəticəni TAM HTML formatında ver. Markdown istifadə etmə.`;
    }
}

module.exports = { DersPlanlamasiAgent };
