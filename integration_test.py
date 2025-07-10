#!/usr/bin/env python3
"""
Integration test for the LLM client and CLI.
This will test both Ollama and OpenRouter fallback if configured.
"""

import os
import sys

from llm_client import LLMClient


def test_ollama():
    """Test Ollama integration."""
    print("Testing Ollama integration...")
    client = LLMClient()

    if not client.is_ollama_available():
        print("Ollama is not available. Skipping test.")
        return False

    try:
        response = client.generate(
            prompt="Say 'Hello, Ollama test successful!' and nothing else.",
            model="llama3",
            temperature=0.1,
            max_tokens=20,
        )

        print(f"Response: {response['text']}")
        print(f"Using model: {response['model']}")
        print(f"Provider: {response['provider']}")

        return "successful" in response["text"].lower()
    except Exception as e:
        print(f"Error testing Ollama: {e}")
        return False


def test_openrouter():
    """Test OpenRouter integration."""
    print("\nTesting OpenRouter fallback...")

    if not os.environ.get("OPENROUTER_API_KEY"):
        print("OPENROUTER_API_KEY not set. Skipping test.")
        return False

    # Force fallback by using an invalid Ollama URL
    client = LLMClient(ollama_base_url="http://invalid-url:11434")

    try:
        response = client.generate(
            prompt="Say 'Hello, OpenRouter test successful!' and nothing else.",
            model="llama3",
            temperature=0.1,
            max_tokens=20,
        )

        print(f"Response: {response['text']}")
        print(f"Using model: {response['model']}")
        print(f"Provider: {response['provider']}")

        return "successful" in response["text"].lower()
    except Exception as e:
        print(f"Error testing OpenRouter: {e}")
        return False


def main():
    """Run all integration tests."""
    ollama_success = test_ollama()
    openrouter_success = test_openrouter()

    print("\nTest Results:")
    print(f"Ollama: {'PASS' if ollama_success else 'FAIL'}")
    print(f"OpenRouter: {'PASS' if openrouter_success else 'FAIL'}")

    if not (ollama_success or openrouter_success):
        print("\nAll tests failed!")
        sys.exit(1)

    print("\nAt least one test passed.")


if __name__ == "__main__":
    main()
