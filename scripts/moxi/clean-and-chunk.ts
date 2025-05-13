// clean-and-chunk.ts
import fs from 'fs/promises'
import { encoding_for_model } from '@dqbd/tiktoken'

const [_,__,transcript] = process.argv;
// const transcript = './transcript_fbf7e3f2-b255-e94f-7943-d0aaf24602c7.gpml-large-v3-turbo-q8_0.txt.txt';

const MAX = 500          // tokens per chunk
const OVERLAP = 50       // sliding-window overlap
const enc = await encoding_for_model('gpt-3.5-turbo')  // same tokenizer as Ollama models

// 1. read + strip timestamps like [00:12:34] or 0:12:34.56
const raw = await fs.readFile(transcript, 'utf8')
const clean = raw.replace(/^\s*\[?\d{1,2}:\d{2}:\d{2}(?:\.\d{2})?\]?\s*/gm, '')

// 2. encode → tokens → sliding window
const tokens = enc.encode(clean)
const chunks: string[] = []

for (let i = 0; i < tokens.length; i += MAX - OVERLAP) {
  const slice = tokens.slice(i, i + MAX)
  chunks.push(enc.decode(slice))
}
await fs.writeFile('chunks.json', JSON.stringify(chunks, null, 2))
console.log(`Wrote ${chunks.length} chunks`)
