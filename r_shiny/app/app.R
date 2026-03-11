# ══════════════════════════════════════════════════════════
# Az_Muellim_Agent v1.0 — Azerbaycan Dili Muellim Agenti
# ARTI 2026 (c) Tariyel Talibov
# ══════════════════════════════════════════════════════════

library(shiny)
library(shinydashboard)
library(shinyjs)
library(DT)
library(httr)
library(jsonlite)

PLOTLY_OK <- tryCatch({ library(plotly); TRUE }, error = function(e) {
  message("plotly yuklenmedi: ", e$message); FALSE })

LOCAL_DIR <- normalizePath("~/Desktop/Az_agent", mustWork = FALSE)
APP_DIR   <- if (dir.exists(LOCAL_DIR)) LOCAL_DIR else getwd()

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
DERS_DIR <- file.path(APP_DIR, "output", "Ders_planlari")
TEST_DIR <- file.path(APP_DIR, "output", "Testler")
MSG_DIR  <- file.path(APP_DIR, "output", "Mesajlar")
dir.create(DERS_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(TEST_DIR, showWarnings = FALSE, recursive = TRUE)
dir.create(MSG_DIR,  showWarnings = FALSE, recursive = TRUE)

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || (is.character(x) && all(nchar(x) == 0))) y else x

# ═══════════════ SYSTEM PROMPT ═══════════════
SYSTEM_PROMPT <- paste0(
  "Sen Azerbaycan Respublikasinin 1-11-ci sinif Azerbaycan dili ve edebiyyat ",
  "fennini derinden bilen, muasir tehsil metodlarini, tematik planlamani, ",
  "oxu-yazi bacariqlarini, edebi metn tehlilini, qrammatika tedrisini ve ",
  "qiymetlendirme rubrikalarini yaxshi bilen bir mutexessis AI muellim ",
  "assistentisen. Butun cavablarini Azerbaycan dilinde ver."
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
  for (b in gd$bolmeler) {
    bn <- b$bolme %||% "?"
    for (m in b$movzular) {
      ad <- m$ad %||% "?"; seh <- m$seh %||% "?"
      label <- paste0("[", bn, "]  ", ad, "  (seh. ", seh, ")")
      ch <- c(ch, setNames(ad, label))
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
    '<div class="arti-footer">ARTI 2026 | ', format(Sys.time(), "%d.%m.%Y %H:%M"), ' | ', base_name, '</div>\n',
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
# HTML5 CSS (Green Theme)
# ══════════════════════════════════════════════
HTML5_CSS <- '<style>
@import url("https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap");
.ai-output{font-family:"Noto Sans","Segoe UI",sans-serif;color:#1a1a2e;font-size:1.30em;line-height:1.90;max-width:1100px;margin:0 auto}
.test-header,.lesson-header{background:linear-gradient(135deg,#0a2810,#1b5e20,#2E7D32);color:#fff;padding:36px;border-radius:16px;margin-bottom:30px;box-shadow:0 8px 32px rgba(0,0,0,.18);position:relative;overflow:hidden}
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
.bloom-badge,.dok-badge{display:inline-flex;align-items:center;padding:6px 16px;border-radius:20px;font-size:1.0em;font-weight:700}
.bloom-badge{background:#f0fdf4;color:#15803d;border:1px solid #86efac}
.dok-badge{background:#fef3c7;color:#92400e;border:1px solid #fde68a}
.question-text{font-size:1.33em;margin-bottom:18px;line-height:1.95;color:#1e293b}
.options{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px}
.option{background:#f8fafc;padding:14px 20px;border-radius:10px;border:1px solid #e2e8f0;font-size:1.24em;transition:all .2s}
.option:hover{background:#f0fdf4;border-color:#86efac}
.answer-box{background:linear-gradient(135deg,#f0fdf4,#ecfdf5);border:1px solid #86efac;border-radius:12px;padding:20px;margin-top:12px}
.answer-box .answer{font-weight:700;color:#15803d;font-size:1.30em;margin-bottom:10px;padding-bottom:8px;border-bottom:1px solid #bbf7d0}
.answer-box .solution{color:#374151;margin-bottom:8px;white-space:pre-wrap;font-size:1.20em;line-height:1.7}
.answer-box .textbook-ref{color:#1b5e20;font-weight:600;font-size:1.17em;padding:6px 0}
.answer-box .difficulty{color:#6b7280;font-size:1.10em;margin-top:6px}
.answer-box .rubric{margin-top:12px;padding:14px;background:#fffbeb;border-radius:10px;border:1px solid #fde68a;font-size:1.14em}
.answer-box .distractors{margin-top:10px;padding:14px;background:#faf5ff;border-radius:10px;border:1px solid #d8b4fe;font-size:1.10em}
.phase{background:#fff;border-radius:16px;padding:28px;margin-bottom:20px;box-shadow:0 2px 16px rgba(0,0,0,.06);border-left:5px solid #2E7D32;transition:all .25s ease}
.phase:hover{box-shadow:0 6px 24px rgba(0,0,0,.10)}
.phase-1{border-left-color:#f59e0b}.phase-2{border-left-color:#2E7D32}.phase-3{border-left-color:#10b981}
.phase-4{border-left-color:#8b5cf6}.phase-5{border-left-color:#ef4444}
.phase-header{display:flex;align-items:center;gap:14px;margin-bottom:18px}
.phase-header h3{margin:0;font-size:1.43em;flex-grow:1;color:#1e293b}
.phase-icon{font-size:1.8em}
.phase-time{background:linear-gradient(135deg,#f0fdf4,#dcfce7);padding:6px 18px;border-radius:20px;font-size:1.07em;font-weight:700;color:#1b5e20;border:1px solid #86efac}
.teacher-activity,.student-activity,.phase .textbook-ref,.assessment{padding:12px 18px;margin-bottom:10px;border-radius:10px;font-size:1.20em;line-height:1.7}
.teacher-activity{background:linear-gradient(135deg,#f0fdf4,#e8f5e9);border-left:4px solid #2E7D32}
.student-activity{background:linear-gradient(135deg,#e8f5e9,#f1f8e9);border-left:4px solid #66BB6A}
.phase .textbook-ref{background:linear-gradient(135deg,#fefce8,#fffde4);border-left:4px solid #eab308;color:#854d0e;font-weight:600}
.assessment{background:linear-gradient(135deg,#faf5ff,#f8f0ff);border-left:4px solid #a855f7}
.differentiation{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin:14px 0}
.diff-level{padding:16px;border-radius:12px;font-size:1.14em}
.diff-base{background:#f0fdf4;border:1px solid #86efac}.diff-mid{background:#fffbeb;border:1px solid #fde68a}
.diff-high{background:#fef2f2;border:1px solid #fca5a5}
.stats-block,.analysis-block{background:linear-gradient(135deg,#0f172a,#1e293b);color:#e2e8f0;padding:28px;border-radius:16px;margin-top:28px;box-shadow:0 4px 20px rgba(0,0,0,.2)}
.stats-block h3,.analysis-block h3{margin:0 0 18px;color:#fbbf24;font-size:1.43em}
.stat-row{padding:10px 0;border-bottom:1px solid rgba(255,255,255,.08);font-size:1.17em;line-height:1.6}
.stat-row:last-child{border-bottom:none}
.lang-section{margin-top:36px;padding:24px 0;border-top:4px solid #2E7D32}
.lang-section h2{background:linear-gradient(135deg,#1b5e20,#2E7D32);color:#fff;padding:16px 28px;border-radius:12px;font-size:1.5em;display:inline-block;margin:0 0 20px}
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
    return("\nDIL: Neticeni YALNIZ Azerbaycan dilinde yaz.\nDOLGUNLUQ: Cavabi musefesssel ve tam yaz — her bolmede konkret numuneler, izahlar, praktik melumatlar.\n")
  }
  lang_list <- paste(sapply(seq_along(langs), function(i) {
    paste0(i, ". ", LANG_FLAGS[langs[i]], " ", LANG_NAMES[langs[i]])
  }), collapse = "\n")
  paste0('
DILLER (COX VACIB!):
Neticeni ', length(langs), ' DILDE ver — her dil ayrica bolme sheklinde:
', lang_list, '

Her dil bolmesi bu bashliq ile bashlamalidir:
<div class="lang-section" style="margin-top:36px;padding:24px 0;border-top:4px solid #2E7D32;">
  <h2 style="background:linear-gradient(135deg,#1b5e20,#2E7D32);color:#fff;padding:16px 28px;border-radius:12px;font-size:1.5em;display:inline-block;">
    [BAYRAQ_EMOJI] [DIL ADI]
  </h2>
</div>

Her bolmede HERSEY tam shekilde tercume olunmalidir.
DOLGUNLUQ: Cavabi musefesssel ve tam yaz — her bolmede konkret numuneler, izahlar, praktik melumatlar.
')
}

# ═══════════════ PROMPT BUILDERS ═══════════════

build_lesson_prompt <- function(grade, topic, faaliyet, context, duration, langs = c("az"), standard = NULL) {
  lang_inst <- build_lang_instruction(langs)
  m1 <- as.integer(duration * 0.10); m2 <- as.integer(duration * 0.30)
  m3 <- as.integer(duration * 0.25); m4 <- as.integer(duration * 0.25); m5 <- as.integer(duration * 0.10)
  paste0(
'Sen Azerbaycan Respublikasinin 1-11-ci sinif Azerbaycan dili ve edebiyyat fennini derinden bilen ekspert metodist AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
MOVZU: ', topic, '
STANDART: ', if (!is.null(standard) && standard != "---") standard else "Umumixidmet", '
FEALIYYET NOVU: ', faaliyet, '
MUDDET: ', duration, ' deqiqe

DERSLIKDEN KONTEKST:
', context, '

AZERBAYCAN DILI TEDRISI METODOLOGIYASI:
1. Oxu bacarigi: metn anlama, tehlil, tenqidi dushunme
2. Yazi bacarigi: insha, esse, meqale, metn yaratma
3. Qrammatika: nitq hisseleri, cumle qurulushu, durgu ishareleri
4. Danishiq: shifahi nitq, diskussiya, teqdimat
5. Edebiyyat: bedii metn tehlili, muellif-eser, edebiyyat tarixi

DERS PLANININ STRUKTURU (5 MERHELE):

MERHELE 1: MOTIVASIYA VE AKTUALLASDIRMA (', m1, ' deq)
  - Maraqli metn parcasi ve ya sheirle derse baslama
  - Evvelki biliyin yoxlanmasi (sual-cavab)
  - Dersin meqsedinin elani

MERHELE 2: YENI BILIK VE KESHF (', m2, ' deq)
  - Derslik metni uzarinde ish
  - Yeni qrammatik/edebi anlayishin izahi
  - Numune metn parcalari ile ish

MERHELE 3: BIRGE TETBIQ (', m3, ' deq)
  - Muellim rehberliyi ile tapshiriq icra
  - Cutluk/qrup ishi
  - Metn uzerinde musteqil tapshiriqlar

MERHELE 4: DIFERENSIASIYA VE MUSTEQIL ISH (', m4, ' deq)
  BAZA seviyye: Sadeleshtrilmish tapshiriqlar
  ORTA seviyye: Standart tapshiriqlar
  YUKSEK seviyye: Yaradici tapshiriqlar (insha, esse, layihe)

MERHELE 5: YEKUNLASDIRMA VE REFLEKSIYA (', m5, ' deq)
  - Dersin xulasesi
  - 3-2-1 refleksiya: 3 sey oyrendim, 2 sual var, 1 sey maraqli idi
  - Ev tapshirigi

HTML FORMATI (CIDDI RIAYAT):
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Ders Plani: Azerbaycan Dili</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Movzu:</span> ', topic, '</div>
    <div class="meta-item"><span class="label">Muddet:</span> ', duration, ' deqiqe</div>
    <div class="meta-item"><span class="label">Fealiyyet:</span> ', faaliyet, '</div>
  </div>
  <div class="objectives">
    <h3>Telim Neticeleri</h3>
    <ul>
      <li><strong>Bilik:</strong> Shagird ... bilecek/izah ede bilecek</li>
      <li><strong>Bacariq:</strong> Shagird ... tetbiq ede bilecek</li>
      <li><strong>Munasibet:</strong> Shagird ... deyerlendire bilecek</li>
    </ul>
  </div>
</div>

HER MERHELE bele olmalidir:
<div class="phase phase-[N]">
  <div class="phase-header">
    <span class="phase-icon">[uygun emoji]</span>
    <h3>MERHELE [N]: [AD]</h3>
    <span class="phase-time">[X] deq</span>
  </div>
  <div class="teacher-activity"><strong>Muellim fealiyyeti:</strong> [Deqiq ne deyir, ne gosterir, hansi suallari verir]</div>
  <div class="student-activity"><strong>Shagird fealiyyeti:</strong> [Deqiq ne edir: oxuyur, yazir, muzakire edir]</div>
  <div class="textbook-ref"><strong>Derslik istinadi:</strong> seh. [XX]</div>
  <div class="assessment"><strong>Formativ qiymetlendirme:</strong> [Muellim NECE yoxlayir]</div>
</div>

Sonda MUTLEQ bu analiz blokunu yaz:
<div class="analysis-block">
  <h3>Ders Analizi</h3>
  <div class="stat-row"><strong>Dil bacariq paylamasi:</strong> Oxu X% | Yazi X% | Qrammatika X% | Danishiq X% | Edebiyyat X%</div>
  <div class="stat-row"><strong>Zaman bolgusu:</strong> Muellim X% | Shagird X% | Muzakire X%</div>
  <div class="stat-row"><strong>Derslik istinadlari:</strong> seh. [istifade olunan sehifeler]</div>
  <div class="stat-row"><strong>Ev tapshirigi:</strong> Derslik seh. XX (texmini 10-15 deq)</div>
</div>')
}

build_test_prompt <- function(grade, topic, test_type, context, count, difficulty, langs = c("az"), standard = NULL) {
  lang_inst <- build_lang_instruction(langs)
  paste0(
'Sen Azerbaycan dili ve edebiyyat fenninden test tapshiriqlari yaradan ekspert AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
MOVZU: ', topic, '
STANDART: ', if (!is.null(standard) && standard != "---") standard else "Umumixidmet", '
TEST TIPI: ', test_type, '
TAPSHIRIQ SAYI: ', count, '
CETINLIK: ', difficulty, '

DERSLIKDEN KONTEKST:
', context, '

TEST TIPLERINE GORE QAYDALAR:

1. COXSECIMLI SUALLAR (A, B, C, D):
   - Qrammatika qaydalarini yoxlayan suallar
   - Metn anlama suallari
   - Eded-herf analojilari, sinonim/antonim
   - HER sualin cavab acari ve izahi olmalidir

2. ACIQ SUALLAR:
   - Metn tehlili suallari
   - Fikir bildirme suallari
   - Rubrika (0-3 bal skalasi) ile

3. DIKTANT:
   - Sinif seviyyesine uygun metn (80-150 soz)
   - Cetinlik: durgu ishareleri, sait-samit qaydalar, boyuk herf
   - Qiymetlendirme meyarlari

4. INSHA RUBRIKASI:
   - Mezmun (0-5 bal)
   - Quruluish (0-5 bal)
   - Dil duzgunluyu (0-5 bal)
   - Yaradiciliq (0-5 bal)

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="test-header">
  <h1>Azerbaycan Dili Test Tapshiriqlari</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Movzu:</span> ', topic, '</div>
    <div class="meta-item"><span class="label">Test tipi:</span> ', test_type, '</div>
    <div class="meta-item"><span class="label">Tapshiriq sayi:</span> ', count, '</div>
    <div class="meta-item"><span class="label">Cetinlik:</span> ', difficulty, '</div>
  </div>
</div>

HER TAPSHIRIQ bele olmalidir:
<div class="question-block">
  <div class="question-header">
    <span class="bloom-badge">[SEVIYYE]</span>
  </div>
  <div class="question-text"><strong>Tapshiriq [N].</strong> [Sualin tam metni]</div>
  [coxsecimli ise:]
  <div class="options">
    <div class="option"><strong>A)</strong> [variant]</div>
    <div class="option"><strong>B)</strong> [variant]</div>
    <div class="option"><strong>C)</strong> [variant]</div>
    <div class="option"><strong>D)</strong> [variant]</div>
  </div>
  <div class="answer-box">
    <div class="answer">Duzgun cavab: [HERF]) [metn]</div>
    <div class="solution"><strong>Izah:</strong> [Niye bu cavab duzdur]</div>
    <div class="textbook-ref">Derslik istinadi: seh. [XX]</div>
  </div>
</div>

Sonda MUTLEQ bu analiz blokunu elave et:
<div class="stats-block">
  <h3>Test Statistikasi</h3>
  <div class="stat-row"><strong>Cetinlik paylamasi:</strong> Asan: X% | Orta: X% | Cetin: X%</div>
  <div class="stat-row"><strong>Dil bacariq saheleri:</strong> Oxu: X tapshiriq | Yazi: X | Qrammatika: X | Edebiyyat: X</div>
  <div class="stat-row"><strong>Derslik istinadlari:</strong> seh. [butun istifade olunan sehifeler]</div>
  <div class="stat-row"><strong>Texmini vaxt:</strong> Cemi [X] deqiqe</div>
</div>')
}

build_monthly_prompt <- function(grade, month, weekly_hours, langs = c("az")) {
  lang_inst <- build_lang_instruction(langs)
  paste0(
'Sen Azerbaycan dili ve edebiyyat fenninden ayliq plan hazirlayan ekspert metodist AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
AY: ', month, '
HEFTELIK SAAT: ', weekly_hours, '

Ayliq plani HTML cedvel formatinda hazirla:
- Her hefte ucun: movzu, saat, fealiyyet novu, qiymetlendirme, derslik sehifesi
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
<thead><tr style="background:#2E7D32;color:#fff;">
<th style="padding:12px;border:1px solid #ddd;">Hefte</th>
<th style="padding:12px;border:1px solid #ddd;">Movzu</th>
<th style="padding:12px;border:1px solid #ddd;">Saat</th>
<th style="padding:12px;border:1px solid #ddd;">Fealiyyet</th>
<th style="padding:12px;border:1px solid #ddd;">Qiymetlendirme</th>
<th style="padding:12px;border:1px solid #ddd;">Derslik</th>
</tr></thead>
<tbody>
[CEDVEL SATRLARI]
</tbody>
</table>

Sonda analiz bloku elave et.')
}

build_analysis_prompt <- function(grade, author_work, analysis_type, langs = c("az")) {
  lang_inst <- build_lang_instruction(langs)
  paste0(
'Sen Azerbaycan edebiyyatinin derinden bilen ekspert edebiyyatshinas AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
MUELLIF/ESER: ', author_work, '
ANALIZ NOVU: ', analysis_type, '

Edebi metn tehlilini bu aspektlerde hazirla:
1. MEZMUN TEHLILI: Movzu, ideya, problem, konflikt
2. SHEXSIYYET TEHLILI: Bas qehremanlar, xarakter xususiyyetleri
3. DIL-USLUB TEHLILI: Bedii ifade vasiteleri, dil xususiyyetleri
4. MOVZU-IDEYA TEHLILI: Eserin esas fikri, yazicinin meqsedi

Shagird sinifine uygun dilde ve seviyyede yaz.

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Edebi Metn Analizi</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Eser:</span> ', author_work, '</div>
    <div class="meta-item"><span class="label">Analiz novu:</span> ', analysis_type, '</div>
  </div>
</div>

Tehlili bolmeler sheklinde ver, her bolme <div class="phase"> icinde.
Sonuna shagirdler ucun suallar ve tapshiriqlar elave et.')
}

build_student_prompt <- function(grade, weaknesses, langs = c("az")) {
  lang_inst <- build_lang_instruction(langs)
  weak_text <- paste(weaknesses, collapse = ", ")
  paste0(
'Sen shagirdlerin Azerbaycan dili ve edebiyyat fennindeki inkishafini tehlil eden psixoloq-pedaqoq AI-san.
', lang_inst, '

PARAMETRLER:
SINIF: ', grade, '-ci sinif
ZEIF TEREFLER: ', weak_text, '

Asagidakilari hazirla:
1. TEHLIL: Her zeif terefi ayrica tehlil et, sebeblerini goster
2. FERDI PLAN: 4 heftelik inkishaf plani (her hefte ucun konkret tapshiriqlar)
3. VALIDEYN MEKTUBU: Valideyne gonderilecek melumat mektubu
4. TOVSIYYELER: Muellim ve valideyn ucun praktik tovsiyyeler
5. RESURSLAR: Elave oxu materiallari ve menbeler

HTML FORMATI:
Neticeni YALNIZ HTML teqleri ile ver. Markdown ISTIFADE ETME.

<div class="lesson-header">
  <h1>Shagird Inkishaf Tehlili</h1>
  <div class="meta-grid">
    <div class="meta-item"><span class="label">Sinif:</span> ', grade, '-ci sinif</div>
    <div class="meta-item"><span class="label">Zeif saheler:</span> ', weak_text, '</div>
  </div>
</div>

Her bolmeni <div class="phase"> icinde ver.
Valideyn mektubunu ayrica blokda goster.')
}

build_assistant_prompt <- function(question) {
  paste0(
'Azerbaycan dili ve edebiyyat muellimi kimi asagidaki suala tam ve professional cavab ver.
Cavabi HTML formatinda ver (Markdown istifade etme).
Derslik istinadlari ve praktik numuneler elave et.

SUAL: ', question, '

Cavabi <div class="phase"> bloklari icinde strukturlashdir.
Konkret numuneler, metn parcalari ve tapshiriq numuneleri elave et.')
}

# ═══════════════ HELPER ═══════════════
plotly_or_msg <- function(outputId, height = "300px") {
  if (PLOTLY_OK) plotlyOutput(outputId, height = height) else tags$p(style = "color:#94a3b8;padding:40px;text-align:center;", "plotly lazimdir")
}

# ═══════════════════════════════════════════════
# UI
# ═══════════════════════════════════════════════
ui <- dashboardPage(skin = "green",
  dashboardHeader(title = span(icon("book"), " Az Dili Muellim Agent v1.0"), titleWidth = 340),
  dashboardSidebar(width = 280, sidebarMenu(id = "tabs",
    menuItem("Ana Sehife", tabName = "home", icon = icon("home")),
    menuItem("Ders Plani", tabName = "lesson", icon = icon("book")),
    menuItem("Test ve Qiymetlendirme", tabName = "test", icon = icon("clipboard-check")),
    menuItem("Ayliq Plan", tabName = "monthly", icon = icon("calendar")),
    menuItem("Edebi Tehlil", tabName = "analysis", icon = icon("feather-alt")),
    menuItem("Shagird Analizi", tabName = "student", icon = icon("user-graduate")),
    menuItem("Muellim Komekchisi", tabName = "assistant", icon = icon("comments")),
    menuItem("Arxiv", tabName = "archive", icon = icon("archive")),
    hr(),
    div(style = "padding:10px;",
      passwordInput("api_key_input", label = tags$span(icon("key"), " API Key"),
                    value = Sys.getenv("ANTHROPIC_API_KEY", ""),
                    placeholder = "sk-ant-..."),
      tags$p(style = "color:#b8c7ce;font-size:10px;margin-top:5px;",
             "Anthropic API key daxil edin")
    ),
    hr(),
    div(p(style = "padding:10px;color:#b8c7ce;font-size:11px;", "ARTI 2026 (c) Tariyel Talibov"))
  )),
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
        body,.content-wrapper,.box-body,.box-header,.sidebar-menu li a{font-size:115%!important}
        .form-group label{font-size:1.05em!important;font-weight:600!important}
        .form-control,.selectize-input,.selectize-dropdown{font-size:1.02em!important}
        .content-wrapper{background:#f4f6f9}.box{border-top:3px solid #2E7D32}
        .skin-green .main-header .navbar{background:#2E7D32}
        .skin-green .main-header .logo{background:#1b5e20;font-size:17px!important}
        .skin-green .main-header .logo:hover{background:#1b5e20}
        .btn-generate{font-size:1.25em!important;padding:14px 28px!important;font-weight:700!important;border-radius:10px!important}
        .btn-az-green{background:#2E7D32!important;color:#fff!important;border-color:#1b5e20!important}
        .btn-az-green:hover{background:#1b5e20!important}
        .ai-loading{text-align:center;padding:60px}
        .ai-loading .spinner{width:56px;height:56px;border:5px solid #e2e8f0;border-top-color:#2E7D32;border-radius:50%;animation:spin .8s linear infinite;margin:0 auto 20px}
        @keyframes spin{to{transform:rotate(360deg)}}
        .selectize-dropdown{max-height:420px!important}.selectize-dropdown-content{max-height:400px!important}
        .token-display{display:inline-flex;align-items:center;gap:8px;font-size:1.15em;font-weight:700;padding:8px 16px;border-radius:10px;margin-top:25px}
        .token-waiting{background:#fef3c7;color:#92400e;border:1px solid #fde68a}
        .token-done{background:#dcfce7;color:#166534;border:1px solid #86efac}
        .token-error{background:#fef2f2;color:#991b1b;border:1px solid #fca5a5}
        .live-timer-panel{background:linear-gradient(135deg,#0f172a,#1e293b);border:2px solid #2E7D32;border-radius:16px;padding:28px 36px;margin:20px 0;text-align:center;box-shadow:0 4px 24px rgba(46,125,50,.15)}
        .live-timer-panel .t-status{font-size:1.15em;color:#94a3b8;margin-bottom:10px}
        .live-timer-panel .t-clock{font-family:'JetBrains Mono',monospace;font-size:3.2em;font-weight:700;color:#66BB6A;letter-spacing:.06em;margin:8px 0}
        .live-timer-panel .t-start{font-size:.95em;color:#64748b;margin-bottom:14px}
        .live-timer-panel .t-details{display:flex;justify-content:center;gap:16px;flex-wrap:wrap}
        .live-timer-panel .t-item{background:rgba(255,255,255,.06);padding:8px 18px;border-radius:10px;font-size:.95em;color:#cbd5e1}
        .pdot{display:inline-block;width:10px;height:10px;background:#22c55e;border-radius:50%;margin-right:8px;animation:pdot 1s infinite}
        @keyframes pdot{0%,100%{opacity:1}50%{opacity:.3}}
        .t-done{border-color:#22c55e!important}.t-err{border-color:#ef4444!important}
      ")),
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
          infoBox("DERS PLANLARI", textOutput("home_plan_count"), icon = icon("book"), color = "green", width = 3),
          infoBox("TESTLER", textOutput("home_test_count"), icon = icon("clipboard"), color = "olive", width = 3),
          infoBox("MESAJLAR", textOutput("home_msg_count"), icon = icon("comments"), color = "teal", width = 3),
          infoBox("CHUNKS", textOutput("home_chunk_count"), icon = icon("database"), color = "maroon", width = 3)
        ),
        fluidRow(
          box(title = "Fealiyyet Saheleri", width = 6, solidHeader = TRUE, status = "success", plotly_or_msg("home_area_chart")),
          box(title = "Sinif Paylamasi", width = 6, solidHeader = TRUE, plotly_or_msg("home_grade_chart"))
        ),
        fluidRow(
          box(title = "Xosh geldiniz!", width = 12, solidHeader = TRUE, status = "success",
            tags$div(style = "padding:20px;font-size:1.2em;line-height:1.8;",
              tags$h2(style = "color:#2E7D32;", "Azerbaycan Dili Muellim Agenti v1.0"),
              tags$p("Bu sistem Azerbaycan Respublikasinin 1-11-ci sinif Azerbaycan dili ve edebiyyat ",
                     "muellimlerine komeye yaradilmishdir."),
              tags$ul(
                tags$li("Ders planlari yaratma (oxu, yazi, qrammatika, danishiq, edebiyyat)"),
                tags$li("Test ve qiymetlendirme materiallari hazirlama"),
                tags$li("Ayliq tematik plan tuzme"),
                tags$li("Edebi metn tehlili"),
                tags$li("Shagird inkishaf analizi"),
                tags$li("Azad sual-cavab assistenti")
              )))
        )
      ),

      # === TAB 1: DERS PLANI ===
      tabItem(tabName = "lesson", fluidRow(box(title = "AI ile Ders Plani Yaratma", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("lp_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(4, uiOutput("lp_standard_ui")),
          column(3, uiOutput("lp_topic_ui")),
          column(3, selectInput("lp_faaliyet", "Fealiyyet:", choices = c("Oxu", "Yazi", "Qrammatika", "Danishiq", "Edebiyyat")))
        ),
        fluidRow(
          column(2, selectInput("lp_type", "Ders tipi:", choices = c("Yeni movzu", "Mohkemlendirme", "Qiymetlendirme"))),
          column(2, numericInput("lp_duration", "Muddet (deq):", value = 45, min = 30, max = 90))
        ),
        fluidRow(
          column(4, checkboxGroupInput("lp_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE)),
          column(4, actionButton("lp_generate", "Ders Plani Yarat", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("magic")))
        ),
        fluidRow(column(12, uiOutput("lp_token_ui"))),
        hr(), tags$div(id = "lp_timer_live"), uiOutput("lp_result"),
        fluidRow(column(6, uiOutput("lp_download_ui")))))),

      # === TAB 2: TEST ===
      tabItem(tabName = "test", fluidRow(box(title = "AI Test Generatoru", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("tc_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(4, uiOutput("tc_standard_ui")),
          column(3, uiOutput("tc_topic_ui")),
          column(3, selectInput("tc_type", "Test tipi:", choices = c("Coxsecimli", "Aciq sual", "Diktant", "Insha rubrikasi")))
        ),
        fluidRow(
          column(3, sliderInput("tc_count", "Sual sayi:", min = 5, max = 30, value = 10)),
          column(2, selectInput("tc_diff", "Cetinlik:", choices = c("Asan", "Orta", "Cetin", "Qarishiq")))
        ),
        fluidRow(
          column(4, checkboxGroupInput("tc_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE)),
          column(4, actionButton("tc_generate", "Test Yarat", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("clipboard-check")))
        ),
        fluidRow(column(12, uiOutput("tc_token_ui"))),
        hr(), tags$div(id = "tc_timer_live"), uiOutput("tc_result"),
        fluidRow(column(6, uiOutput("tc_download_ui")))))),

      # === TAB 3: AYLIQ PLAN ===
      tabItem(tabName = "monthly", fluidRow(box(title = "Ayliq Tematik Plan", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(3, selectInput("mp_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(3, selectInput("mp_month", "Ay:", choices = c("Sentyabr","Oktyabr","Noyabr","Dekabr","Yanvar","Fevral","Mart","Aprel","May"), selected = "Mart")),
          column(3, selectInput("mp_hours", "Heftelik saat:", choices = c("2","3","4"), selected = "3")),
          column(3, actionButton("mp_generate", "Plan Yarat", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("calendar-alt")))
        ),
        fluidRow(
          column(4, checkboxGroupInput("mp_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE))
        ),
        fluidRow(column(12, uiOutput("mp_token_ui"))),
        hr(), tags$div(id = "mp_timer_live"), uiOutput("mp_result"),
        fluidRow(column(6, uiOutput("mp_download_ui")))))),

      # === TAB 4: EDEBI TEHLIL ===
      tabItem(tabName = "analysis", fluidRow(box(title = "Edebi Metn Analizi", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(2, selectInput("an_grade", "Sinif:", choices = as.character(5:11), selected = "7")),
          column(4, uiOutput("an_eser_ui")),
          column(3, textInput("an_work", "Ve ya azad daxil edin:", placeholder = "Mes: Nizami Gencevi - Xemse")),
          column(2, selectInput("an_type", "Analiz novu:", choices = c("Mezmun tehlili", "Shexsiyyet tehlili", "Dil-uslub tehlili", "Movzu-ideya tehlili"))),
          column(2, actionButton("an_generate", "Tehlil Et", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("feather-alt")))
        ),
        fluidRow(
          column(4, checkboxGroupInput("an_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE))
        ),
        fluidRow(column(12, uiOutput("an_token_ui"))),
        hr(), tags$div(id = "an_timer_live"), uiOutput("an_result"),
        fluidRow(column(6, uiOutput("an_download_ui")))))),

      # === TAB 5: SHAGIRD ANALIZI ===
      tabItem(tabName = "student", fluidRow(box(title = "Shagird Inkishaf Analizi", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(3, selectInput("sa_grade", "Sinif:", choices = as.character(1:11), selected = "5")),
          column(5, checkboxGroupInput("sa_weak", "Zeif terefler:", choices = c("Oxu", "Yazi", "Qrammatika", "Nitq", "Edebiyyat"),
            selected = c("Oxu", "Yazi"), inline = TRUE)),
          column(4, actionButton("sa_generate", "Analiz Et", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;", icon = icon("user-graduate")))
        ),
        fluidRow(
          column(4, checkboxGroupInput("sa_lang", "Dil:", choices = c("Azerbaycan"="az","Rus"="ru","Ingilis"="en"), selected = "az", inline = TRUE))
        ),
        fluidRow(column(12, uiOutput("sa_token_ui"))),
        hr(), tags$div(id = "sa_timer_live"), uiOutput("sa_result"),
        fluidRow(column(6, uiOutput("sa_download_ui")))))),

      # === TAB 6: MUELLIM KOMEKCHISI ===
      tabItem(tabName = "assistant", fluidRow(box(title = "Muellim Komekchisi — Azad Sual-Cavab", width = 12, solidHeader = TRUE, status = "success",
        fluidRow(
          column(9, textAreaInput("qa_question", "Sualinizi yazin:", rows = 4,
            placeholder = "Mes: 5-ci sinifde qrammatika tedrisinde hansi feal tedris metodlarindan istifade ede bilerem?")),
          column(3, actionButton("qa_generate", "Cavab Al", class = "btn-lg btn-generate btn-az-green", style = "margin-top:25px;width:100%;", icon = icon("robot")))
        ),
        fluidRow(column(12, uiOutput("qa_token_ui"))),
        hr(), tags$div(id = "qa_timer_live"), uiOutput("qa_result")))),

      # === TAB 7: ARXIV ===
      tabItem(tabName = "archive",
        fluidRow(
          column(12, tags$div(style = "margin-bottom:16px;",
            actionButton("arch_refresh", "Yenile", class = "btn-success", icon = icon("refresh")),
            tags$span(style = "margin-left:12px;color:#666;", "Fayllar: ~/Desktop/Az_agent/output/Ders_planlari/ ve ~/Desktop/Az_agent/output/Testler/")
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

  # --- Saved file paths for downloads ---
  saved_files <- reactiveValues(lp = NULL, tc = NULL, mp = NULL, an = NULL, sa = NULL)

  # --- Resource paths for serving files ---
  addResourcePath("ders_planlari", DERS_DIR)
  addResourcePath("testler", TEST_DIR)
  addResourcePath("mesajlar", MSG_DIR)

  # --- Dynamic standard dropdowns ---
  output$lp_standard_ui <- renderUI(selectInput("lp_standard", "Standart:", choices = get_standards_dropdown(input$lp_grade), width = "100%"))
  output$tc_standard_ui <- renderUI(selectInput("tc_standard", "Standart:", choices = get_standards_dropdown(input$tc_grade), width = "100%"))

  # --- Dynamic topic dropdowns ---
  output$lp_topic_ui <- renderUI(selectizeInput("lp_topic", "Movzu:", choices = get_topics_for_grade(input$lp_grade),
    width = "100%", options = list(placeholder = "Movzu secin ve ya yazin...", create = TRUE)))
  output$tc_topic_ui <- renderUI(selectizeInput("tc_topic", "Movzu:", choices = get_topics_for_grade(input$tc_grade),
    width = "100%", options = list(placeholder = "Movzu secin ve ya yazin...", create = TRUE)))
  output$an_eser_ui <- renderUI(selectizeInput("an_eser", "Derslikden eser secin:", choices = get_eserler_for_grade(input$an_grade),
    width = "100%", options = list(placeholder = "Eser secin...", create = FALSE)))

  # === HOME ===
  output$home_plan_count <- renderText(as.character(length(list.files(DERS_DIR, pattern = "\\.html$"))))
  output$home_test_count <- renderText(as.character(length(list.files(TEST_DIR, pattern = "\\.html$"))))
  output$home_msg_count  <- renderText(as.character(length(list.files(MSG_DIR, pattern = "\\.html$"))))
  output$home_chunk_count <- renderText({
    fs <- list.files(CHUNKS_DIR, pattern = "\\.json$", full.names = TRUE)
    total <- 0
    for (f in fs) tryCatch({ total <- total + length(fromJSON(f, simplifyVector = FALSE)) }, error = function(e) {})
    as.character(total)
  })

  if (PLOTLY_OK) {
    output$home_area_chart <- renderPlotly(
      plot_ly(x = c("Oxu","Yazi","Qrammatika","Danishiq","Edebiyyat"),
              y = c(25,20,30,10,15), type = "bar",
              marker = list(color = c("#2E7D32","#66BB6A","#A5D6A7","#f59e0b","#8b5cf6"))) %>%
        layout(xaxis = list(title = "Sahe"), yaxis = list(title = "Faiz (%)")))
    output$home_grade_chart <- renderPlotly(
      plot_ly(x = paste0(1:11, "-ci sinif"),
              y = c(180,195,210,225,200,190,185,175,165,155,150), type = "bar",
              marker = list(color = "#2E7D32")) %>%
        layout(xaxis = list(title = "Sinif"), yaxis = list(title = "Chunk sayi")))
  }

  # === TAB 1: DERS PLANI ===
  observeEvent(input$lp_generate, {
    req(input$lp_grade, input$lp_topic)
    gr <- as.integer(input$lp_grade); tp <- input$lp_topic
    fa <- input$lp_faaliyet; dur <- input$lp_duration; ln <- input$lp_lang; st <- input$lp_standard
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "lp_timer_live", "lp_token_ui", "lp_result",
      sprintf("Sinif: %d", gr), sprintf("%s (%s)", tp, fa), "AI ile elaqe quruldu, ders plani yaradilir...",
      function() { ctx <- build_context(gr, tp); build_lesson_prompt(gr, tp, fa, ctx, dur, ln, st) },
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, tp, "ders_plani"),
      function() sprintf("ARTI 2026 | Sinif %d | %s | %d deq", gr, tp, dur),
      download_ui_id = "lp_download_ui", saved_rv = saved_files, rv_key = "lp", btn_id = "lp_generate",
      user_api_key = current_key)
  })

  # === TAB 2: TEST ===
  observeEvent(input$tc_generate, {
    req(input$tc_grade, input$tc_topic)
    gr <- as.integer(input$tc_grade); tp <- input$tc_topic
    tt <- input$tc_type; cnt <- input$tc_count; df <- input$tc_diff; ln <- input$tc_lang; st <- input$tc_standard
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "tc_timer_live", "tc_token_ui", "tc_result",
      sprintf("Sinif: %d", gr), sprintf("%s (%d sual, %s)", tp, cnt, tt), "AI ile elaqe quruldu, test yaradilir...",
      function() { ctx <- build_context(gr, tp); build_test_prompt(gr, tp, tt, ctx, cnt, df, ln, st) },
      function(text) save_result(text, HTML5_CSS, TEST_DIR, gr, tp, "test"),
      function() sprintf("ARTI 2026 | Sinif %d | %s | %d tapshiriq", gr, tp, cnt),
      download_ui_id = "tc_download_ui", saved_rv = saved_files, rv_key = "tc", btn_id = "tc_generate",
      user_api_key = current_key)
  })

  # === TAB 3: AYLIQ PLAN ===
  observeEvent(input$mp_generate, {
    req(input$mp_grade, input$mp_month)
    gr <- as.integer(input$mp_grade); ay <- input$mp_month; hrs <- input$mp_hours; ln <- input$mp_lang
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "mp_timer_live", "mp_token_ui", "mp_result",
      sprintf("Sinif: %d", gr), sprintf("%s, %s saat/hefte", ay, hrs), "AI ile elaqe quruldu, ayliq plan yaradilir...",
      function() build_monthly_prompt(gr, ay, hrs, ln),
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, ay, "ayliq_plan"),
      function() sprintf("ARTI 2026 | Sinif %d | %s | %s saat", gr, ay, hrs),
      download_ui_id = "mp_download_ui", saved_rv = saved_files, rv_key = "mp", btn_id = "mp_generate",
      user_api_key = current_key)
  })

  # === TAB 4: EDEBI TEHLIL ===
  observeEvent(input$an_generate, {
    req(input$an_grade)
    gr <- as.integer(input$an_grade)
    aw <- if (!is.null(input$an_work) && nchar(trimws(input$an_work)) > 0) input$an_work else input$an_eser
    req(aw)
    at <- input$an_type; ln <- input$an_lang
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "an_timer_live", "an_token_ui", "an_result",
      sprintf("Sinif: %d", gr), aw, "AI ile elaqe quruldu, edebi tehlil yaradilir...",
      function() build_analysis_prompt(gr, aw, at, ln),
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, aw, "edebi_tehlil"),
      function() sprintf("ARTI 2026 | Sinif %d | %s", gr, aw),
      download_ui_id = "an_download_ui", saved_rv = saved_files, rv_key = "an", btn_id = "an_generate",
      user_api_key = current_key)
  })

  # === TAB 5: SHAGIRD ANALIZI ===
  observeEvent(input$sa_generate, {
    req(input$sa_grade, input$sa_weak)
    gr <- as.integer(input$sa_grade); wk <- input$sa_weak; ln <- input$sa_lang
    current_key <- isolate(input$api_key_input)
    run_ai_async(session, output, "sa_timer_live", "sa_token_ui", "sa_result",
      sprintf("Sinif: %d", gr), paste(wk, collapse = ", "), "AI ile elaqe quruldu, shagird analizi yaradilir...",
      function() build_student_prompt(gr, wk, ln),
      function(text) save_result(text, HTML5_CSS, DERS_DIR, gr, paste(wk, collapse = "_"), "shagird_analiz"),
      function() sprintf("ARTI 2026 | Sinif %d | Shagird Analizi", gr),
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
