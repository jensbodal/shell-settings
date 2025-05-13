#!/usr/bin/env bun
/**
 * bun run transcribe_and_chunk.ts <audio> [modelPath] [chunkTokens]
 *
 * Defaults
 *   whisperBin  = /Users/jensbodal/github/whisper.cpp/build/bin/whisper-cli
 *   modelPath   = /Users/jensbodal/github/whisper.cpp/models/ggml-large-v3-turbo.bin
 *   chunkTokens = 500
 *
 * Requires:
 *   bun add @dqbd/tiktoken
 */

import { readFileSync, writeFileSync } from "node:fs";
import { join, basename } from "node:path";
import { encoding_for_model } from "@dqbd/tiktoken";
import { spawnSync } from "bun";

//── configuration ────────────────────────────────────────────
const BIN_DEFAULT = "/Users/jensbodal/github/whisper.cpp/build/bin/whisper-cli";
const MODEL_DEFAULT = "/Users/jensbodal/github/whisper.cpp/models/ggml-large-v3-turbo.bin";

//── CLI args ─────────────────────────────────────────────────
const [, , AUDIO, MODEL_CLI, TOK_CLI] = process.argv;
if (!AUDIO) {
  console.error("Usage: bun transcribe_and_chunk.ts <audio> [model] [chunkTokens]");
  process.exit(1);
}
const MODEL = MODEL_CLI ?? MODEL_DEFAULT;
const CHUNK_SZ = Number(TOK_CLI) || 500;
const PREFIX = basename(AUDIO).replace(/\.[^.]+$/, ""); // audio.mp3 → audio

//── run whisper.cpp ─────────────────────────────────────────
console.log("🚀  Transcribing…");
const { exitCode } = spawnSync({
  cmd: [BIN_DEFAULT, "-m", MODEL, "-f", AUDIO, "--output-txt", "--output-file", PREFIX],
  stdout: "inherit",
  stderr: "inherit",
});
if (exitCode !== 0) {
  console.error(`Whisper exited with code ${exitCode}`);
  process.exit(exitCode);
}
console.log("✅  transcript.txt written");

//── chunk into ~N token blocks ──────────────────────────────
const enc = encoding_for_model("gpt-3.5-turbo");
const full = readFileSync(`${PREFIX}.txt`, "utf8");
const toks = enc.encode(full);

const chunks: string[] = [];
for (let i = 0; i < toks.length; i += CHUNK_SZ) {
  chunks.push(enc.decode(toks.slice(i, i + CHUNK_SZ)).trim());
}
enc.free();

writeFileSync("chunks.json", JSON.stringify(chunks, null, 2));
console.log(`✅  ${chunks.length} chunks (~${CHUNK_SZ} tokens) → chunks.json`);
