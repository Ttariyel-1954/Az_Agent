# 📚 Azərbaycan Dili Müəllim Agenti v1.0

**ARTI 2026 — Azərbaycan Respublikası Təhsil İnstitutu**

Azərbaycan dili və ədəbiyyat müəllimləri üçün AI-əsaslı agent sistemi.

## Xüsusiyyətlər

### 6 AI Agent

1. **Dərs Planlaması** — Sinif, mövzu, fəaliyyət növü üzrə dərs planı yaradır
2. **Qiymətləndirmə** — Çoxseçimli test, açıq sual, diktant, inşa rubrikası hazırlayır
3. **Müəllim Kommunikasiyası** — Valideyn məktubu, bildiriş, uğur məktubu yazır
4. **Şagird İnkişafı** — Oxu-yazı inkişafını təhlil edir, fərdi tövsiyələr verir
5. **Metodiki Kömək** — Fəal təlim üsulları, metodiki tövsiyələr verir
6. **Rəqəmsal Assistant** — Azad sual-cavab, aylıq plan, ədəbi təhlil

### Dərslik Bazası
- 16 PDF dərslik (1-11-ci sinif)
- 519 chunk (32 JSON fayl)
- Kurikulum standartları

### İnterfeys
- **R Shiny** — İnteraktiv veb interfeys (7 tab)
- **REST API** — Node.js/Express backend
- **PostgreSQL** — Verilənlər bazası

## Quraşdırma

### Tələblər
- Node.js 18+
- PostgreSQL 14+
- R 4.0+ (Shiny interfeys üçün)
- Anthropic API açarı

### Addımlar

```bash
# 1. Qovluğa keçin
cd ~/Desktop/Az_agent

# 2. Avtomatik quraşdırma
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. Server-i işə salın
npm start

# 4. R Shiny interfeysi
cd r_shiny/app
R -e "shiny::runApp()"
```

### Manual quraşdırma

```bash
# npm paketləri
npm install

# Verilənlər bazası
createdb az_muellim_db
psql -d az_muellim_db -f database/migrations/001_schema.sql
psql -d az_muellim_db -f database/seeds/001_base_seed.sql
node database/seeds/002_chunks_seed.js
```

## API Endpointləri

| Endpoint | Metod | Təsvir |
|----------|-------|--------|
| `/api/v1/ders-plani` | POST | Dərs planı yarat |
| `/api/v1/test-yarat` | POST | Test yarat |
| `/api/v1/insha-rubrika` | POST | İnşa rubrikası yarat |
| `/api/v1/diktant-hazirla` | POST | Diktant hazırla |
| `/api/v1/edebi-tahlil` | POST | Ədəbi təhlil |
| `/api/v1/aylik-plan` | POST | Aylıq plan yarat |
| `/api/v1/mesaj-yaz` | POST | Mesaj yaz |
| `/api/v1/shagird-analiz` | POST | Şagird analizi |
| `/api/v1/arxiv/ders-planlari` | GET | Dərs planları arxivi |
| `/api/v1/arxiv/testler` | GET | Testlər arxivi |
| `/api/v1/health` | GET | Sistem statusu |

## R Shiny İnterfeys

**7 Tab:**

1. **Dərs Planı** — Sinif, mövzu, fəaliyyət seçib plan yaradın
2. **Test və Qiymətləndirmə** — Müxtəlif tipli testlər hazırlayın
3. **Aylıq Plan** — Ay, sinif, həftəlik saat seçib plan yaradın
4. **Ədəbi Mətn Analizi** — Müəllif/əsər təhlil edin
5. **Şagird Analizi** — Fərdi inkişaf planı hazırlayın
6. **Müəllim Köməkçisi** — Azad sual-cavab
7. **Arxiv** — Keçmiş planlar və testlər

## Qovluq Strukturu

```
Az_agent/
├── config/
│   └── database.js          # PostgreSQL bağlantısı
├── database/
│   ├── migrations/
│   │   └── 001_schema.sql   # DB sxemi
│   └── seeds/
│       ├── 001_base_seed.sql    # Standartlar
│       └── 002_chunks_seed.js   # Dərslik chunk-ları
├── derslikler/
│   ├── pdf/                 # 16 PDF dərslik
│   ├── chunks/              # 519 chunk (JSON+TXT)
│   └── index.json           # Master indeks
├── src/
│   ├── server.js            # Express server
│   ├── core/
│   │   └── ai_engine.js     # Claude/GPT AI mühərrik
│   ├── agents/
│   │   ├── ders_planlamasi/     # Agent 1
│   │   ├── qiymetlendirme/     # Agent 2
│   │   ├── muellim_kommunikasiyasi/  # Agent 3
│   │   ├── shagird_inkishafi/   # Agent 4
│   │   ├── metodiki_komek/      # Agent 5
│   │   └── reqemsal_assistant/  # Agent 6
│   ├── api/
│   │   └── routes.js        # API marşrutları
│   └── middleware/
│       └── auth.js          # JWT + MFA
├── r_shiny/
│   └── app/
│       └── app.R            # Shiny interfeys
├── Ders_planlari/           # Yaradılmış planlar
├── Testler/                 # Yaradılmış testlər
├── Mesajlar/                # Yaradılmış mesajlar
├── scripts/
│   └── setup.sh             # Quraşdırma skripti
├── package.json
├── .env                     # Konfiqurasiya
├── Dockerfile
└── docker-compose.yml
```

## .env Konfiqurasiyası

```env
DB_NAME=az_muellim_db
ANTHROPIC_API_KEY=sk-ant-...
DEFAULT_AI_MODEL=claude-sonnet-4-20250514
PORT=3000
SHINY_PORT=4040
```

## Lisenziya

MIT — ARTI 2026, Tariyel Talibov
