const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME || 'az_muellim_db',
  user: process.env.DB_USER || 'royatalibova',
  password: process.env.DB_PASSWORD || '',
});

const CHUNKS_DIR = path.join(__dirname, '../../derslikler/chunks');

async function loadChunks() {
  console.log('📚 Chunk-lar yüklənir...\n');

  if (!fs.existsSync(CHUNKS_DIR)) {
    console.error('❌ Chunks qovluğu tapılmadı:', CHUNKS_DIR);
    process.exit(1);
  }

  const files = fs.readdirSync(CHUNKS_DIR).filter(f => f.endsWith('_chunks.json'));
  console.log(`📂 ${files.length} JSON fayl tapıldı\n`);

  let total = 0;
  let errors = 0;

  for (const file of files) {
    try {
      const filePath = path.join(CHUNKS_DIR, file);
      const chunks = JSON.parse(fs.readFileSync(filePath, 'utf8'));
      console.log(`📄 ${file}: ${chunks.length} chunk`);

      for (const chunk of chunks) {
        try {
          await pool.query(`
            INSERT INTO azdili_derslikler
              (sinif, hisse, chunk_id, movzu, saha, metn, sehife_aralighi, soz_sayi)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            ON CONFLICT (chunk_id) DO NOTHING
          `, [
            chunk.grade || chunk.sinif || 0,
            chunk.part || chunk.hisse || 1,
            chunk.id || chunk.chunk_id || `${file}_${total}`,
            chunk.topic || chunk.movzu || chunk.chapter || '',
            chunk.content_area || chunk.saha || 'umumi',
            chunk.text || chunk.metn || '',
            (chunk.page_start || chunk.sehife_baslangic || '?') + '-' + (chunk.page_end || chunk.sehife_son || '?'),
            chunk.word_count || chunk.soz_sayi || 0
          ]);
          total++;
        } catch (err) {
          errors++;
          if (errors <= 5) console.error(`   ⚠️  Chunk xətası: ${err.message}`);
        }
      }
    } catch (err) {
      console.error(`❌ Fayl xətası [${file}]:`, err.message);
    }
  }

  console.log(`\n✅ ${total} chunk yükləndi`);
  if (errors > 0) console.log(`⚠️  ${errors} xəta baş verdi`);

  await pool.end();
}

loadChunks().catch(err => {
  console.error('❌ Fatal xəta:', err.message);
  process.exit(1);
});
