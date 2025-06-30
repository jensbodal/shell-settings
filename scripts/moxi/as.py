from ollama import Client

cli = Client(host="http://localhost:11434")  # default Ollama REST port
print(cli.embeddings(model="all-minilm", prompt="test")["embedding"][:5])
