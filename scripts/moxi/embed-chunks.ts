import fs from "fs/promises";
import { OpenAI } from "openai";          // points at Ollama locally

const api = new OpenAI({ baseURL: "http://localhost:11434" });

const chunks: string[] = JSON.parse(await fs.readFile("chunks.json", "utf8"));
const embeds: [string, number[]][] = [];

for (const c of chunks) {
  const e = (await api.embeddings.create({
    model: "all-minilm",                 // pulled with `ollama pull all-minilm`
    input: c
  })).data[0].embedding;
  embeds.push([c, e]);
}
await fs.writeFile("embeds.tsv",
  embeds.map(([t, v]) => `${t.replace(/\n/g," ")}\t${JSON.stringify(v)}`).join("\n"));
