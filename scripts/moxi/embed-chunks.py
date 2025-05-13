#!/usr/bin/env python3
import json, pathlib, os, pgvector.psycopg
from psycopg import connect
from ollama import Client

DB_URL = os.getenv("DATABASE_URL", "postgresql://localhost/podcasts")
MODEL_EMB = "all-minilm"          # already `ollama pull`-ed
CHUNKS = pathlib.Path("chunks.json").read_text()
chunks = json.loads(CHUNKS)

conn = connect(DB_URL, autocommit=True)
conn.execute("CREATE EXTENSION IF NOT EXISTS vector")
conn.execute("""
  CREATE TABLE IF NOT EXISTS pod_chunks(
    id serial PRIMARY KEY,
    text text,
    emb vector(384)
  )""")

cli = Client(host="http://localhost:11434")

for c in chunks:
  v = cli.embeddings(model=MODEL_EMB, prompt=c)["embedding"]
  conn.execute("INSERT INTO pod_chunks(text, emb) VALUES (%s, %s)", (c, v))

print(f"✔  stored {len(chunks)} chunks")
