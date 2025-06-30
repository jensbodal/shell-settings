#!/usr/bin/env python3
"""
Example showing how to use the LLMClient from llm_client.py
"""

import os

from llm_client import LLMClient


def main():
    # Initialize the client
    # You can set OPENROUTER_API_KEY in your environment for fallback capability
    client = LLMClient(
        ollama_base_url="http://localhost:11434",  # Default Ollama URL
        default_model="llama3",  # Default model to use
        timeout=5,  # Timeout for checking Ollama availability
    )

    # Simple generation example
    response = client.generate(
        prompt="Write a short poem about programming",
        system_prompt="You are a creative assistant that writes concise, thoughtful poetry.",
    )

    # Print information about the response
    provider = "OpenRouter" if client.using_fallback else "Ollama"
    print(f"Using: {provider} with model: {response['model']}")
    print("\nResponse:")
    print(response["text"])

    # You can also specify different parameters
    print("\n--- Another example with different parameters ---\n")
    response = client.generate(
        prompt="Explain how to make pancakes in 3 steps",
        model="mistral",  # Use a different model
        temperature=0.3,  # Lower temperature for more focused output
        max_tokens=150,  # Limit the response length
    )

    print(
        f"Using: {'OpenRouter' if client.using_fallback else 'Ollama'} with model: {response['model']}"
    )
    print("\nResponse:")
    print(response["text"])


if __name__ == "__main__":
    main()
