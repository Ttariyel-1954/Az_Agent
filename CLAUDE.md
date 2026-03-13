# AZ_MUELLIM_AGENT — Claude Code Tapşırığı (v2.0 — Genişləndirilmiş)

## VƏZİYYƏT
Hazır olan fayllar:
- derslikler/pdf/ — 16 PDF dərslik (1-11-ci sinif, 2191 səhifə)
- derslikler/chunks/ — 519 chunk (index.json ilə)
- scripts/pdf_pipeline.py — tamamlanmış
- .env — DB və API açarları mövcuddur

---

## TAPŞIRIQ 1 — VERİLƏNLƏR BAZASI

### database/migrations/001_schema.sql

Aşağıdakı cədvəlləri yarat (az_muellim_db):
```sql
-- Standartlar (kurikulum + beynəlxalq çərçivə)
CREATE TABLE azdili_standartlari (
  id SERIAL PRIMARY KEY,
  sinif INTEGER NOT NULL CHECK (sinif BETWEEN 1 AND 11),
  saha VARCHAR(50) NOT NULL, -- oxu/yazi/qrammatika/danisiq/edebiyyat
  standard_kodu VARCHAR(20),
  standard_metni TEXT NOT NULL,
  alstandart_kodu VARCHAR(20),
  alstandart_metni TEXT,
  pisa_saviyyesi VARCHAR(10),   -- 1a/1b/2/3/4/5/6
  pirls_kateqoriya VARCHAR(50), -- məlumat alma / şərh etmə / qiymətləndirmə
  blooms_seviyyesi VARCHAR(30), -- xatırlamaq/anlamaq/tətbiq/təhlil/qiymətləndirmə/yaratmaq
  created_at TIMESTAMP DEFAULT NOW()
);

-- Mövzular
CREATE TABLE azdili_movzular (
  id SERIAL PRIMARY KEY,
  sinif INTEGER NOT NULL,
  saha VARCHAR(50),
  movzu_adi VARCHAR(200) NOT NULL,
  movzu_izahi TEXT,
  saat_sayi INTEGER DEFAULT 2,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Dərslik chunk-ları
CREATE TABLE azdili_derslikler (
  id SERIAL PRIMARY KEY,
  sinif INTEGER NOT NULL,
  hisse INTEGER DEFAULT 1,
  chunk_id VARCHAR(50) UNIQUE,
  movzu VARCHAR(200),
  saha VARCHAR(50),
  metn TEXT,
  sehife_aralighi VARCHAR(20),
  soz_sayi INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Dərs planları
CREATE TABLE ders_planlari (
  id SERIAL PRIMARY KEY,
  sinif INTEGER NOT NULL,
  movzu VARCHAR(200),
  ders_tipi VARCHAR(50),
  faaliyet_novu VARCHAR(50),
  muddет INTEGER DEFAULT 45,
  məzmun TEXT,
  beynelxalq_standartlar JSONB,
  yaradilma_tarixi TIMESTAMP DEFAULT NOW(),
  fayl_adi VARCHAR(200)
);

-- Testlər
CREATE TABLE testler (
  id SERIAL PRIMARY KEY,
  sinif INTEGER NOT NULL,
  movzu VARCHAR(200),
  test_tipi VARCHAR(50),
  çətinlik VARCHAR(20),
  sual_sayi INTEGER,
  məzmun TEXT,
  pisa_saviyyesi VARCHAR(10),
  yaradilma_tarixi TIMESTAMP DEFAULT NOW(),
  fayl_adi VARCHAR(200)
);

-- Mesajlar
CREATE TABLE mesajlar (
  id SERIAL PRIMARY KEY,
  sinif INTEGER,
  növ VARCHAR(50),
  məzmun TEXT,
  yaradilma_tarixi TIMESTAMP DEFAULT NOW()
);

-- Ədəbi mətnlər
CREATE TABLE edebi_metnler (
  id SERIAL PRIMARY KEY,
  sinif INTEGER NOT NULL,
  müəllif VARCHAR(100),
  əsər_adı VARCHAR(200),
  janr VARCHAR(50),
  dövr VARCHAR(50),
  mövzu VARCHAR(200),
  əsas_ideya TEXT,
  xülasə TEXT,
  tam_mətn TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Lüğət
CREATE TABLE luget_izahlar (
  id SERIAL PRIMARY KEY,
  sinif INTEGER,
  söz VARCHAR(100),
  izah TEXT,
  misal_cümlə TEXT,
  sahə VARCHAR(50)
);
```

### database/seeds/001_base_seed.sql

1-11-ci sinif üçün Azərbaycan dili standartlarını daxil et.
BLOOMS TAKSONOMİYASI və PISA/PIRLS uyğunluğu ilə.

### database/seeds/002_chunks_seed.js

derslikler/chunks/ qovluğundakı bütün *_chunks.json fayllarını oxuyub
azdili_derslikler cədvəlinə yüklə. chunk_id üzrə ON CONFLICT DO NOTHING.

---

## TAPŞIRIQ 2 — NODE.JS BACKEND

Riy_Muellim_Agent-dəki src/ fayllarını kopyala, fənn kontekstini dəyiştir.

### src/core/ai_engine.js — ƏSAS SYSTEM PROMPT
```
Sən Azərbaycan Respublikasının 1-11-ci sinif Azərbaycan dili və ədəbiyyat
fənnini dərindən bilən, aşağıdakı beynəlxalq çərçivələri mənimsəmiş
AI müəllim assistentisən:

BEYNƏLXALQ ÇƏRÇIVƏLƏR:
- PISA Oxu Savadlılığı (6 səviyyə: 1b→6): mətn növləri, oxu prosesləri,
  kontekst növləri; kritik düşüncə, çoxmənbəli mətn analizi
- PIRLS 4-cü sinif oxu: bədii mətn + məlumat mətni; birbaşa anlama /
  şərh etmə / qiymətləndirmə / inteqrasiya prosesləri
- Blum Taksonomiyası (6 səviyyə): xatırlamaq → anlamaq → tətbiq etmək →
  təhlil etmək → qiymətləndirmək → yaratmaq
- CEFR Dil Çərçivəsi (A1→C2): dinləmə, danışıq, oxu, yazı bacarıqları
- Azərbaycan Dili Fənn Kurikulumu (2024): məzmun xətləri üzrə standartlar

DƏRS PLANI YAZARKƏN:
1. Məqsəd — Blum taksonomiyasına görə ölçülə bilən feillərlə
   (müəyyən edir / təhlil edir / qiymətləndirir / yaradır)
2. PISA/PIRLS uyğunluğu — hansı oxu prosesini inkişaf etdirir
3. Diferensial təlim — 3 səviyyə: zəif / orta / güclü şagird
4. Formativ qiymətləndirmə — dərs ərzində yoxlama üsulları
5. Fəallaşdırma strategiyaları — sual növləri (açıq/qapalı/kritik)
6. Fənlərarası inteqrasiya — tarix, coğrafiya, musiqi və s.
7. Resurslar — dərslik səhifələri, əlavə materiallar

ƏDƏBİYYAT MƏTNİNİN TƏHLİLİ YAZARKƏN:
1. Kompozisiya analizi: ekspozisiya → kulminasiya → çözüm
2. Obraz sistemi: əsas + ikinci dərəcəli obrazlar, xarakter inkişafı
3. Müəllif mövqeyi: birbaşa/dolayı ifadə üsulları
4. Bədii təsvir vasitələri: metafora, epitet, bənzətmə, hiperbola,
   litota, təzad, parallelizm — mətn nümunələri ilə
5. Janr xüsusiyyətləri: nağıl/hekayə/poema/roman/dram fərqləri
6. Dövr konteksti: əsər yazıldığı tarixi-ictimai mühit
7. Müqayisəli analiz: başqa müəlliflərlə/əsərlərlə paralellər
8. Şagird tənqidi düşüncəsi: "Müəllif niyə belə etdi?" sualları
9. Dil analizi: leksik seçim, üslub, ton, bədii dil xüsusiyyətləri
10. PISA oxu formatı: çoxseçimli + konstruktiv cavab + açıq sual

Bütün cavabları Azərbaycan dilində ver. Konkret, praktik, dərhal
istifadəyə hazır məzmun yaz.
```

### src/agents/ders_planlamasi/index.js

Dərs planı yaratarkən aşağıdakı ƏTRAFLY STRUKTUR-u tətbiq et:
```javascript
const DERS_PLANI_STRUKTURU = `
## DƏRS PLANI

### ÜMUMİ MƏLUMAT
| Sinif | Mövzu | Tarix | Müddət | Müəllim |
|-------|-------|-------|--------|---------|
| {sinif} | {movzu} | _____ | {muddет} dəq | __________ |

### TƏLİM NƏTİCƏLƏRİ (Blum Taksonomiyasına görə)
Dərsin sonunda şagirdlər:
- **Bilik səviyyəsi:** [nəyi xatırlayacaq]
- **Anlama səviyyəsi:** [nəyi izah edəcək]
- **Tətbiq səviyyəsi:** [nəyi tətbiq edəcək]
- **Təhlil səviyyəsi:** [nəyi təhlil edəcək]
- **Qiymətləndirmə:** [nəyi qiymətləndirəcək]
- **Yaratma:** [nə yaradacaq] ← (yüksək siniflərdə)

### BEYNƏLXALQ STANDART UYĞUNLUĞU
- **Azərbaycan Kurikulumu:** [standart kodu və metni]
- **PISA oxu prosesi:** [məlumat alma / şərh / qiymətləndirmə]
- **PISA saviyyəsi:** [hədəf PISA səviyyəsi — 1-dən 6-ya]
- **PIRLS kateqoriyası:** [birbaşa anlama / çıxarım / şərh]
- **CEFR səviyyəsi:** [A1/A2/B1/B2]
- **Blum taksonomiyası:** [əsas məqsədin taksonomiya səviyyəsi]

### RESURSLAR VƏ HAZIRLIIQ
- Dərslik: [sinif, səhifə nömrəsi]
- Əlavə materiallar: [vizual, audio, kart və s.]
- Lövhə/proyektor hazırlığı

### DƏRSİN GEDİŞAT

#### I. MOTİVASİYA VƏ FƏALLAŞDIRMA (5-7 dəq)
- Əvvəlki biliklərin aktivləşdirilməsi
- Açar suallar: [konkret suallar yazılsın]
- Gözlənti: şagirdlərin mövzu haqqında fərziyyələri

#### II. YENİ MATERİALIN İZAHI (15-20 dəq)
- Müəllim izahı
- Dərslik mətni ilə iş
- Nümunə təhlil

**Diferensial tapşırıqlar:**
| Səviyyə | Tapşırıq | Məqsəd |
|---------|---------|--------|
| Zəif şagird | [sadə, dəstəkli] | anlama |
| Orta şagird | [müstəqil] | tətbiq |
| Güclü şagird | [yaradıcı, analitik] | yaratma |

#### III. MƏŞQ VƏ TƏTBİQ (10-15 dəq)
- Qrup işi / cütlük işi
- Fəal təlim üsulu: [konkret üsul — "Düşün-Cütləş-Paylaş" və s.]
- Tapşırıq məzmunu

#### IV. FORMATIV QİYMƏTLƏNDİRMƏ (5 dəq)
- Yoxlama üsulu: [Çıxış bileti / Baş barmaq / Mini test / Sual-cavab]
- Uğur meyarları: [nə edə bilsə keçmiş sayılır]

#### V. ÜMUMILƏŞDIRMƏ VƏ EV İŞİ (3-5 dəq)
- Dərsin xülasəsi
- Ev tapşırığı: [diferensial — iki səviyyə]
- Növbəti dərsin elanı

### QİYMƏTLƏNDİRMƏ METRİKASI
| Meyar | 4 (əla) | 3 (yaxşı) | 2 (kafi) | 1 (qeyri-kafi) |
|-------|---------|-----------|----------|----------------|
| Anlama | | | | |
| Tətbiq | | | | |
| Nitq | | | | |
| İştirak | | | | |

### ÖZÜNÜQIYMƏTLƏNDIRMƏ (şagird üçün)
Dərsin sonunda şagird özünə sual verir:
□ Mövzunu başa düşdüm
□ Nümunə gətirə bilərəm  
□ Hələ anlamadığım var: ___________
`;
```

### src/agents/qiymetlendirme/index.js

Test yaratarkən PISA formatını tətbiq et:
```javascript
const TEST_STRUKTURU = `
## TEST — Sinif {sinif}, Mövzu: {movzu}
**Test tipi:** {test_tipi} | **Çətinlik:** {çətinlik} | **PISA Səviyyəsi:** {pisa}

---

### OXUMA MƏTNİ (əgər varsa)
[Kontekstual mətn — 150-300 söz, sinif səviyyəsinə uyğun]

---

### I HİSSƏ — ÇOXSEÇIMLI SUALLAR ({n} sual × 1 bal)

**S1. [PISA Səv.2 — Məlumat alma]**
[Sual mətni]
A) ...  B) ...  C) ...  D) ...
✓ Cavab: X  |  İzah: [niyə düzgündür]

**S2. [PISA Səv.3 — Şərh etmə]**
...

**S3. [PISA Səv.4 — Qiymətləndirmə]**
...

### II HİSSƏ — QISA CAVABLI SUALLAR ({n} sual × 2 bal)

**S{n+1}. [Blum: Anlama]**
[Sual]
Gözlənilən cavab: ___________
Qiymətləndirmə meyarı: [nə yazsa 2 bal, nə yazsa 1 bal]

### III HİSSƏ — AÇIQ SUALLAR ({n} sual × 4 bal)

**S{n+m}. [PISA Səv.5 — Kritik qiymətləndirmə]**
[Geniş cavab tələb edən sual]

**Qiymətləndirmə rubrikalari:**
| Bal | Meyar |
|-----|-------|
| 4 | Əsaslandırılmış, nümunəli, strukturlu cavab |
| 3 | Düzgün, lakin az əsaslandırılmış |
| 2 | Qismən düzgün |
| 1 | Cüzi anlama nümayiş etdirir |
| 0 | Cavab yoxdur / tamamilə yanlış |

---
**Ümumi bal:** ___/20  
**PISA uyğunluğu:** Sualların 30%-i Səv.1-2, 50%-i Səv.3-4, 20%-i Səv.5-6
`;
```

### src/agents/edebi_tahlil/index.js — YENİ AGENT
```javascript
const EDEBI_TAHLIL_STRUKTURU = `
## ƏDƏBİ MƏTNİN TƏHLİLİ

**Əsər:** {eser} | **Müəllif:** {müəllif} | **Sinif:** {sinif}

---

### 1. BİBLİOQRAFİK MƏLUMAT
- Müəllif haqqında: [həyatı, dövrü, əsas əsərləri — 3-4 cümlə]
- Əsərin yazılma tarixi və tarixi kontekst
- Janr və forma xüsusiyyətləri

### 2. SÜJETİN STRUKTURU
| Kompozisiya elementi | Məzmun | Əhəmiyyəti |
|---------------------|--------|------------|
| Ekspozisiya | | |
| Düyün | | |
| İnkişaf | | |
| Kulminasiya | | |
| Çözüm | | |

### 3. OBRAZ SİSTEMİ

**Baş qəhrəman(lar):**
- Ad: | Xarakter cizgiləri: | İnkişaf: | Simvolik məna:

**İkinci dərəcəli obrazlar:**
[Hər obraz üçün: rolu, əsas qəhrəmanla münasibəti]

**Müəllifin obraz sistemi vasitəsilə ifadə etdiyi ideya:**

### 4. MÖVZU VƏ İDEYA
- **Əsas mövzu:** 
- **Alt mövzular:**
- **Əsas ideya (məhsul):** [müəllifin oxucuya çatdırmaq istədiyi əsas fikir]
- **Aktuallıq:** Bu ideya bu gün üçün nə dərəcədə aktualdır?

### 5. BƏDİİ TƏSVİR VASİTƏLƏRİ

| Vasitə | Mətn nümunəsi | Funksiyası |
|--------|--------------|------------|
| Metafora | "..." | |
| Epitet | "..." | |
| Bənzətmə | "..." | |
| Təzad | "..." | |
| Hiperbola | "..." | |
| Alliterasiya | "..." | |

### 6. DİL VƏ ÜSLUB
- Leksik xüsusiyyətlər: [arxaizmlər, dialektizmlər, neologizmlər]
- Sintaktik xüsusiyyətlər: [cümlə quruluşu, sual cümləsi, nida]
- Ton: [lirik/dramatik/ironik/elegik]
- Bədii dil effektləri

### 7. MÜQAYİSƏLİ TƏHLİL
- Eyni mövzuda başqa əsərlərlə müqayisə
- Eyni dövrün digər müəllifləri ilə paralellər
- Dünya ədəbiyyatında analoqlar

### 8. ŞAGİRD TƏNQİDİ DÜŞÜNCƏ SUALLAIRI

**Məzmun anlama (PIRLS — birbaşa):**
1. Əsərdə baş verən hadisələri ardıcıllıqla sadalayın.
2. Baş qəhrəman hansı problemi həll etməyə çalışır?

**Şərhetmə (PIRLS — çıxarım):**
3. Müəllif niyə əsəri belə bitirdi? Başqa son mümkün idimi?
4. Qəhrəmanın hərəkətlərinin səbəbini izah edin.

**Qiymətləndirmə (PISA Səv.4-5):**
5. Siz qəhrəmanın yerindəolsaydınız, eyni addımı atardınızmı? Niyə?
6. Bu əsərin ən güclü və ən zəif tərəfi sizin fikrinizlə nədir?

**Yaratma (Blum — yüksək səviyyə):**
7. Əsərə alternativ son yazın.
8. Əsərin müasir versiyasını necə yazardınız?

### 9. MÜƏLLİM ÜÇÜN METODİK QEYDLƏR
- Dərsdə istifadə üçün 3 fəal təlim üsulu
- Fənlərarası əlaqə: [tarix/musiqi/rəsm/coğrafiya]
- Yaradıcı tapşırıq: [inşa/şeir/rol oyunu/layihə]
- Qiymətləndirmə rubrikalari: [inşa üçün hazır rubrika]

### 10. QİYMƏTLƏNDİRMƏ RUBRİKASI — İNŞA / ŞIFAHI TƏHLİL

| Meyar | 4 — Əla | 3 — Yaxşı | 2 — Kafi | 1 — Qeyri-kafi |
|-------|---------|-----------|----------|----------------|
| Mövzu uyğunluğu | Tam uyğun, dərin | Uyğun | Qismən | Uyğun deyil |
| İdeyaların inkişafı | Ətraflı, nümunəli | Kifayət qədər | Az inkişaf | İnkişafsız |
| Bədii təsvir | Zəngin, yerli | Var, az | Cüzi | Yoxdur |
| Dil və üslub | Zəngin, səlis | Düzgün | Bəzi səhvlər | Çox səhv |
| Struktur | Mükəmməl | Yaxşı | Var | Yoxdur |
`;
```

### src/agents/aylik_plan/index.js — YENİ AGENT

Aylıq plan aşağıdakı strukturla:
- Həftəlik cədvəl (saat bölgüsü)
- Hər həftə üçün: mövzu + standart + resurs + qiymətləndirmə
- PISA/PIRLS uyğunluğu
- Formativ/summativ qiymətləndirmə nöqtələri

---

## TAPŞIRIQ 3 — R SHINY FRONTEND (r_shiny/app/app.R)

Riy_Muellim_Agent-dəki app.R-i oxu, TAM YENİDƏN yaz.
Aşağıdakı GENİŞLƏNDİRİLMİŞ fərqlər ilə:

### Rəng sxemi
```r
RENGLER <- list(
  əsas    = "#1B5E20",   # tünd yaşıl
  ikinci  = "#2E7D32",
  açıq    = "#E8F5E9",
  vurğu   = "#FF6F00",   # narıncı
  mətn    = "#212121"
)
```

### Tab 1 — Dərs Planı (GENİŞLƏNDİRİLMİŞ)
```r
sidebarPanel(
  selectInput("sinif", "Sinif:", choices = 1:11),
  textInput("movzu", "Mövzu:"),
  selectInput("ders_tipi", "Dərs tipi:",
    choices = c("Yeni mövzu", "Möhkəmləndirmə", 
                "Qiymətləndirmə", "Ədəbiyyat təhlili",
                "İnteqrativ dərs", "Layihə dərsi")),
  selectInput("faaliyet", "Fəaliyyət növü:",
    choices = c("Oxu", "Yazı", "Qrammatika", 
                "Danışıq", "Ədəbiyyat", "Qarışıq")),
  selectInput("muddет", "Müddət (dəq):", 
    choices = c(45, 60, 90)),
  # YENİ: Beynəlxalq standart seçimi
  checkboxGroupInput("beynelxalq", "Beynəlxalq çərçivə:",
    choices = c("PISA oxu savadlılığı" = "pisa",
                "PIRLS oxu" = "pirls", 
                "Blum taksonomiyası" = "blooms",
                "CEFR dil çərçivəsi" = "cefr"),
    selected = c("pisa", "blooms")),
  # YENİ: Diferensial təlim
  checkboxInput("diferensial", 
    "Diferensial tapşırıqlar (3 səviyyə) əlavə et", 
    value = TRUE),
  # YENİ: Qiymətləndirmə rubrikalari
  checkboxInput("rubrika", 
    "Qiymətləndirmə rubrikalari əlavə et", 
    value = TRUE),
  actionButton("ders_yarat", "📝 Dərs Planı Yarat",
    class = "btn-success btn-lg btn-block")
)
```

### Tab 2 — Test (PISA formatı ilə)
```r
sidebarPanel(
  selectInput("t_sinif", "Sinif:", choices = 1:11),
  textInput("t_movzu", "Mövzu:"),
  selectInput("test_tipi", "Test tipi:",
    choices = c("Çoxseçimli (standart)", 
                "PISA formatı (mətn + suallar)",
                "Diktant mətni",
                "İnşa rubrikalari",
                "Şifahi nitq qiymətləndirmə",
                "Portfel qiymətləndirmə")),
  sliderInput("sual_sayi", "Sual sayı:", 5, 30, 15),
  selectInput("çətinlik", "Çətinlik:",
    choices = c("Asan (PISA Səv.1-2)", 
                "Orta (PISA Səv.3-4)",
                "Çətin (PISA Səv.5-6)",
                "Qarışıq (bütün səviyyələr)")),
  # YENİ: Mətn növü
  selectInput("metn_novu", "Mətn növü (PISA):",
    choices = c("Bədii mətn", "Məlumat mətni",
                "Publisistik", "Sənəd/praktik mətn",
                "Qarışıq mətn")),
  checkboxInput("rubrika_elave", 
    "Açıq suallar üçün rubrika əlavə et", TRUE),
  actionButton("test_yarat", "📋 Test Yarat",
    class = "btn-success btn-lg btn-block")
)
```

### Tab 3 — Aylıq Plan
```r
sidebarPanel(
  selectInput("ap_sinif", "Sinif:", choices = 1:11),
  selectInput("ay", "Ay:",
    choices = c("Sentyabr","Oktyabr","Noyabr","Dekabr",
                "Yanvar","Fevral","Mart","Aprel","May")),
  selectInput("heftelik_saat", "Həftəlik saat:", 
    choices = c(2, 3, 4, 5)),
  checkboxInput("pisa_uygun", 
    "PISA/PIRLS uyğunluğunu göstər", TRUE),
  checkboxInput("qiymet_noqte", 
    "Qiymətləndirmə nöqtələrini əlavə et", TRUE),
  actionButton("aylik_yarat", "📅 Aylıq Plan Yarat",
    class = "btn-success btn-lg btn-block")
)
```

### Tab 4 — Ədəbi Mətn Analizi (GENİŞLƏNDİRİLMİŞ)
```r
sidebarPanel(
  selectInput("ea_sinif", "Sinif:", choices = 1:11),
  textInput("müəllif", "Müəllif:"),
  textInput("eser", "Əsər adı:"),
  selectInput("analiz_novu", "Analiz növü:",
    choices = c(
      "Tam ədəbi təhlil (bütün elementlər)",
      "Kompozisiya və süjet təhlili",
      "Obraz sistemi təhlili",
      "Bədii təsvir vasitələri",
      "Müqayisəli ədəbi təhlil",
      "Dil və üslub təhlili",
      "Tənqidi düşüncə sualları (PISA)",
      "Müəllim üçün metodiki qeydlər"
    )),
  checkboxInput("rubrika_edebi",
    "İnşa qiymətləndirmə rubrikalari əlavə et", TRUE),
  checkboxInput("muqayise",
    "Müqayisəli təhlil (digər əsərlərlə)", FALSE),
  actionButton("edebi_yarat", "📖 Ədəbi Təhlil Yarat",
    class = "btn-success btn-lg btn-block")
)
```

### Tab 5 — Şagird Analizi
Riy_Muellim_Agent analoqu — fənn kontekstini dəyiştir:
- Zəif tərəflər: Oxu sürəti / Anlama / Yazı / Qrammatika /
  Nitq / Ədəbiyyat dərki / Lüğət ehtiyatı / Orfoqrafiya
- PISA səviyyəsi müəyyən et
- Fərdi CEFR profili
- Valideyn məktubu

### Tab 6 — Müəllim Köməkçisi
Azad sual, AI cavabı. Əlavə olaraq:
- "Metodiki tövsiyə" düyməsi
- "Beynəlxalq praktika" düyməsi (PISA ölkələrinin təcrübəsi)

### Tab 7 — Arxiv
Keçmiş planlar + testlər cədvəl şəklində, yüklə düyməsi ilə.

### DOCX çıxışı (officer paketi)

Hər nəticə üçün DOCX-da aşağıdakılar olsun:
- Başlıq səhifəsi: ARTI loqosu, tarix, sinif, mövzu
- Məzmun: formatlanmış cədvəllər, başlıqlar
- Altbilgi: "Azərbaycan Respublikası Elm və Təhsil Nazirliyi — ARTI"
- Şrift: DejaVu Sans (Azərbaycan əlifbası üçün)

---

## TAPŞIRIQ 4 — FAYL SAXLAMA
```
Ders_planlari/ → sinif{N}_{movzu_slug}_ders_plani_{timestamp}.html + .docx
Testler/        → sinif{N}_{movzu_slug}_test_{timestamp}.html + .docx
Mesajlar/       → mesaj_{timestamp}.docx
```

---

## İCRA SIRASI
1. database/migrations/001_schema.sql
2. database/seeds/001_base_seed.sql + 002_chunks_seed.js
3. config/database.js
4. src/core/ai_engine.js (system prompt yuxarıdakı kimi)
5. src/agents/ (6 agent + 2 yeni: edebi_tahlil, aylik_plan)
6. src/api/routes.js + src/server.js
7. r_shiny/app/app.R (ən vacib fayl)
8. package.json + scripts/setup.sh + README.md

## QEYDLƏR
- .env hazırdır, dəyişmə
- Hər dərs planında PISA + Blum + Azərbaycan kurikulumu MÜTLƏQ olsun
- Ədəbi təhlil heç vaxt səthi olmasın — MIN 10 analiz elementi
- Diferensial tapşırıqlar DEFAULT olaraq açıq olsun
- Timestamp: format(Sys.time(), "%Y%m%d_%H%M%S")
