# AZ_MUELLIM_AGENT — Claude Code Tapşırığı

## VƏZİYYƏT
Hazır olan fayllar:
- derslikler/pdf/ — 16 PDF dərslik (1-11-ci sinif, cəmi 2191 səhifə)
- derslikler/chunks/ — 519 chunk (32 JSON+TXT fayl)
- derslikler/index.json — master indeks
- scripts/pdf_pipeline.py — PDF emal skripti
- .env — DB və API açarları

## TAPŞIRIQ
Aşağıdakı işləri ardıcıl icra et:

### 1. Riy_Muellim_Agent-dən faylları kopyala və uyğunlaşdır
```
cp ~/Desktop/Riy_Muellim_Agent/database/migrations/001_schema.sql database/migrations/001_schema.sql
cp ~/Desktop/Riy_Muellim_Agent/database/seeds/run.js database/seeds/run.js
cp ~/Desktop/Riy_Muellim_Agent/database/migrations/run.js database/migrations/run.js
cp ~/Desktop/Riy_Muellim_Agent/config/database.js config/database.js
cp ~/Desktop/Riy_Muellim_Agent/src/server.js src/server.js
cp ~/Desktop/Riy_Muellim_Agent/src/core/ai_engine.js src/core/ai_engine.js
cp ~/Desktop/Riy_Muellim_Agent/src/api/routes.js src/api/routes.js
cp ~/Desktop/Riy_Muellim_Agent/src/middleware/auth.js src/middleware/auth.js
cp ~/Desktop/Riy_Muellim_Agent/package.json package.json
cp ~/Desktop/Riy_Muellim_Agent/.gitignore .gitignore
cp ~/Desktop/Riy_Muellim_Agent/Dockerfile Dockerfile
cp ~/Desktop/Riy_Muellim_Agent/docker-compose.yml docker-compose.yml
```

### 2. database/migrations/001_schema.sql — yenidən yaz

Riy_Muellim_Agent-dəki sxemi model kimi götür, lakin TAM YENİDƏN yaz:
- DB adı: `az_muellim_db`
- Cədvəl: `azdili_standartlari` (riyaziyyat_standartlari əvəzinə)
  - id, sinif (1-11), saha (oxu/yazi/qrammatika/danisiq/edebiyyat), 
    standard_kodu, standard_metni, alstandart_kodu, alstandart_metni
- Cədvəl: `azdili_movzular`
  - id, sinif, saha, movzu_adi, movzu_izahi, saat_sayi
- Cədvəl: `azdili_derslikler`
  - id, sinif, hisse, chunk_id, movzu, saha, metn, sehife_aralighi, soz_sayi
- Cədvəl: `ders_planlari`
  - id, sinif, movzu, ders_tipi, faaliyet_novu, muddət, məzmun (TEXT), 
    yaradilma_tarixi, fayl_adi
- Cədvəl: `testler`
  - id, sinif, movzu, test_tipi, çətinlik, sual_sayi, məzmun (TEXT),
    yaradilma_tarixi, fayl_adi
- Cədvəl: `mesajlar`
  - id, sinif, novü, məzmun (TEXT), yaradilma_tarixi
- Cədvəl: `edebi_metnler`
  - id, sinif, müəllif, əsər_adı, janr, mövzu, xülasə, tam_mətn (TEXT)
- Cədvəl: `luget_izahlar`
  - id, sinif, söz, izah, misal_cümlə, sahə

### 3. database/seeds/001_base_seed.sql — yarat

1-11-ci sinif üçün Azərbaycan dili standartlarını daxil et.
Hər sinif üçün ən azı 5-6 əsas standard (oxu, yazı, qrammatika, danışıq sahələri üzrə).
Kurikulum faylına bax: derslikler/pdf/az_dili_kurikulum_2024.pdf — 
lakin PDF oxumaq əvəzinə, ümumi bilikdən Azərbaycan dili kurikulumu standartlarını yaz.

### 4. database/seeds/002_chunks_seed.js — yarat

Bu skript derslikler/chunks/ qovluğundakı bütün JSON fayllarını oxuyub
`azdili_derslikler` cədvəlinə yükləsin:
```javascript
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const CHUNKS_DIR = path.join(__dirname, '../../derslikler/chunks');

async function loadChunks() {
  const files = fs.readdirSync(CHUNKS_DIR).filter(f => f.endsWith('_chunks.json'));
  let total = 0;
  for (const file of files) {
    const chunks = JSON.parse(fs.readFileSync(path.join(CHUNKS_DIR, file), 'utf8'));
    for (const chunk of chunks) {
      await pool.query(`
        INSERT INTO azdili_derslikler 
          (sinif, hisse, chunk_id, movzu, saha, metn, sehife_aralighi, soz_sayi)
        VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
        ON CONFLICT (chunk_id) DO NOTHING
      `, [
        chunk.grade, chunk.part, chunk.id,
        chunk.topic, chunk.content_area, chunk.text,
        chunk.page_start + '-' + chunk.page_end,
        chunk.word_count
      ]);
      total++;
    }
  }
  console.log(`✅ ${total} chunk yükləndi`);
  await pool.end();
}

loadChunks().catch(console.error);
```

### 5. config/database.js — yenilə
`az_muellim_db` DB adını işlət.

### 6. src/core/ai_engine.js — system promptu yenilə
Riy_Muellim_Agent-dəki ai_engine.js-i kopyala, yalnız system promptu dəyiştir:
```
Sən Azərbaycan Respublikasının 1-11-ci sinif Azərbaycan dili və ədəbiyyat 
fənnini dərindən bilən, müasir təhsil metodlarını, tematik planlamanı, 
oxu-yazı bacarıqlarını, ədəbi mətn təhlilini, qrammatika tədrisini və 
qiymətləndirmə rubrikalarını yaxşı bilən bir mütəxəssis AI müəllim 
assistentisən. Bütün cavablarını Azərbaycan dilində ver.
```

### 7. src/agents/ — 6 agent yarat

Hər agenti Riy_Muellim_Agent-dəki müvafiq agent əsasında yaz, 
yalnız fənn kontekstini dəyiştir:

**src/agents/ders_planlamasi/index.js**
- Sinif + mövzu + ders tipi (oxu/yazı/qrammatika/ədəbiyyat/danışıq) + müddət alır
- DB-dən həmin sinif və mövzu üzrə chunk-ları çəkir
- Claude API ilə dərs planı yaradır
- Ders_planlari/ qovluğuna HTML+DOCX saxlayır
- DB-yə yazır

**src/agents/qiymetlendirme/index.js**  
- Test tipi: çoxseçimli / açıq sual / diktant / inşa rubrikalari / şifahi
- Sual sayı + çətinlik + sinif + mövzu alır
- Testler/ qovluğuna saxlayır

**src/agents/muellim_kommunikasiyasi/index.js**
- Valideyn məktubu / müəllimə istinad / bildiriş yaradır

**src/agents/shagird_inkishafi/index.js**
- Şagirdin oxu-yazı inkişafını təhlil edir, fərdi tövsiyələr verir

**src/agents/metodiki_komek/index.js**
- Fəal təlim üsulları, metodiki tövsiyələr verir

**src/agents/reqemsal_assistant/index.js**
- Azad sual-cavab assistenti

### 8. src/api/routes.js — endpointlər
```
POST /api/ders-plani
POST /api/test-yarat  
POST /api/insha-rubrika
POST /api/diktant-hazirla
POST /api/edebi-tahlil
POST /api/aylik-plan
POST /api/mesaj-yaz
POST /api/shagird-analiz
GET  /api/arxiv/ders-planlari
GET  /api/arxiv/testler
```

### 9. r_shiny/app/app.R — TAM YENİDƏN YAZ

Riy_Muellim_Agent-dəki r_shiny/app/app.R-i oxu və TAM analoqu yarat.
Fərqlər:
- Başlıq: "Azərbaycan Dili Müəllim Agenti v1.0"
- Rəng: #2E7D32 (tünd yaşıl) əsas rəng
- İkon: 📚

**6 Tab:**

Tab 1 — Dərs Planı:
  - sinif (1-11), mövzu (text), ders_tipi (Yeni/Möhkəmləndirmə/Qiymətləndirmə),
    faaliyet (Oxu/Yazı/Qrammatika/Danışıq/Ədəbiyyat), müddət (45/60 dəq)
  - "Dərs Planı Yarat" → HTML göstər + DOCX yüklə

Tab 2 — Test və Qiymətləndirmə:
  - sinif, mövzu, test_tipi (Çoxseçimli/Açıq sual/Diktant/İnşa rubrikalari),
    sual_sayi (5-30), çətinlik (Asan/Orta/Çətin/Qarışıq)
  - "Test Yarat" → HTML göstər + DOCX yüklə

Tab 3 — Aylıq Plan:
  - sinif, ay, həftəlik_saat (2/3/4)
  - Cədvəl + DOCX

Tab 4 — Ədəbi Mətn Analizi:
  - sinif, müəllif/əsər, analiz_novu (Məzmun/Şəxsiyyət/Dil-üslub/Mövzu-ideya)
  - Suallar + DOCX

Tab 5 — Şagird Analizi:
  - sinif, zəif_tərəflər (checkbox: Oxu/Yazı/Qrammatika/Nitq/Ədəbiyyat)
  - Fərdi tövsiyələr + valideyn məktubu

Tab 6 — Müəllim Köməkçisi:
  - Azad sual → AI cavabı

Hər tabda:
- withProgress() yükləmə animasiyası
- Nəticəni HTML kimi göstər (htmlOutput)
- DOCX yükləmə düyməsi (officer paketi ilə)
- Faylları Ders_planlari/ və Testler/ qovluğuna saxla

**DB inteqrasiyası:**
- Hər nəticəni avtomatik DB-yə yaz
- Tab7 — Arxiv: keçmiş planların/testlərin cədvəli

### 10. package.json — yenilə
name: "az-muellim-agent", Riy-dəki asılılıqları saxla.

### 11. scripts/setup.sh — yarat
```bash
#!/bin/bash
echo "Az_Muellim_Agent quraşdırılır..."
cd ~/Desktop/Az_agent
npm install
createdb az_muellim_db 2>/dev/null || echo "DB mövcuddur"
psql -d az_muellim_db -f database/migrations/001_schema.sql
psql -d az_muellim_db -f database/seeds/001_base_seed.sql
node database/seeds/002_chunks_seed.js
echo "✅ Hazırdır! R Shiny üçün: cd r_shiny/app && R -e \"shiny::runApp()\""
```

### 12. README.md — yarat
Azərbaycan dilində tam təlimat.

## İCRA SIRASI
1. DB faylları (schema → seeds)
2. config/ 
3. src/core/ → src/agents/ → src/api/ → src/server.js
4. r_shiny/app/app.R (ən böyük fayl, diqqətlə yaz)
5. package.json, scripts/, README.md

## QEYDLƏR
- .env faylı hazırdır, dəyişmə
- Azərbaycan əlifbası: ə, ö, ü, ğ, ı, ç, ş
- DOCX üçün `officer` R paketi
- Timestamp: format(Sys.time(), "%Y%m%d_%H%M%S")
- Fayllar: ~/Desktop/Az_agent/Ders_planlari/ və ~/Desktop/Az_agent/Testler/
