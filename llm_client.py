import os
import sys
import requests
import json
import time
from typing import Dict, List, Optional, Union, Any

class LLMClient:
    """
    A client for interacting with LLMs with automatic fallback capability.
    Tries local Ollama first, then falls back to OpenRouter if local is unavailable.
    """
    
    def __init__(self, 
                 ollama_base_url: str = "http://localhost:11434",
                 openrouter_api_key: Optional[str] = None,
                 default_model: str = "llama3",
                 timeout: int = 5):
        """
        Initialize the LLM client with fallback capability.
        
        Args:
            ollama_base_url: Base URL for Ollama API
            openrouter_api_key: API key for OpenRouter (from env var if None)
            default_model: Default model to use
            timeout: Timeout in seconds for checking if Ollama is available
        """
        self.ollama_base_url = ollama_base_url
        self.openrouter_api_key = openrouter_api_key or os.environ.get("OPENROUTER_API_KEY")
        self.default_model = default_model
        self.timeout = timeout
        self.using_fallback = False
        
        # Model mapping from Ollama to OpenRouter equivalents
        self.model_mapping = {
            "llama3": "anthropic/claude-3-opus:beta",
            "llama3:8b": "anthropic/claude-3-sonnet:beta",
            "mistral": "mistralai/mistral-large",
            "phi3": "microsoft/phi-3",
            "gemma": "google/gemma-7b",
            # Add more mappings as needed
        }
        
        # Check if OpenRouter API key is available when needed
        if not self.openrouter_api_key:
            print("Warning: OPENROUTER_API_KEY not set. Fallback will not be available.")
    
    def is_ollama_available(self) -> bool:
        """Check if Ollama is available by making a simple request."""
        try:
            response = requests.get(f"{self.ollama_base_url}/api/tags", timeout=self.timeout)
            return response.status_code == 200
        except (requests.RequestException, ConnectionError):
            return False
    
    def get_openrouter_model(self, ollama_model: str) -> str:
        """Map Ollama model name to OpenRouter equivalent."""
        return self.model_mapping.get(ollama_model, "anthropic/claude-3-sonnet:beta")
    
    def generate(self, 
                prompt: str, 
                model: Optional[str] = None,
                system_prompt: Optional[str] = None,
                temperature: float = 0.7,
                max_tokens: int = 1024) -> Dict[str, Any]:
        """
        Generate text from the LLM with automatic fallback.
        
        Args:
            prompt: The user prompt
            model: Model to use (defaults to self.default_model)
            system_prompt: Optional system prompt
            temperature: Temperature for generation
            max_tokens: Maximum tokens to generate
            
        Returns:
            Response dictionary with generated text and metadata
        """
        model = model or self.default_model
        
        # Try Ollama first
        if self.is_ollama_available():
            self.using_fallback = False
            try:
                return self._generate_ollama(prompt, model, system_prompt, temperature, max_tokens)
            except Exception as e:
                print(f"Ollama generation failed: {e}")
                if not self.openrouter_api_key:
                    raise Exception("Ollama failed and OpenRouter API key not available")
                self.using_fallback = True
        else:
            if not self.openrouter_api_key:
                raise Exception("Ollama not available and OpenRouter API key not set")
            self.using_fallback = True
            
        # Fallback to OpenRouter
        return self._generate_openrouter(prompt, model, system_prompt, temperature, max_tokens)
    
    def _generate_ollama(self, 
                        prompt: str, 
                        model: str,
                        system_prompt: Optional[str],
                        temperature: float,
                        max_tokens: int) -> Dict[str, Any]:
        """Generate text using Ollama."""
        url = f"{self.ollama_base_url}/api/generate"
        
        payload = {
            "model": model,
            "prompt": prompt,
            "temperature": temperature,
            "max_tokens": max_tokens,
        }
        
        if system_prompt:
            payload["system"] = system_prompt
            
        response = requests.post(url, json=payload)
        response.raise_for_status()
        
        return {
            "text": response.json().get("response", ""),
            "model": model,
            "provider": "ollama",
            "raw_response": response.json()
        }
    
    def _generate_openrouter(self, 
                           prompt: str, 
                           ollama_model: str,
                           system_prompt: Optional[str],
                           temperature: float,
                           max_tokens: int) -> Dict[str, Any]:
        """Generate text using OpenRouter as fallback."""
        openrouter_model = self.get_openrouter_model(ollama_model)
        url = "https://openrouter.ai/api/v1/chat/completions"
        
        headers = {
            "Authorization": f"Bearer {self.openrouter_api_key}",
            "Content-Type": "application/json",
            "HTTP-Referer": "https://github.com/yourusername/yourrepo",  # Update this
        }
        
        messages = []
        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
        
        messages.append({"role": "user", "content": prompt})
        
        payload = {
            "model": openrouter_model,
            "messages": messages,
            "temperature": temperature,
            "max_tokens": max_tokens,
        }
        
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        response_json = response.json()
        
        return {
            "text": response_json.get("choices", [{}])[0].get("message", {}).get("content", ""),
            "model": openrouter_model,
            "provider": "openrouter",
            "raw_response": response_json
        }

# Example usage
if __name__ == "__main__":
    client = LLMClient()
    
    try:
        response = client.generate(
            prompt="Explain quantum computing in simple terms",
            system_prompt="You are a helpful assistant that explains complex topics simply."
        )
        
        provider = "OpenRouter" if client.using_fallback else "Ollama"
        print(f"Using: {provider} with model: {response['model']}")
        print("\nResponse:")
        print(response["text"])
    except Exception as e:
        print(f"Error: {e}")
