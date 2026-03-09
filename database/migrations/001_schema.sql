-- ============================================================
-- Az Muellim Agent - PostgreSQL Database Schema
-- ARTI 2026
-- ============================================================
-- Azerbaycan dili ve edebiyyat muellim agenti ucun verilener bazasi
-- DB adi: az_muellim_db
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 1. azdili_standartlari - Kurikulum standartlari
-- Azerbaycan dili fenni uzre 1-11-ci sinif standartlari
-- ============================================================
CREATE TABLE IF NOT EXISTS azdili_standartlari (
    id SERIAL PRIMARY KEY,
    sinif INTEGER NOT NULL CHECK (sinif BETWEEN 1 AND 11),
    saha VARCHAR(50) NOT NULL CHECK (saha IN ('oxu', 'yazi', 'qrammatika', 'danisiq', 'edebiyyat')),
    standard_kodu VARCHAR(20) NOT NULL,
    standard_metni TEXT NOT NULL,
    alstandart_kodu VARCHAR(20),
    alstandart_metni TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE azdili_standartlari IS 'Azerbaycan dili fenni uzre milli kurikulum standartlari';
COMMENT ON COLUMN azdili_standartlari.sinif IS 'Sinif nomresi (1-11)';
COMMENT ON COLUMN azdili_standartlari.saha IS 'Mezmun xetti: oxu, yazi, qrammatika, danisiq, edebiyyat';
COMMENT ON COLUMN azdili_standartlari.standard_kodu IS 'Standart kodu, mes: 1.1.1';
COMMENT ON COLUMN azdili_standartlari.standard_metni IS 'Standartin tam metni';
COMMENT ON COLUMN azdili_standartlari.alstandart_kodu IS 'Alt-standart kodu';
COMMENT ON COLUMN azdili_standartlari.alstandart_metni IS 'Alt-standartin tam metni';

-- ============================================================
-- 2. azdili_movzular - Tedris movzulari
-- Her sinif ve sahe uzre movzular
-- ============================================================
CREATE TABLE IF NOT EXISTS azdili_movzular (
    id SERIAL PRIMARY KEY,
    sinif INTEGER NOT NULL CHECK (sinif BETWEEN 1 AND 11),
    saha VARCHAR(50) NOT NULL,
    movzu_adi VARCHAR(255) NOT NULL,
    movzu_izahi TEXT,
    saat_sayi INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE azdili_movzular IS 'Azerbaycan dili fenni uzre tedris movzulari';
COMMENT ON COLUMN azdili_movzular.sinif IS 'Sinif nomresi (1-11)';
COMMENT ON COLUMN azdili_movzular.saha IS 'Mezmun sahesi';
COMMENT ON COLUMN azdili_movzular.movzu_adi IS 'Movzunun adi';
COMMENT ON COLUMN azdili_movzular.movzu_izahi IS 'Movzunun qisa izahi';
COMMENT ON COLUMN azdili_movzular.saat_sayi IS 'Bu movzuya ayrilmis ders saati';

-- ============================================================
-- 3. azdili_derslikler - Derslik chunk-lari
-- PDF dersliklerden cikarilmis metn hisseleri
-- ============================================================
CREATE TABLE IF NOT EXISTS azdili_derslikler (
    id SERIAL PRIMARY KEY,
    sinif INTEGER NOT NULL,
    hisse INTEGER,
    chunk_id VARCHAR(100) UNIQUE NOT NULL,
    movzu VARCHAR(255),
    saha VARCHAR(50),
    metn TEXT,
    sehife_aralighi VARCHAR(20),
    soz_sayi INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE azdili_derslikler IS 'Dersliklerden cikarilmis metn chunk-lari';
COMMENT ON COLUMN azdili_derslikler.sinif IS 'Sinif nomresi';
COMMENT ON COLUMN azdili_derslikler.hisse IS 'Dersliyin hisse nomresi';
COMMENT ON COLUMN azdili_derslikler.chunk_id IS 'Unikal chunk identifikatoru';
COMMENT ON COLUMN azdili_derslikler.movzu IS 'Chunk-un aid oldugu movzu';
COMMENT ON COLUMN azdili_derslikler.saha IS 'Mezmun sahesi';
COMMENT ON COLUMN azdili_derslikler.metn IS 'Chunk metni';
COMMENT ON COLUMN azdili_derslikler.sehife_aralighi IS 'Sehife aralighi, mes: 12-15';
COMMENT ON COLUMN azdili_derslikler.soz_sayi IS 'Metndeki soz sayi';

-- ============================================================
-- 4. ders_planlari - Ders planlari
-- AI terefinden yaradilmis ders planlari
-- ============================================================
CREATE TABLE IF NOT EXISTS ders_planlari (
    id SERIAL PRIMARY KEY,
    sinif INTEGER NOT NULL CHECK (sinif BETWEEN 1 AND 11),
    movzu VARCHAR(255) NOT NULL,
    ders_tipi VARCHAR(50),
    faaliyet_novu VARCHAR(50),
    muddet INTEGER DEFAULT 45,
    mezmun TEXT,
    yaradilma_tarixi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fayl_adi VARCHAR(255)
);

COMMENT ON TABLE ders_planlari IS 'AI terefinden yaradilmis ders planlari';
COMMENT ON COLUMN ders_planlari.sinif IS 'Sinif nomresi (1-11)';
COMMENT ON COLUMN ders_planlari.movzu IS 'Dersin movzusu';
COMMENT ON COLUMN ders_planlari.ders_tipi IS 'Ders tipi: Yeni/Mohkemlendirme/Qiymetlendirme';
COMMENT ON COLUMN ders_planlari.faaliyet_novu IS 'Fealiyyet novu: Oxu/Yazi/Qrammatika/Danisiq/Edebiyyat';
COMMENT ON COLUMN ders_planlari.muddet IS 'Dersin muddeti deqiqe ile';
COMMENT ON COLUMN ders_planlari.mezmun IS 'Ders planinin tam mezmunu';
COMMENT ON COLUMN ders_planlari.fayl_adi IS 'Saxlanilmis faylin adi';

-- ============================================================
-- 5. testler - Testler ve qiymetlendirme materiallari
-- AI terefinden yaradilmis test ve tapshiriqlar
-- ============================================================
CREATE TABLE IF NOT EXISTS testler (
    id SERIAL PRIMARY KEY,
    sinif INTEGER NOT NULL CHECK (sinif BETWEEN 1 AND 11),
    movzu VARCHAR(255) NOT NULL,
    test_tipi VARCHAR(50),
    cetinlik VARCHAR(20),
    sual_sayi INTEGER DEFAULT 10,
    mezmun TEXT,
    yaradilma_tarixi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fayl_adi VARCHAR(255)
);

COMMENT ON TABLE testler IS 'AI terefinden yaradilmis testler ve qiymetlendirme materiallari';
COMMENT ON COLUMN testler.sinif IS 'Sinif nomresi (1-11)';
COMMENT ON COLUMN testler.movzu IS 'Testin movzusu';
COMMENT ON COLUMN testler.test_tipi IS 'Test tipi: Coxsecimli/Aciq sual/Diktant/Insha rubrikalari';
COMMENT ON COLUMN testler.cetinlik IS 'Cetinlik seviyyesi: Asan/Orta/Cetin/Qarisiq';
COMMENT ON COLUMN testler.sual_sayi IS 'Suallarin sayi';
COMMENT ON COLUMN testler.mezmun IS 'Testin tam mezmunu';
COMMENT ON COLUMN testler.fayl_adi IS 'Saxlanilmis faylin adi';

-- ============================================================
-- 6. mesajlar - Mesajlar ve kommunikasiya
-- Valideyn mektublari, bildirisler ve s.
-- ============================================================
CREATE TABLE IF NOT EXISTS mesajlar (
    id SERIAL PRIMARY KEY,
    sinif INTEGER,
    novu VARCHAR(50),
    mezmun TEXT,
    yaradilma_tarixi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE mesajlar IS 'Muellim kommunikasiya mesajlari';
COMMENT ON COLUMN mesajlar.sinif IS 'Aid oldugu sinif';
COMMENT ON COLUMN mesajlar.novu IS 'Mesaj novu: valideyn_mektubu/bildiris/istinad';
COMMENT ON COLUMN mesajlar.mezmun IS 'Mesajin tam mezmunu';

-- ============================================================
-- 7. edebi_metnler - Edebi metnler bazasi
-- Azerbaycan edebiyyati numuneleri
-- ============================================================
CREATE TABLE IF NOT EXISTS edebi_metnler (
    id SERIAL PRIMARY KEY,
    sinif INTEGER,
    muellif VARCHAR(255),
    eser_adi VARCHAR(255),
    janr VARCHAR(100),
    movzu VARCHAR(255),
    xulase TEXT,
    tam_metn TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE edebi_metnler IS 'Azerbaycan edebiyyati numuneleri ve edebi metnler';
COMMENT ON COLUMN edebi_metnler.sinif IS 'Hansi sinif ucun nezerde tutulub';
COMMENT ON COLUMN edebi_metnler.muellif IS 'Eserin muellifi';
COMMENT ON COLUMN edebi_metnler.eser_adi IS 'Eserin adi';
COMMENT ON COLUMN edebi_metnler.janr IS 'Edebi janr: seir/hekaye/nagil/roman/dram ve s.';
COMMENT ON COLUMN edebi_metnler.movzu IS 'Eserin esas movzusu';
COMMENT ON COLUMN edebi_metnler.xulase IS 'Eserin qisa xulasesi';
COMMENT ON COLUMN edebi_metnler.tam_metn IS 'Eserin tam metni';

-- ============================================================
-- 8. luget_izahlar - Luget ve izahlar
-- Soz izahlari ve terminler
-- ============================================================
CREATE TABLE IF NOT EXISTS luget_izahlar (
    id SERIAL PRIMARY KEY,
    sinif INTEGER,
    soz VARCHAR(100) NOT NULL,
    izah TEXT,
    misal_cumle TEXT,
    sahe VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE luget_izahlar IS 'Soz izahlari, terminler ve luget melumatlari';
COMMENT ON COLUMN luget_izahlar.sinif IS 'Hansi sinif seviyyesine uygun';
COMMENT ON COLUMN luget_izahlar.soz IS 'Izah olunan soz ve ya termin';
COMMENT ON COLUMN luget_izahlar.izah IS 'Sozun izahi';
COMMENT ON COLUMN luget_izahlar.misal_cumle IS 'Sozle numune cumle';
COMMENT ON COLUMN luget_izahlar.sahe IS 'Sahesi: qrammatika/edebiyyat/umumi ve s.';

-- ============================================================
-- Indeksler - Sorgu performansi ucun
-- ============================================================

-- azdili_standartlari indeksleri
CREATE INDEX IF NOT EXISTS idx_standartlar_sinif ON azdili_standartlari(sinif);
CREATE INDEX IF NOT EXISTS idx_standartlar_saha ON azdili_standartlari(saha);
CREATE INDEX IF NOT EXISTS idx_standartlar_sinif_saha ON azdili_standartlari(sinif, saha);

-- azdili_movzular indeksleri
CREATE INDEX IF NOT EXISTS idx_movzular_sinif ON azdili_movzular(sinif);
CREATE INDEX IF NOT EXISTS idx_movzular_saha ON azdili_movzular(saha);

-- azdili_derslikler indeksleri
CREATE INDEX IF NOT EXISTS idx_derslikler_sinif ON azdili_derslikler(sinif);
CREATE INDEX IF NOT EXISTS idx_derslikler_chunk_id ON azdili_derslikler(chunk_id);
CREATE INDEX IF NOT EXISTS idx_derslikler_sinif_saha ON azdili_derslikler(sinif, saha);

-- ders_planlari indeksleri
CREATE INDEX IF NOT EXISTS idx_planlari_sinif ON ders_planlari(sinif);
CREATE INDEX IF NOT EXISTS idx_planlari_yaradilma ON ders_planlari(yaradilma_tarixi);

-- testler indeksleri
CREATE INDEX IF NOT EXISTS idx_testler_sinif ON testler(sinif);
CREATE INDEX IF NOT EXISTS idx_testler_yaradilma ON testler(yaradilma_tarixi);

-- mesajlar indeksleri
CREATE INDEX IF NOT EXISTS idx_mesajlar_sinif ON mesajlar(sinif);

-- edebi_metnler indeksleri
CREATE INDEX IF NOT EXISTS idx_edebi_sinif ON edebi_metnler(sinif);
CREATE INDEX IF NOT EXISTS idx_edebi_muellif ON edebi_metnler(muellif);

-- luget_izahlar indeksleri
CREATE INDEX IF NOT EXISTS idx_luget_sinif ON luget_izahlar(sinif);
CREATE INDEX IF NOT EXISTS idx_luget_soz ON luget_izahlar(soz);

-- ============================================================
-- Schema yaradilmasi tamamlandi
-- ============================================================
