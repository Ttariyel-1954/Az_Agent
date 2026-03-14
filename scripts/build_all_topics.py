#!/usr/bin/env python3
"""
Bütün 442 standart üçün konkret mövzular generasiya edir.
Sinif 1-5: əllə yazılmış mövzulardan istifadə edir.
Sinif 6-11: standart mətninə əsasən konkret mövzular yaradır.
"""
import json
import sys
sys.path.insert(0, 'scripts')

from topics_sinif3_5 import SINIF3, SINIF4, SINIF5

with open('r_shiny/app/derslikler/standards.json', 'r') as f:
    standards = json.load(f)

# Sinif 1-2: generate_topics.py-dən əvvəlki əllə yazılmış data
# Burada inline olaraq saxlayırıq

# ============================================================
# Sinif 6-11 üçün kontekstual mövzu generatoru
# ============================================================

# Hər sinif üçün dərslikdəki real ədəbi əsərlər və qrammatika mövzuları
EDEBI_ESERLER = {
    6: ["«Əlvida, bilmirəm»", "«Quş dili» (M.Ə.Sabir)", "«Vətənim» şeiri", "«Hikmət xəzinəsi»",
        "«Bəs zınqırovu kim asacaq?»", "«Ana laylası»", "«Ağabəyim ağa»", "«Kəlilə və Dimnə»"],
    7: ["«Koroğlu» dastanı", "«Əsli və Kərəm»", "«Leyli və Məcnun» (Füzuli)", "M.Ə.Sabir satirası",
        "«Hophopnamə»", "«Molla Nəsrəddin» jurnalı", "«Dədə Qorqud» boyları", "S.Ə.Şirvani qəzəlləri"],
    8: ["«Vətənim» (S.Vurğun)", "«Ağabəyim» (tarixi hekayə)", "«Beşikdən qəbirə» (Hz.Məhəmməd)",
        "Ü.Hacıbəyov publisistikası", "«Arşın mal alan» (komediya)", "C.Cabbarlı «Od gəlini»",
        "«Azərbaycan» (S.Vurğun)", "M.Hüseyn hekayələri"],
    9: ["«Mənim anam» (R.Rza)", "Nizami Gəncəvi «Xəmsə»", "İ.Nəsimi fəlsəfi qəzəlləri",
        "M.Füzuli «Leyli və Məcnun»", "M.P.Vaqif qoşmaları", "A.Bakıxanov publisistikası",
        "M.F.Axundzadə komediyaları", "«Danabaş kəndinin əhvalatları» (C.Məmmədquluzadə)"],
    10: ["Nizami «İskəndərnamə»", "Xaqani Şirvani qəsidələri", "İ.Nəsimi hürufi fəlsəfəsi",
         "Ş.İ.Xətai qəzəlləri", "M.Füzuli «Şikayətnamə»", "M.P.Vaqif «Bayatılar»",
         "A.Bakıxanov «Əsərləri»", "Q.Zakir satirası"],
    11: ["C.Məmmədquluzadə «Ölülər»", "Ü.Hacıbəyov felyetonları", "H.Cavid «İblis»",
         "M.Ə.Sabir «Hophopnamə»", "C.Cabbarlı «Oqtay Eloğlu»", "S.Vurğun «Vaqif» dramı",
         "İ.Əfəndiyev «Söyüdlü arx»", "B.Vahabzadə «Gülüstan» poeması"],
}

QRAMMATIKA_MOVZULARI = {
    6: ["İsmin halları (ətraflı)", "Feilin zamanları", "Təsriflənməyən feillər", "Sifətin dərəcələri",
        "Zərf və onun növləri", "Qoşma və bağlayıcı", "Ədat və modal sözlər", "Nida"],
    7: ["İsmin hallanması — dərinləşmə", "Feilin növləri (təsirli-təsirsiz)", "Sifətin quruluşca növləri",
        "Əvəzliyin növləri", "Sayın növləri", "Feili sifət", "Feili bağlama", "Məsdər"],
    8: ["Tabesiz mürəkkəb cümlə", "Tabeli mürəkkəb cümlə", "Tabeli mürəkkəb cümlənin növləri",
        "Vasitəsiz və vasitəli nitq", "Durğu işarələri sistemi", "Sintaktik təhlil"],
    9: ["Üslubiyyat: bədii üslub", "Elmi üslub", "Publisistik üslub", "Rəsmi-işgüzar üslub",
        "Mətn linqvistikası", "Arxaizmlər və neologizmlər", "Frazeologiya", "Leksikoqrafiya"],
    10: ["Azərbaycan dilinin tarixi", "Türk dilləri ailəsi", "Ədəbi dilin normaları",
         "Alınma sözlər", "Söz yaradıcılığı", "Terminologiya", "Üslubi fiqurlar"],
    11: ["Dilçiliyin sahələri", "Fonetik qanunauyğunluqlar", "İltisaqilik", "Sintaktik fiqurlar",
         "Leksik kateqoriyalar", "Natiqlik sənəti", "Media savadlılığı"],
}

DINLEME_SITUASIYALAR = {
    6: ["xəbər reportajı", "radio verilişi", "müəllim mühazirəsi", "sənədli film fraqmenti"],
    7: ["elmi-populyar çıxış", "tarixi sənəd oxunuşu", "debat dinləmə", "konfrans məruzəsi"],
    8: ["arxiv audio yazısı", "analitik proqram", "mühazirə", "ekspert müsahibəsi"],
    9: ["akademik məruzə", "polemik çıxış", "media təhlili", "fəlsəfi diskussiya"],
    10: ["konfrans çıxışı", "elmi seminar", "ictimai forum", "natiqlik nümunəsi"],
    11: ["parlament debatı", "akademik diskurs", "fəlsəfi mühazirə", "tənqidi media təhlili"],
}

YAZI_TAPSHIRIQLARI = {
    6: ["esse", "xülasə", "təlimat", "məruzə tezisləri", "rəy yazısı"],
    7: ["izahedici mətn", "arqumentativ yazı", "qaydalar siyahısı", "tezis", "referat"],
    8: ["kitab icmalı", "mühakimə essesi", "ərizə", "protokol", "təqdimat"],
    9: ["analitik esse", "CV", "motivasiya məktubu", "resenziya", "müqayisəli təhlil"],
    10: ["tənqidi esse", "rəsmi məktub", "mənbə təhlili", "layihə təklifi", "annotasiya"],
    11: ["polemik esse", "elmi məqalə planı", "protokol", "media təhlili", "disputa hazırlıq"],
}

def make_topics_for_grade(sinif_str):
    """Bir sinif üçün bütün standartlara 2 mövzu yarat."""
    s = int(sinif_str)
    stds = standards[sinif_str]
    topics = []

    eserler = EDEBI_ESERLER.get(s, ["mətn nümunəsi"])
    qram = QRAMMATIKA_MOVZULARI.get(s, ["qrammatika mövzusu"])
    dinl = DINLEME_SITUASIYALAR.get(s, ["dinləmə mətni"])
    yazi = YAZI_TAPSHIRIQLARI.get(s, ["yazı tapşırığı"])

    eser_idx = 0
    qram_idx = 0
    dinl_idx = 0
    yazi_idx = 0

    for std in stds:
        kod = std["kod"]
        sahe = std["sahe"]
        metn = std["metn"]

        # Standart mətnindən qısa versiya
        metn_qisa = metn[:55].rstrip(" .")
        if len(metn) > 55:
            # Son tam sözə qədər kəs
            last_space = metn_qisa.rfind(" ")
            if last_space > 30:
                metn_qisa = metn_qisa[:last_space]

        # Sahəyə görə kontekstual mövzu adları
        if sahe == "Dinləmə və danışma":
            sit = dinl[dinl_idx % len(dinl)]
            dinl_idx += 1
            eser = eserler[eser_idx % len(eserler)]
            eser_idx += 1

            parts = kod.split("-")[1].split(".")
            esas = int(parts[1]) if len(parts) > 1 else 1

            if esas == 1:  # anlama/şərh
                t1 = f"{eser} — dinlə və {metn_qisa.lower().split('dinlədiyi')[-1].strip() if 'dinlədiyi' in metn_qisa.lower() else 'məzmunu müzakirə et'}"
                t2 = f"{sit.capitalize()} dinləmə: əsas fikirləri qeyd et"
            elif esas == 2:  # müzakirə/debat
                t1 = f"Müzakirə: {eser} əsasında — {metn_qisa.lower().split('müzakirə')[-1].strip() if 'müzakirə' in metn_qisa.lower() else 'fikir mübadiləsi'}"
                t2 = f"Sinif debatı: «{eserler[(eser_idx+1) % len(eserler)].strip('«»')}» mövzusunda"
            elif esas == 3:  # təqdimat/nəql
                t1 = f"Şifahi təqdimat: {eser} əsəri haqqında"
                t2 = f"Mövzu üzrə çıxış hazırla və nəql et"
            else:  # nitq normaları
                t1 = f"Nitq mədəniyyəti: düzgün tələffüz və intonasiya məşqi"
                t2 = f"İfadəli danışma: {eser} parçasını təqdim et"

            # Qısa və konkretsizliyi aradan qaldır
            t1 = t1[:90]
            t2 = t2[:90]

            page_base = 6 + (dinl_idx * 4) % 50
            topics.append({"ad": t1, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base}-{page_base+6}"})
            topics.append({"ad": t2, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base+7}-{page_base+12}"})

        elif sahe == "Oxu":
            eser = eserler[eser_idx % len(eserler)]
            eser_idx += 1
            eser2 = eserler[(eser_idx) % len(eserler)]

            parts = kod.split("-")[1].split(".")
            esas = int(parts[1]) if len(parts) > 1 else 1

            if esas == 1:  # oxu bacarığı
                t1 = f"{eser} — ifadəli oxu və məzmun anlama"
                t2 = f"Kontekstdən söz mənasını müəyyən et: {eser2} mətni"
            elif esas == 2:  # anlama/təhlil
                t1 = f"{eser} oxusu: fakt və fikir əlaqəsini müəyyən et"
                t2 = f"Sətiraltı məna: {eser2} mətnində gizli informasiya"
            else:  # qiymətləndirmə
                t1 = f"{eser} — dil-üslub təhlili və bədii vasitələr"
                t2 = f"Müqayisəli oxu: {eser} və {eser2}"

            t1 = t1[:90]
            t2 = t2[:90]

            page_base = 30 + (eser_idx * 5) % 60
            topics.append({"ad": t1, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base}-{page_base+6}"})
            topics.append({"ad": t2, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base+7}-{page_base+12}"})

        elif sahe == "Yazı":
            tap = yazi[yazi_idx % len(yazi)]
            yazi_idx += 1
            eser = eserler[eser_idx % len(eserler)]

            parts = kod.split("-")[1].split(".")
            esas = int(parts[1]) if len(parts) > 1 else 1

            if esas == 1:  # yazı normaları
                t1 = f"Yazı strukturu: {metn_qisa.lower()}"
                t2 = f"Redaktə məşqi: yazını dil normaları baxımından təkmilləşdir"
            else:  # yaradıcılıq
                t1 = f"{tap.capitalize()} yazma: {eser} əsasında"
                t2 = f"Yaradıcı yazı: {metn_qisa.lower()}"

            t1 = t1[:90]
            t2 = t2[:90]

            page_base = 60 + (yazi_idx * 4) % 30
            topics.append({"ad": t1, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base}-{page_base+6}"})
            topics.append({"ad": t2, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base+7}-{page_base+12}"})

        elif sahe == "Dil qaydaları":
            qr = qram[qram_idx % len(qram)]
            qram_idx += 1
            eser = eserler[eser_idx % len(eserler)]

            parts = kod.split("-")[1].split(".")
            esas = int(parts[1]) if len(parts) > 1 else 1

            if esas == 1:  # orfoqrafiya
                t1 = f"{qr}: {metn_qisa.lower()}"
                t2 = f"Orfoqrafiya məşqi: {qr.lower()} — tapşırıqlar"
            elif esas == 2:  # morfologiya/sintaksis
                t1 = f"{qr}: {metn_qisa.lower()}"
                t2 = f"{qr} — {eser} mətnindən nümunələrlə"
            elif esas == 3:  # durğu işarələri
                t1 = f"Durğu işarələri: {metn_qisa.lower()}"
                t2 = f"Punktuasiya məşqi: {eser} mətnində durğu işarələri"
            else:  # leksika
                t1 = f"Leksika: {metn_qisa.lower()}"
                t2 = f"Söz təhlili: {eser} mətnindən nümunələr"

            t1 = t1[:90]
            t2 = t2[:90]

            page_base = 84 + (qram_idx * 4) % 40
            topics.append({"ad": t1, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base}-{page_base+6}"})
            topics.append({"ad": t2, "standard_kodu": kod, "sahe": sahe, "saat": 1, "sehife": f"{page_base+7}-{page_base+12}"})

    return topics


# ============================================================
# Sinif 1-2 üçün əllə yazılmış data (generate_topics.py-dən)
# ============================================================
# Əvvəlki skriptdən SINIF1 və SINIF2-ni import et
exec(open('scripts/generate_topics.py').read().split('# Sinif 1 və 2 əllə yazılıb')[0])
# TOPICS dict-i artıq mövcuddur, sinif 1 və 2 daxildir

# ============================================================
# Hamısını birləşdir
# ============================================================
output = {}

# Sinif 1 və 2 — əvvəlki skriptdən
output["1"] = TOPICS["1"]
output["2"] = TOPICS["2"]

# Sinif 3-5 — əllə yazılmış
output["3"] = SINIF3
output["4"] = SINIF4
output["5"] = SINIF5

# Sinif 6-11 — kontekstual generator
for sinif in range(6, 12):
    output[str(sinif)] = make_topics_for_grade(str(sinif))

# Statistika
total = sum(len(v) for v in output.values())
print(f"Ümumi mövzu sayı: {total}")
for s in sorted(output.keys(), key=int):
    std_count = len(standards[s])
    topic_count = len(output[s])
    ratio = topic_count / std_count if std_count else 0
    print(f"  Sinif {s}: {topic_count} mövzu / {std_count} standart = {ratio:.1f}x")

# Yaz
with open('r_shiny/app/derslikler/topics.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

print(f"\ntopics.json yazıldı! ({total} mövzu)")
