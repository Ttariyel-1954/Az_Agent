# Az Muellim Agent v3.0

**Azerbaycan Respublikasi 1-11-ci sinif Azerbaycan dili va adabiyyat muallimlari ucun AI agent sistemi**

ARTI 2026 — Azerbaycan Respublikasi Tahsil Institutu

---

## Canli Demo

- **Shiny App:** https://t01061954.shinyapps.io/Az-Muellim-Agent/
- **Binder (Shiny):** https://mybinder.org/v2/gh/Ttariyel-1954/Az_Agent/main?urlpath=shiny/r_shiny/app/
- **Binder (RStudio):** https://mybinder.org/v2/gh/Ttariyel-1954/Az_Agent/main?urlpath=rstudio

---

## Haqqinda

Az Muellim Agent — Azerbaycan dili va adabiyyat muallimlari ucun hazirlanmis suni intellekt asasli koamakci sistemdir. Sistem dars planlari, testlar, adabi tahlillar, ayliq planlar, sagird analizlari va muallim kommunikasiya sanadlari yaradir.

Butun cixislar Azerbaycan Respublikasi fann kurikulumuna va baynalxalq tahsil standartlarina (PISA, PIRLS, Blum taksonomiyasi, CEFR) uygun hazirlanir.

### Asas xususiyyatlar

- 1-11-ci sinif ucun tam kurikulum dastayi (442 alt-standart, 890 movzu)
- 18 darslik PDF-dan cixarilmis 519 chunk bilik bazasi
- PISA oxu savadliligi (6 saviyya) inteqrasiyasi
- PIRLS oxu proseslari (birbasa anlama / sarh / qiymatlandirma)
- Blum taksonomiyasi (6 saviyya) ila dars planlamasi
- CEFR dil carcivasi (A1→C2) uygunlugu
- 10 elementli adabi tahlil sistemi
- HTML5 + DOCX formatinda fayl cixisi
- 3 dilda interfeys: Azerbaycanca, Rusca, Ingilisca
- Real vaxt generasiya statistikasi (token, xerc, vaxt)

---

## Sistem Arxitekturasi

```
Az_agent/
├── r_shiny/app/
│   └── app.R                 # R Shiny interfeys (asas proqram)
├── src/
│   ├── server.js             # Node.js API server
│   ├── core/
│   │   └── ai_engine.js      # Claude + OpenAI multi-model engine
│   ├── agents/
│   │   ├── ders_planlamasi/  # Dars planlama agenti
│   │   ├── qiymetlendirme/   # Test va qiymatlandirma agenti
│   │   ├── edebi_tahlil/     # Adabi tahlil agenti
│   │   ├── aylik_plan/       # Ayliq plan agenti
│   │   ├── muellim_kommunikasiyasi/  # Kommunikasiya agenti
│   │   ├── shagird_inkishafi/ # Sagird inkisafi agenti
│   │   ├── metodiki_komek/   # Metodiki komak agenti
│   │   └── reqemsal_assistant/ # Raqamsal assistant
│   ├── api/
│   │   └── routes.js         # API endpoint-lari
│   └── middleware/
│       └── auth.js           # JWT autentifikasiya
├── database/
│   ├── migrations/
│   │   └── 001_schema.sql    # PostgreSQL schema (8 cadval)
│   └── seeds/
│       ├── 001_base_seed.sql     # Kurikulum standartlari
│       ├── 002_chunks_seed.js    # Darslik chunk-lari yuklama
│       └── 003_movzular_seed.sql # 890 movzu
├── derslikler/
│   ├── pdf/                  # 18 darslik PDF (gitignore)
│   ├── chunks/               # 519 chunk (32 JSON fayl)
│   ├── standards.json        # 442 kurikulum standarti
│   ├── topics.json           # 890 movzu
│   └── eserler.json          # Adabi asarlar siyahisi
├── config/
│   └── database.js           # DB konfiqurasiyasi
├── scripts/
│   ├── pdf_pipeline.py       # PDF → chunk pipeline
│   ├── build_all_topics.py   # Movzu generasiyasi
│   ├── generate_topics.py    # Movzu yaratma
│   └── setup.sh              # Qurasdirma skripti
├── Ders_planlari/            # Generasiya olunmus dars planlari
├── Testler/                  # Generasiya olunmus testlar
├── Mesajlar/                 # Generasiya olunmus mesajlar
├── .env.example              # Konfiqurasiya numunasi
├── package.json              # Node.js asililiqlar
├── Dockerfile                # Docker image
├── docker-compose.yml        # Docker compose
└── CLAUDE.md                 # AI agent talimati
```

---

## Qurasdirma

### Talablar

| Komponent | Versiya | Maqsad |
|-----------|---------|--------|
| R | >= 4.3 | Shiny interfeys |
| Node.js | >= 18 | API server |
| PostgreSQL | >= 14 | Verilanlar bazasi (optional) |
| Pandoc | >= 2.19 | DOCX generasiyasi |
| Python | >= 3.9 | PDF pipeline (birdafalik) |

### R paketlari

```r
install.packages(c(
  "shiny", "shinydashboard", "DT",
  "httr", "jsonlite", "plotly"
))
```

### Addim 1: Klonlama

```bash
git clone https://github.com/Ttariyel-1954/Az_Agent.git
cd Az_Agent
```

### Addim 2: .env faylini yaradin

```bash
cp .env.example .env
```

`.env` faylini redakta edin va ANTHROPIC_API_KEY daxil edin.

### Addim 3: R Shiny interfeysi isa salin

```bash
cd r_shiny/app
Rscript -e "shiny::runApp('.', port = 4040, host = '0.0.0.0')"
```

Va ya:

```bash
npm run shiny
```

Brauzer: `http://localhost:4040`

### Addim 4: Node.js API (optional)

```bash
npm install
npm run db:setup   # PostgreSQL lazimdir
npm start          # http://localhost:3000
```

---

## Docker ila isa salma

```bash
docker-compose up -d
```

---

## 8 AI Agent

### 1. Dars Planlamasi

Muallim sinif, movzu, dars tipi va faaliyyat novu secir, sistem PISA/PIRLS/Blum cercivalarina uygun atrafli dars plani yaradir.

**Dars planinin strukturu:**

| Bolma | Mazmun |
|-------|--------|
| Umumi malumat | Sinif, movzu, standart kodu, muddaт |
| Talim naticalar | Blum taksonomiyasina gora olculabilan feillar |
| Baynalxalq standart | PISA oxu prosesi + saviyya, PIRLS kateqoriya, CEFR |
| Motivasiya (5-7 daq) | Acar suallar, farziyya, avvalki biliklarin aktivlasdirilmasi |
| Yeni material (15-20 daq) | Muallim izahi, darslik matni, numuna tahlil |
| Diferensial tapsiriqlar | 3 saviyya: zaif / orta / guclu sagird |
| Masq va tatbiq (10-15 daq) | Qrup isi, faal talim usulu, tapsiriq mazmunu |
| Formativ qiymatlandirma (5 daq) | Cixis bileti, bas barmaq, mini test |
| Umulasdirma (3-5 daq) | Xulasa, ev tapsirigi, novbati darsin elani |
| Qiymatlandirma metrikasi | 4 balliq rubrika (anlama, tatbiq, nitq, istirak) |
| Ozunuqiymatlandirma | Sagird ucun refleksiya suallari |

**Dars tiplari:** Yeni movzu, Mohkamlandirma, Qiymatlandirma, Adabiyyat tahlili, Inteqrativ dars, Layiha darsi

**Faaliyyat novlari:** Oxu, Yazi, Qrammatika, Danisiq, Adabiyyat, Qarisiq

### 2. Test va Qiymatlandirma

PISA formatinda testlar yaradir:

**Test strukturu:**
- I hissa — Cocsecimli suallar (1 bal)
- II hissa — Qisa cavabli suallar (2 bal)
- III hissa — Aciq suallar (4 bal)

**Har sual ucun:**
- PISA saviyyasi (1-6)
- Blum taksonomiya saviyyasi
- Duzgun cavab + izah
- Qiymatlandirma rubrikalari (aciq suallar ucun)

**Test tiplari:** Cocsecimli, PISA formati, Diktant matni, Insa rubrikalari, Sifahi nitq qiymatlandirma, Portfel qiymatlandirma

**Matn novlari (PISA):** Badii matn, Malumat matni, Publisistik, Sanad/praktik matn, Qarisiq matn

### 3. Adabi Matn Tahlili

10 elementli adabi tahlil sistemi:

| Element | Mazmun |
|---------|--------|
| 1. Biblioqrafik malumat | Muallif haqqinda, tarix, janr |
| 2. Sujetin strukturu | Ekspozisiya → Duyun → Inkisaf → Kulminasiya → Cozum |
| 3. Obraz sistemi | Bas qahraman + ikinci daracali obrazlar |
| 4. Movzu va ideya | Asas movzu, alt movzular, asas ideya, aktualliq |
| 5. Badii tasvir vasitalari | Metafora, epitet, banzatma, tazad, hiperbola, alliterasiya |
| 6. Dil va uslub | Leksik, sintaktik xususiyyatlar, ton |
| 7. Muqayisali tahlil | Basqa asarlarla paralelllar |
| 8. Tanqidi dusunca suallari | PIRLS + PISA formatinda suallar |
| 9. Metodiki qeydlar | Faal talim usullari, fanlarasi alaqe, yaradici tapsiriq |
| 10. Qiymatlandirma rubrikalari | Insa / sifahi tahlil ucun 4-balliq rubrika |

**Analiz novlari:** Tam adabi tahlil, Kompozisiya tahlili, Obraz sistemi, Badii tasvir vasitalari, Muqayisali tahlil, Dil va uslub, Tanqidi dusunca suallari, Metodiki qeydlar

### 4. Ayliq Plan

Butov ay ucun haftalik cadval:
- Har hafta: movzu + standart + saat bolgusu + resurs + qiymatlandirma
- PISA/PIRLS uygunluq gostaricisi
- Formativ/summativ qiymatlandirma noqtalari

### 5. Muallim Kommunikasiyasi

Hazir sanad sablonlari:
- Valideyn maktubu (ugur / narahatciliq / davat)
- Idari hesabat
- Pedaqoji sura cixisi
- Sagird xasiyyatnamasi

### 6. Sagird Inkisafi

Fardi sagird profili:
- Zaif taraflar: Oxu surati, Anlama, Yazi, Qrammatika, Nitq, Adabiyyat darki, Lugat ehtiyati, Orfoqrafiya
- PISA saviyyasi muayyanlasdirma
- Fardi CEFR profili
- Valideyn maktubu

### 7. Metodiki Komak

Muallim ucun metodiki tovsiyalar:
- Faal talim usullari
- Baynalxalq praktika (PISA olkalarinin tacrubasi)

### 8. Raqamsal Assistant

Azad sual-cavab — istanilan pedaqoji suala cavab verir.

---

## Bilik Bazasi

### Darslik Chunk-lari

18 Azerbaycan dili va adabiyyat darsliyi (1-11-ci sinif, I va II hissa) PDF formatindan parcalanib JSON chunk-larina cevrilib:

| Sinif | Darslik | Format |
|-------|---------|--------|
| 1 | I hissa + II hissa | 2 PDF |
| 2 | I hissa + II hissa | 2 PDF |
| 3 | I hissa + II hissa | 2 PDF |
| 4 | I hissa + II hissa | 2 PDF |
| 5 | I hissa + II hissa | 2 PDF |
| 6 | I hissa + II hissa | 2 PDF |
| 7 | Tam | 1 PDF |
| 8 | Tam | 1 PDF |
| 9 | Tam | 1 PDF |
| 10 | Tam | 1 PDF |
| 11 | Tam | 1 PDF |
| **Cami** | **18 PDF** | **519 chunk, 32 JSON** |

Har chunk tarkibi: sinif, hissa, movzu, saha, matn, sahifa araligi, soz sayi.

### Kurikulum Standartlari

442 alt-standart, 5 saha uzra:

| Saha | Izah |
|------|------|
| Oxu | Matn anlama, sarhetma, qiymatlandirma, muqayisa |
| Yazi | Insa, meqale, hekaya, xulasa, qeyd |
| Qrammatika | Fonetika, leksika, morfologiya, sintaksis |
| Danisiq | Sifahi nitq, muzakira, taqdimат, dialoq |
| Adabiyyat | Adabi analiz, janr, dovar, muallif, obraz sistemi |

### Movzular

890 movzu 1-11-ci sinif uzra, har movzu ucun:
- Saha (oxu/yazi/qrammatika/danisiq/adabiyyat)
- Saat sayi
- Darslik istinad

### Adabi Asarlar

`eserler.json` — sinif uzra adabi asarlar siyahisi (muallif, asar adi, janr).

---

## Baynalxalq Standartlar

### PISA Oxu Savadliligi

6 saviyyali qiymatlandirma cercivasi:

| Saviyya | Bacariq |
|---------|---------|
| 1a-1b | Sadə matndda aciq malumati tapma |
| 2 | Asas ideyanin muayyanlasdirilmasi, sada sarh |
| 3 | Matnin muxtalif hissalari arasinda alaqe qurma |
| 4 | Muallif maqsadini, uslubunu qiymatlandirma |
| 5 | Murakkab matnlarda gizli malumatin tapilmasi |
| 6 | Coxmanbali matni tanqidi tahlil etma |

### PIRLS Oxu Proseslari

| Proses | Izah |
|--------|------|
| Malumat alma | Matnddan konkret informasiya cixarma |
| Birbasa ciхarim | Matndaki aydın ifadalardan natica cixarma |
| Sarh etma | Matnin manasini oz sozlari ila ifada etma |
| Qiymatlandirma | Matn haqqinda fikir bildirma, muqayisa etma |

### Blum Taksonomiyasi

| Saviyya | Feil numunalari |
|---------|----------------|
| Xatirlamaq | adlandirmaq, sadalamaq, tanımaq |
| Anlamaq | izah etmak, muqayisa etmak, tasniflasdirimak |
| Tatbiq etmak | istifada etmak, hall etmak, numayis etdirmak |
| Tahlil etmak | farqlandirmak, taskilatlandirmaq, aid etmak |
| Qiymatlandirmak | argumetlasdirimak, muhasiba yurutmak |
| Yaratmaq | planlasdirmaq, yazmaq, dizayn etmak |

### CEFR Dil Carcivasi

| Saviyya | Tatbiq |
|---------|--------|
| A1 | 1-2-ci sinif: sada cumla, tanidiq sozlar |
| A2 | 3-4-cu sinif: qisa matn, gundalik movzular |
| B1 | 5-7-ci sinif: mustaqil oxu va yazi, asas fikirlar |
| B2 | 8-9-cu sinif: murakkab matn, argumetlasdirilmis yazi |
| C1 | 10-11-ci sinif: akademik matn, adabi tahlil |

---

## API Endpoint-lari

Node.js API (optional, R Shiny mustaqil islayir):

| Metod | Endpoint | Funksiyasi |
|-------|----------|-----------|
| GET | `/api/v1/health` | Saglamliq yoxlamasi |
| POST | `/api/v1/ders-plani` | Dars plani generasiyasi |
| POST | `/api/v1/test-yarat` | Test generasiyasi |
| POST | `/api/v1/insha-rubrika` | Insa rubrikasi |
| POST | `/api/v1/diktant-hazirla` | Diktant hazirligi |
| POST | `/api/v1/edebi-tahlil` | Adabi tahlil |
| POST | `/api/v1/aylik-plan` | Ayliq plan |
| POST | `/api/v1/mesaj-yaz` | Mesaj generasiyasi |
| POST | `/api/v1/shagird-analiz` | Sagird analizi |
| GET | `/api/v1/arxiv/ders-planlari` | Kecmis planlar |
| GET | `/api/v1/arxiv/testler` | Kecmis testlar |

---

## Verilanlar Bazasi (PostgreSQL)

### Asas cadvallar

| Cadval | Maqsad |
|--------|--------|
| `azdili_standartlari` | Kurikulum standartlari (442 alt-standart) |
| `azdili_movzular` | 890 movzu |
| `azdili_derslikler` | 519 darslik chunk-i |
| `ders_planlari` | Generasiya olunmus dars planlari |
| `testler` | Generasiya olunmus testlar |
| `mesajlar` | Mesajlar |
| `edebi_metnler` | Adabi matnlar bazasi |
| `luget_izahlar` | Lugat izahlari |

### Migration va Seed

```bash
npm run db:migrate   # Schema yaradir (8 cadval)
npm run db:seed      # Standartlar + movzular daxil edir
npm run db:chunks    # 519 chunk-i DB-ya yuklamak
npm run db:setup     # Hamisi birdafaya
```

---

## R Shiny Interfeys

### 7 Tab

**Tab 1 — Dars Plani:**
Sinif, movzu, dars tipi, faaliyyat novu, muddaт, baynalxalq carciva secimi, diferensial talim va rubrika secimi ila atrafli dars plani yaradir.

**Tab 2 — Test va Qiymatlandirma:**
PISA formatinda testlar — cocsecimli + qisa cavabli + aciq suallar. Catinlik saviyyasi, matn novu, rubrika secimi.

**Tab 3 — Ayliq Plan:**
Butov ay ucun haftalik cadval — sinif, ay, haftalik saat, PISA/PIRLS uygunluq, qiymatlandirma noqtalari.

**Tab 4 — Adabi Matn Analizi:**
10 elementli tam adabi tahlil — muallif, asar, analiz novu, insa rubrikalari, muqayisali tahlil secimi.

**Tab 5 — Sagird Analizi:**
Fardi sagird profili — guclu/zaif taraflar, PISA saviyyasi, CEFR profili, fardilasdirilmis tovsiyalar.

**Tab 6 — Muallim Komakcisi:**
Azad sual-cavab + metodiki tovsiya + baynalxalq praktika duymalari.

**Tab 7 — Arxiv:**
Kecmis planlar va testlar cadval saklinda, HTML bax + DOCX yukla duymalari.

---

## Fayl Cixisi

Har generasiya naticasi 2 formatda saxlanir:

### HTML5
- Responsive dizayn, mobil uyumlu
- Gradient basliqlar, rangli fazalar
- ARTI 2026 brendinq (yasil + narinci tema)
- Cap ucun optimizasiya (`@media print`)

### DOCX (Word)
- Pandoc vasitasila avtomatik cevrilir
- Azerbaycan alifbasi dastayi (UTF-8)
- ARTI 2026 altbilgi

### Fayl adlandirma

```
sinif{N}_{movzu_slug}_{tip}_{timestamp}.html
sinif{N}_{movzu_slug}_{tip}_{timestamp}.docx
```

Misal: `sinif8_D_rnaq_i_ar_si_v__m_t_riz__ders_plani_20260309_084314.html`

### Saxlama yolu

Fayllar `r_shiny/app/output/` altinda saxlanir:
```
r_shiny/app/output/Ders_planlari/   # Dars planlari
r_shiny/app/output/Testler/         # Testlar
r_shiny/app/output/Mesajlar/        # Mesajlar
```

---

## Konfiqurasiya

### AI Model Secimi

`.env` faylinda:

```env
DEFAULT_AI_MODEL=claude-sonnet-4-20250514
```

Dastaklanan modellar:
- `claude-sonnet-4-20250514` (default, optimal balans)
- `claude-haiku-4-5-20251001` (suratli, ucuz)
- `gpt-4o` (OpenAI alternativi)

### Token Limitlari

| Model | Default max_tokens |
|-------|--------------------|
| Claude Sonnet/Opus | 16384 |
| Claude Haiku | 4096 |
| GPT-4o | 16384 |

---

## Inkisaf

### Lokal inkisaf

```bash
# R Shiny
cd r_shiny/app
Rscript -e "shiny::runApp('.', port = 4040)"

# Node.js (nodemon ila)
npm run dev

# PDF pipeline (birdafalik)
python3 scripts/pdf_pipeline.py

# Movzu generasiyasi
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
| Sanad generasiyasi | Pandoc (HTML → DOCX) | 2.19+ |
| PDF pipeline | Python (PyPDF2, tiktoken) | 3.9+ |
| Konteynerlasdirma | Docker + Docker Compose | 24+ |

---

## Verilanlarin Xulasasi

| Gostarici | Say |
|-----------|-----|
| Asas standart | 147 |
| Alt-standart | 442 |
| Movzu | 890 |
| Darslik chunk | 519 |
| PDF darslik | 18 |
| Chunk JSON fayl | 32 |
| Sinif | 1-11 |
| AI Agent | 8 |
| Interfeys tab | 7 |
| Saha | 5 (oxu, yazi, qrammatika, danisiq, adabiyyat) |

---

## Lisenziya

MIT License — ARTI 2026, Tariyel Talibov

---

## Alaqe

- **Muallif:** Tariyel Talibov
- **Taskilat:** ARTI — Azerbaycan Respublikasi Tahsil Institutu
- **GitHub:** [Ttariyel-1954/Az_Agent](https://github.com/Ttariyel-1954/Az_Agent)
