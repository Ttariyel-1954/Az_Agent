# ══════════════════════════════════════════════════════════
# Az_Muellim_Agent v2.0 — Azerbaycan Dili Muellim Agenti
# ARTI 2026 (c) Tariyel Talibov
# PISA/PIRLS/Blum/CEFR beynelxalq cerciveleri ile
# ══════════════════════════════════════════════════════════

library(shiny)
library(shinydashboard)
library(shinyjs)
library(DT)
library(httr)
library(jsonlite)

PLOTLY_OK <- tryCatch({ library(plotly); TRUE }, error = function(e) {
  message("plotly yuklenmedi: ", e$message); FALSE })

PROJECT_DIR <- normalizePath("~/projects/ai-agents/Az_agent", mustWork = FALSE)
LOCAL_DIR   <- normalizePath("~/Desktop/Az_agent", mustWork = FALSE)
APP_DIR     <- if (dir.exists(PROJECT_DIR)) PROJECT_DIR else if (dir.exists(LOCAL_DIR)) LOCAL_DIR else getwd()

env_file <- file.path(APP_DIR, ".env")
if (file.exists(env_file)) {
  for (line in readLines(env_file, warn = FALSE)) {
    line <- trimws(line)
    if (nchar(line) > 0 && !startsWith(line, "#") && grepl("=", line)) {
      p <- strsplit(line, "=", fixed = TRUE)[[1]]
      do.call(Sys.setenv, setNames(list(trimws(paste(p[-1], collapse = "="))), trimws(p[1])))
    }
  }
}

DATA_DIR       <- file.path(APP_DIR, "derslikler")
CHUNKS_DIR     <- file.path(DATA_DIR, "chunks")
CLAUDE_MODEL   <- Sys.getenv("DEFAULT_AI_MODEL", "claude-sonnet-4-20250514")
CLAUDE_ENDPOINT <- "https://api.anthropic.com/v1/messages"
SHINY_APP_DIR <- normalizePath(file.path(APP_DIR, "r_shiny", "app"), mustWork = FALSE)
DERS_DIR <- file.path(SHINY_APP_DIR, "output", "Ders_planlari")
TEST_DIR <- file.path(SHINY_APP_DIR, "output", "Testler")
MSG_DIR  <- file.path(SHINY_APP_DIR, "output", "Mesajlar")
dir.create(DERS_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(TEST_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(MSG_DIR,  showWarnings = FALSE, recursive = TRUE)

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || (is.character(x) && all(nchar(x) == 0))) y else x

# ═══════════════ RENGLER ═══════════════
RENGLER <- list(
  esas    = "#1B5E20",
  ikinci  = "#2E7D32",
  aciq    = "#E8F5E9",
  vurgu   = "#FF6F00",
  metn    = "#212121"
)

# ═══════════════ SYSTEM PROMPT (v2.0) ═══════════════
SYSTEM_PROMPT <- paste0(
  "Sen Azerbaycan Respublikasinin 1-11-ci sinif Azerbaycan dili ve edebiyyat ",
  "fennini derinden bilen, PISA/PIRLS/Blum/CEFR cercivelrini menimseyen ",
  "AI muellim assistentisen.\n\n",

  "SENIN ESAS PRINSIPIN: HEC VAXT umumi, shablonvari, soz yigini olan mezmun yazma. ",
  "Her cavab KONKRET, PRAKTIK, DERHAL istifadeye hazir olmalidir. Muellim senin ",
  "yazdiqlarini oxuyanda 'bu mehz menim dersime uygun, bu mehz bu standarta xidmet edir' ",
  "demlidir. Umumi sozler, bosh cumleler, doldurucu ifadeler QADAGANDIR.\n\n",

  "STANDART-MOVZU ELAQESI (EN VACIB PRINSIP):\n",
  "Her ders planinda, her testde, her tehlilde MUTLEQ goster:\n",
  "- Bu movzu bu standarta NECE xidmet edir\n",
  "- Standartta teleb olunan bacariq bu movzuda NECE formalasinr\n",
  "- Sagird bu dersin/testin sonunda standartin HANSI telabini ode bilecek\n",
  "- KONKRET misal: 'Bu standart sagirdden [X] teleb edir. Bu movzuda sagird [Y] ederek ",
  "bu bacarigi inkishaf etdirir.'\n\n",

  "BEYNELXALQ CERCIVELER:\n",
  "- PISA Oxu Savadliligi (6 seviyye: 1b-6): metn novleri, oxu prosesleri\n",
  "- PIRLS 4-cu sinif oxu: bedii metn + melumat metni; 4 proses\n",
  "- Blum Taksonomiyasi (6 seviyye): xatirlamaq - anlamaq - tetbiq - tehlil - qiymetlendirme - yaratma\n",
  "- CEFR Dil Cercivesi (A1-C2): dinleme, danisiq, oxu, yazi\n",
  "- Azerbaycan Dili Fenn Kurikulumu (2024): 4 mezmun xetti, 147 esas standart, 442 alt-standart\n\n",

  "DERS PLANI YAZARKEN:\n",
  "1. Meqsed — OLCULE BILEN feillerle (sadalayir, izah edir, tetbiq edir, tehlil edir, yaradir)\n",
  "2. Her merhelede standartla ELAQENI goster — bu merhele standarta NECE xidmet edir\n",
  "3. Diferensial telim — 3 seviyye: zeif/orta/guclu — her biri ucun KONKRET tapshiriq\n",
  "4. Formativ qiymetlendirme — KONKRET suallar, cixis bileti, mini test\n",
  "5. Derslik istinadlari — KONKRET sehife nomreleri\n",
  "6. Fenlerarasi inteqrasiya — tarix, cografiya, musiqi ve s.\n",
  "7. Standarta nail olma xulasesi — ders sonu muellim ucun\n\n",

  "TEST YAZARKEN:\n",
  "1. Her sualin HANSI standarti olcduyunu goster\n",
  "2. Distraktorlar sagirdlerin TIPIK sehvlerine esaslansin\n",
  "3. Her sualin izahinda muellim ucun metodiki qeyd olsun\n",
  "4. Rubrikalar KONKRET numune cavablarla olsun\n\n",

  "EDEBIYYAT TEHLILI YAZARKEN:\n",
  "1. Kompozisiya analizi: ekspozisiya - kulminasiya - cozum\n",
  "2. Obraz sistemi: esas + ikinci dereceli obrazlar, xarakter inkishafi\n",
  "3. Bedii tesvir vasiteleri: metafora, epitet, benzetme — METN NUMUNELERI ile\n",
  "4. Muellif movqeyi, janr xususiyyetleri, dovr konteksti\n",
  "5. PISA formatinda suallar: coxsecimli + konstruktiv + aciq\n\n",

  "QIZIL QAYDALAR:\n",
  "- HEC VAXT 'meselen', 'numune ucun', 'buna benzer' kimi bosh istinadlar yazma — KONKRET yaz\n",
  "- HEC VAXT 'muellim izah edir' kimi umumi cumleler yazma — NE izah edir, NECE izah edir yaz\n",
  "- HEC VAXT 'tapshiriq verilir' yazma — TAPSHIRIGIN OZUNU yaz\n",
  "- HEC VAXT 'qiymetlendirme aparilir' yazma — NECE qiymetlendirilir, HANSI suallarla yaz\n",
  "- Her cavab minimum 2000 soz olmalidir — qisa, sathi cavab QADAGANDIR\n",
  "- Butun cavablari Azerbaycan dilinde ver."
)

# ═══════════════ STANDARTLAR ═══════════════
ALL_STANDARDS <- tryCatch(
  fromJSON(file.path(DATA_DIR, "standards.json"), simplifyVector = FALSE),
  error = function(e) { message("standards.json: ", e$message); list() })

get_standards_dropdown <- function(grade) {
  stds <- ALL_STANDARDS[[as.character(grade)]]
  if (is.null(stds) || length(stds) == 0) return(c("Standart tapilmadi" = "---"))
  ch <- character(0)
  for (s in stds) {
    kod <- s$kod %||% "?"; sahe <- s$sahe %||% "?"; metn <- s$metn %||% "?"
    label <- paste0(kod, "  [", sahe, "]  ", metn)
    val <- paste0(kod, " - ", metn)
    ch <- c(ch, setNames(val, label))
  }
  ch
}

# ═══════════════ MOVZULAR ═══════════════
ALL_TOPICS <- tryCatch(
  fromJSON(file.path(DATA_DIR, "topics.json"), simplifyVector = FALSE),
  error = function(e) { message("topics.json: ", e$message); list() })

get_topics_for_grade <- function(grade) {
  gd <- ALL_TOPICS[[as.character(grade)]]
  if (is.null(gd)) return(c("Movzu tapilmadi" = "---"))
  ch <- character(0)
  # Yeni format: list of {ad, standard_kodu, sahe, saat, sehife}
  if (!is.null(gd[[1]]$ad)) {
    for (m in gd) {
      ad <- m$ad %||% "?"
      sahe <- m$sahe %||% "?"
      seh <- m$sehife %||% m$seh %||% "?"
      std <- m$standard_kodu %||% ""
      label <- paste0("[", sahe, "]  ", ad, "  (", std, ", seh. ", seh, ")")
      ch <- c(ch, setNames(ad, label))
    }
  } else {
    # Köhnə format: bolmeler
    for (b in gd$bolmeler) {
      bn <- b$bolme %||% "?"
      for (m in b$movzular) {
        ad <- m$ad %||% "?"; seh <- m$seh %||% "?"
        label <- paste0("[", bn, "]  ", ad, "  (seh. ", seh, ")")
        ch <- c(ch, setNames(ad, label))
      }
    }
  }
  if (length(ch) == 0) return(c("Movzu tapilmadi" = "---"))
  ch
}

# ═══════════════ ESERLER ═══════════════
ALL_ESERLER <- tryCatch(
  fromJSON(file.path(DATA_DIR, "eserler.json"), simplifyVector = FALSE),
  error = function(e) { message("eserler.json: ", e$message); list() })

get_eserler_for_grade <- function(grade) {
  es <- ALL_ESERLER[[as.character(grade)]]
  if (is.null(es) || length(es) == 0) return(c("Eser tapilmadi" = "---"))
  ch <- character(0)
  for (e in es) {
    muellif <- e$muellif %||% "?"; eser <- e$eser %||% "?"; janr <- e$janr %||% "?"
    label <- paste0(muellif, " — ", eser, "  [", janr, "]")
    val <- paste0(muellif, " - ", eser)
    ch <- c(ch, setNames(val, label))
  }
  ch
}

# ═══════════════ CHUNK FUNCTIONS ═══════════════
load_chunks_for_grade <- function(gr) {
  fs <- list.files(CHUNKS_DIR, pattern = sprintf("sinif%d_.*\\.json$", gr), full.names = TRUE)
  out <- list()
  for (f in fs) tryCatch({ out <- c(out, fromJSON(f, simplifyVector = FALSE)) }, error = function(e) {})
  out
}

search_chunks <- function(gr, topic, mx = 3) {
  chs <- load_chunks_for_grade(gr)
  if (length(chs) == 0) return(list())
  tl <- tolower(topic); tw <- strsplit(tl, "\\s+")[[1]]; tw <- tw[nchar(tw) >= 3]
  sc <- list()
  for (ch in chs) {
    s <- 0
    bl <- tolower(paste(ch$text %||% "", ch$topic %||% "", ch$chapter %||% "",
                        paste(ch$keywords %||% character(0), collapse = " ")))
    if (grepl(tl, bl, fixed = TRUE)) s <- s + 10
    for (w in tw) s <- s + min(length(gregexpr(w, bl, fixed = TRUE)[[1]]), 5)
    if (nchar(ch$chapter %||% "") > 0 && grepl(tl, tolower(ch$chapter), fixed = TRUE)) s <- s + 15
    if (s > 0) sc <- c(sc, list(list(score = s, chunk = ch)))
  }
  sc <- sc[order(-sapply(sc, function(x) x$score))]
  lapply(head(sc, mx), function(x) x$chunk)
}

build_context <- function(gr, topic) {
  res <- search_chunks(gr, topic)
  if (length(res) == 0) return(sprintf("[Sinif %d, '%s' - kontekst yoxdur]", gr, topic))
  pts <- character(0)
  for (ch in res) {
    tx <- ch$text %||% ""
    if (nchar(tx) > 4000) tx <- paste0(substr(tx, 1, 4000), "\n...")
    pts <- c(pts, sprintf("\n--- Derslik: %s, seh. %s-%s ---\nFesil: %s\nAcar: %s\n\n%s\n",
      ch$source_file %||% "?", ch$page_start %||% "?", ch$page_end %||% "?",
      ch$chapter %||% "-", paste(head(ch$keywords %||% character(0), 10), collapse = ", "), tx))
  }
  paste(pts, collapse = "\n")
}

# ══════════════════════════════════════════════
# CLAUDE API
# ══════════════════════════════════════════════
call_claude <- function(prompt, api_key = NULL) {
  key <- if (!is.null(api_key) && nchar(api_key) >= 10) api_key else Sys.getenv("ANTHROPIC_API_KEY", "")
  if (nchar(key) < 10) return(list(success = FALSE, error = "API key daxil edin! (Sol panelde 'API Key' xanasi)",
                                    time_sec = 0, input_tokens = 0, output_tokens = 0))
  t0 <- proc.time()["elapsed"]
  tryCatch({
    resp <- POST(CLAUDE_ENDPOINT,
      add_headers(`x-api-key` = key, `anthropic-version` = "2023-06-01", `content-type` = "application/json"),
      body = toJSON(list(
        model = CLAUDE_MODEL,
        max_tokens = if (grepl("haiku", CLAUDE_MODEL)) 4096L else 16384L,
        system = SYSTEM_PROMPT,
        messages = list(list(role = "user", content = prompt))
      ), auto_unbox = TRUE),
      encode = "raw", timeout(300))
    elapsed <- round(as.numeric(proc.time()["elapsed"] - t0), 1)
    res <- content(resp, "parsed", encoding = "UTF-8")
    inp_tok <- as.integer(res$usage$input_tokens %||% 0)
    out_tok <- as.integer(res$usage$output_tokens %||% 0)
    if (resp$status_code == 200) {
      txt <- if (length(res$content) > 0) res$content[[1]]$text %||% "" else ""
      list(success = TRUE, text = txt, time_sec = elapsed, input_tokens = inp_tok, output_tokens = out_tok)
    } else {
      err_msg <- if (!is.null(res$error)) res$error$message %||% paste("HTTP", resp$status_code) else "Bilinmeyen xeta"
      list(success = FALSE, error = err_msg, time_sec = elapsed, input_tokens = inp_tok, output_tokens = out_tok)
    }
  }, error = function(e) {
    elapsed <- round(as.numeric(proc.time()["elapsed"] - t0), 1)
    list(success = FALSE, error = e$message, time_sec = elapsed, input_tokens = 0, output_tokens = 0)
  })
}

# ══════════════════════════════════════════════
# FAYL SAXLAMA
# ══════════════════════════════════════════════
save_result <- function(html_body, css_text, folder, grade, topic, type_label) {
  ts <- format(Sys.time(), "%Y%m%d_%H%M%S")
  safe_topic <- substr(gsub("[^a-zA-Z0-9_-]", "_", topic), 1, 40)
  base_name <- sprintf("sinif%d_%s_%s_%s", grade, safe_topic, type_label, ts)
  full_html <- paste0('<!DOCTYPE html>\n<html lang="az"><head><meta charset="UTF-8">\n',
    '<meta name="viewport" content="width=device-width,initial-scale=1.0">\n',
    '<title>ARTI 2026 | Sinif ', grade, ' | ', topic, '</title>\n',
    css_text, '\n</head><body>\n<div class="ai-output">\n', html_body, '\n</div>\n',
    '<div class="arti-footer">Azerbaycan Respublikasi Elm ve Tehsil Nazirliyi — ARTI 2026 | ',
    format(Sys.time(), "%d.%m.%Y %H:%M"), ' | ', base_name, '</div>\n',
    '</body></html>')
  html_path <- file.path(folder, paste0(base_name, ".html"))
  writeLines(full_html, html_path, useBytes = TRUE)
  docx_path <- file.path(folder, paste0(base_name, ".docx"))
  docx_ok <- FALSE
  tryCatch({
    tmp <- tempfile(fileext = ".html")
    writeLines(full_html, tmp, useBytes = TRUE)
    pan <- Sys.which("pandoc")
    if (nchar(pan) == 0) { rsp <- Sys.getenv("RSTUDIO_PANDOC", ""); if (nchar(rsp) > 0) pan <- file.path(rsp, "pandoc") }
    if (nchar(pan) == 0) tryCatch({ pd <- rmarkdown::find_pandoc(); if (!is.null(pd$dir)) pan <- file.path(pd$dir, "pandoc") }, error = function(e) {})
    if (nchar(pan) > 0 && file.exists(pan)) {
      system2(pan, c("-f", "html", "-t", "docx", "-o", docx_path, tmp), stderr = FALSE, stdout = FALSE)
      if (file.exists(docx_path)) docx_ok <- TRUE
    }
    unlink(tmp)
  }, error = function(e) {})
  list(html = html_path, docx = if (docx_ok) docx_path else NA_character_)
}

# ══════════════════════════════════════════════
# STATS BAR
# ══════════════════════════════════════════════
make_stats_bar <- function(time_sec, input_tokens, output_tokens, saved_files) {
  total <- input_tokens + output_tokens
  cost <- round((input_tokens * 3 + output_tokens * 15) / 1e6, 4)
  html_name <- basename(saved_files$html)
  docx_part <- if (!is.na(saved_files$docx)) paste0(
    '<div style="background:rgba(255,255,255,0.08);padding:8px 16px;border-radius:8px;border-left:3px solid #a78bfa;">',
    'DOCX: ', basename(saved_files$docx), '</div>') else ""
  paste0(
    '<div style="background:linear-gradient(135deg,#0f172a,#1e293b);color:#e2e8f0;padding:20px 28px;border-radius:14px;margin-top:24px;box-shadow:0 4px 20px rgba(0,0,0,0.2);">',
    '<div style="font-size:1.3em;font-weight:700;margin-bottom:14px;color:#fbbf24;">Generasiya Statistikasi</div>',
    '<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:12px;margin-bottom:16px;">',
    '<div style="background:rgba(255,255,255,0.06);padding:12px 16px;border-radius:10px;border-left:3px solid #2E7D32;"><div style="font-size:0.85em;color:#94a3b8;">Vaxt</div><div style="font-size:1.4em;font-weight:700;color:#66BB6A;">', sprintf("%.1f", time_sec), ' san</div></div>',
    '<div style="background:rgba(255,255,255,0.06);padding:12px 16px;border-radius:10px;border-left:3px solid #22c55e;"><div style="font-size:0.85em;color:#94a3b8;">Giris token</div><div style="font-size:1.4em;font-weight:700;color:#4ade80;">', formatC(input_tokens, format = "d", big.mark = ","), '</div></div>',
    '<div style="background:rgba(255,255,255,0.06);padding:12px 16px;border-radius:10px;border-left:3px solid #f59e0b;"><div style="font-size:0.85em;color:#94a3b8;">Cixis token</div><div style="font-size:1.4em;font-weight:700;color:#fbbf24;">', formatC(output_tokens, format = "d", big.mark = ","), '</div></div>',
    '<div style="background:rgba(255,255,255,0.06);padding:12px 16px;border-radius:10px;border-left:3px solid #ef4444;"><div style="font-size:0.85em;color:#94a3b8;">Cemi token</div><div style="font-size:1.4em;font-weight:700;color:#f87171;">', formatC(total, format = "d", big.mark = ","), '</div></div>',
    '<div style="background:rgba(255,255,255,0.06);padding:12px 16px;border-radius:10px;border-left:3px solid #a78bfa;"><div style="font-size:0.85em;color:#94a3b8;">Texmini qiymet</div><div style="font-size:1.4em;font-weight:700;color:#c4b5fd;">$', sprintf("%.4f", cost), '</div></div>',
    '</div><div style="display:flex;flex-wrap:wrap;gap:12px;">',
    '<div style="background:rgba(255,255,255,0.08);padding:8px 16px;border-radius:8px;border-left:3px solid #2E7D32;">HTML: ', html_name, '</div>', docx_part, '</div></div>')
}

# ══════════════════════════════════════════════
# HTML5 CSS (Green + Orange Theme v2.0)
# ══════════════════════════════════════════════
HTML5_CSS <- '<style>
@import url("https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap");
.ai-output{font-family:"Noto Sans","Segoe UI",sans-serif;color:#212121;font-size:1.30em;line-height:1.90;max-width:1100px;margin:0 auto}
.test-header,.lesson-header{background:linear-gradient(135deg,#0a2810,#1B5E20,#2E7D32);color:#fff;padding:36px;border-radius:16px;margin-bottom:30px;box-shadow:0 8px 32px rgba(0,0,0,.18);position:relative;overflow:hidden}
.test-header::before,.lesson-header::before{content:"";position:absolute;top:-50%;right:-20%;width:400px;height:400px;background:radial-gradient(circle,rgba(76,175,80,.15) 0%,transparent 70%);border-radius:50%}
.test-header h1,.lesson-header h1{font-size:2.10em;font-weight:700;margin:0 0 20px;position:relative}
.meta-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:14px;position:relative}
.meta-item{background:rgba(255,255,255,.08);padding:12px 18px;border-radius:10px;border-left:3px solid #66BB6A;font-size:1.17em}
.meta-item .label{font-weight:700;color:#A5D6A7;margin-right:8px}
.objectives{margin-top:20px;background:rgba(255,255,255,.06);padding:18px 24px;border-radius:12px;border:1px solid rgba(255,255,255,.1)}
.objectives h3{margin:0 0 12px;color:#fbbf24;font-size:1.37em}
.objectives ul{margin:0;padding-left:24px}
.objectives li{margin-bottom:8px;color:#e2e8f0;font-size:1.17em;line-height:1.6}
.question-block{background:#fff;border-radius:16px;padding:28px;margin-bottom:22px;box-shadow:0 2px 16px rgba(0,0,0,.06);border-left:5px solid #94a3b8;transition:all .25s ease}
.question-block:hover{transform:translateY(-3px);box-shadow:0 8px 30px rgba(0,0,0,.12)}
.bloom-xatirlama{border-left-color:#92400e!important}.bloom-anlama{border-left-color:#15803d!important}
.bloom-tetbiqetme{border-left-color:#1d4ed8!important}.bloom-tehlil{border-left-color:#a16207!important}
.bloom-qiymetlendirme{border-left-color:#c2410c!important}.bloom-yaratma{border-left-color:#dc2626!important}
.question-header{display:flex;gap:12px;margin-bottom:16px;flex-wrap:wrap;align-items:center}
.bloom-badge,.dok-badge,.pisa-badge{display:inline-flex;align-items:center;padding:6px 16px;border-radius:20px;font-size:1.0em;font-weight:700}
.bloom-badge{background:#f0fdf4;color:#15803d;border:1px solid #86efac}
.dok-badge{background:#fef3c7;color:#92400e;border:1px solid #fde68a}
.pisa-badge{background:#eff6ff;color:#1d4ed8;border:1px solid #93c5fd}
.question-text{font-size:1.33em;margin-bottom:18px;line-height:1.95;color:#1e293b}
.options{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px}
.option{background:#f8fafc;padding:14px 20px;border-radius:10px;border:1px solid #e2e8f0;font-size:1.24em;transition:all .2s}
.option:hover{background:#f0fdf4;border-color:#86efac}
.answer-box{background:linear-gradient(135deg,#f0fdf4,#ecfdf5);border:1px solid #86efac;border-radius:12px;padding:20px;margin-top:12px}
.answer-box .answer{font-weight:700;color:#15803d;font-size:1.30em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid #bbf7d0}
.answer-box .solution{color:#374151;margin-bottom:8px;white-space:pre-wrap;font-size:1.20em;line-height:1.7}
.answer-box .textbook-ref{color:#1B5E20;font-weight:600;font-size:1.17em;padding:6px 0}
.answer-box .difficulty{color:#6b7280;font-size:1.10em;margin-top:6px}
.answer-box .rubric{margin-top:12px;padding:14px;background:#fffbeb;border-radius:10px;border:1px solid #fde68a;font-size:1.14em}
.phase{background:#fff;border-radius:16px;padding:28px;margin-bottom:20px;box-shadow:0 2px 16px rgba(0,0,0,.06);border-left:5px solid #2E7D32;transition:all .25s ease}
.phase:hover{box-shadow:0 6px 24px rgba(0,0,0,.10)}
.phase-1{border-left-color:#FF6F00}.phase-2{border-left-color:#1B5E20}.phase-3{border-left-color:#2E7D32}
.phase-4{border-left-color:#8b5cf6}.phase-5{border-left-color:#ef4444}
.phase-header{display:flex;align-items:center;gap:14px;margin-bottom:18px}
.phase-header h3{margin:0;font-size:1.43em;flex-grow:1;color:#1e293b}
.phase-icon{font-size:1.8em}
.phase-time{background:linear-gradient(135deg,#E8F5E9,#dcfce7);padding:6px 18px;border-radius:20px;font-size:1.07em;font-weight:700;color:#1B5E20;border:1px solid #86efac}
.teacher-activity,.student-activity,.phase .textbook-ref,.assessment{padding:12px 18px;margin-bottom:10px;border-radius:10px;font-size:1.20em;line-height:1.7}
.teacher-activity{background:linear-gradient(135deg,#E8F5E9,#e8f5e9);border-left:4px solid #1B5E20}
.student-activity{background:linear-gradient(135deg,#e8f5e9,#f1f8e9);border-left:4px solid #66BB6A}
.phase .textbook-ref{background:linear-gradient(135deg,#fefce8,#fffde4);border-left:4px solid #eab308;color:#854d0e;font-weight:600}
.assessment{background:linear-gradient(135deg,#faf5ff,#f8f0ff);border-left:4px solid #a855f7}
.differentiation{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin:14px 0}
.diff-level{padding:16px;border-radius:12px;font-size:1.14em}
.diff-base{background:#E8F5E9;border:1px solid #86efac}.diff-mid{background:#fffbeb;border:1px solid #fde68a}
.diff-high{background:#fef2f2;border:1px solid #fca5a5}
.stats-block,.analysis-block{background:linear-gradient(135deg,#0f172a,#1e293b);color:#e2e8f0;padding:28px;border-radius:16px;margin-top:28px;box-shadow:0 4px 20px rgba(0,0,0,.2)}
.stats-block h3,.analysis-block h3{margin:0 0 18px;color:#fbbf24;font-size:1.43em}
.stat-row{padding:10px 0;border-bottom:1px solid rgba(255,255,255,.08);font-size:1.17em;line-height:1.6}
.stat-row:last-child{border-bottom:none}
.beynelxalq-box{background:linear-gradient(135deg,#eff6ff,#e0f2fe);border:2px solid #3b82f6;border-radius:12px;padding:20px;margin:16px 0}
.beynelxalq-box h4{color:#1d4ed8;margin:0 0 12px}
.lang-section{margin-top:36px;padding:24px 0;border-top:4px solid #1B5E20}
.lang-section h2{background:linear-gradient(135deg,#1B5E20,#2E7D32);color:#fff;padding:16px 28px;border-radius:12px;font-size:1.5em;display:inline-block;margin:0 0 20px}
.arti-footer{text-align:center;margin-top:36px;padding:18px;color:#94a3b8;font-size:1.04em;border-top:2px solid #e2e8f0}
@media print{.answer-box,.question-block,.phase{page-break-inside:avoid}.ai-output{font-size:12pt}}
@media(max-width:768px){.options{grid-template-columns:1fr}.meta-grid{grid-template-columns:1fr}.differentiation{grid-template-columns:1fr}}
</style>'

# ═══════════════ DIL HELPER ═══════════════
build_lang_instruction <- function(langs) {
  if (is.null(langs) || length(langs) == 0) langs <- "az"
  LANG_NAMES <- c(az = "AZERBAYCAN DILI", ru = "RUS DILI", en = "INGILIS DILI")
  LANG_FLAGS <- c(az = "\U0001F1E6\U0001F1FF", ru = "\U0001F1F7\U0001F1FA", en = "\U0001F1EC\U0001F1E7")
  if (length(langs) == 1 && langs == "az") {
    return("\nDIL: Neticeni YALNIZ Azerbaycan dilinde yaz.\nDOLGUNLUQ: Cavabi musefesssel ve tam yaz.\n")
  }
  lang_list <- paste(sapply(seq_along(langs), function(i) {
    paste0(i, ". ", LANG_FLAGS[langs[i]], " ", LANG_NAMES[langs[i]])
  }), collapse = "\n")
  paste0('\nDILLER: Neticeni ', length(langs), ' DILDE ver:\n', lang_list, '\nHer dil ayrica bolme sheklinde.\n')
}

# ═══════════════ STANDART-MOVZU ELAQE HELPER ═══════════════

get_standard_details <- function(grade, standard_code) {
  stds <- ALL_STANDARDS[[as.character(grade)]]
  if (is.null(stds)) return(NULL)
  for (st in stds) {
    if (!is.null(st$kod) && grepl(standard_code, paste0(st$kod, " - ", st$metn), fixed = TRUE)) return(st)
    if (!is.null(st$kod) && st$kod == standard_code) return(st)
  }
  # partial match
  for (st in stds) {
    if (!is.null(st$metn) && grepl(substr(standard_code, 1, 15), st$metn, fixed = TRUE)) return(st)
  }
  NULL
}

get_topic_details <- function(grade, topic_name) {
  tops <- ALL_TOPICS[[as.character(grade)]]
  if (is.null(tops)) return(NULL)
  for (tp in tops) {
    if (!is.null(tp$ad) && tp$ad == topic_name) return(tp)
  }
  NULL
}

get_related_standards <- function(grade, topic_name) {
  tp <- get_topic_details(grade, topic_name)
  if (is.null(tp) || is.null(tp$standard_kodu)) return("")
  std_kod <- tp$standard_kodu
  stds <- ALL_STANDARDS[[as.character(grade)]]
  if (is.null(stds)) return("")
  # find the exact standard
  result <- character(0)
  for (st in stds) {
    if (!is.null(st$kod) && st$kod == std_kod) {
      result <- c(result, sprintf("ESAS STANDART: %s\nSahe: %s\nMetn: %s\nBlum seviyyesi: %s\nPISA seviyyesi: %s",
        st$kod, st$sahe %||% "-", st$metn %||% "-", st$bloom %||% "-", st$pisa %||% "-"))
    }
  }
  # find sibling standards (same prefix)
  parts <- strsplit(std_kod, "[.]")[[1]]
  if (length(parts) >= 2) {
    prefix <- paste(parts[1:2], collapse = ".")
    for (st in stds) {
      if (!is.null(st$kod) && grepl(paste0("^", gsub("([.])", "\\\\\\1", prefix)), st$kod) && st$kod != std_kod) {
        result <- c(result, sprintf("ELAQELI STANDART: %s — %s (Blum: %s)", st$kod, st$metn %||% "-", st$bloom %||% "-"))
      }
    }
  }
  paste(result, collapse = "\n\n")
}

# ═══════════════ PROMPT BUILDERS (v3.0 — DERIN STANDART-MOVZU ELAQESI) ═══════════════

build_lesson_prompt <- function(grade, topic, faaliyet, context, duration, langs = c("az"),
                                 standard = NULL, ders_tipi = "Yeni movzu",
                                 beynelxalq = c("pisa", "blooms"),
                                 diferensial = TRUE, rubrika = TRUE) {
  lang_inst <- build_lang_instruction(langs)
  m1 <- as.integer(duration * 0.12); m2 <- as.integer(duration * 0.35)
  m3 <- as.integer(duration * 0.25); m4 <- as.integer(duration * 0.10); m5 <- as.integer(duration * 0.08)

  # Standart-movzu elaqesi
  std_detail <- ""
  topic_detail <- ""
  related_stds <- ""
  tp_info <- get_topic_details(grade, topic)
  if (!is.null(tp_info)) {
    topic_detail <- sprintf("MOVZU DETALLARI:\n- Ad: %s\n- Sahe: %s\n- Standart kodu: %s\n- Saat: %s\n- Derslik sehifesi: %s",
      tp_info$ad %||% topic, tp_info$sahe %||% "-", tp_info$standard_kodu %||% "-",
      tp_info$saat %||% "2", tp_info$sehife %||% "-")
    related_stds <- get_related_standards(grade, topic)
  }
  if (!is.null(standard) && standard != "---" && nchar(standard) > 3) {
    st_parts <- strsplit(standard, " - ", fixed = TRUE)[[1]]
    st_obj <- get_standard_details(grade, st_parts[1])
    if (!is.null(st_obj)) {
      std_detail <- sprintf("SECILMISH STANDART DETALLARI:\n- Kod: %s\n- Sahe: %s\n- Metn: %s\n- Blum seviyyesi: %s\n- PISA seviyyesi: %s",
        st_obj$kod %||% "-", st_obj$sahe %||% "-", st_obj$metn %||% "-", st_obj$bloom %||% "-", st_obj$pisa %||% "-")
    }
  }

  beynelxalq_inst <- ""
  if (length(beynelxalq) > 0) {
    parts <- character(0)
    if ("pisa" %in% beynelxalq) parts <- c(parts, "- PISA oxu prosesi: melumat alma / serh / qiymetlendirme — hansi prosesi inkishaf etdirir\n- PISA seviyyesi: hedeg PISA seviyyesi (1-den 6-ya)")
    if ("pirls" %in% beynelxalq) parts <- c(parts, "- PIRLS kateqoriyasi: birbasa anlama / cixarim / serh / inteqrasiya")
    if ("blooms" %in% beynelxalq) parts <- c(parts, "- Blum taksonomiyasi: her meqsedin taksonomiya seviyyesini goster")
    if ("cefr" %in% beynelxalq) parts <- c(parts, "- CEFR dil seviyyesi: A1/A2/B1/B2/C1/C2")
    beynelxalq_inst <- paste0("\nBEYNELXALQ STANDART UYGUNLUGU (MUTLEQ daxil et):\n", paste(parts, collapse = "\n"), "\n")
  }

  paste0(
'Sen Azerbaycan Respublikasinin 1-11-ci sinif Azerbaycan dili ve edebiyyat fennini derinden bilen,
PISA/PIRLS/Blum/CEFR cercivelrini menitimseyen ekspert metodist AI-san.

SENIN ESASS VEZIFEN: Bu ders planinda KONKRET movzunun KONKRET standarta NECE nail oldugunu
muellime AYDIN ve PRAKTIK sekilde gostermekdir. Muellim bu plani oxuyanda:
1) Bu movzunun bu standartla elaqesini AYDIN gormeli
2) Her merhelenin standarta NECE xidmet etdiyini bashlsa dushmeli
3) Sagirdlerin standarti NECE mecimsemeleri ucun KONKRET fealiyyetler gormeli
4) Qiymetlendirmenin MEHZ bu standarti olcduyunu derk etmeli

', lang_inst, '

═══════════════════════════════════════
SINIF: ', grade, '-ci sinif
MOVZU: ', topic, '
DERS TIPI: ', ders_tipi, '
FEALIYYET NOVU: ', faaliyet, '
MUDDET: ', duration, ' deqiqe

', topic_detail, '

', std_detail, '

', if (nchar(related_stds) > 0) paste0("ELAQELI STANDARTLAR VE KONTEKST:\n", related_stds, "\n") else "", '
═══════════════════════════════════════

DERSLIKDEN KONTEKST (bu sehifelerdeki material ders planinin ESASINI teshkil etmelidir):
', context, '
', beynelxalq_inst, '

══════════════ VACIB TELEBLER ══════════════

1. STANDART-MOVZU ELAQESI (EN VACIB HISSE):
   Bu bolmede MUTLEQ izah et:
   - Bu movzu bu standarta NECE xidmet edir?
   - Standartda teleb olunan bacariq bu movzuda NECE formalashan?
   - Sagird bu dersin sonunda standartin hansi telabini ode bilecek?
   - KONKRET misal: "Bu standart sagirdden [X] teleb edir. Bu movzuda sagird [Y] ederek
     bu bacarigi inkishaf etdirir. Meselen, [Z] tapshiriginda sagird mehz bu standarti tetbiq edir."

2. TELIM NETICELERI (Blum Taksonomiyasina gore — OLCULE BILEN feillerle):
   Dersin sonunda sagirdler:
   - Bilik: [KONKRET — meselen: "Ismin 6 halini sadalayir" — yox ki "bilir"]
   - Anlama: [KONKRET — meselen: "Yiyeik halinin funksiyasini oz sozleri ile izah edir"]
   - Tetbiq: [KONKRET — meselen: "Verilmish metinde isimlerin hallarini mueiyyen edir"]
   - Tehlil: [KONKRET — meselen: "Iki metni muqayise ederek hal istifadesindeki ferqleri tehlil edir"]
   - Qiymetlendirme: [eger uygunsa]
   - Yaratma: [eger uygunsa]

3. RESURSLAR VE HAZIRLIQ:
   - Derslik: KONKRET sehife nomreleri
   - Levhe/proyektor hazrligi: ne yazilacaq/gosterilecek
   - Elave material: ishci vereqleri, kartlar, audio/video

4. DERSIN GEDISHATI (her merhelede standartla elaqe gosterilmelidir):

   I. MOTIVASIYA VE FEALLASHDIRMA (', m1, ' deq)
   - Evvelki biliklerin aktivleshdirmesi — KONKRET suallar yaz (minimum 3 sual)
   - Bu merhelenin standarla elaqesi: sagirdin movcud biliyini yoxlayir
   - Ferziiyye: sagirdlerden ne gozlenilir?

   II. YENI MATERIALIN IZAHI (', m2, ' deq)
   - Muellim izahi: ADDIM-ADDIM ne edir, ne danishir, ne gosterir
   - Derslik metni ile ish: HANSI sehife, HANSI tapshiriq, NECE istifade olunur
   - Numune tehlil: KONKRET misal getir (meselen, cemleni tehlil et, sozun qurlushunugoster)
   - STANDARTLA ELAQE: Bu izahin standartin hansi telabine cavab verdiyini goster

   DIFERENSIAL TAPSHIRIQLAR (3 SEVIYYE):
   | Seviyye | KONKRET Tapshiriq | Standarta Xidmeti | Blum Seviyyesi |
   |---------|------------------|-------------------|----------------|
   | Zeif sagird | [KONKRET ve SADE — meselen: "Verilmish 5 cumlede isimlerin altini ciz"] | Bilik/Anlama |  xatirlama |
   | Orta sagird | [MUSTEQIL — meselen: "Metnden isimleri tap ve hallarini mueiyyen et"] | Tetbiq | tetbiq |
   | Guclu sagird | [YARADICI — meselen: "Butun hallarda istifade olunan 6 cumle yaz"] | Yaratma | yaratma |

   III. MESHQ VE TETBIQ (', m3, ' deq)
   - FEAL TELIM USULU: Konkret usul sec (Dushun-Cutles-Paylas / Qalereya gezi / Beyin Hucumu / Rol oyunu)
     ve bu usulun NECE tetbiq olundugunu addim-addim izah et
   - Qrup/cutluk tapshirigi: KONKRET mezmun yaz — umumi "tapshiriq verin" yox!
   - STANDARTLA ELAQE: Bu meshqin standarti NECE mohkemlendirdiyini goster

   IV. FORMATIV QIYMETLENDIRME (', m4, ' deq)
   - Yoxlama usulu: KONKRET SEC ve MEZMUNUNU yaz
     (Meselen: "Cixis bileti: Asagidaki 3 sualdan 2-sine cavab ver: 1)... 2)... 3)...")
   - Ugur meyarlari: Sagird NELERI ede bilse, standarta nail olmus sayilir?
   - STANDARTLA ELAQE: Bu qiymetlendirme MEHZ bu standarti olcur

   V. UMUMILESHDIRME VE EV ISHI (', m5, ' deq)
   - Dersin xulasesi: Esass 3 netice
   - Ev tapshirigi (2 seviyye):
     * Butun sagirdler ucun: [KONKRET]
     * Guclu sagirdler ucun: [ELAVE YARADICI]
   - Novbeti ders haqqinda qisa melumat

5. QIYMETLENDIRME RUBRIKASI:
   | Meyar | 4 (ela) | 3 (yaxshi) | 2 (kafi) | 1 (qeyri-kafi) |
   |-------|---------|-----------|----------|----------------|
   | Standarta uygunluq | Standartin butun telablerini edir | Esass hisseisni edir | Qismen edir | Ede bilmir |
   | Anlama | Movzunu derinden izah edir | Izah edir | Qismen izah edir | Izah ede bilmir |
   | Tetbiq | Musteqil ve yaradici tetbiq edir | Musteqil tetbiq edir | Komekle tetbiq edir | Tetbiq ede bilmir |
   | Nitq/Yazi | Seliss, zening dilde ifade edir | Duzgun ifade edir | Bezi sehvlerle | Coxlu sehvle |

6. STANDARTA NAIL OLMA XULASESI (DERSIN SONUNDA):
   Bu blokda muellim ucun yaz:
   - "Bu ders [STANDART KODU] standartina bu yollarla nail olur: ..."
   - "Sagird bu dersin sonunda [KONKRET bacariq] ede bilir ki, bu da standartin [KONKRET hissesine] cavab verir"
   - "Novbeti dersde bu standarti [NECE] davam etdirmek olar"

OZUNUQIYMETLENDIRME (sagird ucun):
Dersn sonunda sagird ozune sual verir:
- Bu gun [KONKRET bacariq] oyrendim: beli / xeyr
- [KONKRET tapshiriq] hel ede bilerem: beli / xeyr
- Hele anlamadigim var: ___________

HTML FORMATI (CIDDI RIAYAT):
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Ders Plani: Azerbaycan Dili</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Movzu:</span> ', topic, '</div>
    <div class="meta-item"><span class="label">Standart:</span> [standart kodu ve metni]</div>
    <div class="meta-item"><span class="label">Muddet:</span> ', duration, ' deqiqe</div>
    <div class="meta-item"><span class="label">Fealiyyet:</span> ', faaliyet, '</div>
    <div class="meta-item"><span class="label">Ders tipi:</span> ', ders_tipi, '</div>
  </div>
  <div class="objectives">
    <h3>Telim Neticeleri (Blum Taksonomiyasi)</h3>
    <ul>
      <li><strong>Bilik:</strong> Sagird [KONKRET] bilecek</li>
      <li><strong>Bacariq:</strong> Sagird [KONKRET] tetbiq ede bilecek</li>
      <li><strong>Munasibet:</strong> Sagird [KONKRET] deyerlendire bilecek</li>
    </ul>
  </div>
</div>

STANDART-MOVZU ELAQESINI <div class="beynelxalq-box"> icinde goster — bu AYRI ve BOYUK bolme olmalidir.
Muellim bu bolmeni oxuyanda mehz bu movzunun bu standarta NECE nail oldugunu AYDIN gormelidir.

HER MERHELE bele olmalidir:
<div class="phase phase-[N]">
  <div class="phase-header">
    <span class="phase-icon">[uygun emoji]</span>
    <h3>MERHELE [N]: [AD]</h3>
    <span class="phase-time">[X] deq</span>
  </div>
  <div class="teacher-activity"><strong>Muellim fealiyyeti:</strong> [DETALLI — ne deyir, ne gosterir, nece izah edir]</div>
  <div class="student-activity"><strong>Sagird fealiyyeti:</strong> [DETALLI — ne edir, nece cavab verir, nece ishleyir]</div>
  <div class="textbook-ref"><strong>Derslik istinadi:</strong> seh. [XX] — [NECE istifade olunur]</div>
  <div class="assessment"><strong>Standarta xidmet:</strong> Bu merhele [STANDART] standartinin [HANSI] hissesini inkishaf etdirir</div>
</div>

Diferensial tapshiriqlari <div class="differentiation"> icinde goster:
<div class="differentiation">
  <div class="diff-level diff-base"><strong>Zeif sagird:</strong> [KONKRET tapshiriq]<br><em>Standarta xidmet: [izah]</em></div>
  <div class="diff-level diff-mid"><strong>Orta sagird:</strong> [KONKRET tapshiriq]<br><em>Standarta xidmet: [izah]</em></div>
  <div class="diff-level diff-high"><strong>Guclu sagird:</strong> [KONKRET tapshiriq]<br><em>Standarta xidmet: [izah]</em></div>
</div>

Sonda MUTLEQ iki analiz bloku yaz:
1. <div class="stats-block"> — Blum/PISA/PIRLS paylamasi statistikasi
2. <div class="beynelxalq-box"> — STANDARTA NAIL OLMA XULASESI: Bu ders bu standarta NECE nail oldu,
   sagird ne qazandi, novbeti adimlar ne olmalidir. Muellim bunu oxuyanda bu dersin DEYERINI gormeli.')
}

build_test_prompt <- function(grade, topic, test_type, context, count, difficulty, langs = c("az"),
                               standard = NULL, metn_novu = "Bedii metn", rubrika_elave = TRUE) {
  lang_inst <- build_lang_instruction(langs)

  # Standart-movzu elaqesi
  std_detail <- ""
  topic_detail <- ""
  related_stds <- ""
  tp_info <- get_topic_details(grade, topic)
  if (!is.null(tp_info)) {
    topic_detail <- sprintf("MOVZU DETALLARI:\n- Ad: %s\n- Sahe: %s\n- Standart kodu: %s\n- Derslik sehifesi: %s",
      tp_info$ad %||% topic, tp_info$sahe %||% "-", tp_info$standard_kodu %||% "-", tp_info$sehife %||% "-")
    related_stds <- get_related_standards(grade, topic)
  }
  if (!is.null(standard) && standard != "---" && nchar(standard) > 3) {
    st_parts <- strsplit(standard, " - ", fixed = TRUE)[[1]]
    st_obj <- get_standard_details(grade, st_parts[1])
    if (!is.null(st_obj)) {
      std_detail <- sprintf("SECILMISH STANDART DETALLARI:\n- Kod: %s\n- Sahe: %s\n- Metn: %s\n- Blum seviyyesi: %s\n- PISA seviyyesi: %s",
        st_obj$kod %||% "-", st_obj$sahe %||% "-", st_obj$metn %||% "-", st_obj$bloom %||% "-", st_obj$pisa %||% "-")
    }
  }

  paste0(
'Sen Azerbaycan dili ve edebiyyat fenninden PISA formatinda test tapshiriqlari yaradan ekspert AI-san.
Senin esas vezifen: her sualin KONKRET standarta ve movzuya NECE xidmet etdiyini gostermekdir.
Muellim bu testi oxuyanda her sualin NIYE bu formada oldugunu ve HANSI bacarigi olcduyunu AYDIN gormelidir.

', lang_inst, '

═══════════════════════════════════════
SINIF: ', grade, '-ci sinif
MOVZU: ', topic, '
TEST TIPI: ', test_type, '
TAPSHIRIQ SAYI: ', count, '
CETINLIK: ', difficulty, '
METN NOVU: ', metn_novu, '

', topic_detail, '

', std_detail, '

', if (nchar(related_stds) > 0) paste0("ELAQELI STANDARTLAR:\n", related_stds, "\n") else "", '
═══════════════════════════════════════

DERSLIKDEN KONTEKST (suallar bu materiala esaslanmalidir):
', context, '

══════════════ VACIB TELEBLER ══════════════

1. STANDART-SUAL ELAQESI:
   Her sualin yaninda goster:
   - Bu sual HANSI standarti olcur (standart kodu ve metni)
   - Bu sual standartin HANSI telabine cavab verir
   - Sagird bu suala DUZGUN cavab verese, bu onun HANSI bacarigini subut edir
   - Meselen: "Bu sual ', if (!is.null(standard) && standard != "---") standard else "[standart kodu]", ' standartini olcur.
     Sagird bu suala cavab vermekle [KONKRET bacariq] numayish etdirir."

2. OXUMA METNI (I HISSE):
   - ', metn_novu, ' novunde, ', grade, '-ci sinif seviyyesine uygun, 200-400 soz
   - Metn derslik materialina UYGUN olmalidir — umumi internet metnleri yox!
   - Metn icinde hem aciq melumat, hem gizli mena, hem muellif movqeyi olmalidir
   - Metni MOVZU ile elaqeli yaz — meselen, eger movzu "Ismin hallari"-dirsa,
     metn bu qrammatik quruluslarin zengin istifadesini numayish etdirmelidir

3. COXSECIMLI SUALLAR (II HISSE — her sual 1 bal):
   Her sual ucun MUTLEQ goster:
   - PISA seviyyesi (1-6) ve bu seviyyenin NECE oldugunu 1 cumlede izah et
   - Blum taksonomiya seviyyesi
   - Standart kodu ve standartin HANSI telabini olcur
   - 4 variant (A, B, C, D) — distraktorlar REALIST olmalidir (sagirdlerin tipik sehvlerine esaslansn)
   - Duzgun cavab + ETRAFLY izah (sadece "duzgun cavabdir" yox!)
   - Her distraktorun NIYE sehv oldugunu izah et
   - Muellim ucun qeyd: Bu sualda sagirdlerin coxu HANSI sehvi edir ve NIYE

4. QISA CAVABLI SUALLAR (III HISSE — her sual 2 bal):
   - Blum taksonomiya seviyyesi + standart kodu
   - Gozlenilen cavab — KONKRET ve ETRAFLY
   - Qiymetlendirme meyari: 2 bal / 1 bal / 0 bal ucun AYRI-AYRI ne yazilmalidir
   - Standarta xidmet izahi

5. ACIQ SUALLAR (IV HISSE — her sual 4 bal):
   - PISA Sev.4-6 — kritik dushunce, qiymetlendirme, yaratma
   - Sagirdden ESASLANDIRMA teleb et
   - QIYMETLENDIRME RUBRIKASI (her aciq sual ucun):
     | Bal | Meyar | Numune cavab |
     |-----|-------|-------------|
     | 4 | Esaslandirilmish, numuneli, strukturlu | [KONKRET numune] |
     | 3 | Duzgun, lakin az esaslandirilmish | [KONKRET numune] |
     | 2 | Qismen duzgun | [KONKRET numune] |
     | 1 | Cuzi anlama | [KONKRET numune] |
     | 0 | Cavab yoxdur / tamamile yanlish | - |
   - Standarta xidmet: Bu sual standartin HANSI en yuksek telabini olcur

6. SUAL PAYLANMASI:
   - Suallarin 30%-i Sev.1-2 (bilik, anlama — asan)
   - Suallarin 50%-i Sev.3-4 (tetbiq, tehlil — orta)
   - Suallarin 20%-i Sev.5-6 (qiymetlendirme, yaratma — cetin)

7. TEST SONU ANALIZ BLOKU (muellim ucun):
   - Blum paylamasi cedveli: nece sual hansi seviyye
   - PISA paylamasi: nece sual hansi PISA seviyyesi
   - Standart uygunlugu: bu test HANSI standartlari olcur, NECE olcur
   - Muellim ucun tovsiyyeler: testin neticelerine gore NECE fealiyyet qurmaq olar
   - Zeif neticelerde: sagird bu suali sehv cavablandirirsa, NECE komek etmek olar

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="test-header">
  <h1>Azerbaycan Dili Test Tapshiriqlari</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Movzu:</span> ', topic, '</div>
    <div class="meta-item"><span class="label">Standart:</span> [standart kodu ve metni]</div>
    <div class="meta-item"><span class="label">Test tipi:</span> ', test_type, '</div>
    <div class="meta-item"><span class="label">Cetinlik:</span> ', difficulty, '</div>
    <div class="meta-item"><span class="label">Metn novu:</span> ', metn_novu, '</div>
    <div class="meta-item"><span class="label">Sual sayi:</span> ', count, '</div>
  </div>
</div>

HER TAPSHIRIQ bele olmalidir:
<div class="question-block bloom-[seviyye]">
  <div class="question-header">
    <span class="pisa-badge">PISA Sev.[N]: [seviyye adi]</span>
    <span class="bloom-badge">Blum: [SEVIYYE]</span>
    <span class="dok-badge">Standart: [KOD]</span>
  </div>
  <div class="question-text"><strong>Tapshiriq [N].</strong> [SUAL METNI]</div>
  [variantlar — eger coxsecimlidirse]
  <div class="answer-box">
    <div class="answer">Duzgun cavab: [CAVAB]</div>
    <div class="solution"><strong>Izah:</strong> [ETRAFLY — niye duzgun, distraktorlar niye sehv]</div>
    <div class="textbook-ref"><strong>Standarta xidmet:</strong> Bu sual [STANDART KODU] standartini olcur.
    Sagird bu suala duzgun cavab vermekle [KONKRET bacariq] numayish etdirir.</div>
  </div>
</div>

Sonda MUTLEQ iki analiz bloku:
1. <div class="stats-block"> — Blum/PISA paylamasi, cetinlik balansi statistikasi
2. <div class="beynelxalq-box"> — STANDART UYGUNLUGU XULASESI: Bu test HANSI standartlari olcur,
   NECE olcur, zeif neticelerde muellim NE etmelidir. Muellim bunu oxuyanda testin
   standarti NECE olcduyunu ve neticelere gore NECE fealiyyet qurmalasini AYDIN gormelidir.')
}

build_monthly_prompt <- function(grade, month, weekly_hours, langs = c("az"),
                                  pisa_uygun = TRUE, qiymet_noqte = TRUE) {
  lang_inst <- build_lang_instruction(langs)
  pisa_inst <- ""
  if (pisa_uygun) {
    pisa_inst <- '
PISA/PIRLS UYGUNLUGU:
Her hefte ucun goster:
- Hansi PISA oxu prosesini inkishaf etdirir
- PIRLS kateqoriyasi
- Blum taksonomiya seviyyesi'
  }
  qiymet_inst <- ""
  if (qiymet_noqte) {
    qiymet_inst <- '
QIYMETLENDIRME NOQTELERI:
- Her 2 hefteden bir formativ qiymetlendirme
- Ayin sonunda summativ qiymetlendirme
- Qiymetlendirme novleri: test, insha, shifahi, layihe, portfel'
  }

  paste0(
'Sen Azerbaycan dili ve edebiyyat fenninden ayliq plan hazirlayan ekspert metodist AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
AY: ', month, '
HEFTELIK SAAT: ', weekly_hours, '
', pisa_inst, '
', qiymet_inst, '

Ayliq plani HTML cedvel formatinda hazirla:
- Her hefte ucun: movzu, saat, fealiyyet novu, standart, PISA/Blum, qiymetlendirme, resurs
- Oxu, yazi, qrammatika, danishiq, edebiyyat saheleri arasinda balans
- Aylik yekun qiymetlendirme plani

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Ayliq Plan: Azerbaycan Dili</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Ay:</span> ', month, '</div>
    <div class="meta-item"><span class="label">Heftelik saat:</span> ', weekly_hours, '</div>
  </div>
</div>

Plan cedveli:
<table style="width:100%;border-collapse:collapse;margin:20px 0;font-size:1.1em;">
<thead><tr style="background:#1B5E20;color:#fff;">
<th style="padding:12px;border:1px solid #ddd;">Hefte</th>
<th style="padding:12px;border:1px solid #ddd;">Movzu</th>
<th style="padding:12px;border:1px solid #ddd;">Saat</th>
<th style="padding:12px;border:1px solid #ddd;">Fealiyyet</th>
<th style="padding:12px;border:1px solid #ddd;">Standart</th>
<th style="padding:12px;border:1px solid #ddd;">PISA/Blum</th>
<th style="padding:12px;border:1px solid #ddd;">Qiymetlendirme</th>
<th style="padding:12px;border:1px solid #ddd;">Derslik</th>
</tr></thead>
<tbody>[CEDVEL SATRLARI]</tbody>
</table>

Sonda analiz bloku elave et.')
}

build_analysis_prompt <- function(grade, muellif, eser, analysis_type, langs = c("az"),
                                   rubrika_edebi = TRUE, muqayise = FALSE) {
  lang_inst <- build_lang_instruction(langs)
  author_work <- paste0(muellif, " - ", eser)

  muqayise_inst <- if (muqayise) "- Eyni movzuda bashqa eserlerle muqayise\n- Eyni dovrun diger muellifleri ile paraleller\n- Dunya edebiyyatinda analoqlar" else "- Qisa muqayiseli qeydler"

  rubrika_inst <- ""
  if (rubrika_edebi) {
    rubrika_inst <- '
10. QIYMETLENDIRME RUBRIKASI — INSHA / SHIFAHI TEHLIL
| Meyar | 4 — Ela | 3 — Yaxshi | 2 — Kafi | 1 — Qeyri-kafi |
|-------|---------|-----------|----------|----------------|
| Movzu uygunlugu | Tam uygun, derin | Uygun | Qismen | Uygun deyil |
| Idealarin inkishafi | Etrafli, numuneli | Kifayet qeder | Az inkishaf | Inkishafsiz |
| Bedii tesvir | Zengin, yerli | Var, az | Cuzi | Yoxdur |
| Dil ve uslub | Zengin, selis | Duzgun | Bezi sehvler | Cox sehv |
| Struktur | Mukemmel | Yaxshi | Var | Yoxdur |'
  }

  paste0(
'Sen Azerbaycan edebiyyatini derinden bilen ekspert edebiyyatshinas AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
MUELLIF: ', muellif, '
ESER: ', eser, '
ANALIZ NOVU: ', analysis_type, '

EDEBI METNIN TEHLILI — 10 ELEMENT:

1. BIBLIOQRAFIK MELUMAT
- Muellif haqqinda: heyati, dovru, esas eserleri (3-4 cumle)
- Eserin yazilma tarixi ve tarixi kontekst
- Janr ve forma xususiyyetleri

2. SUJETIN STRUKTURU (cedvel sheklinde):
| Kompozisiya elementi | Mezmun | Ehemiyyeti |
|---------------------|--------|------------|
| Ekspozisiya | | |
| Duyun | | |
| Inkishaf | | |
| Kulminasiya | | |
| Cozum | | |

3. OBRAZ SISTEMI
- Bash qehremanlar: ad, xarakter cizgileri, inkishaf, simvolik mena
- Ikinci dereceli obrazlar: rolu, esas qehremanla munasibeti

4. MOVZU VE IDEYA
- Esas movzu, alt movzular
- Esas ideya
- Aktualliq

5. BEDII TESVIR VASITELERI (cedvel):
| Vasite | Metn numunesi | Funksiyasi |
|--------|--------------|------------|
| Metafora | "..." | |
| Epitet | "..." | |
| Benzetme | "..." | |
| Tezad | "..." | |
| Hiperbola | "..." | |

6. DIL VE USLUB
- Leksik xususiyyetler
- Sintaktik xususiyyetler
- Ton: lirik/dramatik/ironik/elegik

7. MUQAYISELI TEHLIL
', muqayise_inst, '

8. SAGIRD TENQIDI DUSHUNCE SUALLARI
Mezmun anlama (PIRLS): 2 sual
Sherhetme (PIRLS — cixarim): 2 sual
Qiymetlendirme (PISA Sev.4-5): 2 sual
Yaratma (Blum — yuksek seviyye): 2 sual

9. MUELLIM UCUN METODIK QEYDLER
- Dersde istifade ucun 3 feal telim usulu
- Fenlerarasi elaqe
- Yaradici tapshiriq
', rubrika_inst, '

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Edebi Metn Analizi</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Muellif:</span> ', muellif, '</div>
    <div class="meta-item"><span class="label">Eser:</span> ', eser, '</div>
    <div class="meta-item"><span class="label">Analiz novu:</span> ', analysis_type, '</div>
  </div>
</div>

Tehlili bolmeler sheklinde ver, her bolme <div class="phase"> icinde.
HER element etrafli ve konkret olmalidir — sethi tehlil QEBUL EDILMIR.')
}

build_student_prompt <- function(grade, weaknesses, langs = c("az")) {
  lang_inst <- build_lang_instruction(langs)
  weak_text <- paste(weaknesses, collapse = ", ")
  paste0(
'Sen sagirdlerin Azerbaycan dili ve edebiyyat fennindeki inkishafini tehlil eden psixoloq-pedaqoq AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
ZEIF TEREFLER: ', weak_text, '

ASAGIDAKILARI HAZIRLA:
1. TEHLIL: Her zeif saheni ayrica tehlil et, sebeblerini goster
2. PISA SEVIYYESI: Sagirdin texmini PISA oxu seviyyesini mueyyen et (1a-6)
3. CEFR PROFILI: Sagirdin texmini CEFR dil seviyyesini goster (A1-C2)
4. FERDI PLAN: 4 heftelik inkishaf plani (her hefte ucun konkret tapshiriqlar)
5. VALIDEYN MEKTUBU: Valideyne gonderilecek melumat mektubu
6. TOVSIYYELER: Muellim ve valideyn ucun praktik tovsiyyeler
7. RESURSLAR: Elave oxu materiallari ve menbeler

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Sagird Inkishaf Tehlili</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Zeif saheler:</span> ', weak_text, '</div>
  </div>
</div>

PISA seviyyesini ve CEFR profilini <div class="beynelxalq-box"> icinde goster.
Her bolmeni <div class="phase"> icinde ver.
Valideyn mektubunu ayrica blokda goster.')
}

build_assistant_prompt <- function(question) {
  paste0(
'Azerbaycan dili ve edebiyyat muellimi kimi asagidaki suala tam ve professional cavab ver.
Cavabi HTML formatinda ver (Markdown istifade etme).
Derslik istinadlari ve praktik numuneler elave et.
PISA/Blum/kurikulum istinadlari elave et.

SUAL: ', question, '

Cavabi <div class="phase"> bloklari icinde strukturlashdir.
Konkret numuneler, metn parcalari ve tapshiriq numuneleri elave et.')
}

build_metodiki_prompt <- function(question) {
  paste0(
'Sen Azerbaycan dili ve edebiyyat tedrisinin metodika mutexessisisen.
Asagidaki movzuda etrafli METODIKI TOVSIYE hazirla:

MOVZU: ', question, '

DAXIL ET:
1. Feal telim usullari (minimum 5)
2. Her usul ucun: addim-addim tetbiq plani
3. Formativ qiymetlendirme strategiyalari
4. Diferensial telim yanasmasi
5. Resurslar ve materiallar

PISA/PIRLS best practices istinad et.
Neticeni HTML formatinda ver. Markdown istifade etme.
Her bolmeni <div class="phase"> icinde ver.')
}

build_beynelxalq_prompt <- function(question) {
  paste0(
'Sen beynelxalq tehsil sistemi mutexessisisen.
Asagidaki movzuda PISA olkelerinin tecrubelerini paylash:

MOVZU: ', question, '

DAXIL ET:
1. Finlandiya, Sinqapur, Yaponiya, Estoniya, Kanada tecrubesi
2. PISA lideri olkelerin bu sahede ne etdikleri
3. Azerbaycan ucun tetbiq olunan bilen konkret tovsiyyeler
4. Muqayiseli cedvel: olke-yanashma-netice
5. Praktik addimlar muellim ucun

Neticeni HTML formatinda ver. Markdown istifade etme.
Her bolmeni <div class="phase"> icinde ver.')
}

# ═══════════════ HELPER ═══════════════
plotly_or_msg <- function(outputId, height = "300px") {
  if (PLOTLY_OK) plotlyOutput(outputId, height = height) else tags$p(style = "color:#94a3b8;padding:40px;text-align:center;", "plotly lazimdir")
}

# ═══════════════════════════════════════════════
# UI (v2.0)
# ═══════════════════════════════════════════════
ui <- dashboardPage(skin = "green",
  dashboardHeader(title = span(icon("book"), " Az Dili Muellim Agent v2.0"), titleWidth = 360),
  dashboardSidebar(width = 280, sidebarMenu(id = "tabs",
    menuItem("Ana Sehife", tabName = "home", icon = icon("home")),
    menuItem("Ders Plani", tabName = "lesson", icon = icon("book")),
    menuItem("Test (PISA)", tabName = "test", icon = icon("clipboard-check")),
    menuItem("Ayliq Plan", tabName = "monthly", icon = icon("calendar")),
    menuItem("Edebi Tehlil", tabName = "analysis", icon = icon("feather-alt")),
    menuItem("Sagird Analizi", tabName = "student", icon = icon("user-graduate")),
    menuItem("Muellim Komekchisi", tabName = "assistant", icon = icon("comments")),
    menuItem("Arxiv", tabName = "archive", icon = icon("archive")),
    hr(),
    div(style = "padding:10px;",
      passwordInput("api_key_input", label = tags$span(icon("key"), " API Key"),
                    value = Sys.getenv("ANTHROPIC_API_KEY", ""),
                    placeholder = "sk-ant-..."),
      tags$p(style = "color:#b8c7ce;font-size:10px;margin-top:5px;", "Anthropic API key daxil edin")
    ),
    hr(),
    div(p(style = "padding:10px;color:#b8c7ce;font-size:11px;", "ARTI 2026 (c) Tariyel Talibov\nPISA/PIRLS/Blum/CEFR"))
  )),
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$style(HTML(paste0("
        body,.content-wrapper,.box-body,.box-header,.sidebar-menu li a{font-size:115%!important}
        .form-group label{font-size:1.05em!important;font-weight:600!important}
        .form-control,.selectize-input,.selectize-dropdown{font-size:1.02em!important}
        .content-wrapper{background:#f4f6f9}.box{border-top:3px solid ", RENGLER$ikinci, "}
        .skin-green .main-header .navbar{background:", RENGLER$ikinci, "}
        .skin-green .main-header .logo{background:", RENGLER$esas, ";font-size:16px!important}
        .skin-green .main-header .logo:hover{background:", RENGLER$esas, "}
        .btn-generate{font-size:1.25em!important;padding:14px 28px!important;font-weight:700!important;border-radius:10px!important}
        .btn-az-green{background:", RENGLER$ikinci, "!important;color:#fff!important;border-color:", RENGLER$esas, "!important}
        .btn-az-green:hover{background:", RENGLER$esas, "!important}
        .btn-az-orange{background:", RENGLER$vurgu, "!important;color:#fff!important;border-color:#e65100!important}
        .btn-az-orange:hover{background:#e65100!important}
        .ai-loading{text-align:center;padding:60px}
        .selectize-dropdown{max-height:420px!important}.selectize-dropdown-content{max-height:400px!important}
        .token-display{display:inline-flex;align-items:center;gap:8px;font-size:1.15em;font-weight:700;padding:8px 16px;border-radius:10px;margin-top:25px}
        .token-waiting{background:#fef3c7;color:#92400e;border:1px solid #fde68a}
        .token-done{background:#dcfce7;color:#166534;border:1px solid #86efac}
        .token-error{background:#fef2f2;color:#991b1b;border:1px solid #fca5a5}
        .live-timer-panel{background:linear-gradient(135deg,#0f172a,#1e293b);border:2px solid ", RENGLER$ikinci, ";border-radius:16px;padding:28px 36px;margin:20px 0;text-align:center;box-shadow:0 4px 24px rgba(46,125,50,.15)}
        .live-timer-panel .t-status{font-size:1.15em;color:#94a3b8;margin-bottom:10px}
        .live-timer-panel .t-clock{font-family:'JetBrains Mono',monospace;font-size:3.2em;font-weight:700;color:#66BB6A;letter-spacing:.06em;margin:8px 0}
        .live-timer-panel .t-start{font-size:.95em;color:#64748b;margin-bottom:14px}
        .live-timer-panel .t-details{display:flex;justify-content:center;gap:16px;flex-wrap:wrap}
        .live-timer-panel .t-item{background:rgba(255,255,255,.06);padding:8px 18px;border-radius:10px;font-size:.95em;color:#cbd5e1}
        .pdot{display:inline-block;width:10px;height:10px;background:#22c55e;border-radius:50%;margin-right:8px;animation:pdot 1s infinite}
        @keyframes pdot{0%,100%{opacity:1}50%{opacity:.3}}
        .t-done{border-color:#22c55e!important}.t-err{border-color:#ef4444!important}
      "))),
      tags$script(HTML('
        var _atI=null,_atS=null;
        Shiny.addCustomMessageHandler("ai_timer_start",function(m){
          if(_atI)clearInterval(_atI);_atS=new Date();
          var e=document.getElementById(m.target);if(!e)return;
          var st=_atS.toLocaleTimeString("az-AZ",{hour:"2-digit",minute:"2-digit",second:"2-digit"});
          e.innerHTML="<div class=\\"live-timer-panel\\"><div class=\\"t-status\\"><span class=\\"pdot\\"></span>"+m.status+"</div><div class=\\"t-clock\\" id=\\"_clk_"+m.target+"\\">00:00</div><div class=\\"t-start\\">Baslama: "+st+"</div><div class=\\"t-details\\"><div class=\\"t-item\\">"+m.info1+"</div><div class=\\"t-item\\">"+m.info2+"</div><div class=\\"t-item\\">Claude AI</div></div></div>";
          _atI=setInterval(function(){var d=Math.floor((new Date()-_atS)/1000),mm=Math.floor(d/60),ss=d%60;var t=(mm<10?"0":"")+mm+":"+(ss<10?"0":"")+ss;var c=document.getElementById("_clk_"+m.target);if(c)c.textContent=t},250)
        });
        Shiny.addCustomMessageHandler("ai_timer_stop",function(m){
          if(_atI){clearInterval(_atI);_atI=null}var e=document.getElementById(m.target);if(!e)return;
          var ok=m.ok,cl=ok?"t-done":"t-err",co=ok?"#22c55e":"#ef4444",lb=ok?"Tamamlandi!":"Xeta bas verdi";
          e.innerHTML="<div class=\\"live-timer-panel "+cl+"\\"><div class=\\"t-status\\" style=\\"color:"+co+"\\">"+lb+"</div><div class=\\"t-clock\\" style=\\"color:"+co+"\\">"+m.elapsed+" san</div><div class=\\"t-details\\"><div class=\\"t-item\\">Giris: "+m.inp+"</div><div class=\\"t-item\\">Cixis: "+m.out+"</div><div class=\\"t-item\\">"+m.cost+"</div></div></div>"
        });
      '))
    ),
    tabItems(
      # === HOME ===
      tabItem(tabName = "home",
        fluidRow(
          valueBoxOutput("home_esas_std_box", width = 2),
          valueBoxOutput("home_alt_std_box", width = 2),
          valueBoxOutput("home_topic_box", width = 2),
          valueBoxOutput("home_plan_box", width = 2),
          valueBoxOutput("home_test_box", width = 2),
          valueBoxOutput("home_chunk_box", width = 2)
        ),
        fluidRow(
          box(title = "Sinif uzre Standartlar, Alt-standartlar ve Movzular", width = 12, solidHeader = TRUE, status = "success",
            DT::dataTableOutput("home_sinif_table")
          )
        ),
        fluidRow(
          box(title = "Fealiyyet Saheleri", width = 6, solidHeader = TRUE, status = "success", plotly_or_msg("home_area_chart")),
          box(title = "Sinif Paylamasi", width = 6, solidHeader = TRUE, plotly_or_msg("home_grade_chart"))
        ),
        fluidRow(
          box(title = "Xosh geldiniz!", width = 12, solidHeader = TRUE, status = "success",
            tags$div(style = "padding:20px;font-size:1.2em;line-height:1.8;",
              tags$h2(style = paste0("color:", RENGLER$esas, ";"), "Azerbaycan Dili Muellim Agenti v2.0"),
              tags$p("PISA/PIRLS/Blum/CEFR beynelxalq cerciveleri ile guclendirilmish AI muellim assistenti."),
              tags$ul(
                tags$li("Ders planlari (Blum taksonomiyasi, diferensial, rubrika)"),
                tags$li("PISA formatinda test ve qiymetlendirme"),
                tags$li("Ayliq tematik plan (PISA/PIRLS uygunlugu)"),
                tags$li("10 elementli edebi metn tehlili"),
                tags$li("Sagird inkishaf analizi (PISA seviyye + CEFR profil)"),
                tags$li("Muellim komekchisi (metodiki + beynelxalq praktika)")
              )))
        )
      ),

      # === TAB 1: DERS PLANI (GENISLENDIRILMISH) ===
      tabItem(tabName = "lesson", fluidRow(box(title = "AI ile Ders Plani Yaratma (PISA/Blum)", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("lp_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(4, uiOutput("lp_standard_ui")),
          column(3, uiOutput("lp_topic_ui")),
          column(3, selectInput("lp_faaliyet", "Fealiyyet novu:", choices = c("Oxu", "Yazi", "Qrammatika", "Danishiq", "Edebiyyat", "Qarishiq")))
        ),
        fluidRow(
          column(3, selectInput("lp_type", "Ders tipi:", choices = c("Yeni movzu", "Mohkemlendirme", "Qiymetlendirme", "Edebiyyat tehlili", "Inteqrativ ders", "Layihe dersi"))),
          column(2, selectInput("lp_duration", "Muddet (deq):", choices = c("45", "60", "90"), selected = "45"))
        ),
        fluidRow(
          column(4, checkboxGroupInput("lp_beynelxalq", "Beynelxalq cercive:",
            choices = c("PISA oxu savadliligi" = "pisa", "PIRLS oxu" = "pirls", "Blum taksonomiyasi" = "blooms", "CEFR dil cercivesi" = "cefr"),
            selected = c("pisa", "blooms"), inline = TRUE)),
          column(2, checkboxInput("lp_diferensial", "Diferensial tapshiriqlar (3 seviyye)", value = TRUE)),
          column(2, checkboxInput("lp_rubrika", "Qiymetlendirme rubrikasi", value = TRUE))
        ),
        fluidRow(
          column(4, checkboxGroupInput("lp_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE)),
          column(4, actionButton("lp_generate", "Ders Plani Yarat", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("magic")))
        ),
        fluidRow(column(12, uiOutput("lp_token_ui"))),
        hr(), tags$div(id = "lp_timer_live"), uiOutput("lp_result"),
        fluidRow(column(6, uiOutput("lp_download_ui")))))),

      # === TAB 2: TEST (PISA FORMATI) ===
      tabItem(tabName = "test", fluidRow(box(title = "AI Test Generatoru (PISA Formati)", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("tc_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(4, uiOutput("tc_standard_ui")),
          column(3, uiOutput("tc_topic_ui")),
          column(3, selectInput("tc_type", "Test tipi:", choices = c("Coxsecimli (standart)", "PISA formati (metn + suallar)", "Diktant metni", "Insha rubrikasi", "Shifahi nitq qiymetlendirme", "Portfel qiymetlendirme")))
        ),
        fluidRow(
          column(3, sliderInput("tc_count", "Sual sayi:", min = 5, max = 30, value = 15)),
          column(3, selectInput("tc_diff", "Cetinlik:", choices = c("Asan (PISA Sev.1-2)", "Orta (PISA Sev.3-4)", "Cetin (PISA Sev.5-6)", "Qarishiq (butun seviyyeler)"))),
          column(3, selectInput("tc_metn", "Metn novu (PISA):", choices = c("Bedii metn", "Melumat metni", "Publisistik", "Sened/praktik metn", "Qarishiq metn")))
        ),
        fluidRow(
          column(3, checkboxInput("tc_rubrika", "Aciq suallar ucun rubrika", value = TRUE)),
          column(4, checkboxGroupInput("tc_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE)),
          column(4, actionButton("tc_generate", "Test Yarat", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("clipboard-check")))
        ),
        fluidRow(column(12, uiOutput("tc_token_ui"))),
        hr(), tags$div(id = "tc_timer_live"), uiOutput("tc_result"),
        fluidRow(column(6, uiOutput("tc_download_ui")))))),

      # === TAB 3: AYLIQ PLAN ===
      tabItem(tabName = "monthly", fluidRow(box(title = "Ayliq Tematik Plan (PISA/PIRLS)", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("mp_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(2, selectInput("mp_month", "Ay:", choices = c("Sentyabr","Oktyabr","Noyabr","Dekabr","Yanvar","Fevral","Mart","Aprel","May"), selected = "Mart")),
          column(2, selectInput("mp_hours", "Heftelik saat:", choices = c("2","3","4","5"), selected = "3")),
          column(2, checkboxInput("mp_pisa", "PISA/PIRLS uygunlugu", value = TRUE)),
          column(2, checkboxInput("mp_qiymet", "Qiymetlendirme noqteleri", value = TRUE)),
          column(2, actionButton("mp_generate", "Plan Yarat", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("calendar-alt")))
        ),
        fluidRow(
          column(4, checkboxGroupInput("mp_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE))
        ),
        fluidRow(column(12, uiOutput("mp_token_ui"))),
        hr(), tags$div(id = "mp_timer_live"), uiOutput("mp_result"),
        fluidRow(column(6, uiOutput("mp_download_ui")))))),

      # === TAB 4: EDEBI TEHLIL (GENISLENDIRILMISH — 10 ELEMENT) ===
      tabItem(tabName = "analysis", fluidRow(box(title = "Edebi Metn Analizi (10 Element)", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("an_grade", "Sinif:", choices = as.character(1:11), selected = "7")),
          column(3, uiOutput("an_eser_ui")),
          column(2, textInput("an_muellif", "Muellif:", placeholder = "Mes: Nizami Gencevi")),
          column(2, textInput("an_eser_text", "Eser adi:", placeholder = "Mes: Xemse")),
          column(3, selectInput("an_type", "Analiz novu:", choices = c(
            "Tam edebi tehlil (butun elementler)",
            "Kompozisiya ve sujet tehlili",
            "Obraz sistemi tehlili",
            "Bedii tesvir vasiteleri",
            "Muqayiseli edebi tehlil",
            "Dil ve uslub tehlili",
            "Tenqidi dushunce suallari (PISA)",
            "Muellim ucun metodiki qeydler"
          )))
        ),
        fluidRow(
          column(3, checkboxInput("an_rubrika", "Insha qiymetlendirme rubrikasi", value = TRUE)),
          column(3, checkboxInput("an_muqayise", "Muqayiseli tehlil (diger eserlerle)", value = FALSE)),
          column(4, checkboxGroupInput("an_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE)),
          column(2, actionButton("an_generate", "Tehlil Et", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("feather-alt")))
        ),
        fluidRow(column(12, uiOutput("an_token_ui"))),
        hr(), tags$div(id = "an_timer_live"), uiOutput("an_result"),
        fluidRow(column(6, uiOutput("an_download_ui")))))),

      # === TAB 5: SAGIRD ANALIZI (PISA + CEFR) ===
      tabItem(tabName = "student", fluidRow(box(title = "Sagird Inkishaf Analizi (PISA + CEFR)", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(3, selectInput("sa_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(7, checkboxGroupInput("sa_weak", "Zeif terefler:", choices = c(
            "Oxu sureti", "Anlama", "Yazi", "Qrammatika", "Nitq",
            "Edebiyyat derki", "Luget ehtiyati", "Orfoqrafiya"),
            selected = c("Oxu sureti", "Anlama"), inline = TRUE)),
          column(2, actionButton("sa_generate", "Analiz Et", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("user-graduate")))
        ),
        fluidRow(
          column(4, checkboxGroupInput("sa_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE))
        ),
        fluidRow(column(12, uiOutput("sa_token_ui"))),
        hr(), tags$div(id = "sa_timer_live"), uiOutput("sa_result"),
        fluidRow(column(6, uiOutput("sa_download_ui")))))),

      # === TAB 6: MUELLIM KOMEKCHISI (GENISLENDIRILMISH) ===
      tabItem(tabName = "assistant", fluidRow(box(title = "Muellim Komekchisi — Azad Sual-Cavab", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(8, textAreaInput("qa_question", "Sualinizi yazin:", rows = 4,
            placeholder = "Mes: 5-ci sinifde qrammatika tedrisinde hansi feal tedris metodlarindan istifade ede bilerem?")),
          column(4,
            actionButton("qa_generate", "Cavab Al", class = "btn-lg btn-generate btn-az-green", style = "margin-top:10px;width:100%;", icon = icon("robot")),
            actionButton("qa_metodiki", "Metodiki Tovsiye", class = "btn-lg btn-generate btn-az-orange", style = "margin-top:10px;width:100%;", icon = icon("chalkboard-teacher")),
            actionButton("qa_beynelxalq", "Beynelxalq Praktika", class = "btn-lg btn-generate", style = "margin-top:10px;width:100%;background:#1d4ed8!important;color:#fff!important;", icon = icon("globe"))
          )
        ),
        fluidRow(column(12, uiOutput("qa_token_ui"))),
        hr(), tags$div(id = "qa_timer_live"), uiOutput("qa_result")))),

      # === TAB 7: ARXIV ===
      tabItem(tabName = "archive",
        fluidRow(
          column(12, tags$div(style = "margin-bottom:16px;",
            actionButton("arch_refresh", "Yenile", class = "btn-success", icon = icon("refresh")),
            tags$span(style = "margin-left:12px;color:#666;", "Fayllar: ~/Desktop/Az_agent/output/")
          ))
        ),
        fluidRow(
          box(title = "Ders Planlari Arxivi", width = 12, solidHeader = TRUE, status = "success", DTOutput("arch_plans_table")),
          box(title = "Testler Arxivi", width = 12, solidHeader = TRUE, status = "success", DTOutput("arch_tests_table")),
          box(title = "Mesajlar Arxivi", width = 12, solidHeader = TRUE, DTOutput("arch_msgs_table"))
        )
      )
    )
  )
)

# ═══════════════════════════════════════════════
# ASYNC AI CALL HELPER
# ═══════════════════════════════════════════════
run_ai_async <- function(session, output, timer_id, token_output, result_output,
                         info1, info2, status_text, prompt_fn, save_fn, footer_fn,
                         download_ui_id = NULL, saved_rv = NULL, rv_key = NULL,
                         btn_id = NULL, user_api_key = NULL) {
  if (!is.null(btn_id)) shinyjs::disable(btn_id)
  session$sendCustomMessage("ai_timer_start", list(target = timer_id, status = status_text, info1 = info1, info2 = info2))
  output[[token_output]] <- renderUI(tags$div(class = "token-display token-waiting", icon("hourglass-half"), " AI isleyir..."))
  output[[result_output]] <- renderUI(NULL)
  session$onFlushed(function() {
    tryCatch({
      res <- call_claude(prompt_fn(), api_key = user_api_key)
      if (res$success) {
        session$sendCustomMessage("ai_timer_stop", list(target = timer_id, ok = TRUE,
          elapsed = sprintf("%.1f", res$time_sec),
          inp = formatC(res$input_tokens, format = "d", big.mark = ","),
          out = formatC(res$output_tokens, format = "d", big.mark = ","),
          cost = sprintf("$%.4f", (res$input_tokens * 3 + res$output_tokens * 15) / 1e6)))
        saved <- tryCatch(save_fn(res$text), error = function(e) list(html = NA, docx = NA))
        if (!is.null(saved_rv) && !is.null(rv_key)) saved_rv[[rv_key]] <- saved
        stats_html <- make_stats_bar(res$time_sec, res$input_tokens, res$output_tokens, saved)
        output[[token_output]] <- renderUI(tags$div(class = "token-display token-done", icon("check-circle"),
          sprintf(" %.1f san | %s token", res$time_sec, formatC(res$input_tokens + res$output_tokens, format = "d", big.mark = ","))))
        output[[result_output]] <- renderUI(tagList(HTML(HTML5_CSS), tags$div(class = "ai-output", HTML(res$text)),
          HTML(stats_html), tags$div(class = "arti-footer", footer_fn())))
        if (!is.null(download_ui_id)) {
          btns <- list()
          btns[[length(btns) + 1]] <- downloadButton(paste0(download_ui_id, "_html"), "HTML yukle",
            class = "btn-success", style = "margin:8px 8px 8px 0;")
          if (!is.na(saved$docx)) btns[[length(btns) + 1]] <- downloadButton(paste0(download_ui_id, "_docx"), "DOCX yukle",
            class = "btn-primary", style = "margin:8px 8px 8px 0;")
          output[[download_ui_id]] <- renderUI(tags$div(style = "margin-top:16px;", do.call(tagList, btns)))
        }
        if (!is.null(btn_id)) shinyjs::enable(btn_id)
      } else {
        session$sendCustomMessage("ai_timer_stop", list(target = timer_id, ok = FALSE,
          elapsed = sprintf("%.1f", res$time_sec), inp = "0", out = "0", cost = "$0"))
        output[[token_output]] <- renderUI(tags$div(class = "token-display token-error", icon("times-circle"), sprintf(" Xeta (%.1f san)", res$time_sec)))
        output[[result_output]] <- renderUI(tags$div(style = "padding:30px;color:#dc2626;", tags$h3("Xeta bas verdi"), tags$p(res$error)))
        if (!is.null(btn_id)) shinyjs::enable(btn_id)
      }
    }, error = function(e) {
      message("run_ai_async XETA: ", e$message)
      output[[token_output]] <- renderUI(tags$div(class = "token-display token-error", icon("times-circle"), " Xeta"))
      output[[result_output]] <- renderUI(tags$div(style = "padding:30px;color:#dc2626;",
        tags$h3("Sistem xetasi"), tags$p(e$message)))
      if (!is.null(btn_id)) shinyjs::enable(btn_id)
    })
  }, once = TRUE)
}

# ═══════════════════════════════════════════════
# SERVER
# ═══════════════════════════════════════════════
server <- function(input, output, session) {

  saved_files <- reactiveValues(lp = NULL, tc = NULL, mp = NULL, an = NULL, sa = NULL)

  addResourcePath("ders_planlari", DERS_DIR)
  addResourcePath("testler", TEST_DIR)
  addResourcePath("mesajlar", MSG_DIR)

  # --- Dynamic dropdowns ---
  output$lp_standard_ui <- renderUI(selectInput("lp_standard", "Standart:", choices = get_standards_dropdown(input$lp_grade), width = "100%"))
  output$tc_standard_ui <- renderUI(selectInput("tc_standard", "Standart:", choices = get_standards_dropdown(input$tc_grade), width = "100%"))
  output$lp_topic_ui <- renderUI(selectizeInput("lp_topic", "Movzu:", choices = get_topics_for_grade(input$lp_grade),
    width = "100%", options = list(placeholder = "Movzu secin ve ya yazin...", create = TRUE)))
  output$tc_topic_ui <- renderUI(selectizeInput("tc_topic", "Movzu:", choices = get_topics_for_grade(input$tc_grade),
    width = "100%", options = list(placeholder = "Movzu secin ve ya yazin...", create = TRUE)))
  output$an_eser_ui <- renderUI(selectizeInput("an_eser", "Derslikden eser secin:", choices = get_eserler_for_grade(input$an_grade),
    width = "100%", options = list(placeholder = "Eser secin...", create = FALSE)))

  # === HOME — pre-compute counts ===
  home_data <- local({
    sinifler <- sort(as.integer(names(ALL_STANDARDS)))
    res <- data.frame(
      Sinif = character(0), Esas = integer(0), Alt = integer(0),
      Movzu = integer(0), Nisbet = numeric(0), stringsAsFactors = FALSE
    )
    total_esas <- 0; total_alt <- 0; total_mov <- 0
    for (s in sinifler) {
      sc <- as.character(s)
      st_list <- ALL_STANDARDS[[sc]]
      kodlar <- c()
      for (st in st_list) {
        k <- st$kod
        if (!is.null(k) && nchar(k) > 0) kodlar <- c(kodlar, k)
      }
      kodlar <- unique(kodlar)
      n_alt <- length(kodlar)
      esas <- c()
      for (k in kodlar) {
        p <- strsplit(k, "[.]")[[1]]
        if (length(p) >= 2) esas <- c(esas, paste(p[1], p[2], sep = "."))
      }
      n_esas <- length(unique(esas))
      tp <- ALL_TOPICS[[sc]]
      n_mov <- if (!is.null(tp)) length(tp) else 0L
      nisb <- if (n_alt > 0) round(n_mov / n_alt, 1) else 0
      res <- rbind(res, data.frame(
        Sinif = paste0(s, "-ci sinif"), Esas = n_esas, Alt = n_alt,
        Movzu = n_mov, Nisbet = nisb, stringsAsFactors = FALSE
      ))
      total_esas <- total_esas + n_esas
      total_alt <- total_alt + n_alt
      total_mov <- total_mov + n_mov
    }
    res <- rbind(res, data.frame(
      Sinif = "YEKUN", Esas = total_esas, Alt = total_alt,
      Movzu = total_mov, Nisbet = round(total_mov / total_alt, 1),
      stringsAsFactors = FALSE
    ))
    list(df = res, total_esas = total_esas, total_alt = total_alt, total_mov = total_mov)
  })
  cat("HOME DATA: esas=", home_data$total_esas, " alt=", home_data$total_alt, " mov=", home_data$total_mov, "\n")

  output$home_esas_std_box <- renderValueBox({
    valueBox(home_data$total_esas, "Esas Standart", icon = icon("certificate"), color = "green")
  })
  output$home_alt_std_box <- renderValueBox({
    valueBox(home_data$total_alt, "Alt-standart", icon = icon("sitemap"), color = "olive")
  })
  output$home_topic_box <- renderValueBox({
    valueBox(home_data$total_mov, "Movzu", icon = icon("list"), color = "teal")
  })
  output$home_plan_box <- renderValueBox({
    n <- length(list.files(DERS_DIR, pattern = "\\.html$"))
    valueBox(n, "Ders Plani", icon = icon("book"), color = "aqua")
  })
  output$home_test_box <- renderValueBox({
    n <- length(list.files(TEST_DIR, pattern = "\\.html$"))
    valueBox(n, "Test", icon = icon("clipboard"), color = "yellow")
  })
  output$home_chunk_box <- renderValueBox({
    fs <- list.files(CHUNKS_DIR, pattern = "\\.json$", full.names = TRUE)
    total <- 0
    for (f in fs) tryCatch({ total <- total + length(fromJSON(f, simplifyVector = FALSE)) }, error = function(e) {})
    valueBox(total, "Chunk", icon = icon("database"), color = "maroon")
  })

  output$home_sinif_table <- DT::renderDataTable({
    df <- home_data$df
    colnames(df) <- c("Sinif", "Esas standart", "Alt-standart", "Movzu", "Nisbet (movzu/alt-std)")
    DT::datatable(df, options = list(pageLength = 13, dom = "t", ordering = FALSE),
                  rownames = FALSE, class = "compact stripe hover")
  })

  if (PLOTLY_OK) {
    output$home_area_chart <- renderPlotly(
      plot_ly(x = c("Oxu","Yazi","Qrammatika","Danishiq","Edebiyyat"),
              y = c(25,20,30,10,15), type = "bar",
              marker = list(color = c(RENGLER$esas, RENGLER$ikinci,"#A5D6A7","#FF6F00","#8b5cf6"))) %>%
        layout(xaxis = list(title = "Sahe"), yaxis = list(title = "Faiz (%)")))
    output$home_grade_chart <- renderPlotly(
      plot_ly(x = paste0(1:11, "-ci sinif"),
              y = c(180,195,210,225,200,190,185,175,165,155,150), type = "bar",
              marker = list(color = RENGLER$ikinci)) %>%
        layout(xaxis = list(title = "Sinif"), yaxis = list(title = "Chunk sayi")))
  }

  # === TAB 1: DERS PLANI ===
  observeEvent(input$lp_generate, {
    req(input$lp_grade, input$lp_topic)
    gr <- as.integer(input$lp_grade); tp <- input$lp_topic
    fa <- input$lp_faaliyet; dur <- as.integer(input$lp_duration); ln <- input$lp_lang
    st <- input$lp_standard; dt <- input$lp_type
    bx <- input$lp_beynelxalq; df <- input$lp_diferensial; rb <- input$lp_rubrika
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "lp_timer_live", "lp_token_ui", "lp_result",
      sprintf("Sinif: %d", gr), sprintf("%s (%s)", tp, fa), "AI ile elaqe quruldu, ders plani yaradilir...",
      function() { ctx <- build_context(gr, tp); build_lesson_prompt(gr, tp, fa, ctx, dur, ln, st, dt, bx, df, rb) },
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, tp, "ders_plani"),
      function() sprintf("ARTI 2026 | Sinif %d | %s | %d deq", gr, tp, dur),
      download_ui_id = "lp_download_ui", saved_rv = saved_files, rv_key = "lp", btn_id = "lp_generate",
      user_api_key = current_key)
  })

  # === TAB 2: TEST ===
  observeEvent(input$tc_generate, {
    req(input$tc_grade, input$tc_topic)
    gr <- as.integer(input$tc_grade); tp <- input$tc_topic
    tt <- input$tc_type; cnt <- input$tc_count; df <- input$tc_diff
    ln <- input$tc_lang; st <- input$tc_standard
    mn <- input$tc_metn; rb <- input$tc_rubrika
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "tc_timer_live", "tc_token_ui", "tc_result",
      sprintf("Sinif: %d", gr), sprintf("%s (%d sual, %s)", tp, cnt, tt), "AI ile elaqe quruldu, test yaradilir...",
      function() { ctx <- build_context(gr, tp); build_test_prompt(gr, tp, tt, ctx, cnt, df, ln, st, mn, rb) },
      function(text) save_result(text, HTML5_CSS, TEST_DIR, gr, tp, "test"),
      function() sprintf("ARTI 2026 | Sinif %d | %s | %d tapshiriq", gr, tp, cnt),
      download_ui_id = "tc_download_ui", saved_rv = saved_files, rv_key = "tc", btn_id = "tc_generate",
      user_api_key = current_key)
  })

  # === TAB 3: AYLIQ PLAN ===
  observeEvent(input$mp_generate, {
    req(input$mp_grade, input$mp_month)
    gr <- as.integer(input$mp_grade); ay <- input$mp_month; hrs <- input$mp_hours; ln <- input$mp_lang
    pu <- input$mp_pisa; qn <- input$mp_qiymet
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "mp_timer_live", "mp_token_ui", "mp_result",
      sprintf("Sinif: %d", gr), sprintf("%s, %s saat/hefte", ay, hrs), "AI ile elaqe quruldu, ayliq plan yaradilir...",
      function() build_monthly_prompt(gr, ay, hrs, ln, pu, qn),
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, ay, "ayliq_plan"),
      function() sprintf("ARTI 2026 | Sinif %d | %s | %s saat", gr, ay, hrs),
      download_ui_id = "mp_download_ui", saved_rv = saved_files, rv_key = "mp", btn_id = "mp_generate",
      user_api_key = current_key)
  })

  # === TAB 4: EDEBI TEHLIL ===
  observeEvent(input$an_generate, {
    req(input$an_grade)
    gr <- as.integer(input$an_grade)
    # Get muellif and eser from either dropdown or text fields
    eser_dropdown <- input$an_eser
    muellif <- input$an_muellif %||% ""
    eser <- input$an_eser_text %||% ""
    # If text fields empty, parse from dropdown
    if (nchar(muellif) == 0 && nchar(eser) == 0 && !is.null(eser_dropdown) && eser_dropdown != "---") {
      parts <- strsplit(eser_dropdown, " - ", fixed = TRUE)[[1]]
      muellif <- parts[1] %||% ""
      eser <- if (length(parts) > 1) parts[2] else ""
    }
    req(nchar(paste0(muellif, eser)) > 0)
    at <- input$an_type; ln <- input$an_lang
    rb <- input$an_rubrika; mq <- input$an_muqayise
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "an_timer_live", "an_token_ui", "an_result",
      sprintf("Sinif: %d", gr), paste0(muellif, " - ", eser), "AI ile elaqe quruldu, edebi tehlil yaradilir...",
      function() build_analysis_prompt(gr, muellif, eser, at, ln, rb, mq),
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, paste0(muellif, "_", eser), "edebi_tehlil"),
      function() sprintf("ARTI 2026 | Sinif %d | %s - %s", gr, muellif, eser),
      download_ui_id = "an_download_ui", saved_rv = saved_files, rv_key = "an", btn_id = "an_generate",
      user_api_key = current_key)
  })

  # === TAB 5: SAGIRD ANALIZI ===
  observeEvent(input$sa_generate, {
    req(input$sa_grade, input$sa_weak)
    gr <- as.integer(input$sa_grade); wk <- input$sa_weak; ln <- input$sa_lang
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "sa_timer_live", "sa_token_ui", "sa_result",
      sprintf("Sinif: %d", gr), paste(wk, collapse = ", "), "AI ile elaqe quruldu, sagird analizi yaradilir...",
      function() build_student_prompt(gr, wk, ln),
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, paste(wk, collapse = "_"), "sagird_analiz"),
      function() sprintf("ARTI 2026 | Sinif %d | Sagird Analizi", gr),
      download_ui_id = "sa_download_ui", saved_rv = saved_files, rv_key = "sa", btn_id = "sa_generate",
      user_api_key = current_key)
  })

  # === TAB 6: MUELLIM KOMEKCHISI ===
  observeEvent(input$qa_generate, {
    req(input$qa_question)
    q <- input$qa_question
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "qa_timer_live", "qa_token_ui", "qa_result",
      "Sual-Cavab", substr(q, 1, 50), "AI ile elaqe quruldu, cavab hazirlaniir...",
      function() build_assistant_prompt(q),
      function(text) save_result(text, HTML5_CSS, MSG_DIR, 0, "assistant_cavab", "komekchi"),
      function() "ARTI 2026 | Muellim Komekchisi",
      user_api_key = current_key)
  })

  observeEvent(input$qa_metodiki, {
    req(input$qa_question)
    q <- input$qa_question
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "qa_timer_live", "qa_token_ui", "qa_result",
      "Metodiki Tovsiye", substr(q, 1, 50), "AI ile elaqe quruldu, metodiki tovsiye hazirlaniir...",
      function() build_metodiki_prompt(q),
      function(text) save_result(text, HTML5_CSS, MSG_DIR, 0, "metodiki", "metodiki"),
      function() "ARTI 2026 | Metodiki Tovsiye",
      user_api_key = current_key)
  })

  observeEvent(input$qa_beynelxalq, {
    req(input$qa_question)
    q <- input$qa_question
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "qa_timer_live", "qa_token_ui", "qa_result",
      "Beynelxalq Praktika", substr(q, 1, 50), "AI ile elaqe quruldu, beynelxalq tecrube arashdiriliir...",
      function() build_beynelxalq_prompt(q),
      function(text) save_result(text, HTML5_CSS, MSG_DIR, 0, "beynelxalq", "beynelxalq"),
      function() "ARTI 2026 | Beynelxalq Praktika",
      user_api_key = current_key)
  })

  # === DOWNLOAD HANDLERS ===
  make_download <- function(rv_key, ext) {
    downloadHandler(
      filename = function() {
        sf <- saved_files[[rv_key]]
        if (!is.null(sf) && !is.na(sf[[ext]])) basename(sf[[ext]]) else paste0("netice.", ext)
      },
      content = function(file) {
        sf <- saved_files[[rv_key]]
        if (!is.null(sf) && !is.na(sf[[ext]])) file.copy(sf[[ext]], file)
      }
    )
  }
  output$lp_download_ui_html <- make_download("lp", "html")
  output$lp_download_ui_docx <- make_download("lp", "docx")
  output$tc_download_ui_html <- make_download("tc", "html")
  output$tc_download_ui_docx <- make_download("tc", "docx")
  output$mp_download_ui_html <- make_download("mp", "html")
  output$mp_download_ui_docx <- make_download("mp", "docx")
  output$an_download_ui_html <- make_download("an", "html")
  output$an_download_ui_docx <- make_download("an", "docx")
  output$sa_download_ui_html <- make_download("sa", "html")
  output$sa_download_ui_docx <- make_download("sa", "docx")

  # === TAB 7: ARXIV ===
  arch_trigger <- reactiveVal(0)
  observeEvent(input$arch_refresh, { arch_trigger(arch_trigger() + 1) })

  build_archive_table <- function(dir, resource_prefix) {
    html_files <- list.files(dir, pattern = "\\.html$", full.names = TRUE)
    if (length(html_files) == 0) return(datatable(data.frame(Mesaj = "Hele fayl yoxdur"), options = list(dom = "t")))
    docx_files <- list.files(dir, pattern = "\\.docx$", full.names = TRUE)
    df <- data.frame(
      Fayl = basename(html_files),
      Olcu = paste0(round(file.size(html_files)/1024, 1), " KB"),
      Tarix = format(file.mtime(html_files), "%d.%m.%Y %H:%M"),
      Bax = sapply(basename(html_files), function(f) {
        html_link <- sprintf('<a href="%s/%s" target="_blank" class="btn btn-xs btn-success" style="margin:2px;">Bax</a>', resource_prefix, f)
        docx_name <- sub("\\.html$", ".docx", f)
        docx_link <- if (file.path(dir, docx_name) %in% docx_files) {
          sprintf(' <a href="%s/%s" target="_blank" class="btn btn-xs btn-primary" style="margin:2px;">DOCX</a>', resource_prefix, docx_name)
        } else ""
        paste0(html_link, docx_link)
      }),
      stringsAsFactors = FALSE)
    datatable(df[order(df$Tarix, decreasing = TRUE), ],
      options = list(pageLength = 15, dom = "ftp"),
      rownames = FALSE, escape = FALSE,
      colnames = c("Fayl adi", "Olcu", "Yaradilma tarixi", "Yukle"))
  }

  output$arch_plans_table <- renderDT({ arch_trigger(); build_archive_table(DERS_DIR, "ders_planlari") })
  output$arch_tests_table <- renderDT({ arch_trigger(); build_archive_table(TEST_DIR, "testler") })
  output$arch_msgs_table  <- renderDT({ arch_trigger(); build_archive_table(MSG_DIR, "mesajlar") })
}

shinyApp(ui = ui, server = server, options = list(
  host = "127.0.0.1",
  port = as.integer(Sys.getenv("SHINY_PORT", "4040")),
  launch.browser = TRUE
))
