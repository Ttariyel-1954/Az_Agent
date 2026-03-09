#!/bin/bash
BASE="https://www.trims.edu.az/noduploads/book"
OUT=~/Desktop/Az_agent/derslikler/pdf
mkdir -p "$OUT"
cd "$OUT"

KITABLAR="
azdili_1_hisse1:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-1-ci-sinif-ucun-darslik-i-hissa.pdf
azdili_1_hisse2:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-1-ci-sinif-ucun-darslik-ii-hissa.pdf
azdili_5_hisse1:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-5-ci-sinif-ucun-1-ci-hissa-darslik.pdf
azdili_6:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-6-ci-sinif-ucun-darslik-1634053169-837.pdf
azdili_7:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-7-ci-sinif-ucun-darslik-1663929615-270.pdf
azdili_8:umumtahsil-maktablarinin-8-ci-sinfi-ucun-dovlat-dili-azarbaycan-dili-fanni-uzra-darslik-backup.pdf
azdili_9:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-9-cu-sinif-ucun-darslik.pdf
azdili_10:quot-azarbaycan-dili-tadris-dili-quot-fanni-uzra-10-cu-sinif-ucun-darslik.pdf
"

TOTAL=8
COUNT=0

for CUFT in $KITABLAR; do
  AD=$(echo "$CUFT" | cut -d: -f1)
  SLUG=$(echo "$CUFT" | cut -d: -f2)
  FAYL="${AD}.pdf"
  COUNT=$((COUNT + 1))

  if [ -f "$FAYL" ] && [ -s "$FAYL" ]; then
    echo "[$COUNT/$TOTAL] ✅ Artıq var: $FAYL"
    continue
  fi

  echo "[$COUNT/$TOTAL] Yüklənir: $FAYL..."
  HTTP=$(curl -s -L -w "%{http_code}" -o "$FAYL" "$BASE/$SLUG")

  if [ "$HTTP" = "200" ] && [ -s "$FAYL" ]; then
    SIZE=$(du -h "$FAYL" | cut -f1)
    echo "    ✅ Uğurlu: $SIZE"
  else
    echo "    ❌ Xəta: HTTP $HTTP"
    rm -f "$FAYL"
  fi
  sleep 1
done

echo ""
echo "=== Nəticə ==="
ls -lh "$OUT"/*.pdf 2>/dev/null | awk '{print $5, $9}'
# Bu skript əvvəlki skriptə əlavədir — çatışanları yüklə
