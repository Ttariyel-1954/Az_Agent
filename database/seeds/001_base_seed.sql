-- Az Muellim Agent - Esas Seed Data
-- Azerbaycan dili kurikulum standartlari (1-11-ci sinifler)
-- Rəsmi kurikulum sənədindən tam çıxarış (2024)
-- Sahələr: dinleme_danisma, oxu, yazi, dil_qaydalari
-- PISA/PIRLS/Blooms uyğunluğu ilə

-- Əvvəlki məlumatları sil
DELETE FROM azdili_standartlari;

-- ============================================================
-- I SİNİF (Grade 1)
-- ============================================================

INSERT INTO azdili_standartlari (sinif, saha, standard_kodu, standard_metni, alstandart_kodu, alstandart_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi) VALUES

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
-- Standart 1-1.1
(1, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '1-1.1.1', $$Dinlədiyi mətnlə bağlı sadə faktoloji suallara cavab verir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(1, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '1-1.1.2', $$Dinlədiyi mətndəki fakt və hadisələri şərh edir.$$, '1b', 'şərh etmə', 'anlamaq'),
(1, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '1-1.1.3', $$Dinlədiyi mətndəki obrazlara münasibət bildirir.$$, '1a', 'qiymətləndirmə', 'anlamaq'),

-- Standart 1-1.2
(1, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '1-1.2.1', $$Müzakirə olunan məsələ ilə bağlı öz fikirlərini ifadə edir.$$, '1b', 'şərh etmə', 'anlamaq'),
(1, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '1-1.2.2', $$Hər hansı mövzuda dialoq qurur.$$, '1a', 'şərh etmə', 'tətbiq etmək'),

-- Standart 1-1.3
(1, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '1-1.3.1', $$Oxuduqlarını və dinlədiklərini rabitəli şəkildə təqdim edir.$$, '1b', 'birbaşa anlama', 'anlamaq'),
(1, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '1-1.3.2', $$Sadə sxemlər və komikslər üzrə danışır.$$, '1b', 'məlumat alma', 'anlamaq'),
(1, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '1-1.3.3', $$Hər hansı hadisə, varlıq haqqında fikirlərini rabitəli cümlələrlə ifadə edir.$$, '1a', 'şərh etmə', 'tətbiq etmək'),
(1, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '1-1.3.4', $$Araşdırma nəticəsində əldə etdiyi məlumatları rabitəli şəkildə təqdim edir.$$, '1a', 'inteqrasiya', 'tətbiq etmək'),
(1, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '1-1.3.5', $$Dinlədiyi mətnin məzmunundan çıxış edərək onun davamını təxmin edir.$$, '1a', 'şərh etmə', 'anlamaq'),

-- Standart 1-1.4
(1, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '1-1.4.1', $$Cümlə qurarkən düzgün söz sırasına əməl edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(1, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '1-1.4.2', $$Danışarkən məzmuna uyğun intonasiyadan istifadə edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
-- Standart 1-2.1
(1, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '1-2.1.1', $$İlkin oxu bacarığı nümayiş etdirir.$$, '1b', 'birbaşa anlama', 'xatırlamaq'),
(1, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '1-2.1.2', $$Cümlə sonunda durğu işarələrini nəzərə almaqla oxuyur.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 1-2.2
(1, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '1-2.2.1', $$Oxuduğu mətndəki hadisələri, obrazları, zaman və məkanı müəyyənləşdirir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(1, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '1-2.2.2', $$Verbal informasiyanı qrafik təsvirlə uyğunlaşdırır.$$, '1a', 'inteqrasiya', 'anlamaq'),
(1, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '1-2.2.3', $$Mətndə rast gəldiyi söz və ifadələrin mənasını anladığını nümayiş etdirir.$$, '1b', 'məlumat alma', 'anlamaq'),

-- Standart 1-2.3
(1, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '1-2.3.1', $$Mətndəki hadisələr arasındakı səbəb-nəticə əlaqəsini müəyyən edir.$$, '1a', 'şərh etmə', 'anlamaq'),
(1, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '1-2.3.2', $$Obrazların xarakterindəki əsas xüsusiyyəti müəyyən edir.$$, '1a', 'şərh etmə', 'anlamaq'),
(1, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '1-2.3.3', $$Mətndə əsas fikri müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 1-2.4
(1, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '1-2.4.1', $$Mətndəki obrazlara və onların davranışına münasibətini bildirir.$$, '1a', 'qiymətləndirmə', 'anlamaq'),
(1, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '1-2.4.2', $$Təxəyyülündən çıxış edərək mətnin məzmununa yaradıcı yanaşır.$$, '2', 'qiymətləndirmə', 'yaratmaq'),
(1, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '1-2.4.3', $$Nəzm və nəsrlə yazılmış mətnlərin məzmun-struktur xüsusiyyətlərini müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Məzmun xətti 3: YAZI
-- Standart 1-3.1
(1, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '1-3.1.1', $$Yazısında hüsnxət normalarına riayət edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(1, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '1-3.1.2', $$Yazısında hadisələrin ardıcıllığına riayət edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(1, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '1-3.1.3', $$Öyrəndiyi sadə orfoqrafiya və punktuasiya qaydalarına yazısında riayət edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 1-3.2
(1, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '1-3.2.1', $$Bildiyi məlumatları yazıda əks etdirir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(1, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '1-3.2.2', $$Verilmiş plan əsasında mövzu ilə bağlı fikirlərini yazır.$$, '1a', 'şərh etmə', 'tətbiq etmək'),
(1, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '1-3.2.3', $$Sadə əməli yazılar (anket, açıqca) yazır.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(1, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '1-3.2.4', $$Təqdimat üçün müxtəlif vizual forma və üsullar seçir.$$, '1a', 'inteqrasiya', 'tətbiq etmək'),

-- Məzmun xətti 4: DİL QAYDALARI
-- Standart 1-4.1
(1, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin sadə fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '1-4.1.1', $$Söz tərkibindəki səs və hecaları müəyyən edir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(1, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin sadə fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '1-4.1.2', $$Hərflərin əlifba sırasını müəyyən edir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(1, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin sadə fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '1-4.1.3', $$Yazıda sadə orfoqrafiya normalarına riayət edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 1-4.2
(1, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq vahidlərini (söz, cümlə) ümumi semantik mənalarına görə fərqləndirir.$$, '1-4.2.1', $$Ad, əlamət, say, hərəkət bildirən sözlərin ümumi qrammatik mənalarını müəyyən edir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(1, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq vahidlərini (söz, cümlə) ümumi semantik mənalarına görə fərqləndirir.$$, '1-4.2.2', $$Mətndə cümlələri müəyyən edir, məqsəd və intonasiyaya görə fərqləndirir.$$, '1a', 'məlumat alma', 'anlamaq'),

-- Standart 1-4.3
(1, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda sadə punktuasiya qaydalarına əməl edir.$$, '1-4.3.1', $$Cümlə sonunda müvafiq durğu işarələrindən istifadə edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 1-4.4
(1, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '1-4.4.1', $$Sözün mənasını sadə üsullarla izah edir.$$, '1b', 'məlumat alma', 'anlamaq'),

-- ============================================================
-- II SİNİF (Grade 2)
-- ============================================================

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
-- Standart 2-1.1
(2, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '2-1.1.1', $$Dinlədiyi mətndəki əsas məqamlarla bağlı faktoloji suallara cavab verir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(2, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '2-1.1.2', $$Dinlədiyi mətnin məzmununu şərh edir, obraz və fikirlərə münasibət bildirir.$$, '1a', 'şərh etmə', 'anlamaq'),
(2, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '2-1.1.3', $$Dinlədiyi mətni genişləndirir, davamını təxmin edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 2-1.2
(2, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '2-1.2.1', $$Həyatdan və əldə etdiyi məlumatlardan nümunələr gətirməklə dinlədiyi fikrə münasibət bildirir.$$, '1a', 'şərh etmə', 'anlamaq'),
(2, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '2-1.2.2', $$Mövzu üzrə əvvəlcədən müəyyənləşdirdiyi suallar əsasında dialoq qurur.$$, '1a', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 2-1.3
(2, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '2-1.3.1', $$Oxuduğu və dinlədiyi mətnləri plan əsasında nəql edir.$$, '1a', 'birbaşa anlama', 'anlamaq'),
(2, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '2-1.3.2', $$Şəkil, sxem və illustrasiyaları rabitəli şəkildə şifahi təqdim edir.$$, '1a', 'inteqrasiya', 'anlamaq'),
(2, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '2-1.3.3', $$Hər hansı hadisə, varlıq haqqında fikir və təəssüratlarını ifadə edir.$$, '1a', 'şərh etmə', 'tətbiq etmək'),
(2, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '2-1.3.4', $$Araşdırma nəticəsində əldə etdiyi məlumatları rabitəli şəkildə təqdim edir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 2-1.4
(2, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '2-1.4.1', $$Nitqində yeni öyrəndiyi söz və ifadələrdən kontekstə uyğun istifadə edir.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(2, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '2-1.4.2', $$Danışarkən səs tonunun tənzimlənməsi, məntiqi vurğudan istifadə.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
-- Standart 2-2.1
(2, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '2-2.1.1', $$Müvafiq mətnləri sürətli və aydın səslə oxuyur.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(2, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '2-2.1.2', $$Cümlədə durğu işarələrini nəzərə almaqla oxuyur.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 2-2.2
(2, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '2-2.2.1', $$Oxuduğu mətndəki hadisələri, obrazları, zaman, məkan, fakt və fikirləri müəyyənləşdirir.$$, '1a', 'məlumat alma', 'xatırlamaq'),
(2, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '2-2.2.2', $$Qrafik təsvirlərdən istifadə etməklə mətndəki məlumatları mənimsədiyini nümayiş etdirir.$$, '1a', 'inteqrasiya', 'anlamaq'),
(2, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '2-2.2.3', $$Kontekstdən çıxış edərək sözün mənasını müəyyən edir.$$, '1a', 'şərh etmə', 'anlamaq'),

-- Standart 2-2.3
(2, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '2-2.3.1', $$Mətndəki hadisə, fakt və fikirlərin arasındakı əlaqəni müəyyən edir.$$, '1a', 'şərh etmə', 'anlamaq'),
(2, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '2-2.3.2', $$Mətndəki hadisələr və obrazların davranışından çıxış edərək xarakterləri təhlil edir.$$, '2', 'şərh etmə', 'təhlil etmək'),
(2, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '2-2.3.3', $$Mətndə əsas fikri müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 2-2.4
(2, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '2-2.4.1', $$Mətndəki fakt, hadisə və obrazlara münasibətini bildirir.$$, '1a', 'qiymətləndirmə', 'anlamaq'),
(2, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '2-2.4.2', $$Mətni təxəyyülünə uyğun davam etdirir.$$, '2', 'qiymətləndirmə', 'yaratmaq'),
(2, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '2-2.4.3', $$Bədii və qeyri-bədii mətnlərin məzmun-struktur xüsusiyyətlərini izah edir.$$, '2', 'şərh etmə', 'anlamaq'),
(2, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '2-2.4.4', $$Müxtəlif mətnləri mövzu, məzmun və ideya baxımından müqayisə edir.$$, '2', 'qiymətləndirmə', 'təhlil etmək'),

-- Məzmun xətti 3: YAZI
-- Standart 2-3.1
(2, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '2-3.1.1', $$Yazısının aydın və oxunaqlı olması üçün müvafiq yazı normalarına əməl edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(2, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '2-3.1.2', $$Məlumatları ardıcıllıqla əks etdirir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(2, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '2-3.1.3', $$Öyrəndiyi sadə orfoqrafiya, qrammatika və punktuasiya qaydalarına yazısında riayət edir.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 2-3.2
(2, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '2-3.2.1', $$Bildiyi və ya yeni tanış olduğu məlumatları yazısında əks etdirir.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(2, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '2-3.2.2', $$Təxəyyülünə əsasən sadə süjetli bədii mətn yazır.$$, '2', 'qiymətləndirmə', 'yaratmaq'),
(2, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '2-3.2.3', $$Suallar əsasında mövzu ilə bağlı qeyri-bədii (informativ) mətn yazır.$$, '1a', 'inteqrasiya', 'tətbiq etmək'),
(2, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '2-3.2.4', $$Təqdimat üçün müxtəlif vizual forma və üsullar seçir.$$, '1a', 'inteqrasiya', 'tətbiq etmək'),

-- Məzmun xətti 4: DİL QAYDALARI
-- Standart 2-4.1
(2, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin sadə fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '2-4.1.1', $$Saitlərin növlərini müəyyən edir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(2, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin sadə fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '2-4.1.2', $$Sözlərin əlifba sırasına uyğun ardıcıllığını müəyyən edir.$$, '1b', 'məlumat alma', 'xatırlamaq'),
(2, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin sadə fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '2-4.1.3', $$Yazıda sadə orfoqrafik normalarına riayət edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 2-4.2
(2, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq vahidlərini (söz, cümlə) ümumi semantik mənalarına görə fərqləndirir.$$, '2-4.2.1', $$Ad, əlamət, say, hərəkət bildirən sözlərin ümumi qrammatik mənalarını və morfoloji tərkibini müəyyən edir.$$, '1a', 'məlumat alma', 'anlamaq'),
(2, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq vahidlərini (söz, cümlə) ümumi semantik mənalarına görə fərqləndirir.$$, '2-4.2.2', $$Cümlənin ifadə etdiyi fikri müəyyən edir, məqsəd və intonasiyaya görə növlərini fərqləndirir.$$, '1a', 'şərh etmə', 'anlamaq'),

-- Standart 2-4.3
(2, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda sadə punktuasiya qaydalarına əməl edir.$$, '2-4.3.1', $$Cümlə sonunda müvafiq durğu işarələrindən istifadə edir.$$, '1b', 'birbaşa anlama', 'tətbiq etmək'),
(2, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda sadə punktuasiya qaydalarına əməl edir.$$, '2-4.3.2', $$Vergül işarəsindən istifadə ilə bağlı sadə qaydalara əməl edir.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 2-4.4
(2, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '2-4.4.1', $$Kontekstdən çıxış edərək sözün mənasını müəyyən edir.$$, '1a', 'şərh etmə', 'anlamaq'),
(2, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '2-4.4.2', $$Sözlərin mənalarını müxtəlif üsullarla izah edir.$$, '1a', 'şərh etmə', 'anlamaq'),

-- ============================================================
-- III SİNİF (Grade 3)
-- ============================================================

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
-- Standart 3-1.1
(3, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '3-1.1.1', $$Dinlədiyi mətnin məzmunu ilə bağlı əsas məqamları qeyd edir və onları verilmiş şəkillərlə əlaqələndirir.$$, '1a', 'məlumat alma', 'anlamaq'),
(3, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '3-1.1.2', $$Dinlədiyi mətni əsas epizoda istinad edərək dinlənilmiş mətnin ideyasının müəyyənləşdirilməsi.$$, '2', 'şərh etmə', 'anlamaq'),
(3, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '3-1.1.3', $$Dinlədiyi mətni genişləndirir, davamını təxmin edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 3-1.2
(3, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '3-1.2.1', $$Müzakirələrdə çıxış edərkən mövzudan kənara çıxmır.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '3-1.2.2', $$Dinlədiyi fikirlərə münasibətini bildirməsi üçün arqumentlər gətirir.$$, '2', 'qiymətləndirmə', 'anlamaq'),
(3, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '3-1.2.3', $$Dialoq zamanı mövzu ilə bağlı müəyyən məqamları sual verməklə aydınlaşdırır.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 3-1.3
(3, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '3-1.3.1', $$Oxuduğu və dinlədiyi mətnləri yaradıcı şəkildə nəql edir.$$, '2', 'şərh etmə', 'tətbiq etmək'),
(3, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '3-1.3.2', $$Qrafik və ya verbal-qrafik informasiyanı rabitəli şəkildə şifahi təqdim edir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),
(3, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '3-1.3.3', $$Mövzu ilə bağlı bildiklərini, fikir və təəssüratlarını rabitəli şəkildə təqdim edir.$$, '2', 'şərh etmə', 'tətbiq etmək'),
(3, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '3-1.3.4', $$Araşdırma nəticəsində əldə etdiyi məlumatları rabitəli şəkildə təqdim edir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 3-1.4
(3, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '3-1.4.1', $$Cümlə qurarkən sözləri uyğun qrammatik formada işlədir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '3-1.4.2', $$Danışarkən emosiyalarını nümayiş etdirmək üçün intonasiya, jest və mimikadan istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
-- Standart 3-2.1
(3, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '3-2.1.1', $$Müvafiq mətnləri sürətli, səlis, aydın səslə oxuyur.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '3-2.1.2', $$Dialoji mətni uyğun səs tonları ilə oxuyur.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 3-2.2
(3, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '3-2.2.1', $$Qeyd götürməklə mətndəki əsas məlumatları mənimsədiyini nümayiş etdirir.$$, '1a', 'məlumat alma', 'anlamaq'),
(3, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '3-2.2.2', $$Verbal-qrafik informasiyanı mənimsədiyini nümayiş etdirir.$$, '1a', 'inteqrasiya', 'anlamaq'),
(3, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '3-2.2.3', $$Kontekstdən çıxış edərək söz və ifadələrin mənasını müəyyən edir və verilmiş izahla müqayisə edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 3-2.3
(3, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '3-2.3.1', $$Ümumi məzmun səviyyəsində səbəb-nəticə əlaqəsini müəyyənləşdirir.$$, '2', 'şərh etmə', 'anlamaq'),
(3, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '3-2.3.2', $$Mətndəki hadisələrə və dialoqlara görə obrazlar haqqında fikir yürüdür.$$, '2', 'şərh etmə', 'təhlil etmək'),
(3, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '3-2.3.3', $$Mətndə əsas fikrin açılmasına xidmət edən məqamları müəyyənləşdirir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 3-2.4
(3, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '3-2.4.1', $$Mətndəki fakt, hadisə və obrazlarla bağlı şəxsi mövqeyini əsaslandırır.$$, '2', 'qiymətləndirmə', 'qiymətləndirmək'),
(3, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '3-2.4.2', $$Mətni təxəyyülünə uyğun genişləndirir, dilindən nəql edir.$$, '2', 'qiymətləndirmə', 'yaratmaq'),
(3, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '3-2.4.3', $$Mətnin tərkib hissələrini, struktur elementlərini və dil-üslub xüsusiyyətlərini müəyyən edir.$$, '2', 'şərh etmə', 'təhlil etmək'),
(3, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '3-2.4.4', $$Müxtəlif mətnləri mövzu, məzmun, ideya baxımından müqayisə edir.$$, '2', 'qiymətləndirmə', 'təhlil etmək'),

-- Məzmun xətti 3: YAZI
-- Standart 3-3.1
(3, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '3-3.1.1', $$Yazısında məlumatları mətnin tərkib hissələri üzrə qruplaşdırır.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '3-3.1.2', $$Özünün və başqasının yazısını dil qaydaları baxımından təkmilləşdirir.$$, '2', 'qiymətləndirmə', 'qiymətləndirmək'),

-- Standart 3-3.2
(3, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '3-3.2.1', $$Dinlədiyi, oxuduğu məlumatları yazısında əks etdirir.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '3-3.2.2', $$Fikir, təxəyyül və təəssüratları əsasında bədii mətn yazır.$$, '2', 'qiymətləndirmə', 'yaratmaq'),
(3, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '3-3.2.3', $$Tanış olduğu məlumatlar əsasında kiçikhəcmli qeyri-bədii mətn yazır.$$, '2', 'inteqrasiya', 'tətbiq etmək'),
(3, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '3-3.2.4', $$Standart forma və məzmun xüsusiyyətlərini gözləməklə əməli yazılar yazır.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '3-3.2.5', $$Təqdimat üçün müxtəlif vizual forma və üsullar seçir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Məzmun xətti 4: DİL QAYDALARI
-- Standart 3-4.1
(3, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '3-4.1.1', $$Sözlərdə sait və samitlərin yazılış qaydalarına riayət edir.$$, '1a', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '3-4.1.2', $$Mürəkkəb sözlərin yazılış qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '3-4.1.3', $$Şəkilçilərin yazılış qaydalarına əməl edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 3-4.2
(3, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin ümumi qrammatik mənalarını və morfoloji tərkibini müəyyən edir.$$, '3-4.2.1', $$Nitq hissələrinin ümumi qrammatik mənalarını və morfoloji tərkibini müəyyən edir.$$, '2', 'məlumat alma', 'anlamaq'),
(3, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin ümumi qrammatik mənalarını və morfoloji tərkibini müəyyən edir.$$, '3-4.2.2', $$Sintaktik vahidlərin və cümlə komponentlərini və ifadə etdiyi semantik mənanı izah edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 3-4.3
(3, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '3-4.3.1', $$Dialoqda müvafiq durğu işarələrindən istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(3, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '3-4.3.2', $$Mürəkkəb cümlədə durğu işarələrindən istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 3-4.4
(3, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '3-4.4.1', $$Kontekstdən və morfoloji tərkibdən çıxış edərək sözün mənasını müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),
(3, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '3-4.4.2', $$Sözlərin mənalarını müxtəlif üsullarla izah edir.$$, '2', 'şərh etmə', 'anlamaq');

-- ============================================================
-- IV SİNİF (Grade 4)
-- ============================================================

INSERT INTO azdili_standartlari (sinif, saha, standard_kodu, standard_metni, alstandart_kodu, alstandart_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi) VALUES

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
-- Standart 4-1.1
(4, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '4-1.1.1', $$Dinləmə zamanı götürdüyü qeydlər əsasında mətnlə bağlı suallara cavab verir.$$, '2', 'məlumat alma', 'anlamaq'),
(4, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '4-1.1.2', $$Dinlədiyi mətni ideya və məzmun baxımından şərh edir.$$, '2', 'şərh etmə', 'anlamaq'),
(4, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '4-1.1.3', $$Öz versiya və düşüncələrini əlavə etməklə dinlədiyi mətni genişləndirir, dəyişdirir, davamını təxmin edir.$$, '2', 'şərh etmə', 'yaratmaq'),

-- Standart 4-1.2
(4, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '4-1.2.1', $$Dinlədiyi fikirləri təsdiq və ya təkzib etmək üçün arqument və ya əks-arqumentlər gətirir.$$, '2', 'qiymətləndirmə', 'qiymətləndirmək'),
(4, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '4-1.2.2', $$Əldə etdiyi məlumatlar və tərtib etdiyi suallar əsasında müsahibi ilə dialoq qurur.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 4-1.3
(4, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '4-1.3.1', $$Əlavə məlumatlardan istifadə etməklə dinlədiyi və ya oxuduğu mətni genişləndirib danışır.$$, '2', 'şərh etmə', 'tətbiq etmək'),
(4, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '4-1.3.2', $$Qrafik və ya verbal-qrafik informasiyanı rabitəli şəkildə şifahi təqdim edir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),
(4, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '4-1.3.3', $$Mövzu ilə bağlı bildiklərini, fikir və təəssüratlarını rabitəli şəkildə təqdim edir.$$, '2', 'şərh etmə', 'tətbiq etmək'),
(4, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '4-1.3.4', $$Araşdırma nəticəsində əldə etdiyi məlumatları rabitəli şəkildə təqdim edir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 4-1.4
(4, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '4-1.4.1', $$Şifahi nitqində leksik və qrammatik normalara əməl edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '4-1.4.2', $$Danışarkən məzmuna uyğun intonasiya, jest, mimikadan istifadə edir, auditoriya ilə göz təması qurur.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
-- Standart 4-2.1
(4, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '4-2.1.1', $$Deyilişi çətin olan sözləri aydın tələffüz etməklə kiçikhəcmli mətnləri oxuyur.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'oxu', '2.1', $$Səlis və ifadəli oxu: Kiçik həcmli mətnləri sürətli, aydın, səlis oxuyur.$$, '4-2.1.2', $$Mətni oxuyarkən məzmuna uyğun səs tonu seçir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 4-2.2
(4, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '4-2.2.1', $$Mətndə açıq şəkildə ifadə olunmuş məlumatları mənimsədiyini nümayiş etdirir.$$, '2', 'məlumat alma', 'anlamaq'),
(4, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '4-2.2.2', $$Verbal-qrafik informasiyanı mənimsədiyini nümayiş etdirir.$$, '2', 'inteqrasiya', 'anlamaq'),
(4, 'oxu', '2.2', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '4-2.2.3', $$Kontekstdən çıxış edərək mətndəki söz və ifadələrin mənasını müəyyən edir və lüğət vasitəsilə dəqiqləşdirir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 4-2.3
(4, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '4-2.3.1', $$Mətndə fikirlərlə (müəllif mövqeyi ilə) fakt və hadisələri əlaqələndirir.$$, '2', 'şərh etmə', 'təhlil etmək'),
(4, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '4-2.3.2', $$Mətndəki obrazlara münasibət bildirir və fikirini mətnə istinad etməklə əsaslandırır.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),
(4, 'oxu', '2.3', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '4-2.3.3', $$Mətndəki əsas fikri bağlı həyatdan nümunələr gətirir.$$, '3', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 4-2.4
(4, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '4-2.4.1', $$Mətndəki obrazlara və müəllif yanaşmasına öz münasibətini bildirir.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),
(4, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '4-2.4.2', $$Mətni məzmununa və janrın tələblərinə uyğun dəyişdirir, genişləndirir və ya tamamlayır.$$, '3', 'qiymətləndirmə', 'yaratmaq'),
(4, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '4-2.4.3', $$Mətni məzmun-struktur və dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(4, 'oxu', '2.4', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '4-2.4.4', $$Müxtəlif mətnləri mövzu, məzmun, ideya, struktur və bədii xüsusiyyətlər baxımından müqayisə edir.$$, '3', 'qiymətləndirmə', 'təhlil etmək'),

-- Məzmun xətti 3: YAZI
-- Standart 4-3.1
(4, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '4-3.1.1', $$Məntiqi və xronoloji ardıcıllığı gözləməklə məlumatları mətnin hissələrinə uyğun qruplaşdırır.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '4-3.1.2', $$Yazıda ədəbi dilin normalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 4-3.2
(4, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '4-3.2.1', $$Dinlədiyi, oxuduğu, həyatda gördüyü hadisə və faktlar əsasında mətn yazır.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '4-3.2.2', $$Janr tələblərini gözləməklə təxəyyülə əsasən bədii mətn yazır.$$, '3', 'qiymətləndirmə', 'yaratmaq'),
(4, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '4-3.2.3', $$Araşdırdığı və əldə etdiyi məlumatlar əsasında qeyri-bədii mətn yazır.$$, '2', 'inteqrasiya', 'tətbiq etmək'),
(4, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '4-3.2.4', $$Standart forma və məzmun xüsusiyyətlərini gözləməklə əməli yazılar yazır.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq kiçikhəcmli sadə mətnlər yazır.$$, '4-3.2.5', $$Təqdimat üçün müxtəlif vizual forma və üsullar seçir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Məzmun xətti 4: DİL QAYDALARI
-- Standart 4-4.1
(4, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '4-4.1.1', $$Sözlərdə sait və samitlərin yazılış qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '4-4.1.2', $$Sözlərin bitişik, ayrı və defislə yazılış qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'dil_qaydalari', '4.1', $$Orfoqrafiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '4-4.1.3', $$Sözlərin böyük hərflə yazılış qaydalarına əməl edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 4-4.2
(4, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik-semantik-morfoloji tərkibini izah edir.$$, '4-4.2.1', $$Kontekstdən və qrammatik formadan çıxış edərək əsas nitq hissələrinin qrammatik-semantik-morfoloji tərkibini izah edir.$$, '2', 'şərh etmə', 'anlamaq'),
(4, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik-semantik-morfoloji tərkibini izah edir.$$, '4-4.2.2', $$Köməkçi nitq hissələrinin ümumi qrammatik mənalarını müəyyən edir.$$, '2', 'məlumat alma', 'anlamaq'),
(4, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik-semantik-morfoloji tərkibini izah edir.$$, '4-4.2.3', $$Sintaktik vahidlərin və cümlə komponentlərini və ifadə etdiyi semantik mənanı izah edir.$$, '3', 'şərh etmə', 'anlamaq'),

-- Standart 4-4.3
(4, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '4-4.3.1', $$O, bu əvəzliklərindən sonra əvəzliyindən sonra vergül işarəsinin işlənmə məqamını müəyyən edir.$$, '2', 'birbaşa anlama', 'anlamaq'),
(4, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '4-4.3.2', $$Defis və tire işarələrini fərqləndirir.$$, '2', 'birbaşa anlama', 'anlamaq'),
(4, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '4-4.3.3', $$Sitatda dırnaq işarəsindən istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '4-4.3.4', $$İxtisarlarda durğu işarələrindən istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(4, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '4-4.3.5', $$Müəyyən sintaktik konstruksiyalarda mötərizə işarəsinin funksiyasını izah edir.$$, '3', 'şərh etmə', 'anlamaq'),

-- Standart 4-4.4
(4, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '4-4.4.1', $$Kontekstdən və morfoloji tərkibdən çıxış edərək sözün mənasını müəyyən edir və lüğət vasitəsilə dəqiqləşdirir.$$, '2', 'şərh etmə', 'anlamaq'),
(4, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '4-4.4.2', $$Leksik vahidlərin mənalarını müxtəlif üsullarla izah edir.$$, '2', 'şərh etmə', 'anlamaq'),
(4, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '4-4.4.3', $$Sözləri leksik kateqoriyalar üzrə qruplaşdırır.$$, '2', 'məlumat alma', 'təhlil etmək');

-- ============================================================
-- V SİNİF (Grade 5)
-- ============================================================

INSERT INTO azdili_standartlari (sinif, saha, standard_kodu, standard_metni, alstandart_kodu, alstandart_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi) VALUES

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
-- Standart 5-1.1
(5, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '5-1.1.1', $$Mətni dinləyərkən açar sözlərin qeyd edilməsi.$$, '2', 'məlumat alma', 'anlamaq'),
(5, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '5-1.1.2', $$Dinlədiyi mətni mövzu, məzmun, struktur və ideya baxımından şərh edir və obraz, fakt və fikirlərə münasibət bildirir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(5, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '5-1.1.3', $$Dinlədiyi mətndəki obrazlara münasibətini əsaslandırır.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),

-- Standart 5-1.2
(5, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '5-1.2.1', $$Mövzu üzrə araşdırdığı məlumatlar və tərtib etdiyi suallar əsasında dialoq qurur.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(5, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '5-1.2.2', $$Müzakirə və debatlarda mövzu ilə bağlı mülahizələrini söyləyir, mühakimə yürüdür, başqalarının fikirlərinə münasibət bildirir.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),

-- Standart 5-1.3
(5, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '5-1.3.1', $$Tərtib etdiyi plan əsasında oxuduğu və dinlədiyi mətnləri nəql edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '5-1.3.2', $$Əldə etdiyi məlumatları rabitəli şəkildə təqdim edir.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Standart 5-1.4
(5, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '5-1.4.1', $$Şifahi nitqində orfoepiya normalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '5-1.4.2', $$Danışarkən məzmuna uyğun intonasiyadan istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
-- Standart 5-2.1
(5, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '5-2.1.1', $$Bədii və qeyri-bədii mətnləri oxuyarkən müvafiq səs tonu seçir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '5-2.1.2', $$Mətndə açıq şəkildə ifadə olunmuş məlumatları müəyyənləşdirir.$$, '2', 'məlumat alma', 'anlamaq'),
(5, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '5-2.1.3', $$Kontekstdən çıxış edərək mətndə tanış olmayan sözün mənasını müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),

-- Standart 5-2.2
(5, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '5-2.2.1', $$Mətndə fikirləri, faktlar və hadisələr arasındakı əlaqəni müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(5, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '5-2.2.2', $$Mətndəki məlumatlardan çıxış edərək sətiraltı fikir və informasiyanı müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),

-- Standart 5-2.3
(5, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '5-2.3.1', $$Mətndəki hadisələr və obrazların davranışına əsasən fikirlərin müəyyənləşdirilməsi.$$, '3', 'şərh etmə', 'təhlil etmək'),
(5, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '5-2.3.2', $$Mətndəki müəllif mövqeyinin faktdan fərqləndirilməsi.$$, '3', 'qiymətləndirmə', 'təhlil etmək'),
(5, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '5-2.3.3', $$Mətnin tərkib hissələrini və struktur elementlərini müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),
(5, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '5-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(5, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '5-2.3.5', $$Oxuduğu mətni mövzu və ideya baxımından digər mətnlərlə müqayisə edir.$$, '3', 'qiymətləndirmə', 'təhlil etmək'),
(5, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '5-2.3.6', $$Mətnin məzmunu ilə bağlı şəxsi mövqeyini ifadə edir.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),

-- Məzmun xətti 3: YAZI
-- Standart 5-3.1
(5, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '5-3.1.1', $$Yazısında məlumatları mətnin abzas və hissələri üzrə strukturlaşdırır.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '5-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 5-3.2
(5, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '5-3.2.1', $$Tanış olduğu məlumatlar əsasında qeyri-bədii mətn yazır.$$, '2', 'inteqrasiya', 'tətbiq etmək'),
(5, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '5-3.2.2', $$Fakt, hadisə, təxəyyül və təəssüratları əsasında mətn yazır.$$, '3', 'qiymətləndirmə', 'yaratmaq'),
(5, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '5-3.2.3', $$Məqsədə uyğun olaraq sadə əməli yazılar tərtib edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '5-3.2.4', $$Əldə etdiyi məlumatlar əsasında sadə təqdimat materialı hazırlayır.$$, '2', 'inteqrasiya', 'tətbiq etmək'),

-- Məzmun xətti 4: DİL QAYDALARI
-- Standart 5-4.1
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.1', $$Sözlərdə sait və samitlərin növlərini müəyyən edir.$$, '2', 'məlumat alma', 'xatırlamaq'),
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.2', $$Sözlərdə bəzi sait və samitlərin yazılışı və tələffüzü qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.3', $$Sözün sətirdən-sətrə keçirilmə qaydalarına əməl edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.4', $$Xüsusi isimlərin böyük hərflə yazılışı qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.5', $$Sayların rəqəmlə yazılışında şəkilçilərin orfoqrafiya qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.6', $$Mürəkkəb sözlərin yazılışı zamanı komponentlər arasındakı məna əlaqəsindən çıxış edir.$$, '3', 'şərh etmə', 'anlamaq'),
(5, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '5-4.1.7', $$Azaltma və çoxaltma dərəcəli sifətlərin yazılışında orfoqrafiya qaydalarına riayət edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 5-4.2
(5, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik kateqoriyalarını və morfoloji tərkibini müəyyən edir.$$, '5-4.2.1', $$Əsas nitq hissələrinin ümumi qrammatik kateqoriyalarını və morfoloji tərkibini müəyyən edir.$$, '2', 'məlumat alma', 'anlamaq'),
(5, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik kateqoriyalarını və morfoloji tərkibini müəyyən edir.$$, '5-4.2.2', $$Köməkçi nitq hissələrini əsas nitq hissələrindən fərqləndirən xüsusiyyətləri müəyyən edir.$$, '2', 'şərh etmə', 'anlamaq'),
(5, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik kateqoriyalarını və morfoloji tərkibini müəyyən edir.$$, '5-4.2.3', $$Söz birləşməsini söz və cümlədən fərqləndirir.$$, '2', 'şərh etmə', 'anlamaq'),
(5, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik kateqoriyalarını və morfoloji tərkibini müəyyən edir.$$, '5-4.2.4', $$Cümlənin qrammatik əsasını müəyyən edir.$$, '2', 'məlumat alma', 'anlamaq'),
(5, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin qrammatik kateqoriyalarını və morfoloji tərkibini müəyyən edir.$$, '5-4.2.5', $$Cümlənin məqsəd və intonasiyasına, quruluşuna görə növlərini müəyyən edir.$$, '2', 'məlumat alma', 'anlamaq'),

-- Standart 5-4.3
(5, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '5-4.3.1', $$Məqsəd və intonasiyadan asılı olaraq cümlə sonunda uyğun durğu işarələrindən istifadə edir.$$, '2', 'birbaşa anlama', 'tətbiq etmək'),
(5, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '5-4.3.2', $$Mürəkkəb cümlənin tərkib hissələri arasında vergül işarəsindən yerində istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

-- Standart 5-4.4
(5, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '5-4.4.1', $$Söz tərkibindəki morfemlərin semantik mənasından çıxış edərək sözün mənasını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),
(5, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '5-4.4.2', $$Sözü müxtəlif yollarla izah edir.$$, '2', 'şərh etmə', 'anlamaq'),
(5, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '5-4.4.3', $$Sözün həqiqi və məcazi mənalarını, sadə üslubi fiqurları, frazeologizmləri müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək');

-- ============================================================
-- VI SİNİF (Grade 6)
-- ============================================================

INSERT INTO azdili_standartlari (sinif, saha, standard_kodu, standard_metni, alstandart_kodu, alstandart_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi) VALUES

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
(6, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '6-1.1.1', $$Mətni dinləyərkən əsas fakt və fikirləri qeyd edir.$$, '2', 'məlumat alma', 'anlamaq'),
(6, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '6-1.1.2', $$Dinlədiyi mətndəki əsas fikri dəstəkləyən faktları müəyyənləşdirir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'dinleme_danisma', '1.1', $$Dinləyib-anlama: Dinlədiyi məlumatı anlayır, izah edir və münasibət bildirir.$$, '6-1.1.3', $$Dinlədiyi mətndə hadisə və fikirlərə münasibətini əsaslandırır.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),

(6, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '6-1.2.1', $$Müzakirə və debatlarda tolerantlıq nümayiş etdirir.$$, '3', 'qiymətləndirmə', 'tətbiq etmək'),
(6, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və dialoqlarda dinlədiyi fikirlərə adekvat reaksiya verir.$$, '6-1.2.2', $$Müzakirə zamanı danışanın fikrini verdiyi suallar əsasında aydınlaşdırır və rəy bildirir.$$, '3', 'şərh etmə', 'anlamaq'),

(6, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '6-1.3.1', $$Verilmiş mövzuya və ya situasiyaya uyğun mətn qurub nəql edir.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(6, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '6-1.3.2', $$Mövzu üzrə hazırladığı qrafik və ya verbal-qrafik informasiyanı rabitəli şəkildə şifahi təqdim edir.$$, '3', 'inteqrasiya', 'tətbiq etmək'),

(6, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '6-1.4.1', $$Şifahi nitqində yeni öyrəndiyi akademik sözlərdən və frazeoloji ifadələrdən kontekstə uyğun istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '6-1.4.2', $$Danışarkən səs tonunu tənzimləyir, pauza və məntiqi vurğudan istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
(6, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '6-2.1.1', $$Mətni oxuyarkən obrazların nitqini onların xarakterinə və emosional vəziyyətinə uyğun səsləndirilməsi.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '6-2.1.2', $$Mətndəki fakt və hadisələrin ardıcıllığını müəyyənləşdirir.$$, '2', 'məlumat alma', 'anlamaq'),
(6, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '6-2.1.3', $$Kontekstdən çıxış edərək mətndə tanış olmayan sözün mənasını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),

(6, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '6-2.2.1', $$Mətndə fikirləri, faktlar və hadisələr arasındakı əlaqəni müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '6-2.2.2', $$Mətndə açıq şəkildə ifadə olunmayan şəkildə fikirləri digər fikirlərdən fərqləndirir.$$, '3', 'şərh etmə', 'təhlil etmək'),

(6, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '6-2.3.1', $$Mətndən əsas fikri müəyyənləşdirməyə kömək edən məqamları seçərək izah edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '6-2.3.2', $$Mətndəki fikirlərin əsaslandırılmasında faktların rolunu izah edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '6-2.3.3', $$Mətnin tərkib hissələrini və struktur elementlərini onun məzmunu ilə əlaqəli şərh edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '6-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '6-2.3.5', $$Müxtəlif mətnləri mövzu, məzmun-struktur, ideya baxımından müqayisə edir.$$, '3', 'qiymətləndirmə', 'təhlil etmək'),
(6, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '6-2.3.6', $$Mətndəki fakt, hadisə və obrazlarla bağlı şəxsi mövqeyini bildirir.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),

-- Məzmun xətti 3: YAZI
(6, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '6-3.1.1', $$Mətn yazarkən bədii və qeyri-bədii mətnlərin struktur elementləri arasındakı fərqin izahı.$$, '3', 'şərh etmə', 'anlamaq'),
(6, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '6-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(6, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '6-3.2.1', $$Araşdırdığı mənbələrdən istifadə etməklə qeyri-bədii mətnlər yazır.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(6, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '6-3.2.2', $$Tənqidi və yaradıcı təfəkkür nümayiş etdirməklə bədii və qeyri-bədii mətnlər yazır.$$, '3', 'qiymətləndirmə', 'yaratmaq'),
(6, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '6-3.2.3', $$Sadə direktiv xarakterli mətnlər tertib edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '6-3.2.4', $$Bir neçə mənbədən istifadə etməklə apardığı araşdırma layihəsinin nəticələrini tezislər şəklində təqdim edir.$$, '3', 'inteqrasiya', 'yaratmaq'),

-- Məzmun xətti 4: DİL QAYDALARI
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.1', $$Sözlərdə kar və cingiltili samitlərin deyilişi və yazılışı qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.2', $$Səsdüşümü və səsartımı baş verən sözlərdə orfoqrafiya və orfoepiya qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.3', $$Mürəkkəb adların böyük hərflə yazılışı qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.4', $$"L" samiti ilə başlanan şəkilçilərin tələffüz qaydalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.5', $$Xəbər vəzifəsində olan sözlərin deyilişi və yazılışı qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.6', $$Sözlərdə bəzi şəkilçi və morfemlərin yazılışı ilə bağlı qaydalara əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.7', $$Sözlərin təkrarından yaranan mürəkkəb sözlərin yazılışı qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '6-4.1.8', $$Bəzi köməkçi nitq hissələrinin bitişik və ayrı yazılış qaydalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(6, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '6-4.2.1', $$Kontekstdən çıxış edərək əsas nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '3', 'şərh etmə', 'anlamaq'),
(6, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '6-4.2.2', $$Köməkçi nitq hissələrinin semantik mənalarını və cümlədə funksiyasını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),
(6, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '6-4.2.3', $$İsmi və feili birləşmələrin növlərini və yaranma yollarını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),
(6, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '6-4.2.4', $$Cümlədəki fikrin ifadə olunmasında baş və ikincidərəcəli üzvlərin rolunu müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(6, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '6-4.2.5', $$Cümlədə söz sırasını müəyyən edir.$$, '3', 'məlumat alma', 'anlamaq'),

(6, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '6-4.3.1', $$Bağlayıcılardan əvvəl və sonra vergül işarəsindən yerində istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '6-4.3.2', $$O, bu əvəzliyindən sonra vergül işarəsindən yerində istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(6, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '6-4.4.1', $$Sözün morfoloji tərkibindən çıxış edərək mənasını müəyyənləşdirir və lüğət vasitəsilə dəqiqləşdirir.$$, '3', 'şərh etmə', 'anlamaq'),
(6, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '6-4.4.2', $$Sözü izah edərkən hiperonim, sinonim və antonimlər istifadə edir.$$, '3', 'şərh etmə', 'tətbiq etmək'),
(6, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '6-4.4.3', $$Bədii mətnlərdə sadə məcazları və üslubi fiqurları müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),

-- ============================================================
-- VII SİNİF (Grade 7)
-- ============================================================

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
(7, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '7-1.1.1', $$Dinlədiyi mətnin planını götürdüyü qeydləri yarımbaşlıqlar üzrə qruplaşdırır.$$, '3', 'məlumat alma', 'təhlil etmək'),
(7, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '7-1.1.2', $$Dinlədiyi mətndəki fakt və fikirləri ümumi müəyyənləşdirir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(7, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '7-1.1.3', $$Digər fənlər üzrə əldə etdiyi məlumatlardan bilgilərlə müqayisə edilməsi.$$, '3', 'inteqrasiya', 'təhlil etmək'),

(7, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '7-1.2.1', $$Müzakirə və debatlarda təyin olunmuş formata əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '7-1.2.2', $$Müzakirə və debatlarda qarşı tərəfin fikrinə münasibətini ifadə etmək üçün arqument və əks-arqumentlər gətirir.$$, '3', 'qiymətləndirmə', 'qiymətləndirmək'),

(7, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '7-1.3.1', $$Şəkil və qrafik informasiya üzrə mətn qurub nəql edir.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(7, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '7-1.3.2', $$Mövzu üzrə əldə edilən məlumatları açar sözlər, tezislər şəklində qeyd etmək və onların əsasında mətn qurub danışmaq.$$, '3', 'inteqrasiya', 'tətbiq etmək'),

(7, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '7-1.4.1', $$Müzakirə və debatlarda çıxışı zamanı uyğun standart ifadələrdən və ara sözlərdən istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '7-1.4.2', $$Danışarkən məzmuna uyğun intonasiya, jest və mimikadan istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
(7, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '7-2.1.1', $$Qeyd götürməklə mətndəki əsas və ikincidərəcəli faktları müəyyən edir.$$, '3', 'məlumat alma', 'təhlil etmək'),
(7, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '7-2.1.2', $$Kontekstdən (söz birləşməsi, cümlə, abzas, mətn) çıxış edərək tanış olmayan sözün mənasını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),

(7, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '7-2.2.1', $$Mətnin ideyasının açılmasında obrazların və əsas epizodun rolunu müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(7, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '7-2.2.2', $$Mətndəki hadisə və faktları əlaqələndirərək açıq şəkildə ifadə olunmamış informasiyanın əldə edilməsi.$$, '4', 'şərh etmə', 'təhlil etmək'),

(7, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '7-2.3.1', $$Mətnin ideyasının açılmasında xarakterlərin rolunu izah edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(7, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '7-2.3.2', $$Mətndə faktlara əsaslanaraq müəllif mövqeyinə münasibətin bildirilməsi.$$, '4', 'qiymətləndirmə', 'qiymətləndirmək'),
(7, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '7-2.3.3', $$Bədii və qeyri-bədii mətnlərin struktur elementlərinin ümumi məzmuna təsirini izah edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(7, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '7-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(7, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '7-2.3.5', $$Oxuduğu bədii mətni eyni mövzuda olan qeyri-bədii mətnlə müqayisə edir.$$, '4', 'qiymətləndirmə', 'təhlil etmək'),
(7, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '7-2.3.6', $$Mətnin məzmununa yaradıcı yanaşmaqla süjetdə dəyişikliklər edir.$$, '4', 'qiymətləndirmə', 'yaratmaq'),

-- Məzmun xətti 3: YAZI
(7, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '7-3.1.1', $$Mətnin növündən asılı olaraq yazısında fikir və məlumatların ardıcıllığına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '7-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(7, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '7-3.2.1', $$Tanış olduğu məlumatlar əsasında informativ və izahedici mətnlər yazır.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(7, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '7-3.2.2', $$Mövzu ilə bağlı fikirlərini arqumentləşdirməklə mətnlər yazır.$$, '4', 'qiymətləndirmə', 'yaratmaq'),
(7, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '7-3.2.3', $$Sadə direktiv xarakterli mətnlər tərtib edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '7-3.2.4', $$Mənbələrdən istifadə etməklə mövzunu müxtəlif aspektlərdən araşdırır və tezislər şəklində təqdim edir.$$, '4', 'inteqrasiya', 'yaratmaq'),

-- Məzmun xətti 4: DİL QAYDALARI
(7, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '7-4.1.1', $$Vurğusu dəyişməklə mənası dəyişən sözlərin tələffüzünün fərqləndirilməsi.$$, '3', 'şərh etmə', 'anlamaq'),
(7, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '7-4.1.2', $$Mürəkkəb adların böyük hərflə yazılışı qaydalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '7-4.1.3', $$Bəzi sözlərin hal şəkilçiləri qəbul edərkən deyilişi və yazılışı arasında yaranan fərqi izah edir.$$, '3', 'şərh etmə', 'anlamaq'),
(7, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '7-4.1.4', $$Sinonim və hiponimlərin birləşməsindən əmələ gələn mürəkkəb sözlərin yazılışı qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '7-4.1.5', $$Bəzi köməkçi nitq hissələrinin bitişik və ayrı yazılış qaydalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(7, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '7-4.2.1', $$Kontekstdən çıxış edərək əsas nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '3', 'şərh etmə', 'anlamaq'),
(7, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '7-4.2.2', $$Köməkçi nitq hissələrinin semantik məna növlərinin fərqləndirilməsi.$$, '3', 'şərh etmə', 'anlamaq'),
(7, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '7-4.2.3', $$Cümlədə söz birləşmələrini və onların sintaktik funksiyasını müəyyən edir.$$, '3', 'şərh etmə', 'təhlil etmək'),
(7, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '7-4.2.4', $$Cümlədəki fikrin ifadə olunmasında cümlə üzvlərinin, qrammatik bağlı olmayan sözlərin rolunu müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(7, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '7-4.2.5', $$Sual və nida cümlələrinin yaranma yollarını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),

(7, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '7-4.3.1', $$Xitab və ara sözlərdə durğu işarələrindən yerində istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(7, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '7-4.3.2', $$Həmcins cümlə üzvlərində vergül işarəsindən yerində istifadə edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(7, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '7-4.4.1', $$Sözün morfoloji tərkibindən çıxış edərək mənasını müəyyənləşdirir və lüğət vasitəsilə dəqiqləşdirir.$$, '3', 'şərh etmə', 'anlamaq'),
(7, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '7-4.4.2', $$Sözü izah etmək üçün anlayışın xüsusiyyətlərini sadalayır, hiperonim, sinonim və antonimlerdən istifadə edir.$$, '3', 'şərh etmə', 'tətbiq etmək'),
(7, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '7-4.4.3', $$Bədii mətnlərdə sadə məcazları və üslubi fiqurları müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək');

-- ============================================================
-- VIII SİNİF (Grade 8)
-- ============================================================

INSERT INTO azdili_standartlari (sinif, saha, standard_kodu, standard_metni, alstandart_kodu, alstandart_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi) VALUES

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
(8, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '8-1.1.1', $$Dinlədiyi mətndən götürdüyü qeydləri qrafik vasitələrlə görsəlləşdirir.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(8, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '8-1.1.2', $$Dinlədiyi mətndəki fakt və fikirləri ümumiləşdirərək nəticə çıxarır.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '8-1.1.3', $$Bildiyi faktlardan istifadə etməklə arqumentativ və polemik mətndə müəllif mövqeyinə münasibət bildirir.$$, '4', 'qiymətləndirmə', 'qiymətləndirmək'),

(8, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '8-1.2.1', $$Müzakirə və debatlarda təyin olunmuş formata və reqlamentə əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(8, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '8-1.2.2', $$Müzakirədə səslənən müxtəlif fikirləri yığcam şəkildə ümumiləşdirir və münasibət bildirir.$$, '4', 'qiymətləndirmə', 'qiymətləndirmək'),

(8, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '8-1.3.1', $$Oxuduğu və dinlədiyi eyni mövzuda məlumatları ümumiləşdirərək mətn qurub danışır.$$, '4', 'inteqrasiya', 'yaratmaq'),
(8, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '8-1.3.2', $$Mövzu üzrə araşdırdığı məlumat və fikirləri çatdırmaq üçün müvafiq təqdimetmə formasından istifadə edir.$$, '4', 'inteqrasiya', 'tətbiq etmək'),

(8, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '8-1.4.1', $$Şifahi nitqində orfoepiya normalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(8, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '8-1.4.2', $$Danışarkən məzmuna uyğun intonasiya, jest, mimikadan istifadə edir, göz təması qurur.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
(8, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '8-2.1.1', $$Mətndən götürülən qeydlər əsasında yaddaş xəritəsinin tərtib edilməsi.$$, '3', 'inteqrasiya', 'tətbiq etmək'),
(8, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '8-2.1.2', $$Kontekstdən çıxış edərək söz və ifadələrin (frazemlərin) mənasını müəyyən edir.$$, '3', 'şərh etmə', 'anlamaq'),

(8, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '8-2.2.1', $$Mətndə irəli sürülən fikri əsaslandıran arqumentləri müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '8-2.2.2', $$Mətndəki məlumatlardan çıxış edərək sətiraltı fikir və informasiyanı izah edir.$$, '4', 'şərh etmə', 'təhlil etmək'),

(8, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '8-2.3.1', $$Mətnin ideyasını müəyyənləşdirərkən obrazların davranışını və müəllif mövqeyini nəzərə alır.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '8-2.3.2', $$Oxuduğu mətndəki məlumatları digər fənlərdən əldə etdiyi biliklərlə müqayisə edərək əsas fikrə münasibət bildirir.$$, '4', 'inteqrasiya', 'qiymətləndirmək'),
(8, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '8-2.3.3', $$Mətnin növündən və tipindən asılı olaraq məzmunun açılmasında struktur elementlərinin rolunu izah edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '8-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '8-2.3.5', $$Eyni mövzuda olan müxtəlif tipli mətnləri müqayisə edir.$$, '4', 'qiymətləndirmə', 'təhlil etmək'),
(8, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '8-2.3.6', $$Mətnin məzmununa və kompozisiyasına yaradıcı məzmunda dəyişikliklər edir.$$, '4', 'qiymətləndirmə', 'yaratmaq'),

-- Məzmun xətti 3: YAZI
(8, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '8-3.1.1', $$Mətn yazarkən müxtəlif növ mətnlərə (bədii, informativ, izahedici, arqumentativ və s.) xas olan struktur elementlərini nəzərə alır.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(8, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '8-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(8, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '8-3.2.1', $$Dinlədiyi və ya oxuduğu mətnlə bağlı icmal xarakterli yazı tərtib edir.$$, '4', 'inteqrasiya', 'tətbiq etmək'),
(8, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '8-3.2.2', $$Təsviri və mühakimə xarakterli mətnlərin xüsusiyyətlərini nəzərə almaqla bədii və qeyri-bədii mətnlər yazır.$$, '4', 'qiymətləndirmə', 'yaratmaq'),
(8, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '8-3.2.3', $$Sadə formalı işgüzar sənədlər tərtib edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(8, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '8-3.2.4', $$Müxtəlif fənlər üzrə biliklərini araşdırdığı məlumatlarla əlaqələndirərək təqdimat materialı hazırlayır.$$, '4', 'inteqrasiya', 'yaratmaq'),

-- Məzmun xətti 4: DİL QAYDALARI
(8, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '8-4.1.1', $$Bəzi alınma sözlərdə və uzun saitli sözlərdə vurğulu hecanın fərqləndirilməsi.$$, '3', 'şərh etmə', 'anlamaq'),
(8, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '8-4.1.2', $$Mürəkkəb adların böyük hərflə yazılışı qaydalarına riayət edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(8, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '8-4.1.3', $$Açıq saitle bitən çoxhecalı feillərə y bitişdirici samiti ilə başlayan qrammatik şəkilçilər artırdıqda həmin saitlərin qapalı saitə çevrilməsi qaydasına əməl edilməsi.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(8, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '8-4.1.4', $$İzafət tərkiblərinin yazılış qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(8, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '8-4.1.5', $$Sözlərdə idi, imiş hissəciklərinin deyilişi və yazılışı qaydalarına əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

(8, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '8-4.2.1', $$Kontekstdən çıxış edərək əsas nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '4', 'şərh etmə', 'anlamaq'),
(8, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '8-4.2.2', $$İdi, imiş hissəciklərinin qoşulduğu feillərin semantik mənasını müəyyən edir.$$, '4', 'şərh etmə', 'anlamaq'),
(8, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '8-4.2.3', $$Cümlədə söz birləşmələrini və onların sintaktik funksiyasını müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '8-4.2.4', $$Cümlədə sözlər arasında sintaktik əlaqədən çıxış edərək sözlərin qrammatik formasının müəyyən edilməsi.$$, '4', 'şərh etmə', 'təhlil etmək'),
(8, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '8-4.2.5', $$Tabeli müstəqil komponentin komponentləri arasında məna əlaqələrini müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),

(8, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '8-4.3.1', $$Aydınlaşdırma əlaqəli mürəkkəb cümlədə durğu işarələrindən yerində istifadə edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(8, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '8-4.3.2', $$Nöqtə, üç nöqtə, sual və nida işarələrinin işlənmə məqamlarını fərqləndirir.$$, '4', 'şərh etmə', 'anlamaq'),

(8, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '8-4.4.1', $$Sözün morfoloji tərkibindən çıxış edərək mənasını müəyyənləşdirir və lüğət vasitəsilə dəqiqləşdirir.$$, '4', 'şərh etmə', 'anlamaq'),
(8, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '8-4.4.2', $$Hiperonimin köməyi ilə sözü izah edərkən uyğun sintaktik konstruksiyadan istifadə edir.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(8, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '8-4.4.3', $$Bədii mətnlərdə metonimiya, metafor, sinekdoxa kimi bədii təsvir vasitələrinin fərqləndirilməsi.$$, '4', 'şərh etmə', 'təhlil etmək'),

-- ============================================================
-- IX SİNİF (Grade 9)
-- ============================================================

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
(9, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '9-1.1.1', $$Dinlədiyi mətndən götürdüyü qeydləri qrafik vasitələrlə görsəlləşdirir.$$, '4', 'inteqrasiya', 'tətbiq etmək'),
(9, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '9-1.1.2', $$Dinlədiyi məlumatları başqa mənbələrdən aldığı məlumatlarla müqayisə edir.$$, '4', 'inteqrasiya', 'təhlil etmək'),
(9, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '9-1.1.3', $$Şəxsi bilikləri və əldə etdiyi başqa məlumatlardan çıxış edərək dinlədiyi fikirlərə münasibət bildirir.$$, '4', 'qiymətləndirmə', 'qiymətləndirmək'),

(9, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '9-1.2.1', $$Müzakirə və ya debatın gedişi ilə bağlı şərtlərə əməl edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '9-1.2.2', $$Dinlənilən fikrə münasibətini əsaslandırmaq üçün rasional və emosional arqumentlər gətirir.$$, '4', 'qiymətləndirmə', 'qiymətləndirmək'),

(9, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '9-1.3.1', $$Həyatda gördüyü və ya təxəyyülünə uyğun hadisə, varlıq haqqında fikir və təəssüratlarını rabitəli şəkildə ifadə edir.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(9, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '9-1.3.2', $$Təqdimat zamanı fikirlərin məntiqi ardıcıllıqla ifadə edilməsi.$$, '4', 'inteqrasiya', 'tətbiq etmək'),

(9, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '9-1.4.1', $$Şifahi nitqində orfoepiya normalarına riayət edir və zəngin söz ehtiyatı nümayiş etdirir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '9-1.4.2', $$Nitqində səs tonu, jest və mimikalar vasitəsilə emosiyalarını nümayiş etdirir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
(9, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '9-2.1.1', $$Mətnin və onun struktur elementlərinin ehtiva etdiyi məlumatları müəyyənləşdirir.$$, '4', 'məlumat alma', 'təhlil etmək'),
(9, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '9-2.1.2', $$Kontekstdən çıxış edərək söz və ifadələrin (frazemlərin, atalar sözlərinin) mənasını müəyyən edir.$$, '4', 'şərh etmə', 'anlamaq'),

(9, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '9-2.2.1', $$Mətndə hadisələr (faktlar) arasında uyğunluğu (uyğunsuzluğu) müəyyənləşdirməklə əsaslandırır.$$, '4', 'şərh etmə', 'təhlil etmək'),
(9, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '9-2.2.2', $$Mətndəki məlumatlardan çıxış edərək sətiraltı fikir və informasiyanı əsaslandırır.$$, '5', 'şərh etmə', 'təhlil etmək'),

(9, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '9-2.3.1', $$Mətnin ideyasının açılmasında xarakterlərin və bədii detalların rolunu izah edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(9, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '9-2.3.2', $$Mətndə arqument-lər ardıcıllığının fikrin əsaslandırılmasında rolunu izah edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(9, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '9-2.3.3', $$Mətn strukturunun formalaşmasında müəllifin tətbiq etdiyi üsulları təhlil edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(9, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '9-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(9, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '9-2.3.5', $$Eyni mövzuda olan müxtəlif tipli mətnləri müqayisəli təhlil edir.$$, '5', 'qiymətləndirmə', 'qiymətləndirmək'),
(9, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '9-2.3.6', $$Mətndəki dəyərlərə və müəllif yanaşmasına öz münasibətini bildirir.$$, '5', 'qiymətləndirmə', 'qiymətləndirmək'),

-- Məzmun xətti 3: YAZI
(9, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '9-3.1.1', $$Mətni strukturlaşdırarkən onun forma və məzmun xüsusiyyətlərini nəzərə alır.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(9, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '9-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),

(9, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '9-3.2.1', $$Araşdırmaları əsasında qeyri-xronoloji informativ mətnlər yazır.$$, '4', 'inteqrasiya', 'yaratmaq'),
(9, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '9-3.2.2', $$Fikir, arqument və faktlar arasında məntiqi əlaqəni gözləməklə arqumentativ mətnlər yazır.$$, '5', 'qiymətləndirmə', 'yaratmaq'),
(9, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '9-3.2.3', $$Sadə formalı işgüzar sənədlər tərtib edir.$$, '3', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '9-3.2.4', $$Əldə etdiyi məlumatları tezislər, açar sözlər şəklində ifadə etməklə təqdimat materialı hazırlayır.$$, '4', 'inteqrasiya', 'yaratmaq'),

-- Məzmun xətti 4: DİL QAYDALARI
(9, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '9-4.1.1', $$Paronimlərin yazılışında orfoqrafik normalara riayət edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '9-4.1.2', $$Dırnaq içində yazılan mürəkkəb adların böyük hərflə yazılışı qaydalarına riayət edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '9-4.1.3', $$Sözlərdə q, k, ğ, g samitləri olan şəkilçilərin yazılış və tələffüz qaydalarının izah edilməsi.$$, '4', 'şərh etmə', 'anlamaq'),
(9, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '9-4.1.4', $$Abreviaturların və onlara qoşulan şəkilçilərin deyilişi və yazılışı qaydalarına əməl edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '9-4.1.5', $$Söz birləşmələri və tərkibi sözlərdən yaranmış mürəkkəb sözlərin bitişik yazılışı qaydalarına əməl edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '9-4.1.6', $$Sözlərdə isə, ikən hissəciklərinin şəkilçiləşmə prinsiplərinə əməl edir.$$, '4', 'şərh etmə', 'tətbiq etmək'),

(9, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '9-4.2.1', $$Kontekstdən çıxış edərək köməkçi söz və morfemlərin qrammatik omonimliyini izah edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(9, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '9-4.2.2', $$İsə, ikən sözlərinin semantik mənasını müəyyən edir.$$, '4', 'şərh etmə', 'anlamaq'),
(9, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '9-4.2.3', $$Cümlə üzvü rolunda çıxış edən mürəkkəb söz birləşmələrini müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(9, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '9-4.2.4', $$Həmcins cümlə üzvləri və ümumiləşdirici sözü, cümlə üzvü və onun əlavəsini müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(9, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '9-4.2.5', $$Vasitəsiz nitqin vasitəli nitqə çevrilməsi yollarının müəyyənləşdirilməsi.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.2', $$Qrammatika: Nitq hissələrinin morfoloji tərkibini və semantik mənasını izah edir.$$, '9-4.2.6', $$Tabeli mürəkkəb cümlənin sadə cümləyə çevrilməsi yollarının müəyyən edilməsi.$$, '5', 'şərh etmə', 'tətbiq etmək'),

(9, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '9-4.3.1', $$Vasitəsiz nitqdə və dialoqlarda durğu işarələrindən istifadə edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '9-4.3.2', $$Həmcins cümlə üzvləri və ümumiləşdirici sözü, cümlə üzvü və onun əlavəsi arasında durğu işarələrindən yerində istifadə edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),

(9, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '9-4.4.1', $$Sözün morfoloji tərkibindən çıxış edərək mənasını müəyyənləşdirir və lüğətin köməyi ilə etimoloji mənasını müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək'),
(9, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '9-4.4.2', $$Mətndə rast gəlinən arxaizm və dialektizmlərin olmayan sözləri kontekstə görə izah edir.$$, '4', 'şərh etmə', 'anlamaq'),
(9, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '9-4.4.3', $$Sözün leksikoqrafik qaydalara uyğun izahını verir və kontekstdə işlədir.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(9, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '9-4.4.4', $$Bədii mətndəki sadə üslubi fiqurları müəyyən edir.$$, '4', 'şərh etmə', 'təhlil etmək');

-- ============================================================
-- X SİNİF (Grade 10)
-- ============================================================

INSERT INTO azdili_standartlari (sinif, saha, standard_kodu, standard_metni, alstandart_kodu, alstandart_metni, pisa_saviyyesi, pirls_kateqoriya, blooms_seviyyesi) VALUES

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
(10, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '10-1.1.1', $$Dinlədiyi mətndən götürdüyü qeydləri qrafik vasitələrlə görsəlləşdirir.$$, '4', 'inteqrasiya', 'tətbiq etmək'),
(10, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '10-1.1.2', $$Dinlədiyi məlumatları şəxsi bilikləri və əldə etdiyi başqa məlumatlarla müqayisə edir.$$, '5', 'inteqrasiya', 'təhlil etmək'),

(10, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '10-1.2.1', $$Müzakirə zamanı səslənən fikirləri münasibət ifadə etmək üçün arqument və əks-arqumentlər gətirir.$$, '5', 'qiymətləndirmə', 'qiymətləndirmək'),

(10, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '10-1.3.1', $$Müəyyən mövzuda mətni dinlədikdən və ya oxuduqdan sonra əlavə biliklərinə uyğun yeni məlumatlarla genişləndirir.$$, '5', 'inteqrasiya', 'yaratmaq'),
(10, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '10-1.3.2', $$Problemlə bağlı təqdimat edərkən fikirlərini gətirilməsi və həlli yollarını göstərir.$$, '5', 'inteqrasiya', 'yaratmaq'),

(10, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '10-1.4.1', $$Şifahi nitqində fonetik, leksik normalara əməl edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(10, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '10-1.4.2', $$Nitq prosesində danışığı ilə ifadə tərzi uyğunlaşdırır.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),

-- Məzmun xətti 2: OXU
(10, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '10-2.1.1', $$Mətnin annotasiyasını yazmaqla məzmunu anladığını nümayiş etdirir.$$, '5', 'inteqrasiya', 'yaratmaq'),
(10, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '10-2.1.2', $$Kontekstdən çıxış edərək söz və ifadələrin (frazemlərin, atalar sözlərinin, termin və alınma sözlərinin) mənasını müəyyən edir.$$, '5', 'şərh etmə', 'anlamaq'),

(10, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '10-2.2.1', $$Mətndə fikirlərin irəli sürdüyü fikrə uyğun faktların müəyyən edilməsi.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '10-2.2.2', $$Açıq ifadə olunmayan məlumatı müəyyənləşdirmək üçün faktlardan istifadə edilməsi.$$, '5', 'şərh etmə', 'təhlil etmək'),

(10, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '10-2.3.1', $$Mətndə ideyanın açılmasına xidmət edən məqamları müəyyən edərək əlaqələndirir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '10-2.3.2', $$Mətndəki fikrə münasibətini mətndən seçdiyi faktlarla və əldə etdiyi məlumatlarla əsaslandırır.$$, '5', 'qiymətləndirmə', 'qiymətləndirmək'),
(10, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '10-2.3.3', $$Mətnin müxtəlif hissələri arasında əlaqələrin onun ümumi strukturuna, mətndə ifadə olunan fikrə təsirinin rolunu izah edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '10-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '10-2.3.5', $$Oxuduğu mətndəki məlumatları digər mənbələrlə müqayisə edir.$$, '5', 'qiymətləndirmə', 'qiymətləndirmək'),
(10, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '10-2.3.6', $$Mətnin məzmununa və müəllif yanaşmasına yaradıcı münasibət nümayiş etdirir.$$, '5', 'qiymətləndirmə', 'yaratmaq'),

-- Məzmun xətti 3: YAZI
(10, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '10-3.1.1', $$Mətn yazarkən struktur elementlərinin funksiyalarını nəzərə alır.$$, '4', 'şərh etmə', 'tətbiq etmək'),
(10, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '10-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),

(10, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '10-3.2.1', $$Məlumatları yazıda əks etdirərkən informativ və izahedici mətnlərin xüsusiyyətlərini nəzərə alır.$$, '5', 'şərh etmə', 'tətbiq etmək'),
(10, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '10-3.2.2', $$Mövzu ilə bağlı araşdırdığı mənbələrə tənqidi münasibət ifadə etməklə arqumentativ və izahedici mətnlər yazır.$$, '5', 'qiymətləndirmə', 'yaratmaq'),
(10, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '10-3.2.3', $$Sadə formalı işgüzar sənədlər tərtib edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(10, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '10-3.2.4', $$Əldə etdiyi məlumatlara öz mövqeyini ifadə etməklə təqdimat materialı hazırlayır.$$, '5', 'inteqrasiya', 'yaratmaq'),

-- Məzmun xətti 4: DİL QAYDALARI
(10, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '10-4.1.1', $$Alınma sözlərin yazılışını mənbə dildəki tələffüzü ilə müqayisə edir və orfoqrafik normalara uyğun yazır.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '10-4.1.2', $$Mürəkkəb adların böyük hərflə yazılışı qaydalarına riayət edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(10, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '10-4.1.3', $$Yazılı və şifahi nitqdə morfonoloji qaydalara əməl edir.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),
(10, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '10-4.1.4', $$Mürəkkəb və tərkibi sözlərin bitişik, ayrı və defislə yazılışı qaydalarına əməl edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),

(10, 'dil_qaydalari', '4.2', $$Qrammatika: Sözlərin qrammatik formasını və tərkibindəki morfemlərin semantik funksiyasını izah edir.$$, '10-4.2.1', $$Kontekstdən çıxış edərək sözlərin qrammatik formasını və tərkibindəki morfemlərin semantik funksiyasını izah edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'dil_qaydalari', '4.2', $$Qrammatika: Sözlərin qrammatik formasını və tərkibindəki morfemlərin semantik funksiyasını izah edir.$$, '10-4.2.2', $$Müxtəlif konstruksiyalı söz birləşmələrini fərqləndirir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'dil_qaydalari', '4.2', $$Qrammatika: Sözlərin qrammatik formasını və tərkibindəki morfemlərin semantik funksiyasını izah edir.$$, '10-4.2.3', $$Həmcins cümlə üzvlərinə xas cəhətlərin müəyyənləşdirilməsi.$$, '4', 'şərh etmə', 'anlamaq'),
(10, 'dil_qaydalari', '4.2', $$Qrammatika: Sözlərin qrammatik formasını və tərkibindəki morfemlərin semantik funksiyasını izah edir.$$, '10-4.2.4', $$Cümlə üzvləri və ümumiləşdirici sözü, cümlə üzvü və onun əlavəsini müəyyən edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'dil_qaydalari', '4.2', $$Qrammatika: Sözlərin qrammatik formasını və tərkibindəki morfemlərin semantik funksiyasını izah edir.$$, '10-4.2.5', $$Əlavə cümlənin semantik funksiyasını müəyyən edir.$$, '5', 'şərh etmə', 'təhlil etmək'),

(10, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '10-4.3.1', $$Əlavə cümlələrdə durğu işarələrindən istifadə edir.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),
(10, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '10-4.3.2', $$Vergül, mötərizə, dırnaq işarələrinin işlənmə məqamlarını müəyyən edir.$$, '5', 'şərh etmə', 'anlamaq'),

(10, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '10-4.4.1', $$Sözün morfoloji tərkibindən çıxış edərək mənasını müəyyənləşdirir və etimoloji mənası ilə müqayisə edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '10-4.4.2', $$Konkret varlıq bildirən isimlərin və əlamət bildirən sifətlərin izahını verir və lüğətdəki izahla müqayisə edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(10, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '10-4.4.3', $$Nitqdə qeyri-fəal leksikaya aid söz və ifadələrin nümunələrinin fərqləndirilməsi.$$, '5', 'şərh etmə', 'təhlil etmək'),

-- ============================================================
-- XI SİNİF (Grade 11)
-- ============================================================

-- Məzmun xətti 1: DİNLƏMƏ VƏ DANIŞMA
(11, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '11-1.1.1', $$Dinlədiyi mətnin məzmununu görsəlləşdirmək məqsədi ilə uyğun qrafik vasitə seçir və tətbiq edir.$$, '5', 'inteqrasiya', 'yaratmaq'),
(11, 'dinleme_danisma', '1.1', $$Dinləyib-qavrama: Dinlədiyi məlumatı qavrayır və şərh edir.$$, '11-1.1.2', $$Dinlədiyi mətndəki fikirlərlə arqument və faktlar arasındakı əlaqəni izah edir.$$, '5', 'şərh etmə', 'təhlil etmək'),

(11, 'dinleme_danisma', '1.2', $$Dialoji nitq: Müzakirə və debatlarda iştirak edir.$$, '11-1.2.1', $$Polemikalarda problemə baxış bucaqlarından birini seçir və onu əsaslandırmaq üçün arqument və əks-arqumentlərdən istifadə edir.$$, '6', 'qiymətləndirmə', 'qiymətləndirmək'),

(11, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '11-1.3.1', $$Şəxsi düşüncələrini əlavə etməklə və münasibətini əsaslandırmaqla dinlədiyi mətni genişləndirir.$$, '5', 'inteqrasiya', 'yaratmaq'),
(11, 'dinleme_danisma', '1.3', $$Rabitəli nitq: Hər hansı mövzuda danışarkən rabitəli nitq nümayiş etdirir.$$, '11-1.3.2', $$Təqdimat zamanı fikirləri əsaslandırmaq üçün arqumentin müxtəlif növlərindən istifadə edir.$$, '6', 'inteqrasiya', 'qiymətləndirmək'),

(11, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '11-1.4.1', $$Şifahi nitqində fonetik, leksik normalara əməl edir.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),
(11, 'dinleme_danisma', '1.4', $$Ədəbi dilin normaları və ekspressiv nitq: Danışarkən ədəbi dilin normalarına əməl edir və ekspressiv nitq nümayiş etdirir.$$, '11-1.4.2', $$Monoloq çıxışları zamanı natiqlik bacarıqlarını nümayiş etdirir.$$, '5', 'birbaşa anlama', 'yaratmaq'),

-- Məzmun xətti 2: OXU
(11, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '11-2.1.1', $$Mətndə əsas fikrin açılmasına xidmət edən fakt və detalları qeyd edir.$$, '5', 'məlumat alma', 'təhlil etmək'),
(11, 'oxu', '2.1', $$Faktoloji qavrama: Mətndə açıq şəkildə ifadə olunmuş informasiyanı mənimsədiyini nümayiş etdirir.$$, '11-2.1.2', $$Kontekstdən çıxış edərək mətndəki ümumişlək olmayan söz və ifadələrin mənasını izah edir və lüğətdəki mənası ilə müqayisə edir.$$, '5', 'şərh etmə', 'təhlil etmək'),

(11, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '11-2.2.1', $$Mətndəki əsas fikrlə onun açılmasına xidmət edən köməkçi fikirləri əlaqələndirir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(11, 'oxu', '2.2', $$Şərhetmə və əlaqələndirmə: Mətndə açıq şəkildə ifadə olunmayan informasiya haqqında fikir yürüdür.$$, '11-2.2.2', $$Mətndə əks olunan məlumatları məlum olan faktlarla əlaqələndirərək mühakimənin yürüdülməsi və əsaslandırılması.$$, '6', 'şərh etmə', 'qiymətləndirmək'),

(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.1', $$Mətndəki aparıcı və köməkçi motivləri obrazlarla və əsas ideya ilə əlaqələndirir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.2', $$Mətndəki məlumatlara əsasən irəli sürülən mühakimələrin əsaslandırılması.$$, '6', 'qiymətləndirmə', 'qiymətləndirmək'),
(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.3', $$Müxtəlif tipli bədii və qeyri-bədii mətnlərdə struktur elementlərinin funksiyasını izah edir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.4', $$Mətni dil-üslub xüsusiyyətlərinə görə təhlil edir.$$, '6', 'şərh etmə', 'təhlil etmək'),
(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.5', $$Bədii və informativ mətnlərdə müəllifin məqsədini fərqləndirir.$$, '6', 'qiymətləndirmə', 'təhlil etmək'),
(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.6', $$Oxuduğu mətnləri üslubi xüsusiyyətlərinə görə müqayisə edir, qiymətləndirir.$$, '6', 'qiymətləndirmə', 'qiymətləndirmək'),
(11, 'oxu', '2.3', $$Tənqidi təfəkkür və yaradıcı yanaşma: Mətndəki fakt və hadisələrə bağlı şəxsi münasibətini ifadə edir.$$, '11-2.3.7', $$Müxtəlif mənbələrə əsaslanmaqla mətnin məzmununa münasibət bildirir və təxəyyülünə əsasən məzmuna yaradıcı yanaşır.$$, '6', 'qiymətləndirmə', 'yaratmaq'),

-- Məzmun xətti 3: YAZI
(11, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '11-3.1.1', $$Özünün və başqasının mətnini yenidən yazımla məzmun-struktur baxımından təkmilləşdirir.$$, '5', 'qiymətləndirmə', 'qiymətləndirmək'),
(11, 'yazi', '3.1', $$Yazı normaları: Yazısında ədəbi dilin normalarına və mətnin struktur tələblərinə riayət edir.$$, '11-3.1.2', $$Yazısında ədəbi dilin normalarına riayət edir.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),

(11, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '11-3.2.1', $$Məlumatları yazıda əks etdirərkən vaxt və həcm tələblərinə nəzərə alır.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),
(11, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '11-3.2.2', $$Araşdırdığı mənbələrdən və müxtəlif fənlər üzrə biliklərindən istifadə etməklə polemik xarakterli mətnlər yazır.$$, '6', 'qiymətləndirmə', 'yaratmaq'),
(11, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '11-3.2.3', $$Sadə formalı işgüzar sənədlər tərtib edir.$$, '4', 'birbaşa anlama', 'tətbiq etmək'),
(11, 'yazi', '3.2', $$Yazı məqsədləri və tipləri: Məqsədə uyğun olaraq müxtəlif tipli mətnlər yazır.$$, '11-3.2.4', $$Təqdimat materiallarında əldə etdiyi məlumatlara münasibətini və öz mövqeyini faktlarla və vizual materiallarla müşayiət edir.$$, '6', 'inteqrasiya', 'yaratmaq'),

-- Məzmun xətti 4: DİL QAYDALARI
(11, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '11-4.1.1', $$Nitqində fonetik qanunauyğunluqlardan çıxış edərək sözlərin deyilişi ilə tələffüzü arasındakı fərqin izah edilməsi.$$, '5', 'şərh etmə', 'təhlil etmək'),
(11, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '11-4.1.2', $$Alınma morfemlə işlənən bir sıra adların böyük hərflə yazılışı qaydalarına əməl edir.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),
(11, 'dil_qaydalari', '4.1', $$Orfoqrafiya və orfoepiya: Dilin fonetik qanunauyğunluqlarını izah edir və nitqində onlardan istifadə edir.$$, '11-4.1.3', $$Qrammatik omonimlik təşkil edən söz morfemlərin bitişik və ayrı yazılışı qaydalarına əməl edir.$$, '5', 'şərh etmə', 'tətbiq etmək'),

(11, 'dil_qaydalari', '4.2', $$Qrammatika: Dildə sintaktik fiqurları və iltisaqilik hadisəsini izah edir.$$, '11-4.2.1', $$Dildə iltisaqilik hadisəsini izah edir.$$, '6', 'şərh etmə', 'təhlil etmək'),
(11, 'dil_qaydalari', '4.2', $$Qrammatika: Dildə sintaktik fiqurları və iltisaqilik hadisəsini izah edir.$$, '11-4.2.2', $$Nitqin ekspressivliyinə xidmət edən sintaktik fiqurları müəyyən edir.$$, '6', 'şərh etmə', 'təhlil etmək'),
(11, 'dil_qaydalari', '4.2', $$Qrammatika: Dildə sintaktik fiqurları və iltisaqilik hadisəsini izah edir.$$, '11-4.2.3', $$Fikrin dəqiq və anlaşıqlı ifadə olunması üçün uyğun sintaktik konstruksiyadan istifadə edir.$$, '5', 'birbaşa anlama', 'yaratmaq'),

(11, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '11-4.3.1', $$Qoşa nöqtə, nöqtəli vergül və tire işarələrinin işlənmə məqamlarını fərqləndirir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(11, 'dil_qaydalari', '4.3', $$Punktuasiya: Yazıda punktuasiya qaydalarına əməl edir.$$, '11-4.3.2', $$Yanışı gələn sual və nida işarələrinin ardıcıllığına riayət edir.$$, '5', 'birbaşa anlama', 'tətbiq etmək'),

(11, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '11-4.4.1', $$Söz tərkibindəki morfemlərin semantik mənasından çıxış edərək sözün mənasını müəyyənləşdirir və müxtəlif mənbələr vasitəsilə dəqiqləşdirir.$$, '5', 'şərh etmə', 'təhlil etmək'),
(11, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '11-4.4.2', $$Leksik kateqoriyaları fərqləndirir.$$, '6', 'şərh etmə', 'təhlil etmək'),
(11, 'dil_qaydalari', '4.4', $$Leksika: Sözlərin mənalarını anladığını nümayiş etdirir.$$, '11-4.4.3', $$Söz və ifadələrin üslubi xüsusiyyətlərini izah edir.$$, '6', 'şərh etmə', 'təhlil etmək');
