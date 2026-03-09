// ============================================================
// Agent 5: Metodiki Kömək (Pedagogical Support Agent)
// Fəal təlim üsulları, metodiki tövsiyələr
// ============================================================
const { AIEngine } = require('../../core/ai_engine');
const { query } = require('../../../config/database');

class MetodikiKomekAgent {
    constructor() {
        this.ai = new AIEngine();
    }

    async suggestMethod({ sinif, movzu, faaliyet_novu = 'Oxu', problem = '' }) {
        const prompt = `Sən Azərbaycan dili və ədəbiyyat tədrisinin metodika mütəxəssisisən.

SİNİF: ${sinif}-ci sinif
MÖVZU: ${movzu}
FƏALİYYƏT: ${faaliyet_novu}
${problem ? `PROBLEM: ${problem}` : ''}

AŞAĞIDAKİ METODLARı TÖVSİYƏ ET:

1. İNTERAKTİV OXU METODLARI:
   - Sesli oxu strategiyası
   - Cütlük oxusu (Paired Reading)
   - Proqnozlaşdırma strategiyası (Predict-Read-Confirm)
   - KWL cədvəli (Bilirəm-Bilmək istəyirəm-Öyrəndim)

2. YAZI TƏDRİSİ METODLARI:
   - Proses yazısı (Plan-Qaralama-Redaktə-Yekun)
   - Yaradıcı yazma texnikaları
   - Modelləşdirmə (Müəllim nümunə yazır)
   - Qrup yazısı

3. QRAMMATİKA TƏDRİSİ:
   - İnduktiv metod (nümunələrdən qaydaya)
   - Deduktiv metod (qaydadan nümunəyə)
   - Oyunlaşdırma ilə qrammatika
   - Kontekstdə qrammatika

4. ƏDƏBİYYAT TƏDRİSİ:
   - Diskussiya dairəsi (Literature Circles)
   - Rol oyunu (dramatizasiya)
   - Müqayisəli təhlil
   - Yaradıcı yazma — əsəri dəyişdirmək

5. DANIŞIQ BACARIQLARININ İNKİŞAFI:
   - Debat və müzakirə
   - Təqdimat bacarıqları
   - Müsahibə texnikası
   - Hekayə danışma

Hər metod üçün:
- Niyə bu mövzuya uyğundur
- Addım-addım tətbiq planı
- Lazımi resurslar
- Qiymətləndirmə strategiyası

Nəticəni HTML formatında ver.`;

        const result = await this.ai.complete({ prompt, maxTokens: 4096 });
        if (!result.success) throw new Error('Metodiki kömək xətası: ' + result.error);
        return { content: result.content, model: result.model };
    }

    async getFormativeStrategies({ sinif, movzu, faaliyet_novu }) {
        const prompt = `${sinif}-ci sinif Azərbaycan dili, mövzu: "${movzu}", fəaliyyət: ${faaliyet_novu} üçün formativ qiymətləndirmə strategiyaları təklif et.

10 fərqli strategiya ver:
1. Çıxış bileti
2. Düşün-Paylaş
3. KWL cədvəli
4. Svetofor (öz-özünə qiymətləndirmə)
5. Sürətli yazı
6. Mini-diktant
7. Cütlük redaktəsi
8. Şifahi sorğu
9. Portfel qiymətləndirmə
10. Müşahidə cədvəli

Hər strategiya üçün konkret nümunə ver.
Nəticəni HTML formatında ver.`;

        const result = await this.ai.complete({ prompt, maxTokens: 4096 });
        if (!result.success) throw new Error('Formativ strategiya xətası: ' + result.error);
        return { content: result.content, model: result.model };
    }

    async generateWarmUpActivities({ sinif, movzu, faaliyet_novu }) {
        const prompt = `${sinif}-ci sinif Azərbaycan dili, mövzu: "${movzu}" üçün 5 fərqli 5-7 dəqiqəlik giriş fəaliyyəti hazırla.

Fəaliyyət tipləri:
- Söz oyunu / tapmaca
- Beyin fırtınası
- Mini-diktant
- Şəkildən hekayə
- Sual-cavab yarışı
- "Bilirsənmi?" dil faktları
- Keçən dərslə əlaqə

Nəticəni HTML formatında ver.`;

        const result = await this.ai.complete({ prompt, maxTokens: 2048 });
        if (!result.success) throw new Error('Giriş fəaliyyəti xətası: ' + result.error);
        return { content: result.content, model: result.model };
    }
}

module.exports = { MetodikiKomekAgent };
