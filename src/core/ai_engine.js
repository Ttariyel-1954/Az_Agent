// ============================================================
// Core AI Engine - Az Müəllim Agent
// Multi-model support: Claude 4.5 Sonnet, GPT-4o
// ARTI 2026
// ============================================================
const Anthropic = require('@anthropic-ai/sdk');
const OpenAI = require('openai');

const SYSTEM_PROMPT_AZ = `Sən Azərbaycan Respublikasının 1-11-ci sinif Azərbaycan dili və ədəbiyyat
fənnini dərindən bilən, aşağıdakı beynəlxalq çərçivələri mənimsəmiş
AI müəllim assistentisən:

BEYNƏLXALQ ÇƏRÇIVƏLƏR:
- PISA Oxu Savadlılığı (6 səviyyə: 1b→6): mətn növləri, oxu prosesləri,
  kontekst növləri; kritik düşüncə, çoxmənbəli mətn analizi
- PIRLS 4-cü sinif oxu: bədii mətn + məlumat mətni; birbaşa anlama /
  şərh etmə / qiymətləndirmə / inteqrasiya prosesləri
- Blum Taksonomiyası (6 səviyyə): xatırlamaq → anlamaq → tətbiq etmək →
  təhlil etmək → qiymətləndirmək → yaratmaq
- CEFR Dil Çərçivəsi (A1→C2): dinləmə, danışıq, oxu, yazı bacarıqları
- Azərbaycan Dili Fənn Kurikulumu (2024): məzmun xətləri üzrə standartlar

DƏRS PLANI YAZARKƏN:
1. Məqsəd — Blum taksonomiyasına görə ölçülə bilən feillərlə
   (müəyyən edir / təhlil edir / qiymətləndirir / yaradır)
2. PISA/PIRLS uyğunluğu — hansı oxu prosesini inkişaf etdirir
3. Diferensial təlim — 3 səviyyə: zəif / orta / güclü şagird
4. Formativ qiymətləndirmə — dərs ərzində yoxlama üsulları
5. Fəallaşdırma strategiyaları — sual növləri (açıq/qapalı/kritik)
6. Fənlərarası inteqrasiya — tarix, coğrafiya, musiqi və s.
7. Resurslar — dərslik səhifələri, əlavə materiallar

ƏDƏBİYYAT MƏTNİNİN TƏHLİLİ YAZARKƏN:
1. Kompozisiya analizi: ekspozisiya → kulminasiya → çözüm
2. Obraz sistemi: əsas + ikinci dərəcəli obrazlar, xarakter inkişafı
3. Müəllif mövqeyi: birbaşa/dolayı ifadə üsulları
4. Bədii təsvir vasitələri: metafora, epitet, bənzətmə, hiperbola,
   litota, təzad, parallelizm — mətn nümunələri ilə
5. Janr xüsusiyyətləri: nağıl/hekayə/poema/roman/dram fərqləri
6. Dövr konteksti: əsər yazıldığı tarixi-ictimai mühit
7. Müqayisəli analiz: başqa müəlliflərlə/əsərlərlə paralellər
8. Şagird tənqidi düşüncəsi: "Müəllif niyə belə etdi?" sualları
9. Dil analizi: leksik seçim, üslub, ton, bədii dil xüsusiyyətləri
10. PISA oxu formatı: çoxseçimli + konstruktiv cavab + açıq sual

Bütün cavabları Azərbaycan dilində ver. Konkret, praktik, dərhal
istifadəyə hazır məzmun yaz.`;

class AIEngine {
    constructor() {
        this.anthropic = process.env.ANTHROPIC_API_KEY
            ? new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })
            : null;

        this.openai = process.env.OPENAI_API_KEY
            ? new OpenAI({ apiKey: process.env.OPENAI_API_KEY })
            : null;

        this.defaultModel = process.env.DEFAULT_AI_MODEL || 'claude-sonnet-4-5-20250514';
    }

    async complete({ prompt, systemPrompt, model, maxTokens = 4096, temperature = 0.7, context = {} }) {
        const system = systemPrompt || SYSTEM_PROMPT_AZ;
        const selectedModel = model || this.defaultModel;
        const startTime = Date.now();

        try {
            let result;

            if (selectedModel.startsWith('claude')) {
                result = await this._callClaude(system, prompt, selectedModel, maxTokens, temperature);
            } else if (selectedModel.startsWith('gpt')) {
                result = await this._callOpenAI(system, prompt, selectedModel, maxTokens, temperature);
            } else {
                throw new Error(`Dəstəklənməyən model: ${selectedModel}`);
            }

            const latency = Date.now() - startTime;

            return {
                success: true,
                content: result.content,
                model: selectedModel,
                tokensInput: result.inputTokens || 0,
                tokensOutput: result.outputTokens || 0,
                latencyMs: latency,
            };
        } catch (error) {
            console.error(`❌ AI xəta [${selectedModel}]:`, error.message);
            return {
                success: false,
                error: error.message,
                model: selectedModel,
                latencyMs: Date.now() - startTime,
            };
        }
    }

    async _callClaude(system, prompt, model, maxTokens, temperature) {
        if (!this.anthropic) throw new Error('Anthropic API key konfiqurasiya olunmayıb');

        const response = await this.anthropic.messages.create({
            model: model,
            max_tokens: maxTokens,
            temperature: temperature,
            system: system,
            messages: [{ role: 'user', content: prompt }],
        });

        return {
            content: response.content[0].text,
            inputTokens: response.usage?.input_tokens,
            outputTokens: response.usage?.output_tokens,
        };
    }

    async _callOpenAI(system, prompt, model, maxTokens, temperature) {
        if (!this.openai) throw new Error('OpenAI API key konfiqurasiya olunmayıb');

        const response = await this.openai.chat.completions.create({
            model: model,
            max_tokens: maxTokens,
            temperature: temperature,
            messages: [
                { role: 'system', content: system },
                { role: 'user', content: prompt },
            ],
        });

        return {
            content: response.choices[0].message.content,
            inputTokens: response.usage?.prompt_tokens,
            outputTokens: response.usage?.completion_tokens,
        };
    }

    async completeJSON({ prompt, systemPrompt, model, schema, maxTokens }) {
        const selectedModel = model || this.defaultModel;
        const modelMax = selectedModel.includes('haiku') ? 4096 : 8192;
        maxTokens = Math.min(maxTokens || modelMax, modelMax);
        const jsonPrompt = `${prompt}\n\nCAVABINI YERİNƏ JSON formatında qaytar. Schema:\n${JSON.stringify(schema, null, 2)}\n\nYALNIZ JSON qaytar, başqa heç nə əlavə etmə. JSON-u tam bitir, yarımçıq qoyma.`;

        const result = await this.complete({
            prompt: jsonPrompt,
            systemPrompt,
            model,
            maxTokens,
            temperature: 0.3,
        });

        if (result.success) {
            try {
                let cleaned = result.content
                    .replace(/```json\n?/g, '')
                    .replace(/```\n?/g, '')
                    .trim();
                cleaned = cleaned.replace(/,\s*([\]}])/g, '$1');
                result.parsed = JSON.parse(cleaned);
            } catch (e) {
                try {
                    result.parsed = this._repairJSON(result.content);
                } catch (e2) {
                    result.parseError = e.message;
                }
            }
        }
        return result;
    }

    _repairJSON(raw) {
        let text = raw.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
        text = text.replace(/,\s*([\]}])/g, '$1');

        let openBraces = 0, openBrackets = 0;
        let inString = false, escape = false;

        for (const ch of text) {
            if (escape) { escape = false; continue; }
            if (ch === '\\') { escape = true; continue; }
            if (ch === '"') { inString = !inString; continue; }
            if (inString) continue;
            if (ch === '{') openBraces++;
            if (ch === '}') openBraces--;
            if (ch === '[') openBrackets++;
            if (ch === ']') openBrackets--;
        }

        if (openBraces > 0 || openBrackets > 0) {
            text = text.replace(/,\s*"[^"]*"?\s*:?\s*[^,\]}\n]*$/, '');
            text = text.replace(/,\s*$/, '');
        }

        while (openBrackets > 0) { text += ']'; openBrackets--; }
        while (openBraces > 0) { text += '}'; openBraces--; }

        return JSON.parse(text);
    }

    async batchComplete(prompts, { systemPrompt, model, maxTokens } = {}) {
        const results = await Promise.allSettled(
            prompts.map(prompt =>
                this.complete({ prompt, systemPrompt, model, maxTokens })
            )
        );
        return results.map((r, i) => ({
            index: i,
            ...(r.status === 'fulfilled' ? r.value : { success: false, error: r.reason?.message }),
        }));
    }
}

module.exports = { AIEngine, SYSTEM_PROMPT_AZ };
