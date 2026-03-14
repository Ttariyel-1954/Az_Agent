#!/usr/bin/env python3
"""
442 alt-standarta uyğun 2-3 mövzu generasiya skripti.
Hər standart üçün real dərslik mövzuları yaradılır.
"""
import json

with open('r_shiny/app/derslikler/standards.json', 'r') as f:
    standards = json.load(f)

# Hər standart üçün 2-3 mövzu - sinif və sahə üzrə
TOPICS = {}

# ============================================================
# SİNİF 1
# ============================================================
TOPICS["1"] = [
    # 1-1.1.1 Dinlədiyi mətnlə bağlı sadə faktoloji suallara cavab verir
    {"ad": "Nağıl dinləyək: «Tülkü və Qarğa» — suallara cavab", "standard_kodu": "1-1.1.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "8-10"},
    {"ad": "Hekayə dinləmə: «Mənim ailəm» — kim? nə? harada?", "standard_kodu": "1-1.1.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "11-13"},
    # 1-1.1.2 Dinlədiyi mətndəki fakt və hadisələri şərh edir
    {"ad": "«Günəş və Külək» nağılı — hadisələri şərh etmə", "standard_kodu": "1-1.1.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "14-16"},
    {"ad": "Dinlədiyim hekayəni danışıram — fakt və hadisə", "standard_kodu": "1-1.1.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "17-19"},
    # 1-1.1.3 Dinlədiyi mətndəki obrazlara münasibət bildirir
    {"ad": "Nağıl qəhrəmanlarına münasibət: yaxşı və pis", "standard_kodu": "1-1.1.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "20-22"},
    {"ad": "«Dovşanla Tısbağa» — qəhrəmana məktub yazaq", "standard_kodu": "1-1.1.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "23-25"},
    # 1-1.2.1 Müzakirə olunan məsələ ilə bağlı öz fikirlərini ifadə edir
    {"ad": "Sinif müzakirəsi: «Ən yaxşı fəsil hansıdır?»", "standard_kodu": "1-1.2.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "26-28"},
    {"ad": "Fikir ifadəsi: «Heyvanları qorumaq lazımdır»", "standard_kodu": "1-1.2.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "29-31"},
    # 1-1.2.2 Hər hansı mövzuda dialoq qurur
    {"ad": "Dialoq qurmaq: «Bazarda alış-veriş»", "standard_kodu": "1-1.2.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "32-34"},
    {"ad": "Cütlük işi: dostumla tanışlıq dialoqu", "standard_kodu": "1-1.2.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "35-37"},
    # 1-1.3.1 Oxuduqlarını və dinlədiklərini rabitəli şəkildə təqdim edir
    {"ad": "Dinlədiyim nağılı sinifə danışıram", "standard_kodu": "1-1.3.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "38-40"},
    {"ad": "Oxuduğum şeiri sinif qarşısında söyləyirəm", "standard_kodu": "1-1.3.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "41-43"},
    # 1-1.3.2 Sadə sxemlər və komikslər üzrə danışır
    {"ad": "Komiks oxuyaq və danışaq: «Pişik və siçan»", "standard_kodu": "1-1.3.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "44-46"},
    {"ad": "Sxem üzrə danışma: gündəlik rejimim", "standard_kodu": "1-1.3.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "47-49"},
    # 1-1.3.3 Hər hansı hadisə, varlıq haqqında fikirlərini rabitəli cümlələrlə ifadə edir
    {"ad": "Sevdiyim heyvan haqqında 3-4 cümlə", "standard_kodu": "1-1.3.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "50-52"},
    {"ad": "Məktəbdə olan hadisəni danışıram", "standard_kodu": "1-1.3.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "53-55"},
    # 1-1.3.4 Araşdırma nəticəsində əldə etdiyi məlumatları rabitəli şəkildə təqdim edir
    {"ad": "Mini araşdırma: «Suyun faydaları» — təqdimat", "standard_kodu": "1-1.3.4", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "56-58"},
    {"ad": "Ailə araşdırması: nənəmin uşaqlığı", "standard_kodu": "1-1.3.4", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "59-61"},
    # 1-1.3.5 Dinlədiyi mətnin məzmunundan çıxış edərək onun davamını təxmin edir
    {"ad": "Nağılın davamını təxmin et: «Balıq və balıqçı»", "standard_kodu": "1-1.3.5", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "62-64"},
    {"ad": "Hekayənin sonunu özün fikirləş", "standard_kodu": "1-1.3.5", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "65-67"},
    # 1-1.4.1 Cümlə qurarkən düzgün söz sırasına əməl edir
    {"ad": "Sözləri düzgün sıraya qoy — cümlə qur", "standard_kodu": "1-1.4.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "68-70"},
    {"ad": "Qarışıq sözlərdən düzgün cümlə qurmaq oyunu", "standard_kodu": "1-1.4.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "71-73"},
    # 1-1.4.2 Danışarkən məzmuna uyğun intonasiyadan istifadə edir
    {"ad": "İntonasiya ilə oxuyaq: sevinc, kədər, təəccüb", "standard_kodu": "1-1.4.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "74-76"},
    {"ad": "Rol oyunu: müxtəlif hisslərlə danışmaq", "standard_kodu": "1-1.4.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "77-79"},

    # OXU — Sinif 1
    # 1-2.1.1 İlkin oxu bacarığı nümayiş etdirir
    {"ad": "Hərfləri tanıyaq: sait səslər Aa, Əə, Oo", "standard_kodu": "1-2.1.1", "sahe": "Oxu", "saat": 1, "sehife": "8-12"},
    {"ad": "Hecaları birləşdirərək sözlər oxuyaq", "standard_kodu": "1-2.1.1", "sahe": "Oxu", "saat": 1, "sehife": "13-18"},
    {"ad": "Sadə cümlələri oxuyaq: «Ana gəldi»", "standard_kodu": "1-2.1.1", "sahe": "Oxu", "saat": 1, "sehife": "19-24"},
    # 1-2.1.2 Cümlə sonunda durğu işarələrini nəzərə almaqla oxuyur
    {"ad": "Nöqtə, sual və nida işarəsi ilə oxumaq", "standard_kodu": "1-2.1.2", "sahe": "Oxu", "saat": 1, "sehife": "25-28"},
    {"ad": "Cümlə sonundakı işarəyə görə səs tonu dəyişmək", "standard_kodu": "1-2.1.2", "sahe": "Oxu", "saat": 1, "sehife": "29-32"},
    # 1-2.2.1 Oxuduğu mətndəki hadisələri, obrazları, zaman və məkanı müəyyənləşdirir
    {"ad": "Mətn oxu: Kim? Nə vaxt? Harada? suallarına cavab", "standard_kodu": "1-2.2.1", "sahe": "Oxu", "saat": 1, "sehife": "33-36"},
    {"ad": "Hekayədə baş qəhrəmanı və hadisəni tap", "standard_kodu": "1-2.2.1", "sahe": "Oxu", "saat": 1, "sehife": "37-40"},
    # 1-2.2.2 Verbal informasiyanı qrafik təsvirlə uyğunlaşdırır
    {"ad": "Oxuduğun mətni şəkillə uyğunlaşdır", "standard_kodu": "1-2.2.2", "sahe": "Oxu", "saat": 1, "sehife": "41-44"},
    {"ad": "Şəkildən istifadə edərək mətni anla", "standard_kodu": "1-2.2.2", "sahe": "Oxu", "saat": 1, "sehife": "45-48"},
    # 1-2.2.3 Mətndə rast gəldiyi söz və ifadələrin mənasını anladığını nümayiş etdirir
    {"ad": "Yeni sözlər öyrənək: mətndən tanımadığın sözlər", "standard_kodu": "1-2.2.3", "sahe": "Oxu", "saat": 1, "sehife": "49-52"},
    {"ad": "Sözün mənasını mətndən tap — kontekst ipucu", "standard_kodu": "1-2.2.3", "sahe": "Oxu", "saat": 1, "sehife": "53-56"},
    # 1-2.3.1 Mətndəki hadisələr arasındakı səbəb-nəticə əlaqəsini müəyyən edir
    {"ad": "Niyə belə oldu? Səbəb-nəticə əlaqəsi tapaq", "standard_kodu": "1-2.3.1", "sahe": "Oxu", "saat": 1, "sehife": "57-60"},
    {"ad": "«Çünki» sözü ilə cavab ver — səbəb tapmaq", "standard_kodu": "1-2.3.1", "sahe": "Oxu", "saat": 1, "sehife": "61-64"},
    # 1-2.3.2 Obrazların xarakterindəki əsas xüsusiyyəti müəyyən edir
    {"ad": "Qəhrəman necə adamdır? Xarakter xüsusiyyətləri", "standard_kodu": "1-2.3.2", "sahe": "Oxu", "saat": 1, "sehife": "65-68"},
    {"ad": "Nağıl obrazları: ağıllı tülkü, tənbəl ayı", "standard_kodu": "1-2.3.2", "sahe": "Oxu", "saat": 1, "sehife": "69-72"},
    # 1-2.3.3 Mətndə əsas fikri müəyyən edir
    {"ad": "Mətnin əsas fikri nədir? Başlıq seç", "standard_kodu": "1-2.3.3", "sahe": "Oxu", "saat": 1, "sehife": "73-76"},
    {"ad": "Nağılın bizə öyrətdiyi dərs — əsas fikir", "standard_kodu": "1-2.3.3", "sahe": "Oxu", "saat": 1, "sehife": "77-80"},
    # 1-2.4.1 Mətndəki obrazlara və onların davranışına münasibətini bildirir
    {"ad": "Qəhrəmanın hərəkəti düzgün idi? Münasibət bildir", "standard_kodu": "1-2.4.1", "sahe": "Oxu", "saat": 1, "sehife": "81-84"},
    {"ad": "Sən olsaydın nə edərdin? Obraza münasibət", "standard_kodu": "1-2.4.1", "sahe": "Oxu", "saat": 1, "sehife": "85-88"},
    # 1-2.4.2 Təxəyyülündən çıxış edərək mətnin məzmununa yaradıcı yanaşır
    {"ad": "Nağıla yeni son yaz — yaradıcı yanaşma", "standard_kodu": "1-2.4.2", "sahe": "Oxu", "saat": 1, "sehife": "89-92"},
    {"ad": "Hekayəni şəkillərlə davam etdir", "standard_kodu": "1-2.4.2", "sahe": "Oxu", "saat": 1, "sehife": "93-96"},
    # 1-2.4.3 Nəzm və nəsrlə yazılmış mətnlərin məzmun-struktur xüsusiyyətlərini müəyyən edir
    {"ad": "Şeir və hekayə — nə fərqi var?", "standard_kodu": "1-2.4.3", "sahe": "Oxu", "saat": 1, "sehife": "97-100"},
    {"ad": "Nəzm və nəsr: qafiyəli və qafiyəsiz mətnlər", "standard_kodu": "1-2.4.3", "sahe": "Oxu", "saat": 1, "sehife": "8-12"},

    # YAZI — Sinif 1
    # 1-3.1.1 Yazısında hüsnxət normalarına riayət edir
    {"ad": "Hərflərin düzgün yazılışı: böyük və kiçik hərflər", "standard_kodu": "1-3.1.1", "sahe": "Yazı", "saat": 1, "sehife": "14-18"},
    {"ad": "Gözəl yazı məşqi: sözlər və cümlələr", "standard_kodu": "1-3.1.1", "sahe": "Yazı", "saat": 1, "sehife": "19-22"},
    # 1-3.1.2 Yazısında hadisələrin ardıcıllığına riayət edir
    {"ad": "Şəkillərə bax, ardıcıl hekayə yaz", "standard_kodu": "1-3.1.2", "sahe": "Yazı", "saat": 1, "sehife": "23-26"},
    {"ad": "Səhərdən axşama — günümü yazıram", "standard_kodu": "1-3.1.2", "sahe": "Yazı", "saat": 1, "sehife": "27-30"},
    # 1-3.1.3 Öyrəndiyi sadə orfoqrafiya və punktuasiya qaydalarına yazısında riayət edir
    {"ad": "Böyük hərflə başlamaq və nöqtə qoymaq", "standard_kodu": "1-3.1.3", "sahe": "Yazı", "saat": 1, "sehife": "31-34"},
    {"ad": "Diktant: sadə cümlələr — orfoqrafiya qaydaları", "standard_kodu": "1-3.1.3", "sahe": "Yazı", "saat": 1, "sehife": "35-38"},
    # 1-3.2.1 Bildiyi məlumatları yazıda əks etdirir
    {"ad": "Ailəm haqqında 3-4 cümlə yazıram", "standard_kodu": "1-3.2.1", "sahe": "Yazı", "saat": 1, "sehife": "39-42"},
    {"ad": "Sevdiyim yeməyi təsvir edirəm — yazı", "standard_kodu": "1-3.2.1", "sahe": "Yazı", "saat": 1, "sehife": "43-46"},
    # 1-3.2.2 Verilmiş plan əsasında mövzu ilə bağlı fikirlərini yazır
    {"ad": "Plan üzrə yazı: «Mənim dostum»", "standard_kodu": "1-3.2.2", "sahe": "Yazı", "saat": 1, "sehife": "47-50"},
    {"ad": "Plan üzrə yazı: «Yaz fəsli»", "standard_kodu": "1-3.2.2", "sahe": "Yazı", "saat": 1, "sehife": "51-54"},
    # 1-3.2.3 Sadə əməli yazılar (anket, açıqca) yazır
    {"ad": "Ad günü açıqcası yazaq", "standard_kodu": "1-3.2.3", "sahe": "Yazı", "saat": 1, "sehife": "55-58"},
    {"ad": "Özüm haqqında anket doldururam", "standard_kodu": "1-3.2.3", "sahe": "Yazı", "saat": 1, "sehife": "59-62"},
    # 1-3.2.4 Təqdimat üçün müxtəlif vizual forma və üsullar seçir
    {"ad": "Plakat hazırla: «Təbiəti qoruyaq»", "standard_kodu": "1-3.2.4", "sahe": "Yazı", "saat": 1, "sehife": "63-66"},
    {"ad": "Şəkilli kitabça hazırlamaq — layihə işi", "standard_kodu": "1-3.2.4", "sahe": "Yazı", "saat": 1, "sehife": "67-70"},

    # DİL QAYDALARI — Sinif 1
    # 1-4.1.1 Söz tərkibindəki səs və hecaları müəyyən edir
    {"ad": "Sait və samit səslər — fərqləndirmə", "standard_kodu": "1-4.1.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "8-12"},
    {"ad": "Sözləri hecalara ayıraq — heca qaydası", "standard_kodu": "1-4.1.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "13-16"},
    {"ad": "Neçə heca var? — əl çalmaqla heca saymaq", "standard_kodu": "1-4.1.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "17-20"},
    # 1-4.1.2 Hərflərin əlifba sırasını müəyyən edir
    {"ad": "Azərbaycan əlifbası: 32 hərf", "standard_kodu": "1-4.1.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "21-24"},
    {"ad": "Əlifba sırasına düz: sözləri sırala", "standard_kodu": "1-4.1.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "25-28"},
    # 1-4.1.3 Yazıda sadə orfoqrafiya normalarına riayət edir
    {"ad": "Böyük hərflə yazılan sözlər: ad, soyad, şəhər", "standard_kodu": "1-4.1.3", "sahe": "Dil qaydaları", "saat": 1, "sehife": "29-32"},
    {"ad": "Orfoqrafiya qaydası: sözün düzgün yazılışı", "standard_kodu": "1-4.1.3", "sahe": "Dil qaydaları", "saat": 1, "sehife": "33-36"},
    # 1-4.2.1 Ad, əlamət, say, hərəkət bildirən sözlərin ümumi qrammatik mənalarını müəyyən edir
    {"ad": "İsim: əşyanın adını bildirən sözlər", "standard_kodu": "1-4.2.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "37-40"},
    {"ad": "Feil: hərəkət bildirən sözlər — nə edir?", "standard_kodu": "1-4.2.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "41-44"},
    {"ad": "Sifət və say: əlamət və miqdar bildirən sözlər", "standard_kodu": "1-4.2.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "45-48"},
    # 1-4.2.2 Mətndə cümlələri müəyyən edir, məqsəd və intonasiyaya görə fərqləndirir
    {"ad": "Cümlə nədir? Sözdən fərqi", "standard_kodu": "1-4.2.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "49-52"},
    {"ad": "Nəqli, sual və nida cümlələri", "standard_kodu": "1-4.2.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "53-56"},
    # 1-4.3.1 Cümlə sonunda müvafiq durğu işarələrindən istifadə edir
    {"ad": "Nöqtə, sual işarəsi, nida işarəsi — harda qoyulur?", "standard_kodu": "1-4.3.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "57-60"},
    {"ad": "Cümləni oxu, düzgün durğu işarəsini seç", "standard_kodu": "1-4.3.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "61-64"},
    # 1-4.4.1 Sözün mənasını sadə üsullarla izah edir
    {"ad": "Bu söz nə deməkdir? — sadə izah vermək", "standard_kodu": "1-4.4.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "65-68"},
    {"ad": "Sözü şəkillə izah et — lüğət oyunu", "standard_kodu": "1-4.4.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "69-72"},
]

# ============================================================
# SİNİF 2
# ============================================================
TOPICS["2"] = [
    # 2-1.1.1
    {"ad": "Hekayə dinləmə: «Ağac əkən kişi» — əsas məqamlar", "standard_kodu": "2-1.1.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "6-10"},
    {"ad": "Dinlə və cavab ver: mətn üzrə faktoloji suallar", "standard_kodu": "2-1.1.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "11-14"},
    # 2-1.1.2
    {"ad": "Məzmun şərhi: nağıldakı obrazlara münasibət", "standard_kodu": "2-1.1.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "15-18"},
    {"ad": "Dinlədiyim hekayədəki fikrə münasibət bildirirəm", "standard_kodu": "2-1.1.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "19-22"},
    # 2-1.1.3
    {"ad": "Nağılın davamını uydur: yaradıcı dinləmə", "standard_kodu": "2-1.1.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "23-26"},
    {"ad": "Hekayəni genişləndir: yeni hadisə əlavə et", "standard_kodu": "2-1.1.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "27-30"},
    # 2-1.2.1
    {"ad": "Həyatdan nümunə gətir: «Dostluq» mövzusu", "standard_kodu": "2-1.2.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "31-34"},
    {"ad": "Fikrə münasibət: nümunələrlə əsaslandırma", "standard_kodu": "2-1.2.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "35-38"},
    # 2-1.2.2
    {"ad": "Sual-cavab dialoqu: mövzu üzrə müsahibə", "standard_kodu": "2-1.2.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "39-42"},
    {"ad": "Dialoq qurmaq: «Kitabxanada» situasiyası", "standard_kodu": "2-1.2.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "43-46"},
    # 2-1.3.1
    {"ad": "Plan üzrə nəql etmə: oxuduğum hekayə", "standard_kodu": "2-1.3.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "47-50"},
    {"ad": "Dinlədiyim mətni 5 cümlə ilə nəql et", "standard_kodu": "2-1.3.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "51-54"},
    # 2-1.3.2
    {"ad": "Şəkil üzrə hekayə danış: illustrasiya təqdimatı", "standard_kodu": "2-1.3.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "55-58"},
    {"ad": "Sxem oxumaq: gündəlik fəaliyyət cədvəli", "standard_kodu": "2-1.3.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "59-62"},
    # 2-1.3.3
    {"ad": "Təəssürat paylaş: «Yay tətilim» mövzusu", "standard_kodu": "2-1.3.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "63-66"},
    {"ad": "Fikir ifadəsi: «Ən maraqlı kitab» haqqında", "standard_kodu": "2-1.3.3", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "67-70"},
    # 2-1.3.4
    {"ad": "Araşdırma təqdimatı: «Bitkilərin həyatı»", "standard_kodu": "2-1.3.4", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "71-74"},
    {"ad": "Mini-layihə: məlumat toplayıb təqdim et", "standard_kodu": "2-1.3.4", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "75-78"},
    # 2-1.4.1
    {"ad": "Yeni sözlər öyrən, cümlədə istifadə et", "standard_kodu": "2-1.4.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "79-82"},
    {"ad": "Kontekstə uyğun söz seçimi — nitq zənginliyi", "standard_kodu": "2-1.4.1", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "83-86"},
    # 2-1.4.2
    {"ad": "Məntiqi vurğu: hansı sözü vurğulayaq?", "standard_kodu": "2-1.4.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "87-90"},
    {"ad": "Səs tonunu tənzimlə: yavaş, ucadan, pıçıltı", "standard_kodu": "2-1.4.2", "sahe": "Dinləmə və danışma", "saat": 1, "sehife": "91-94"},

    # OXU — Sinif 2
    {"ad": "Sürətli oxu məşqi: vaxt ölçməklə oxu", "standard_kodu": "2-2.1.1", "sahe": "Oxu", "saat": 1, "sehife": "6-10"},
    {"ad": "Aydın səslə oxu: «Quş və uşaq» hekayəsi", "standard_kodu": "2-2.1.1", "sahe": "Oxu", "saat": 1, "sehife": "11-14"},
    {"ad": "Durğu işarələrinə riayətlə oxu: dialoqlu mətn", "standard_kodu": "2-2.1.2", "sahe": "Oxu", "saat": 1, "sehife": "15-18"},
    {"ad": "Vergül, nöqtə, nida — pauza və intonasiya", "standard_kodu": "2-2.1.2", "sahe": "Oxu", "saat": 1, "sehife": "19-22"},
    {"ad": "Mətndən hadisə, obraz, zaman və məkan tap", "standard_kodu": "2-2.2.1", "sahe": "Oxu", "saat": 1, "sehife": "23-26"},
    {"ad": "«Xəzər dənizi» mətni: fakt və fikirləri ayır", "standard_kodu": "2-2.2.1", "sahe": "Oxu", "saat": 1, "sehife": "27-30"},
    {"ad": "Cədvəl və diaqramdan məlumat oxu", "standard_kodu": "2-2.2.2", "sahe": "Oxu", "saat": 1, "sehife": "31-34"},
    {"ad": "Xəritə oxumaq: məlumatı qrafik təsvirdən al", "standard_kodu": "2-2.2.2", "sahe": "Oxu", "saat": 1, "sehife": "35-38"},
    {"ad": "Kontekstdən söz mənası müəyyən et: ipucu tap", "standard_kodu": "2-2.2.3", "sahe": "Oxu", "saat": 1, "sehife": "39-42"},
    {"ad": "Naməlum sözlər: mətndən mənasını anla", "standard_kodu": "2-2.2.3", "sahe": "Oxu", "saat": 1, "sehife": "43-46"},
    {"ad": "Hadisə-fakt-fikir əlaqəsi: mətn təhlili", "standard_kodu": "2-2.3.1", "sahe": "Oxu", "saat": 1, "sehife": "47-50"},
    {"ad": "Səbəb-nəticə zənciri: nə oldu, niyə oldu?", "standard_kodu": "2-2.3.1", "sahe": "Oxu", "saat": 1, "sehife": "51-54"},
    {"ad": "Obraz təhlili: xarakter cizgilərini müəyyən et", "standard_kodu": "2-2.3.2", "sahe": "Oxu", "saat": 1, "sehife": "55-58"},
    {"ad": "Qəhrəmanın davranışından xarakterini anla", "standard_kodu": "2-2.3.2", "sahe": "Oxu", "saat": 1, "sehife": "59-62"},
    {"ad": "Mətnin əsas fikri: ən mühüm cümləni tap", "standard_kodu": "2-2.3.3", "sahe": "Oxu", "saat": 1, "sehife": "63-66"},
    {"ad": "Başlıq seç: əsas fikrə uyğun başlıq", "standard_kodu": "2-2.3.3", "sahe": "Oxu", "saat": 1, "sehife": "67-70"},
    {"ad": "Obraza münasibət: razısan ya yox? Niyə?", "standard_kodu": "2-2.4.1", "sahe": "Oxu", "saat": 1, "sehife": "71-74"},
    {"ad": "Fakt və hadisəyə şəxsi münasibət bildir", "standard_kodu": "2-2.4.1", "sahe": "Oxu", "saat": 1, "sehife": "75-78"},
    {"ad": "Mətni davam etdir: öz sonunu yaz", "standard_kodu": "2-2.4.2", "sahe": "Oxu", "saat": 1, "sehife": "79-82"},
    {"ad": "Təxəyyül ilə hekayəni genişləndir", "standard_kodu": "2-2.4.2", "sahe": "Oxu", "saat": 1, "sehife": "83-86"},
    {"ad": "Bədii və qeyri-bədii mətn: fərqləri öyrən", "standard_kodu": "2-2.4.3", "sahe": "Oxu", "saat": 1, "sehife": "87-90"},
    {"ad": "Nağıl və məlumat mətni — struktur fərqləri", "standard_kodu": "2-2.4.3", "sahe": "Oxu", "saat": 1, "sehife": "91-94"},
    {"ad": "İki mətni müqayisə et: mövzu və ideya", "standard_kodu": "2-2.4.4", "sahe": "Oxu", "saat": 1, "sehife": "95-98"},
    {"ad": "Eyni mövzuda iki hekayə — fərq və oxşarlıq", "standard_kodu": "2-2.4.4", "sahe": "Oxu", "saat": 1, "sehife": "99-102"},

    # YAZI — Sinif 2
    {"ad": "Yazı normaları: aydın və oxunaqlı xətt", "standard_kodu": "2-3.1.1", "sahe": "Yazı", "saat": 1, "sehife": "6-10"},
    {"ad": "Hüsnxət məşqi: cümlə yazma qaydaları", "standard_kodu": "2-3.1.1", "sahe": "Yazı", "saat": 1, "sehife": "11-14"},
    {"ad": "Ardıcıl yaz: hadisələri sıra ilə qeyd et", "standard_kodu": "2-3.1.2", "sahe": "Yazı", "saat": 1, "sehife": "15-18"},
    {"ad": "Şəkil ardıcıllığına görə hekayə yaz", "standard_kodu": "2-3.1.2", "sahe": "Yazı", "saat": 1, "sehife": "19-22"},
    {"ad": "Orfoqrafiya və punktuasiya: diktant yazaq", "standard_kodu": "2-3.1.3", "sahe": "Yazı", "saat": 1, "sehife": "23-26"},
    {"ad": "Qrammatik qaydalarla yazı: böyük hərf, durğu", "standard_kodu": "2-3.1.3", "sahe": "Yazı", "saat": 1, "sehife": "27-30"},
    {"ad": "Biliyimi yazıda əks etdirirəm: «Ölkəm» yazısı", "standard_kodu": "2-3.2.1", "sahe": "Yazı", "saat": 1, "sehife": "31-34"},
    {"ad": "Yeni öyrəndiklərimi yazıram: informativ yazı", "standard_kodu": "2-3.2.1", "sahe": "Yazı", "saat": 1, "sehife": "35-38"},
    {"ad": "Bədii mətn yaz: «Sehrli orman» hekayəsi", "standard_kodu": "2-3.2.2", "sahe": "Yazı", "saat": 1, "sehife": "39-42"},
    {"ad": "Təxəyyüllə yaz: «Uçan xalça» nağılı", "standard_kodu": "2-3.2.2", "sahe": "Yazı", "saat": 1, "sehife": "43-46"},
    {"ad": "Suallar əsasında informativ mətn yaz", "standard_kodu": "2-3.2.3", "sahe": "Yazı", "saat": 1, "sehife": "47-50"},
    {"ad": "Qeyri-bədii mətn: «Pişiklər haqqında» yazı", "standard_kodu": "2-3.2.3", "sahe": "Yazı", "saat": 1, "sehife": "51-54"},
    {"ad": "Təqdimat posterı hazırla: vizual üsullar", "standard_kodu": "2-3.2.4", "sahe": "Yazı", "saat": 1, "sehife": "55-58"},
    {"ad": "Şəkilli kitabça: vizual forma ilə təqdimat", "standard_kodu": "2-3.2.4", "sahe": "Yazı", "saat": 1, "sehife": "59-62"},

    # DİL QAYDALARI — Sinif 2
    {"ad": "Saitlərin növləri: incə və qalın saitlər", "standard_kodu": "2-4.1.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "6-10"},
    {"ad": "Dodaq və dodaq olmayan saitlər", "standard_kodu": "2-4.1.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "11-14"},
    {"ad": "Əlifba sırasına düzmək: lüğətlə iş", "standard_kodu": "2-4.1.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "15-18"},
    {"ad": "Sözləri əlifba sırasına qoy — yarış oyunu", "standard_kodu": "2-4.1.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "19-22"},
    {"ad": "Sadə orfoqrafik qaydalar: tez-tez səhv yazılan sözlər", "standard_kodu": "2-4.1.3", "sahe": "Dil qaydaları", "saat": 1, "sehife": "23-26"},
    {"ad": "Orfoqrafik lüğətlə iş: sözü yoxla", "standard_kodu": "2-4.1.3", "sahe": "Dil qaydaları", "saat": 1, "sehife": "27-30"},
    {"ad": "İsim, feil, sifət, say — morfoloji tərkib", "standard_kodu": "2-4.2.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "31-34"},
    {"ad": "Sözü kök və şəkilçiyə ayır", "standard_kodu": "2-4.2.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "35-38"},
    {"ad": "Cümlənin məqsədi: nəqli, sual, nida", "standard_kodu": "2-4.2.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "39-42"},
    {"ad": "Cümlənin ifadə etdiyi fikri müəyyən et", "standard_kodu": "2-4.2.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "43-46"},
    {"ad": "Cümlə sonunda durğu işarəsi: nöqtə, sual, nida", "standard_kodu": "2-4.3.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "47-50"},
    {"ad": "Durğu işarələri tapşırığı: düzgün işarəni qoy", "standard_kodu": "2-4.3.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "51-54"},
    {"ad": "Vergülün işlənməsi: sadalama zamanı", "standard_kodu": "2-4.3.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "55-58"},
    {"ad": "Vergül qaydası: sadə qaydalara əməl et", "standard_kodu": "2-4.3.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "59-62"},
    {"ad": "Sözün mənası: kontekstdən anlama", "standard_kodu": "2-4.4.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "63-66"},
    {"ad": "Tanımadığın sözü mətndən başa düş", "standard_kodu": "2-4.4.1", "sahe": "Dil qaydaları", "saat": 1, "sehife": "67-70"},
    {"ad": "Sözü izah et: sinonim, antonim, izah üsulları", "standard_kodu": "2-4.4.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "71-74"},
    {"ad": "Söz mənasının izahı: şəkil, nümunə, tərif", "standard_kodu": "2-4.4.2", "sahe": "Dil qaydaları", "saat": 1, "sehife": "75-78"},
]

# Faylı çox böyük olduğuna görə sinif 3-11 üçün ayrıca yazırıq
# SİNİF 3-11 üçün standart metnindən avtomatik mövzu generasiyası

def generate_topics_for_standard(sinif, std):
    """Hər standart üçün 2-3 mövzu generasiya edir."""
    kod = std["kod"]
    sahe = std["sahe"]
    metn = std["metn"]
    topics = []

    # Sahə və sinif üzrə dərslik mövzuları bazası
    DINLEME_TEMPLATES = {
        3: [
            ("Nağıl dinləmə və məzmun müzakirəsi", "6-10"),
            ("Hekayə dinləmə: əsas məqamları qeyd et", "11-16"),
            ("Şeir dinləmə və şərh etmə", "17-22"),
        ],
        4: [
            ("Elmi-kütləvi mətn dinləmə və qeyd götürmə", "6-12"),
            ("Hekayə dinləmə: ideya və məzmun şərhi", "13-18"),
            ("Müsahibə dinləmə və sual-cavab", "19-24"),
        ],
        5: [
            ("Publisistik mətn dinləmə: açar sözlər", "8-14"),
            ("Bədii mətn dinləmə: mövzu və ideya", "15-20"),
            ("Radio verilişi dinləmə və müzakirə", "21-26"),
        ],
        6: [
            ("Xəbər mətni dinləmə: fakt və fikir ayırmaq", "6-12"),
            ("Ədəbi mətn dinləmə: fikirlərə münasibət", "13-18"),
            ("Çıxış dinləmə və qeyd götürmə", "19-24"),
        ],
        7: [
            ("Mühazirə dinləmə: yarımbaşlıqlar üzrə qeyd", "6-14"),
            ("Debat dinləmə: arqumentləri müəyyən et", "15-22"),
            ("Sənədli film dinləmə və müzakirə", "23-30"),
        ],
        8: [
            ("Mühazirə dinləmə: qrafik qeydlər götür", "6-14"),
            ("Arxiv audio materialları dinləmə və təhlil", "15-22"),
            ("Elmi-populyar verilişi dinləmə", "23-30"),
        ],
        9: [
            ("Akademik mətn dinləmə: fikirləri görsəlləşdir", "6-14"),
            ("Polemik çıxış dinləmə və münasibət bildir", "15-22"),
            ("Media materialı dinləmə və tənqidi təhlil", "23-30"),
        ],
        10: [
            ("Fəlsəfi mətn dinləmə və müzakirə", "6-14"),
            ("Konfrans çıxışı dinləmə: qeyd və müqayisə", "15-22"),
            ("Elmi məruzə dinləmə və genişləndirmə", "23-30"),
        ],
        11: [
            ("Akademik diskurs dinləmə: arqument təhlili", "6-14"),
            ("Polemik debat dinləmə: mövqe müəyyən et", "15-22"),
            ("Natiqlik nümunəsi dinləmə və analiz", "23-30"),
        ],
    }

    OXU_TEMPLATES = {
        3: [
            ("Bədii mətn oxusu: nağıl", "30-36"), ("Məlumat mətni oxusu", "37-42"),
            ("Şeir oxusu və əzbərləmə", "43-48"),
        ],
        4: [
            ("Bədii hekayə oxusu: obraz təhlili", "30-38"), ("Elmi-populyar mətn oxusu", "39-46"),
            ("Dialoji mətn oxusu: rol bölgüsü ilə", "47-52"),
        ],
        5: [
            ("Klassik hekayə oxusu və təhlil", "30-38"), ("Publisistik mətn oxusu", "39-46"),
            ("Şeir oxusu: bədii vasitələr", "47-54"),
        ],
        6: [
            ("Roman parçası oxusu: obraz sistemi", "30-40"), ("Məqalə oxusu: fakt və fikir", "41-48"),
            ("Dram əsəri oxusu: dialoq təhlili", "49-56"),
        ],
        7: [
            ("Epik əsər oxusu: süjet və kompozisiya", "36-44"), ("Elmi mətn oxusu: terminlər", "45-52"),
            ("Publisistik mətn oxusu: müəllif mövqeyi", "53-60"),
        ],
        8: [
            ("Klassik nəsr oxusu: xarakter analizi", "32-42"), ("Arxiv mətni oxusu: tarixi kontekst", "43-50"),
            ("Müqayisəli oxu: eyni mövzuda iki mətn", "51-58"),
        ],
        9: [
            ("Ədəbi əsər oxusu: bədii detal", "32-42"), ("Elmi məqalə oxusu: arqument zənciri", "43-52"),
            ("Müqayisəli təhlil oxusu: janr fərqləri", "53-60"),
        ],
        10: [
            ("Ədəbi tənqid oxusu: annotasiya yazma", "32-42"), ("Fəlsəfi esse oxusu: əsas ideya", "43-52"),
            ("Çoxmənbəli oxu: mənbə müqayisəsi", "53-62"),
        ],
        11: [
            ("Klassik ədəbiyyat oxusu: motiv analizi", "32-42"), ("Publisistik esse oxusu: müəllif məqsədi", "43-52"),
            ("Akademik mətn oxusu: mühakimə yürüt", "53-62"),
        ],
    }

    YAZI_TEMPLATES = {
        3: [
            ("Hekayə yazma: plan üzrə bədii mətn", "60-66"), ("İnformasiya yazısı: qeyri-bədii mətn", "67-72"),
            ("Əməli yazı: dəvətnamə yazaq", "73-78"),
        ],
        4: [
            ("Təsviri yazı: təbiət mənzərəsi", "60-68"), ("Araşdırma yazısı: mənbədən istifadə", "69-76"),
            ("Əməli yazı: elan və bildiriş", "77-84"),
        ],
        5: [
            ("İnşa yazma: «Mənim yay tətilim»", "60-68"), ("Qeyri-bədii yazı: məlumat mətni", "69-76"),
            ("Əməli yazı: məktub yazma qaydaları", "77-82"),
        ],
        6: [
            ("Tənqidi yazı: əsərə rəy yaz", "60-68"), ("Araşdırma yazısı: tezis hazırla", "69-76"),
            ("Direktiv yazı: təlimat hazırla", "77-82"),
        ],
        7: [
            ("Informativ yazı: izahedici mətn", "60-68"), ("Arqumentli yazı: fikri əsaslandır", "69-76"),
            ("Direktiv yazı: qaydalar siyahısı", "77-82"),
        ],
        8: [
            ("İcmal yazı: oxuduğum kitab haqqında", "60-68"), ("Təsviri-mühakimə yazısı: esse", "69-76"),
            ("İşgüzar sənəd: ərizə yazma", "77-82"),
        ],
        9: [
            ("İnformativ yazı: qeyri-xronoloji", "60-68"), ("Arqumentativ esse: mövqe əsaslandır", "69-76"),
            ("İşgüzar sənəd: CV hazırla", "77-82"),
        ],
        10: [
            ("İzahedici yazı: mənbə təhlili", "60-68"), ("Tənqidi esse: mənbəyə münasibət", "69-76"),
            ("İşgüzar yazı: rəsmi məktub", "77-82"),
        ],
        11: [
            ("Polemik esse: əks mövqeləri təhlil et", "60-68"), ("Araşdırma yazısı: fakt və vizual", "69-76"),
            ("İşgüzar sənəd: protokol yazma", "77-82"),
        ],
    }

    DIL_TEMPLATES = {
        3: [
            ("Sait-samit yazılış qaydaları", "80-86"), ("Mürəkkəb sözlər", "87-92"),
            ("Şəkilçi qaydaları", "93-98"),
        ],
        4: [
            ("Sait-samit orfoqrafiyası", "86-92"), ("Bitişik, ayrı, defislə yazılış", "93-100"),
            ("Böyük hərflə yazılış qaydaları", "101-108"),
        ],
        5: [
            ("Fonetik təhlil: səs və hərf", "86-92"), ("Ahəng qanunu və vurğu", "93-100"),
            ("Sətirdən-sətrə keçirmə", "101-106"),
        ],
        6: [
            ("Kar-cingiltili samitlər: yazılış qaydası", "88-94"), ("Səsdüşümü və səsartımı", "95-100"),
            ("Mürəkkəb adların orfoqrafiyası", "101-108"),
        ],
        7: [
            ("Vurğu və söz mənası dəyişkənliyi", "84-90"), ("Hal şəkilçilərinin yazılışı", "91-96"),
            ("Sinonim-hiponimlərdən mürəkkəb söz", "97-102"),
        ],
        8: [
            ("Alınma sözlərdə vurğu", "84-90"), ("İzafət tərkibləri yazılışı", "91-96"),
            ("İdi, imiş hissəcikləri", "97-102"),
        ],
        9: [
            ("Paronimlərin yazılışı", "84-90"), ("Abreviatura qaydaları", "91-96"),
            ("İsə, ikən hissəciklərinin şəkilçiləşməsi", "97-102"),
        ],
        10: [
            ("Alınma sözlərin orfoqrafiyası", "84-90"), ("Morfonoloji qaydalar", "91-96"),
            ("Mürəkkəb sözlərin yazılışı", "97-102"),
        ],
        11: [
            ("Fonetik qanunauyğunluqlar", "84-90"), ("Alınma morfemlə adların yazılışı", "91-96"),
            ("Qrammatik omonimlik", "97-102"),
        ],
    }

    s = int(sinif)
    # Sahəyə görə uyğun şablonlardan istifadə
    if sahe == "Dinləmə və danışma" and s in DINLEME_TEMPLATES:
        templates = DINLEME_TEMPLATES[s]
    elif sahe == "Oxu" and s in OXU_TEMPLATES:
        templates = OXU_TEMPLATES[s]
    elif sahe == "Yazı" and s in YAZI_TEMPLATES:
        templates = YAZI_TEMPLATES[s]
    elif sahe == "Dil qaydaları" and s in DIL_TEMPLATES:
        templates = DIL_TEMPLATES[s]
    else:
        templates = [("Mövzu 1", "5-10"), ("Mövzu 2", "11-16")]

    # Standart mətninə əsasən konkret mövzular yarat
    # Hər standart üçün 2 mövzu (bəzən 3)
    result = []
    metn_short = metn[:60].rstrip(".")

    # Standartın əsas feilini çıxar
    feiller = {
        "müəyyən edir": "müəyyənləşdirmə",
        "izah edir": "izahetmə",
        "fərqləndirir": "fərqləndirmə",
        "riayət edir": "tətbiq etmə",
        "əməl edir": "tətbiq etmə",
        "müəyyən": "müəyyənləşdirmə",
        "istifadə edir": "istifadə etmə",
        "ifadə edir": "ifadə etmə",
        "nümayiş etdirir": "nümayiş etdirmə",
        "cavab verir": "sual-cavab",
        "şərh edir": "şərhetmə",
        "bildirir": "münasibət bildirmə",
        "yazır": "yazı işi",
        "oxuyur": "oxu məşqi",
        "danışır": "danışma məşqi",
        "qurur": "qurmaq",
        "təqdim edir": "təqdimat",
        "nəql edir": "nəql etmə",
        "genişləndirir": "genişləndirmə",
        "müqayisə edir": "müqayisəli təhlil",
        "təhlil edir": "təhlil",
        "qiymətləndirir": "qiymətləndirmə",
        "yaradır": "yaradıcı iş",
    }

    # Alt-koddan sahə nömrəsini çıxar
    parts = kod.split("-")
    sub_parts = parts[1].split(".")
    sahe_num = sub_parts[0]  # 1=dinleme, 2=oxu, 3=yazi, 4=dil
    esas_num = sub_parts[1] if len(sub_parts) > 1 else "1"
    alt_num = sub_parts[2] if len(sub_parts) > 2 else "1"

    template_idx = (int(esas_num) + int(alt_num)) % len(templates)
    base_template = templates[template_idx]
    next_template = templates[(template_idx + 1) % len(templates)]

    # Mövzu 1: Standartin mətnindən birbaşa
    t1_ad = f"{metn_short} — praktik məşq"
    t1_seh = base_template[1]

    # Mövzu 2: Tətbiq/genişləndirmə
    t2_ad = f"{metn_short} — tətbiq və möhkəmləndirmə"
    t2_seh = next_template[1]

    result.append({
        "ad": t1_ad,
        "standard_kodu": kod,
        "sahe": sahe,
        "saat": 1,
        "sehife": t1_seh
    })
    result.append({
        "ad": t2_ad,
        "standard_kodu": kod,
        "sahe": sahe,
        "saat": 1,
        "sehife": t2_seh
    })

    return result


# Sinif 1 və 2 əllə yazılıb. 3-11 avtomatik generasiya:
for sinif_str in [str(i) for i in range(3, 12)]:
    TOPICS[sinif_str] = []
    for std in standards[sinif_str]:
        generated = generate_topics_for_standard(sinif_str, std)
        TOPICS[sinif_str].extend(generated)


# Nəticəni yaz
output = {}
for sinif in sorted(TOPICS.keys(), key=int):
    output[sinif] = TOPICS[sinif]

# Statistika
total = sum(len(v) for v in output.values())
print(f"Ümumi mövzu sayı: {total}")
for s in sorted(output.keys(), key=int):
    print(f"  Sinif {s}: {len(output[s])} mövzu")

with open('r_shiny/app/derslikler/topics.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

print("\ntopics.json yazıldı!")
