# Azərbaycan Dili Müəllim Agenti (Az_agent)

[![R](https://img.shields.io/badge/R-4.2+-blue.svg)](https://www.r-project.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791.svg)](https://www.postgresql.org/)
[![Claude](https://img.shields.io/badge/AI-Claude%20Sonnet%204-purple.svg)](https://www.anthropic.com/)
[![Shiny](https://img.shields.io/badge/R%20Shiny-Dashboard-149eca.svg)](https://shiny.rstudio.com/)

**Azərbaycan Respublikasında 1-11-ci siniflər üzrə Azərbaycan dili müəllimlərinə dəstək verən, Claude AI əsasında işləyən R Shiny dashboard-u. Müəllimlər üçün dərs planı, test, mesaj və müxtəlif tədris materiallarını avtomatik generasiya edir.**

---

## Mündəricat

- [Layihənin Məqsədi](#layihənin-məqsədi)
- [Əsas Xüsusiyyətlər](#əsas-xüsusiyyətlər)
- [Dashboard Bölmələri](#dashboard-bölmələri)
- [Pedaqoji Yanaşma](#pedaqoji-yanaşma)
- [Texniki Stek](#texniki-stek)
- [Layihə Strukturu](#layihə-strukturu)
- [Verilənlər Bazası](#verilənlər-bazası)
- [Quraşdırma](#quraşdırma)
- [İstifadə Qaydası](#i̇stifadə-qaydası)
- [Konfiqurasiya](#konfiqurasiya)
- [Təhlükəsizlik](#təhlükəsizlik)
- [Layihə Rəhbəri](#layihə-rəhbəri)

---

## Layihənin Məqsədi

Azərbaycan dili müəllimlərinin gündəlik pedaqoji fəaliyyətini avtomatlaşdırmaq və dünya standartlarına uyğun tədris materialları yaratmaq. Əsas məqsədlər:

- **Dərs planlarının avtomatik generasiyası** — 1-11-ci siniflər üçün standart və alt standartlara əsaslanan dərs planları
- **Test və qiymətləndirmə materialları** — Bloom taksonomiyasına və CEFR səviyyələrinə uyğun testlər
- **Mesaj və bildiriş şablonları** — valideynlər, şagirdlər üçün peşəkar mesajlar
- **Analitik təhlil** — şagird nailiyyətlərinin və dərs planlarının keyfiyyət təhlili
- **Dərsliklərdən kontekst çıxarma** — PDF dərsliklərdən RAG (Retrieval-Augmented Generation) vasitəsilə məlumat istifadəsi

---

## Əsas Xüsusiyyətlər

### 🤖 Süni İntellekt Əsaslı Generasiya
- Claude Sonnet 4 modelindən istifadə
- Azərbaycan dili standartlarına tam uyğunluq
- PISA, PIRLS, CEFR çərçivələri ilə uyğunlaşdırma

### 📚 Dərs Planı Generatoru
- Sinif və mövzuya görə avtomatik dərs planı
- Standart və alt standartların inteqrasiyası
- Motivasiya, təqdimat, möhkəmləndirmə mərhələləri
- HTML və DOCX formatında ixrac

### ✍️ Test Generatoru
- Çoxvariantlı, doğru-yanlış, qısa cavab testləri
- Bloom taksonomiyası səviyyəsinə görə
- Avtomatik qiymətləndirmə rubrikası

### 💬 Mesaj Şablonları
- Valideyn bildirişləri
- Şagird motivasiya mesajları
- Rəsmi yazışmalar
- Hadisə təsvirləri

### 📖 Ədəbiyyat Analizi
- Müəllif və əsər əsasında analiz
- Dərsdə istifadə üçün suallar
- Ədəbi təhlil şablonları

### 🎨 Çıxışlar
- HTML (nəfis rəngli)
- DOCX (Word sənəd)
- Plotly ilə interaktiv qrafiklər

---

## Dashboard Bölmələri

| Bölmə | Funksiyası |
|-------|------------|
| **Ana Səhifə** | Ümumi statistika, qısa rəhbər |
| **Dərs Planı** | Sinif, standart, mövzu → AI dərs planı |
| **Testlər** | Standartlara əsaslanan test generasiyası |
| **Mesajlar** | Hazır mesaj şablonları + AI generasiya |
| **Analiz** | Müəllif/əsər əsasında ədəbi analiz |
| **Standartlar** | 442 alt standartın interaktiv baxışı |
| **Dərsliklər** | PDF dərsliklərdən kontekst axtarışı (RAG) |
| **Konfiqurasiya** | API key, model seçimi, dil parametrləri |

---

## Pedaqoji Yanaşma

### Beynəlxalq Çərçəvələr
- **PISA** — Oxu savadlılığı (məlumat əldə etmə, interpretasiya, qiymətləndirmə)
- **PIRLS** — Oxu bacarıqlarının beynəlxalq qiymətləndirilməsi
- **CEFR** — Avropa dil çərçəvəsi (A1-C1 səviyyələri)
- **Bloom taksonomiyası** — Xatırlama → Anlama → Tətbiq → Təhlil → Qiymətləndirmə → Yaratma

### Aparıcı 6 Ölkənin Pedaqoji Təcrübəsi
| Ölkə | Yanaşma |
|------|---------|
| **Finlandiya** | Fənlərarası oxu, müstəqil düşüncə |
| **Sinqapur** | STELLAR proqramı, kritik düşüncə |
| **Estoniya** | Rəqəmsal savadlılıq |
| **Yaponiya** | Dərin oxu, estetik duyum |
| **Kanada** | Diferensial öyrənmə, inklüziv yanaşma |
| **İrlandiya** | İkidilli yanaşma, şifahi ənənə |

### 442 Alt Standart (1-11 siniflər)
Azərbaycan dili fənn kurikulumunun bütün standart və alt standartları:
- **Dinləmə və danışma** — şifahi kommunikasiya
- **Oxu** — mətn anlamasınıncı, fonetik bacarıqlar
- **Yazı** — yaradıcı və akademik yazı
- **Dil qaydaları** — qrammatika, orfoqrafiya, durğu işarələri

---

## Texniki Stek

| Komponent | Texnologiya |
|-----------|-------------|
| **Proqramlaşdırma dili** | R (>= 4.2) |
| **Veb interfeys** | R Shiny + shinydashboard |
| **Süni intellekt** | Claude API (Anthropic) — Sonnet 4 |
| **Verilənlər bazası** | PostgreSQL |
| **PDF emalı** | pdftools, tesseract (OCR) |
| **Vizuallaşdırma** | Plotly |
| **HTTP sorğular** | httr paketi |
| **JSON emal** | jsonlite paketi |
| **DOCX ixrac** | officer, flextable |
| **Backend skriptləri** | Node.js, Python |
| **Konteynerləşdirmə** | Docker, docker-compose |

---

## Layihə Strukturu

```
Az_agent/
├── r_shiny/                      # R Shiny dashboard
│   └── app/
│       └── app.R                 # Əsas Shiny tətbiqi
├── src/                          # Backend mənbə kodu
├── scripts/                      # Köməkçi skriptlər
├── database/                     # PostgreSQL schema və seed
│   ├── migrations/               # Baza sxemi
│   └── seeds/                    # İlkin data
├── derslikler/                   # PDF dərsliklər və embeddings
│   ├── pdf/                      # Ham PDF faylları (git-də deyil)
│   ├── epub/                     # EPUB versiyalar
│   └── embeddings/               # Vector embeddings (RAG üçün)
├── Ders_planlari/                # Generasiya olunmuş dərs planları
├── Testler/                      # Generasiya olunmuş testlər
├── Mesajlar/                     # Generasiya olunmuş mesajlar
├── output/                       # Ümumi çıxışlar
├── config/                       # Konfiqurasiya faylları
├── .env                          # API açarları (git-ə daxil deyil!)
├── .env.example                  # .env nümunəsi
├── .gitignore                    # Git ignore qaydaları
├── CLAUDE.md                     # AI təlimatları
├── README.md                     # Bu fayl
├── Dockerfile                    # Docker konteyner
├── docker-compose.yml            # Docker Compose konfiqurasiyası
└── package.json                  # Node.js asılılıqları
```

---

## Verilənlər Bazası

Baza adı: `muellim_agent` və ya `az_muellim_db`

### Əsas cədvəllər
- **subjects** — Fənlər (Azərbaycan dili, Riyaziyyat və s.)
- **curriculum_standards** — 442 Azərbaycan dili standartı (+riyaziyyat)
- **content_standards_detail** — Alt standartların ətraflı təsviri
- **generated_content** — AI tərəfindən yaradılmış məzmun
- **users** — İstifadəçi hesabları (müəllimlər)
- **usage_log** — API istifadə tarixçəsi

---

## Quraşdırma

### Tələblər
- **R** >= 4.2
- **PostgreSQL** >= 14
- **Anthropic API açarı**
- **Node.js** >= 18 (backend skriptlər üçün)
- R paketləri: `shiny`, `shinydashboard`, `shinyjs`, `DT`, `httr`, `jsonlite`, `plotly`

### Addımlar

```bash
# 1. Repo-nu klonla
git clone https://github.com/Ttariyel-1954/Az_Agent.git
cd Az_Agent

# 2. .env faylını yarat
cp .env.example .env
nano .env
# ANTHROPIC_API_KEY=sk-ant-api03-SİZİN_AÇARINIZ yazın

# 3. R paketlərini qur
Rscript -e 'install.packages(c("shiny","shinydashboard","shinyjs","DT","httr","jsonlite","plotly"))'

# 4. PostgreSQL bazasını yarat
createdb muellim_agent
psql -d muellim_agent -f database/migrations/001_schema.sql
psql -d muellim_agent -f database/seeds/001_standards_seed.sql

# 5. Dashboard-u işə sal
Rscript -e "shiny::runApp('r_shiny/app/app.R', port=4040)"
```

Brauzer: **http://localhost:4040**

### Docker ilə (alternativ)
```bash
docker-compose up -d
```

---

## İstifadə Qaydası

### Dərs planı yaratmaq
1. **Dərs Planı** tabını açın
2. Sinif, məzmun xətti və mövzu seçin
3. **"Dərs planı yarat"** düyməsini basın
4. 30-60 saniyə ərzində tam dərs planı hazır olacaq
5. HTML və ya DOCX formatında yükləyin

### Test yaratmaq
1. **Testlər** tabına keçin
2. Standart və çətinlik səviyyəsini seçin
3. Sual saylarını təyin edin
4. **"Test yarat"** düyməsi ilə generasiya edin

### Ədəbi analiz
1. **Analiz** tabına keçin
2. Müəllif və əsər adını daxil edin
3. Analiz növünü seçin (ümumi, xarakter, üslub və s.)
4. Nəticəni HTML və ya DOCX kimi yükləyin

---

## Konfiqurasiya

### `.env` faylı

```bash
# PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_NAME=muellim_agent
DB_USER=your_username
DB_PASSWORD=

# Claude AI
ANTHROPIC_API_KEY=sk-ant-api03-SİZİN_AÇARINIZ
DEFAULT_AI_MODEL=claude-sonnet-4-20250514

# Shiny
SHINY_PORT=4040
```

### Avtomatik API Key Yükləmə

Dashboard açılanda API açarı `.env` faylından avtomatik oxunur və **görünməz** (password format) olaraq daxil edilir. İstifadəçi onu əl ilə daxil etməyə ehtiyac duymur.

Əgər açar yüklənmirsə, `app.R`-da `APP_DIR` yolunun düzgün olduğunu yoxlayın:

```r
PROJECT_DIR <- normalizePath("~/projects/standards/Az_agent", mustWork = FALSE)
```

---

## Təhlükəsizlik

### API Açarları
- **HEÇ VAXT** `.env` faylını git-ə commit etməyin
- `.gitignore` faylı `.env`, `.env.sh`, `.Renviron` fayllarını avtomatik istisna edir
- API açarı sızarsa, dərhal [console.anthropic.com](https://console.anthropic.com) saytından **revoke** edin
- Git-də yalnız `.env.example` saxlanılır (açarsız nümunə)

### Dəyişənləri Yoxlama

```bash
# Git-də hansı .env faylları izlənir?
git ls-files | grep -E "\.env"
# Yalnız .env.example görünməlidir

# .env-in git-ə gedib-getmədiyini yoxla
git status --ignored | grep ".env"
```

### Backup
- `database/` qovluğundakı SQL faylları (schema və seed) əsas bərpa mənbəyidir
- AI-generasiya məzmunu `output/`, `Ders_planlari/`, `Testler/` qovluqlarında lokal saxlanılır (git-də deyil)

---

## Onlayn Platformalar

| Platforma | Link |
|-----------|------|
| **GitHub** | [github.com/Ttariyel-1954/Az_Agent](https://github.com/Ttariyel-1954/Az_Agent) |

---

## Layihə Rəhbəri

**Talıbov Tariyel İsmayıl oğlu**
Riyaziyyat üzrə fəlsəfə doktoru
Azərbaycan Respublikası Təhsil İnstitutunun direktor müavini

**ARTI — 2026**

---

## Lisenziya

Bu layihə təhsil məqsədli istifadə üçün nəzərdə tutulub.
Azərbaycan Respublikası Elm və Təhsil Nazirliyi — ARTI
