import os
import sys
import unittest
from io import StringIO
from unittest.mock import MagicMock, patch


class TestLLMCLI(unittest.TestCase):

    @patch("sys.argv", ["llm_cli.py", "Test prompt"])
    @patch("llm_client.LLMClient.generate")
    def test_cli_basic(self, mock_generate):
        # Test basic CLI functionality
        from llm_cli import main

        mock_generate.return_value = {
            "text": "CLI test response",
            "model": "llama3",
            "provider": "ollama",
        }

        with (
            patch("sys.stdout", new=StringIO()) as mock_stdout,
            patch("sys.stderr", new=StringIO()),
        ):
            main()

        mock_generate.assert_called_once()
        args, kwargs = mock_generate.call_args
        self.assertEqual(kwargs["prompt"], "Test prompt")

    @patch("sys.argv", ["llm_cli.py", "--stdin"])
    @patch("sys.stdin")
    @patch("llm_client.LLMClient.generate")
    def test_cli_stdin(self, mock_generate, mock_stdin):
        # Test CLI with stdin input
        from llm_cli import main

        mock_stdin.read.return_value = "Stdin test prompt"
        mock_generate.return_value = {
            "text": "Stdin test response",
            "model": "llama3",
            "provider": "ollama",
        }

        with patch("sys.stdout", new=StringIO()), patch("sys.stderr", new=StringIO()):
            main()

        mock_generate.assert_called_once()
        args, kwargs = mock_generate.call_args
        self.assertEqual(kwargs["prompt"], "Stdin test prompt")

    @patch("sys.argv", ["llm_cli.py", "--model", "mistral", "Test prompt"])
    @patch("llm_client.LLMClient.generate")
    def test_cli_with_model(self, mock_generate):
        # Test CLI with model parameter
        from llm_cli import main

        mock_generate.return_value = {
            "text": "Model test response",
            "model": "mistral",
            "provider": "ollama",
        }

        with patch("sys.stdout", new=StringIO()), patch("sys.stderr", new=StringIO()):
            main()

        mock_generate.assert_called_once()
        args, kwargs = mock_generate.call_args
        self.assertEqual(kwargs["model"], "mistral")

    @patch(
        "sys.argv",
        ["llm_cli.py", "--system", "You are a helpful assistant", "Test prompt"],
    )
    @patch("llm_client.LLMClient.generate")
    def test_cli_with_system_prompt(self, mock_generate):
        # Test CLI with system prompt
        from llm_cli import main

        mock_generate.return_value = {
            "text": "System prompt test response",
            "model": "llama3",
            "provider": "ollama",
        }

        with patch("sys.stdout", new=StringIO()), patch("sys.stderr", new=StringIO()):
            main()

        mock_generate.assert_called_once()
        args, kwargs = mock_generate.call_args
        self.assertEqual(kwargs["system_prompt"], "You are a helpful assistant")


if __name__ == "__main__":
    unittest.main()
