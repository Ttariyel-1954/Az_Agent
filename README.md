# Az Müəllim Agent v3.0

**Azərbaycan Respublikası 1-11-ci sinif Azərbaycan dili və ədəbiyyat müəllimləri üçün AI agent sistemi**

ARTI 2026 — Azərbaycan Respublikası Təhsil İnstitutu

---

## Canlı Demo

- **Shiny App:** https://t01061954.shinyapps.io/Az-Muellim-Agent/
- **Binder (Shiny):** https://mybinder.org/v2/gh/Ttariyel-1954/Az_Agent/main?urlpath=shiny/r_shiny/app/
- **Binder (RStudio):** https://mybinder.org/v2/gh/Ttariyel-1954/Az_Agent/main?urlpath=rstudio

---

## Haqqında

Az Müəllim Agent — Azərbaycan dili və ədəbiyyat müəllimləri üçün hazırlanmış süni intellekt əsaslı köməkçi sistemdir. Sistem dərs planları, testlər, ədəbi təhlillər, aylıq planlar, şagird analizləri və müəllim kommunikasiya sənədləri yaradır.

Bütün çıxışlar Azərbaycan Respublikası fənn kurikulumuna və beynəlxalq təhsil standartlarına (PISA, PIRLS, Blum taksonomiyası, CEFR) uyğun hazırlanır.

### Əsas xüsusiyyətlər

- 1-11-ci sinif üçün tam kurikulum dəstəyi (442 alt-standart, 890 mövzu)
- 18 dərslik PDF-dən çıxarılmış 519 chunk bilik bazası
- PISA oxu savadlılığı (6 səviyyə) inteqrasiyası
- PIRLS oxu prosesləri (birbaşa anlama / şərh / qiymətləndirmə)
- Blum taksonomiyası (6 səviyyə) ilə dərs planlaması
- CEFR dil çərçivəsi (A1→C2) uyğunluğu
- 10 elementli ədəbi təhlil sistemi
- HTML5 + DOCX formatında fayl çıxışı
- 3 dildə interfeys: Azərbaycanca, Rusca, İngiliscə
- Real vaxt generasiya statistikası (token, xərc, vaxt)

---

## Sistem Arxitekturası

```
Az_agent/
├── r_shiny/app/
│   └── app.R                 # R Shiny interfeys (əsas proqram)
├── src/
│   ├── server.js             # Node.js API server
│   ├── core/
│   │   └── ai_engine.js      # Claude + OpenAI multi-model engine
│   ├── agents/
│   │   ├── ders_planlamasi/  # Dərs planlama agenti
│   │   ├── qiymetlendirme/   # Test və qiymətləndirmə agenti
│   │   ├── edebi_tahlil/     # Ədəbi təhlil agenti
│   │   ├── aylik_plan/       # Aylıq plan agenti
│   │   ├── muellim_kommunikasiyasi/  # Kommunikasiya agenti
│   │   ├── shagird_inkishafi/ # Şagird inkişafı agenti
│   │   ├── metodiki_komek/   # Metodiki kömək agenti
│   │   └── reqemsal_assistant/ # Rəqəmsal assistant
│   ├── api/
│   │   └── routes.js         # API endpoint-ları
│   └── middleware/
│       └── auth.js           # JWT autentifikasiya
├── database/
│   ├── migrations/
│   │   └── 001_schema.sql    # PostgreSQL schema (8 cədvəl)
│   └── seeds/
│       ├── 001_base_seed.sql     # Kurikulum standartları
│       ├── 002_chunks_seed.js    # Dərslik chunk-ları yükləmə
│       └── 003_movzular_seed.sql # 890 mövzu
├── derslikler/
│   ├── pdf/                  # 18 dərslik PDF (gitignore)
│   ├── chunks/               # 519 chunk (32 JSON fayl)
│   ├── standards.json        # 442 kurikulum standartı
│   ├── topics.json           # 890 mövzu
│   └── eserler.json          # Ədəbi əsərlər siyahısı
├── config/
│   └── database.js           # DB konfiqurasiyası
├── scripts/
│   ├── pdf_pipeline.py       # PDF → chunk pipeline
│   ├── build_all_topics.py   # Mövzu generasiyası
│   ├── generate_topics.py    # Mövzu yaratma
│   └── setup.sh              # Quraşdırma skripti
├── Ders_planlari/            # Generasiya olunmuş dərs planları
├── Testler/                  # Generasiya olunmuş testlər
├── Mesajlar/                 # Generasiya olunmuş mesajlar
├── .env.example              # Konfiqurasiya nümunəsi
├── package.json              # Node.js asılılıqlar
├── Dockerfile                # Docker image
├── docker-compose.yml        # Docker compose
└── CLAUDE.md                 # AI agent təlimatı
```

---

## Quraşdırma

### Tələblər

| Komponent | Versiya | Məqsəd |
|-----------|---------|--------|
| R | >= 4.3 | Shiny interfeys |
| Node.js | >= 18 | API server |
| PostgreSQL | >= 14 | Verilənlər bazası (optional) |
| Pandoc | >= 2.19 | DOCX generasiyası |
| Python | >= 3.9 | PDF pipeline (birdəfəlik) |

### R paketləri

```r
install.packages(c(
  "shiny", "shinydashboard", "DT",
  "httr", "jsonlite", "plotly"
))
```

### Addım 1: Klonlama

```bash
git clone https://github.com/Ttariyel-1954/Az_Agent.git
cd Az_Agent
```

### Addım 2: .env faylını yaradın

```bash
cp .env.example .env
```

`.env` faylını redaktə edin və ANTHROPIC_API_KEY daxil edin.

### Addım 3: R Shiny interfeysi işə salın

```bash
cd r_shiny/app
Rscript -e "shiny::runApp('.', port = 4040, host = '0.0.0.0')"
```

Və ya:

```bash
npm run shiny
```

Brauzer: `http://localhost:4040`

### Addım 4: Node.js API (optional)

```bash
npm install
npm run db:setup   # PostgreSQL lazımdır
npm start          # http://localhost:3000
```

---

## Docker ilə işə salma

```bash
docker-compose up -d
```

---

## 8 AI Agent

### 1. Dərs Planlaması

Müəllim sinif, mövzu, dərs tipi və fəaliyyət növü seçir, sistem PISA/PIRLS/Blum çərçivələrinə uyğun ətraflı dərs planı yaradır.

**Dərs planının strukturu:**

| Bölmə | Məzmun |
|-------|--------|
| Ümumi məlumat | Sinif, mövzu, standart kodu, müddət |
| Təlim nəticələri | Blum taksonomiyasına görə ölçülə bilən feillər |
| Beynəlxalq standart | PISA oxu prosesi + səviyyə, PIRLS kateqoriya, CEFR |
| Motivasiya (5-7 dəq) | Açar suallar, fərziyyə, əvvəlki biliklərin aktivləşdirilməsi |
| Yeni material (15-20 dəq) | Müəllim izahı, dərslik mətni, nümunə təhlil |
| Diferensial tapşırıqlar | 3 səviyyə: zəif / orta / güclü şagird |
| Məşq və tətbiq (10-15 dəq) | Qrup işi, fəal təlim üsulu, tapşırıq məzmunu |
| Formativ qiymətləndirmə (5 dəq) | Çıxış bileti, baş barmaq, mini test |
| Ümumiləşdirmə (3-5 dəq) | Xülasə, ev tapşırığı, növbəti dərsin elanı |
| Qiymətləndirmə metrikası | 4 ballıq rubrika (anlama, tətbiq, nitq, iştirak) |
| Özünüqiymətləndirmə | Şagird üçün refleksiya sualları |

**Dərs tipləri:** Yeni mövzu, Möhkəmləndirmə, Qiymətləndirmə, Ədəbiyyat təhlili, İnteqrativ dərs, Layihə dərsi

**Fəaliyyət növləri:** Oxu, Yazı, Qrammatika, Danışıq, Ədəbiyyat, Qarışıq

### 2. Test və Qiymətləndirmə

PISA formatında testlər yaradır:

**Test strukturu:**
- I hissə — Çoxseçimli suallar (1 bal)
- II hissə — Qısa cavablı suallar (2 bal)
- III hissə — Açıq suallar (4 bal)

**Hər sual üçün:**
- PISA səviyyəsi (1-6)
- Blum taksonomiya səviyyəsi
- Düzgün cavab + izah
- Qiymətləndirmə rubrikaları (açıq suallar üçün)

**Test tipləri:** Çoxseçimli, PISA formatı, Diktant mətni, İnşa rubrikaları, Şifahi nitq qiymətləndirmə, Portfel qiymətləndirmə

**Mətn növləri (PISA):** Bədii mətn, Məlumat mətni, Publisistik, Sənəd/praktik mətn, Qarışıq mətn

### 3. Ədəbi Mətn Təhlili

10 elementli ədəbi təhlil sistemi:

| Element | Məzmun |
|---------|--------|
| 1. Biblioqrafik məlumat | Müəllif haqqında, tarix, janr |
| 2. Süjetin strukturu | Ekspozisiya → Düyün → İnkişaf → Kulminasiya → Çözüm |
| 3. Obraz sistemi | Baş qəhrəman + ikinci dərəcəli obrazlar |
| 4. Mövzu və ideya | Əsas mövzu, alt mövzular, əsas ideya, aktuallıq |
| 5. Bədii təsvir vasitələri | Metafora, epitet, bənzətmə, təzad, hiperbola, alliterasiya |
| 6. Dil və üslub | Leksik, sintaktik xüsusiyyətlər, ton |
| 7. Müqayisəli təhlil | Başqa əsərlərlə paralellər |
| 8. Tənqidi düşüncə sualları | PIRLS + PISA formatında suallar |
| 9. Metodiki qeydlər | Fəal təlim üsulları, fənlərarası əlaqə, yaradıcı tapşırıq |
| 10. Qiymətləndirmə rubrikaları | İnşa / şifahi təhlil üçün 4-ballıq rubrika |

**Analiz növləri:** Tam ədəbi təhlil, Kompozisiya təhlili, Obraz sistemi, Bədii təsvir vasitələri, Müqayisəli təhlil, Dil və üslub, Tənqidi düşüncə sualları, Metodiki qeydlər

### 4. Aylıq Plan

Bütöv ay üçün həftəlik cədvəl:
- Hər həftə: mövzu + standart + saat bölgüsü + resurs + qiymətləndirmə
- PISA/PIRLS uyğunluq göstəricisi
- Formativ/summativ qiymətləndirmə nöqtələri

### 5. Müəllim Kommunikasiyası

Hazır sənəd şablonları:
- Valideyn məktubu (uğur / narahatlıq / dəvət)
- İdari hesabat
- Pedaqoji şura çıxışı
- Şagird xasiyyətnaməsi

### 6. Şagird İnkişafı

Fərdi şagird profili:
- Zəif tərəflər: Oxu sürəti, Anlama, Yazı, Qrammatika, Nitq, Ədəbiyyat dərki, Lüğət ehtiyatı, Orfoqrafiya
- PISA səviyyəsi müəyyənləşdirmə
- Fərdi CEFR profili
- Valideyn məktubu

### 7. Metodiki Kömək

Müəllim üçün metodiki tövsiyələr:
- Fəal təlim üsulları
- Beynəlxalq praktika (PISA ölkələrinin təcrübəsi)

### 8. Rəqəmsal Assistant

Azad sual-cavab — istənilən pedaqoji suala cavab verir.

---

## Bilik Bazası

### Dərslik Chunk-ları

18 Azərbaycan dili və ədəbiyyat dərsliyi (1-11-ci sinif, I və II hissə) PDF formatından parçalanıb JSON chunk-larına çevrilib:

| Sinif | Dərslik | Format |
|-------|---------|--------|
| 1 | I hissə + II hissə | 2 PDF |
| 2 | I hissə + II hissə | 2 PDF |
| 3 | I hissə + II hissə | 2 PDF |
| 4 | I hissə + II hissə | 2 PDF |
| 5 | I hissə + II hissə | 2 PDF |
| 6 | I hissə + II hissə | 2 PDF |
| 7 | Tam | 1 PDF |
| 8 | Tam | 1 PDF |
| 9 | Tam | 1 PDF |
| 10 | Tam | 1 PDF |
| 11 | Tam | 1 PDF |
| **Cəmi** | **18 PDF** | **519 chunk, 32 JSON** |

Hər chunk tərkibi: sinif, hissə, mövzu, sahə, mətn, səhifə aralığı, söz sayı.

### Kurikulum Standartları

442 alt-standart, 5 sahə üzrə:

| Sahə | İzah |
|------|------|
| Oxu | Mətn anlama, şərhetmə, qiymətləndirmə, müqayisə |
| Yazı | İnşa, məqalə, hekayə, xülasə, qeyd |
| Qrammatika | Fonetika, leksika, morfologiya, sintaksis |
| Danışıq | Şifahi nitq, müzakirə, təqdimat, dialoq |
| Ədəbiyyat | Ədəbi analiz, janr, dövr, müəllif, obraz sistemi |

### Mövzular

890 mövzu 1-11-ci sinif üzrə, hər mövzu üçün:
- Sahə (oxu/yazı/qrammatika/danışıq/ədəbiyyat)
- Saat sayı
- Dərslik istinad

### Ədəbi Əsərlər

`eserler.json` — sinif üzrə ədəbi əsərlər siyahısı (müəllif, əsər adı, janr).

---

## Beynəlxalq Standartlar

### PISA Oxu Savadlılığı

6 səviyyəli qiymətləndirmə çərçivəsi:

| Səviyyə | Bacarıq |
|---------|---------|
| 1a-1b | Sadə mətndə açıq məlumatı tapma |
| 2 | Əsas ideyanın müəyyənləşdirilməsi, sadə şərh |
| 3 | Mətnin müxtəlif hissələri arasında əlaqə qurma |
| 4 | Müəllif məqsədini, üslubunu qiymətləndirmə |
| 5 | Mürəkkəb mətnlərdə gizli məlumatın tapılması |
| 6 | Çoxmənbəli mətni tənqidi təhlil etmə |

### PIRLS Oxu Prosesləri

| Proses | İzah |
|--------|------|
| Məlumat alma | Mətndən konkret informasiya çıxarma |
| Birbaşa çıxarım | Mətndəki aydın ifadələrdən nəticə çıxarma |
| Şərh etmə | Mətnin mənasını öz sözləri ilə ifadə etmə |
| Qiymətləndirmə | Mətn haqqında fikir bildirmə, müqayisə etmə |

### Blum Taksonomiyası

| Səviyyə | Feil nümunələri |
|---------|----------------|
| Xatırlamaq | adlandırmaq, sadalamaq, tanımaq |
| Anlamaq | izah etmək, müqayisə etmək, təsnifləşdirmək |
| Tətbiq etmək | istifadə etmək, həll etmək, nümayiş etdirmək |
| Təhlil etmək | fərqləndirmək, təşkilatlandırmaq, aid etmək |
| Qiymətləndirmək | arqumentləşdirmək, mühakimə yürütmək |
| Yaratmaq | planlaşdırmaq, yazmaq, dizayn etmək |

### CEFR Dil Çərçivəsi

| Səviyyə | Tətbiq |
|---------|--------|
| A1 | 1-2-ci sinif: sadə cümlə, tanıdıq sözlər |
| A2 | 3-4-cü sinif: qısa mətn, gündəlik mövzular |
| B1 | 5-7-ci sinif: müstəqil oxu və yazı, əsas fikirlər |
| B2 | 8-9-cu sinif: mürəkkəb mətn, arqumentləşdirilmiş yazı |
| C1 | 10-11-ci sinif: akademik mətn, ədəbi təhlil |

---

## API Endpoint-ları

Node.js API (optional, R Shiny müstəqil işləyir):

| Metod | Endpoint | Funksiyası |
|-------|----------|-----------|
| GET | `/api/v1/health` | Sağlamlıq yoxlaması |
| POST | `/api/v1/ders-plani` | Dərs planı generasiyası |
| POST | `/api/v1/test-yarat` | Test generasiyası |
| POST | `/api/v1/insha-rubrika` | İnşa rubrikası |
| POST | `/api/v1/diktant-hazirla` | Diktant hazırlığı |
| POST | `/api/v1/edebi-tahlil` | Ədəbi təhlil |
| POST | `/api/v1/aylik-plan` | Aylıq plan |
| POST | `/api/v1/mesaj-yaz` | Mesaj generasiyası |
| POST | `/api/v1/shagird-analiz` | Şagird analizi |
| GET | `/api/v1/arxiv/ders-planlari` | Keçmiş planlar |
| GET | `/api/v1/arxiv/testler` | Keçmiş testlər |

---

## Verilənlər Bazası (PostgreSQL)

### Əsas cədvəllər

| Cədvəl | Məqsəd |
|--------|--------|
| `azdili_standartlari` | Kurikulum standartları (442 alt-standart) |
| `azdili_movzular` | 890 mövzu |
| `azdili_derslikler` | 519 dərslik chunk-u |
| `ders_planlari` | Generasiya olunmuş dərs planları |
| `testler` | Generasiya olunmuş testlər |
| `mesajlar` | Mesajlar |
| `edebi_metnler` | Ədəbi mətnlər bazası |
| `luget_izahlar` | Lüğət izahları |

### Migration və Seed

```bash
npm run db:migrate   # Schema yaradır (8 cədvəl)
npm run db:seed      # Standartlar + mövzular daxil edir
npm run db:chunks    # 519 chunk-u DB-ya yükləmək
npm run db:setup     # Hamısı birdəfəyə
```

---

## R Shiny İnterfeys

### 7 Tab

**Tab 1 — Dərs Planı:**
Sinif, mövzu, dərs tipi, fəaliyyət növü, müddət, beynəlxalq çərçivə seçimi, diferensial təlim və rubrika seçimi ilə ətraflı dərs planı yaradır.

**Tab 2 — Test və Qiymətləndirmə:**
PISA formatında testlər — çoxseçimli + qısa cavablı + açıq suallar. Çətinlik səviyyəsi, mətn növü, rubrika seçimi.

**Tab 3 — Aylıq Plan:**
Bütöv ay üçün həftəlik cədvəl — sinif, ay, həftəlik saat, PISA/PIRLS uyğunluq, qiymətləndirmə nöqtələri.

**Tab 4 — Ədəbi Mətn Analizi:**
10 elementli tam ədəbi təhlil — müəllif, əsər, analiz növü, inşa rubrikaları, müqayisəli təhlil seçimi.

**Tab 5 — Şagird Analizi:**
Fərdi şagird profili — güclü/zəif tərəflər, PISA səviyyəsi, CEFR profili, fərdiləşdirilmiş tövsiyələr.

**Tab 6 — Müəllim Köməkçisi:**
Azad sual-cavab + metodiki tövsiyə + beynəlxalq praktika düymələri.

**Tab 7 — Arxiv:**
Keçmiş planlar və testlər cədvəl şəklində, HTML bax + DOCX yüklə düymələri.

---

## Fayl Çıxışı

Hər generasiya nəticəsi 2 formatda saxlanır:

### HTML5
- Responsive dizayn, mobil uyumlu
- Gradient başlıqlar, rəngli fazalar
- ARTI 2026 brendinq (yaşıl + narıncı tema)
- Çap üçün optimizasiya (`@media print`)

### DOCX (Word)
- Pandoc vasitəsilə avtomatik çevrilir
- Azərbaycan əlifbası dəstəyi (UTF-8)
- ARTI 2026 altbilgi

### Fayl adlandırma

```
sinif{N}_{movzu_slug}_{tip}_{timestamp}.html
sinif{N}_{movzu_slug}_{tip}_{timestamp}.docx
```

Misal: `sinif8_D_rnaq_i_ar_si_v__m_t_riz__ders_plani_20260309_084314.html`

### Saxlama yolu

Fayllar `r_shiny/app/output/` altında saxlanır:
```
r_shiny/app/output/Ders_planlari/   # Dərs planları
r_shiny/app/output/Testler/         # Testlər
r_shiny/app/output/Mesajlar/        # Mesajlar
```

---

## Konfiqurasiya

### AI Model Seçimi

`.env` faylında:

```env
DEFAULT_AI_MODEL=claude-sonnet-4-20250514
```

Dəstəklənən modellər:
- `claude-sonnet-4-20250514` (default, optimal balans)
- `claude-haiku-4-5-20251001` (sürətli, ucuz)
- `gpt-4o` (OpenAI alternativi)

### Token Limitləri

| Model | Default max_tokens |
|-------|--------------------|
| Claude Sonnet/Opus | 16384 |
| Claude Haiku | 4096 |
| GPT-4o | 16384 |

---

## İnkişaf

### Lokal inkişaf

```bash
# R Shiny
cd r_shiny/app
Rscript -e "shiny::runApp('.', port = 4040)"

# Node.js (nodemon ilə)
npm run dev

# PDF pipeline (birdəfəlik)
python3 scripts/pdf_pipeline.py

# Mövzu generasiyası
python3 scripts/build_all_topics.py
```

---

## Texnoloji Stek

| Komponent | Texnologiya | Versiya |
|-----------|-------------|---------|
| Frontend | R Shiny + shinydashboard | 1.8.x |
| AI Engine | Claude API (Anthropic) | v2023-06-01 |
| AI Engine (alt) | OpenAI GPT-4o | v4 |
| Backend | Node.js + Express | 18+ |
| Database | PostgreSQL | 14+ |
| Vizualizasiya | Plotly.js | 2.x |
| Sənəd generasiyası | Pandoc (HTML → DOCX) | 2.19+ |
| PDF pipeline | Python (PyPDF2, tiktoken) | 3.9+ |
| Konteynerləşdirmə | Docker + Docker Compose | 24+ |

---

## Verilənlərin Xülasəsi

| Göstərici | Say |
|-----------|-----|
| Əsas standart | 147 |
| Alt-standart | 442 |
| Mövzu | 890 |
| Dərslik chunk | 519 |
| PDF dərslik | 18 |
| Chunk JSON fayl | 32 |
| Sinif | 1-11 |
| AI Agent | 8 |
| İnterfeys tab | 7 |
| Sahə | 5 (oxu, yazı, qrammatika, danışıq, ədəbiyyat) |

---

## Lisenziya

MIT License — ARTI 2026, Tariyel Talibov

---

## Əlaqə

- **Müəllif:** Tariyel Talibov
- **Təşkilat:** ARTI — Azərbaycan Respublikası Təhsil İnstitutu
- **GitHub:** [Ttariyel-1954/Az_Agent](https://github.com/Ttariyel-1954/Az_Agent)
