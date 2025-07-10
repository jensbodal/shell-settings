import os
import unittest
from unittest.mock import MagicMock, patch

import requests

from llm_client import LLMClient


class TestLLMClient(unittest.TestCase):

    def setUp(self):
        # Set up test environment
        os.environ["OPENROUTER_API_KEY"] = "test_key"
        self.client = LLMClient(
            ollama_base_url="http://localhost:11434", default_model="llama3", timeout=1
        )

    @patch("requests.get")
    def test_ollama_available(self, mock_get):
        # Test when Ollama is available
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_get.return_value = mock_response

        self.assertTrue(self.client.is_ollama_available())
        mock_get.assert_called_once_with("http://localhost:11434/api/tags", timeout=1)

    @patch("requests.get")
    def test_ollama_unavailable(self, mock_get):
        # Test when Ollama is unavailable
        mock_get.side_effect = requests.RequestException("Connection error")

        self.assertFalse(self.client.is_ollama_available())

    def test_model_mapping(self):
        # Test model mapping functionality
        self.assertEqual(
            self.client.get_openrouter_model("llama3"), "anthropic/claude-3-opus:beta"
        )
        self.assertEqual(
            self.client.get_openrouter_model("unknown_model"),
            "anthropic/claude-3-sonnet:beta",
        )

    @patch("llm_client.LLMClient.is_ollama_available")
    @patch("llm_client.LLMClient._generate_ollama")
    def test_generate_with_ollama(self, mock_generate_ollama, mock_is_available):
        # Test generation using Ollama
        mock_is_available.return_value = True
        mock_generate_ollama.return_value = {
            "text": "Test response",
            "model": "llama3",
            "provider": "ollama",
        }

        response = self.client.generate("Test prompt")

        self.assertEqual(response["text"], "Test response")
        self.assertEqual(response["provider"], "ollama")
        self.assertFalse(self.client.using_fallback)

    @patch("llm_client.LLMClient.is_ollama_available")
    @patch("llm_client.LLMClient._generate_openrouter")
    def test_generate_with_fallback(self, mock_generate_openrouter, mock_is_available):
        # Test fallback to OpenRouter
        mock_is_available.return_value = False
        mock_generate_openrouter.return_value = {
            "text": "Fallback response",
            "model": "anthropic/claude-3-opus:beta",
            "provider": "openrouter",
        }

        response = self.client.generate("Test prompt")

        self.assertEqual(response["text"], "Fallback response")
        self.assertEqual(response["provider"], "openrouter")
        self.assertTrue(self.client.using_fallback)

    @patch("llm_client.LLMClient.is_ollama_available")
    @patch("requests.post")
    def test_generate_ollama_implementation(self, mock_post, mock_is_available):
        # Test the actual Ollama API call
        mock_is_available.return_value = True

        mock_response = MagicMock()
        mock_response.json.return_value = {"response": "Ollama test response"}
        mock_post.return_value = mock_response

        response = self.client._generate_ollama(
            prompt="Test prompt",
            model="llama3",
            system_prompt="Test system",
            temperature=0.7,
            max_tokens=100,
        )

        self.assertEqual(response["text"], "Ollama test response")
        mock_post.assert_called_once()

    @patch("requests.post")
    def test_generate_openrouter_implementation(self, mock_post):
        # Test the actual OpenRouter API call
        mock_response = MagicMock()
        mock_response.json.return_value = {
            "choices": [{"message": {"content": "OpenRouter test response"}}]
        }
        mock_post.return_value = mock_response

        response = self.client._generate_openrouter(
            prompt="Test prompt",
            ollama_model="llama3",
            system_prompt="Test system",
            temperature=0.7,
            max_tokens=100,
        )

        self.assertEqual(response["text"], "OpenRouter test response")
        mock_post.assert_called_once()


if __name__ == "__main__":
    unittest.main()
