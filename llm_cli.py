#!/usr/bin/env python3
"""
LLM CLI - A command-line interface for interacting with LLMs with fallback capability.
"""

import argparse
import os
import sys
from typing import Optional
from llm_client import LLMClient

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description="LLM CLI with fallback capability")

    parser.add_argument("prompt", nargs="?", help="The prompt to send to the LLM")
    parser.add_argument(
        "--model", "-m",
        default=os.environ.get("LLM_DEFAULT_MODEL", "llama3"),
        help="Model to use (default: llama3)"
    )
    parser.add_argument(
        "--system", "-s",
        help="System prompt to use"
    )
    parser.add_argument(
        "--temperature", "-t",
        type=float, default=0.7,
        help="Temperature for generation (default: 0.7)"
    )
    parser.add_argument(
        "--max-tokens", "-mt",
        type=int, default=1024,
        help="Maximum tokens to generate (default: 1024)"
    )
    parser.add_argument(
        "--ollama-url",
        default=os.environ.get("OLLAMA_BASE_URL", "http://127.0.0.1:11434"),
        help="Ollama base URL (default: http://127.0.0.1:11434)"
    )
    parser.add_argument(
        "--openrouter-key", "-k",
        default=os.environ.get("OPENROUTER_API_KEY"),
        help="OpenRouter API key (default: from OPENROUTER_API_KEY env var)"
    )
    parser.add_argument(
        "--stdin", "-i",
        action="store_true",
        help="Read prompt from stdin"
    )

    return parser.parse_args()

def main():
    """Main entry point."""
    args = parse_args()

    # Get prompt from stdin if requested
    if args.stdin:
        prompt = sys.stdin.read().strip()
    elif args.prompt:
        prompt = args.prompt
    else:
        print("Error: No prompt provided. Use positional argument or --stdin")
        sys.exit(1)

    # Initialize client
    client = LLMClient(
        ollama_base_url=args.ollama_url,
        openrouter_api_key=args.openrouter_key,
        default_model=args.model
    )

    try:
        # Generate response
        response = client.generate(
            prompt=prompt,
            model=args.model,
            system_prompt=args.system,
            temperature=args.temperature,
            max_tokens=args.max_tokens
        )

        # Print provider info
        provider = "OpenRouter (fallback)" if client.using_fallback else "Ollama (local)"
        print(f"Using: {provider} with model: {response['model']}", file=sys.stderr)

        # Print just the response text to stdout
        print(response["text"])

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
