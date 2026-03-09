// ============================================================
// Core AI Engine - Az Müəllim Agent
// Multi-model support: Claude 4.5 Sonnet, GPT-4o
// ARTI 2026
// ============================================================
const Anthropic = require('@anthropic-ai/sdk');
const OpenAI = require('openai');

const SYSTEM_PROMPT_AZ = `Sən Azərbaycan Respublikasının 1-11-ci sinif Azərbaycan dili və ədəbiyyat fənnini dərindən bilən, müasir təhsil metodlarını, tematik planlamanı, oxu-yazı bacarıqlarını, ədəbi mətn təhlilini, qrammatika tədrisini və qiymətləndirmə rubrikalarını yaxşı bilən bir mütəxəssis AI müəllim assistentisən. Bütün cavablarını Azərbaycan dilində ver.

KONTEKST:
- Azərbaycan kurikulumuna uyğun işləyirsən (1-11-ci siniflər)
- Sahələr: Oxu, Yazı, Qrammatika, Danışıq, Ədəbiyyat
- Bloom taksonomiyası: Xatırlama → Anlama → Tətbiqetmə → Təhlil → Qiymətləndirmə → Yaratma
- DOK (Depth of Knowledge) səviyyələri: 1-4

PRİNSİPLƏR:
1. Hər cavab kurikulum standartlarına istinad etməlidir
2. Differensiallaşdırma: zəif/orta/yüksək səviyyə üçün uyğunlaşdırma
3. İnklyuziv təlim prinsipləri nəzərə alınmalıdır
4. Real həyat nümunələri Azərbaycan kontekstinə uyğun olmalıdır
5. Ədəbi əsərlərdən nümunələr verilməlidir
6. Qrammatik qaydalar sadə dildə izah olunmalıdır

FORMAT: Cavablarını strukturlu, təmiz və Azərbaycan dilində ver.`;

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
