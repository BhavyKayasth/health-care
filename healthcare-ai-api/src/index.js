export default {
  async fetch(request, env) {
    // ==========================================================
    // CORS
    // ==========================================================

    if (request.method === "OPTIONS") {
      return new Response(null, {
        status: 204,
        headers: corsHeaders(),
      });
    }

    // ==========================================================
    // HEALTH CHECK
    // ==========================================================

    if (request.method === "GET") {
      return jsonResponse({
        message: "Healthcare AI API is working!",
      });
    }

    // ==========================================================
    // ONLY POST
    // ==========================================================

    if (request.method !== "POST") {
      return jsonResponse(
        {
          error: "Method not allowed.",
        },
        405,
      );
    }

    try {
      // ========================================================
      // API KEY
      // ========================================================

      if (!env.GROQ_API_KEY) {
        console.error("GROQ_API_KEY is missing.");

        return jsonResponse(
          {
            error: "AI service is not configured.",
          },
          500,
        );
      }

      // ========================================================
      // REQUEST
      // ========================================================

      const body = await request.json();

      // Existing chat requests can continue working without
      // specifying an action.
      const action = body?.action ?? "chat";

      // ========================================================
      // CHAT
      // ========================================================

      if (action === "chat") {
        const userMessage =
          body?.message?.toString().trim();

        if (!userMessage) {
          return jsonResponse(
            {
              error: "Message is required.",
            },
            400,
          );
        }

        const groqResponse = await fetch(
          "https://api.groq.com/openai/v1/chat/completions",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              Authorization:
                `Bearer ${env.GROQ_API_KEY}`,
            },
            body: JSON.stringify({
              model: "openai/gpt-oss-20b",
              messages: [
                {
                  role: "system",
                  content:
                    "You are HealthCare AI, a helpful healthcare assistant. " +
                    "Provide general health information in simple language. " +
                    "Do not diagnose diseases or claim certainty. " +
                    "For serious or emergency symptoms, advise the user " +
                    "to seek appropriate medical care.",
                },
                {
                  role: "user",
                  content: userMessage,
                },
              ],
              temperature: 0.5,
              max_tokens: 500,
            }),
          },
        );

        const data = await groqResponse.json();

        console.log(
          "Groq chat status:",
          groqResponse.status,
        );

        if (!groqResponse.ok) {
          console.error(
            "Groq chat error:",
            data,
          );

          return jsonResponse(
            {
              error:
                "Failed to get response from AI.",
              details: data,
            },
            500,
          );
        }

        const reply =
          data?.choices?.[0]?.message?.content;

        if (!reply) {
          return jsonResponse(
            {
              error:
                "AI returned an empty response.",
            },
            500,
          );
        }

        return jsonResponse({
          reply: reply.trim(),
        });
      }

      // ========================================================
      // SYMPTOM ANALYSIS
      // ========================================================

      if (action === "analyze_symptoms") {
        const bodyPart =
          body?.bodyPart?.toString().trim();

        const duration =
          body?.duration?.toString().trim();

        const intensity =
          Number(body?.intensity);

        const symptoms =
          Array.isArray(body?.symptoms)
            ? body.symptoms
                .map((item) =>
                  item.toString().trim(),
                )
                .filter(Boolean)
            : [];

        if (
          !bodyPart ||
          !duration ||
          symptoms.length === 0 ||
          !Number.isFinite(intensity)
        ) {
          return jsonResponse(
            {
              error:
                "Body part, symptoms, duration and intensity are required.",
            },
            400,
          );
        }

        // ======================================================
        // AI SAFETY INSTRUCTIONS
        // ======================================================

        const systemPrompt = `
You are HealthCare AI, a cautious symptom assessment assistant.

Your response is NOT a medical diagnosis.

Analyze the user's reported symptoms and provide general
health information for educational purposes.

Rules:
- Never claim to diagnose a disease.
- Return possible conditions, not confirmed diagnoses.
- Do not invent test results, medical history, age, gender,
  medications, or other information not provided.
- Use the reported symptoms, duration, body area, and intensity.
- Be conservative when assigning severity.
- If symptoms could represent a medical emergency, set severity
  to "critical" and clearly advise immediate professional care.
- Chest pain with serious warning signs should be treated as
  potentially critical.
- Sudden severe breathing difficulty should be treated as
  potentially critical.
- Do not prescribe medication or provide specific medication
  dosing.
- Do not tell the user to delay emergency care.
- Keep recommendations practical and concise.
`;

        const userPrompt = `
Body area:
${bodyPart}

Symptoms:
${symptoms.join(", ")}

Duration:
${duration}

Pain/discomfort intensity:
${intensity}/10

Analyze these symptoms and return the requested structured result.
`;

        // ======================================================
        // STRUCTURED GROQ RESPONSE
        // ======================================================

        const groqResponse = await fetch(
          "https://api.groq.com/openai/v1/chat/completions",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              Authorization:
                `Bearer ${env.GROQ_API_KEY}`,
            },
            body: JSON.stringify({
              model: "openai/gpt-oss-20b",

              messages: [
                {
                  role: "system",
                  content: systemPrompt,
                },
                {
                  role: "user",
                  content: userPrompt,
                },
              ],

              temperature: 0.2,

              max_tokens: 1000,

              response_format: {
                type: "json_schema",
                json_schema: {
                  name: "symptom_analysis",
                  strict: true,
                  schema: {
                    type: "object",
                    additionalProperties: false,
                    properties: {
                      severity: {
                        type: "string",
                        enum: [
                          "low",
                          "moderate",
                          "high",
                          "critical",
                        ],
                      },

                      conditions: {
                        type: "array",
                        items: {
                          type: "string",
                        },
                      },

                      recommendation: {
                        type: "string",
                      },

                      urgency: {
                        type: "string",
                      },

                      doList: {
                        type: "array",
                        items: {
                          type: "string",
                        },
                      },

                      dontList: {
                        type: "array",
                        items: {
                          type: "string",
                        },
                      },
                    },

                    required: [
                      "severity",
                      "conditions",
                      "recommendation",
                      "urgency",
                      "doList",
                      "dontList",
                    ],
                  },
                },
              },
            }),
          },
        );

        const data = await groqResponse.json();

        console.log(
          "Groq analysis status:",
          groqResponse.status,
        );

        if (!groqResponse.ok) {
          console.error(
            "Groq analysis error:",
            data,
          );

          return jsonResponse(
            {
              error:
                "Failed to analyze symptoms.",
              details: data,
            },
            500,
          );
        }

        const content =
          data?.choices?.[0]?.message?.content;

        if (!content) {
          return jsonResponse(
            {
              error:
                "AI returned an empty analysis.",
            },
            500,
          );
        }

        const analysis =
          JSON.parse(content);

        return jsonResponse({
          analysis: analysis,
        });
      }

      // ========================================================
      // UNKNOWN ACTION
      // ========================================================

      return jsonResponse(
        {
          error: "Unknown action.",
        },
        400,
      );
    } catch (error) {
      console.error(
        "Worker error:",
        error,
      );

      return jsonResponse(
        {
          error: "Something went wrong.",
          details:
            error instanceof Error
              ? error.message
              : String(error),
        },
        500,
      );
    }
  },
};

// ============================================================
// JSON RESPONSE
// ============================================================

function jsonResponse(
  data,
  status = 200,
) {
  return new Response(
    JSON.stringify(data),
    {
      status,
      headers: {
        "Content-Type":
          "application/json",
        ...corsHeaders(),
      },
    },
  );
}

// ============================================================
// CORS
// ============================================================

function corsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods":
      "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers":
      "Content-Type",
  };
}