// ============================================================
// Database Connection - PostgreSQL Pool
// Az Müəllim Agent - ARTI 2026
// ============================================================
const { Pool } = require('pg');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../.env') });

const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432'),
    database: process.env.DB_NAME || 'az_muellim_db',
    user: process.env.DB_USER || 'royatalibova',
    password: process.env.DB_PASSWORD,
    max: parseInt(process.env.DB_MAX_POOL || '20'),
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000,
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
});

pool.on('error', (err) => {
    console.error('❌ PostgreSQL pool xətası:', err.message);
});

pool.on('connect', () => {
    console.log('✅ PostgreSQL bağlantısı uğurlu (az_muellim_db)');
});

const query = async (text, params = []) => {
    const start = Date.now();
    try {
        const result = await pool.query(text, params);
        const duration = Date.now() - start;
        if (process.env.NODE_ENV === 'development') {
            console.log(`📊 Query [${duration}ms]: ${text.substring(0, 80)}...`);
        }
        return result;
    } catch (error) {
        console.error('❌ Query xətası:', error.message);
        throw error;
    }
};

const transaction = async (callback) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const result = await callback(client);
        await client.query('COMMIT');
        return result;
    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
};

const testConnection = async () => {
    try {
        const res = await pool.query('SELECT NOW() as current_time, version() as pg_version');
        console.log(`✅ DB bağlantısı: ${res.rows[0].current_time}`);
        console.log(`✅ PostgreSQL: ${res.rows[0].pg_version.split(',')[0]}`);
        return true;
    } catch (error) {
        console.error('❌ DB bağlantı xətası:', error.message);
        return false;
    }
};

module.exports = { pool, query, transaction, testConnection };
