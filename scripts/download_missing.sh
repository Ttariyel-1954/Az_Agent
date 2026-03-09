#!/bin/bash
BASE="https://www.trims.edu.az/noduploads/book"
OUT=~/Desktop/Az_agent/derslikler/pdf
mkdir -p "$OUT"
cd "$OUT"

KITABLAR="
azdili_1_hisse1:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-1-ci-sinif-ucun-darslik-1-ci-hissa.pdf
azdili_1_hisse2:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-1-ci-sinif-ucun-darslik-2-ci-hissa.pdf
azdili_2_hisse1:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-2-ci-sinif-ucun-darslik-1-ci-hissa.pdf
azdili_2_hisse2:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-2-ci-sinif-ucun-darslik-2-ci-hissa.pdf
azdili_3_hisse1:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-3-cu-sinif-ucun-darslik-1-ci-hissa-1662998728-170.pdf
azdili_3_hisse2:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-3-cu-sinif-ucun-darslik-2-ci-hissa.pdf
azdili_5_hisse2:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-5-ci-sinif-ucun-2-ci-hissa-darslik.pdf
azdili_11:quot-azarbaycan-dili-quot-tadris-dili-fanni-uzra-11-ci-sinif-ucun-darslik-1693415917-127-backup.pdf
"

COUNT=0
for CUFT in $KITABLAR; do
  AD=$(echo "$CUFT" | cut -d: -f1)
  SLUG=$(echo "$CUFT" | cut -d: -f2)
  FAYL="${AD}.pdf"
  COUNT=$((COUNT + 1))

  if [ -f "$FAYL" ] && [ -s "$FAYL" ]; then
    echo "[$COUNT] ✅ Artıq var: $FAYL"
    continue
  fi

  echo "[$COUNT] Yüklənir: $FAYL..."
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
echo "=== CƏMİ FAYLLAR ==="
ls "$OUT"/*.pdf 2>/dev/null | wc -l
ls -lh "$OUT"/*.pdf 2>/dev/null | awk '{print $5, $9}'
