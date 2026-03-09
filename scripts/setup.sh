#!/bin/bash
# ============================================================
# Az_Muellim_Agent - Quraşdırma Skripti
# ARTI 2026
# ============================================================

echo "╔══════════════════════════════════════════╗"
echo "║   📚 Az_Muellim_Agent quraşdırılır...    ║"
echo "╚══════════════════════════════════════════╝"

cd ~/Desktop/Az_agent || { echo "❌ Az_agent qovluğu tapılmadı!"; exit 1; }

# Node.js asılılıqlarını quraşdır
echo ""
echo "📦 npm paketləri quraşdırılır..."
npm install

# PostgreSQL bazası yarat
echo ""
echo "🗄️  Verilənlər bazası yaradılır..."
createdb az_muellim_db 2>/dev/null || echo "ℹ️  DB artıq mövcuddur"

# Migrasiyaları işlət
echo ""
echo "🔄 Schema yaradılır..."
psql -d az_muellim_db -f database/migrations/001_schema.sql

# Seed data yüklə
echo ""
echo "🌱 Standartlar yüklənir..."
psql -d az_muellim_db -f database/seeds/001_base_seed.sql

# Chunk-ları yüklə
echo ""
echo "📚 Dərslik chunk-ları yüklənir..."
node database/seeds/002_chunks_seed.js

# Qovluqları yarat
mkdir -p Ders_planlari Testler Mesajlar uploads

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ Quraşdırma tamamlandı!              ║"
echo "╠══════════════════════════════════════════╣"
echo "║                                          ║"
echo "║   Node server:                           ║"
echo "║     npm start                            ║"
echo "║                                          ║"
echo "║   R Shiny:                               ║"
echo "║     cd r_shiny/app && R -e               ║"
echo "║       \"shiny::runApp()\"                   ║"
echo "║                                          ║"
echo "╚══════════════════════════════════════════╝"
