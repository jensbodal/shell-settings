#!/bin/bash
# validate-litellm.sh - Test if LiteLLM proxy is working correctly

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Configuration
PORT=4000
HOST="localhost"
BASE_URL="http://${HOST}:${PORT}"
TEST_MODEL="openrouter/auto"
LITELLM_MASTER_KEY="$(gopass show -o sk/litellm_master_$USER@$(hostname))"

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
success() {
  echo -e "${GREEN}✅ $1${NC}"
  ((TESTS_PASSED++))
}

failure() {
  echo -e "${RED}❌ $1${NC}"
  ((TESTS_FAILED++))
}

info() {
  echo -e "${YELLOW}ℹ️ $1${NC}"
}

# 1. Check if service is running
check_service_running() {
  echo -e "\n${YELLOW}Step 1: Checking if LiteLLM service is running${NC}"

  # Check if port is open
  if command -v nc >/dev/null 2>&1; then
    if nc -z "$HOST" "$PORT" >/dev/null 2>&1; then
      success "Service is running on port $PORT"
      return 0
    else
      failure "Service is not running on port $PORT"
      info "Try running: ./install-litellms.sh"
      return 1
    fi
  else
    # Fallback to curl if nc is not available
    if curl -s -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" "$BASE_URL" >/dev/null 2>&1; then
      success "Service is responding on $BASE_URL"
      return 0
    else
      failure "Service is not responding on $BASE_URL"
      info "Try running: ./install-litellms.sh"
      return 1
    fi
  fi
}

# 2. Test health endpoint
check_health() {
  echo -e "\n${YELLOW}Step 2: Testing health endpoint${NC}"

  local response
  response=$(curl -s -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" "$BASE_URL/health" 2>&1)
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    failure "Health endpoint request failed with exit code $exit_code"
    echo "Error: $response"
    return 1
  fi

  # Accept any valid JSON response from health endpoint
  # LiteLLM health endpoint may return empty arrays which is still valid
  if [[ "$response" == *"healthy_endpoints"* || "$response" == *"status"* ]]; then
    success "Health endpoint is working"
    echo "Response: $response"
    return 0
  else
    failure "Health endpoint failed - invalid response format"
    echo "Response: $response"
    return 1
  fi
}

# 3. List available models
check_models() {
  echo -e "\n${YELLOW}Step 3: Listing available models${NC}"

  local response
  response=$(curl -s -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" "$BASE_URL/v1/models" 2>&1)
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    failure "Models endpoint request failed with exit code $exit_code"
    echo "Error: $response"
    return 1
  fi

  if [[ "$response" == *"data"* ]]; then
    # Extract model IDs from the response
    local models
    models=$(echo "$response" | grep -o '"id":"[^"]*"' | sed 's/"id":"//g' | sed 's/"//g')

    if [[ -z "$models" ]]; then
      info "Models endpoint is working but no models were found"
      echo "This could be due to:"
      echo "1. OpenRouter API key not being properly set or having insufficient permissions"
      echo "2. Network connectivity issues to OpenRouter"
      echo "3. LiteLLM configuration issues"
      echo ""
      echo "Try checking the logs at ~/.local/lite-llm/lite-llm.log"
      echo "You can also try: curl -s -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" $BASE_URL/v1/models | jq"

      # Check if we can access the OpenRouter API directly
      echo ""
      echo "Checking OpenRouter API connectivity..."
      if command -v curl >/dev/null 2>&1; then
        local or_response
        or_response=$(curl -s -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" -o /dev/null -w "%{http_code}" "https://openrouter.ai/api/v1/models" -H "Authorization: Bearer $(gopass show api/openrouter 2>/dev/null || echo 'KEY_NOT_FOUND')")
        if [ "$or_response" = "200" ]; then
          echo "✅ OpenRouter API is accessible directly. The issue is likely with the LiteLLM configuration."
        else
          echo "❌ OpenRouter API returned status code: $or_response"
          echo "Please verify your API key at https://openrouter.ai/keys"
        fi
      fi

      return 0
    else
      success "Models endpoint is working"
      echo "Available models:"
      echo "$models"
      return 0
    fi
  else
    failure "Models endpoint failed"
    echo "Response: $response"
    echo ""
    echo "This could indicate a configuration issue with LiteLLM."
    echo "Check the logs at ~/.local/lite-llm/lite-llm.log for more details."
    return 1
  fi
}

# 4. Make a test completion request
test_completion() {
  echo -e "\n${YELLOW}Step 4: Testing completion request${NC}"

  local response
  response=$(curl -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" -s "$BASE_URL/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -d '{
      "model": "'"$TEST_MODEL"'",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Say hello world in one short sentence."}
      ],
      "max_tokens": 50
    }' 2>&1)
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    failure "Completion request failed with exit code $exit_code"
    echo "Error: $response"
    return 1
  fi

  if [[ "$response" == *"content"* ]]; then
    success "Completion request successful"
    echo "Response content:"
    echo "$response" | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//g' | sed 's/"//g'
    return 0
  else
    failure "Completion request failed"
    echo "Response: $response"

    # Provide diagnostic information based on common error patterns
    if [[ "$response" == *"Invalid model name"* ]]; then
      echo ""
      echo "The model name '$TEST_MODEL' is not recognized."
      echo "Available models can be checked with: curl -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" -s $BASE_URL/v1/models | jq"
      echo "You may need to update the TEST_MODEL variable in this script."
    elif [[ "$response" == *"authentication"* || "$response" == *"api_key"* ]]; then
      echo ""
      echo "This appears to be an authentication issue."
      echo "Check that your OpenRouter API key is correctly set in gopass at api/openrouter"
      echo "and that the environment variable is being passed to LiteLLM."
    fi

    return 1
  fi
}

# 5. Test arithmetic capability
test_arithmetic() {
  echo -e "\n${YELLOW}Step 5: Testing arithmetic capability (2+2)${NC}"

  local response
  response=$(curl -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" -s "$BASE_URL/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -d '{
      "model": "'"$TEST_MODEL"'",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant that answers math questions directly with just the number."},
        {"role": "user", "content": "What is 2+2?"}
      ],
      "max_tokens": 10
    }' 2>&1)
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    failure "Arithmetic request failed with exit code $exit_code"
    echo "Error: $response"
    return 1
  fi

  if [[ "$response" == *"content"* ]]; then
    echo "Full response:"
    echo "$response"

    local content
    content=$(echo "$response" | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//g' | sed 's/"//g')
    echo "Response content: $content"

    if [[ "$content" == *"4"* ]]; then
      success "Arithmetic test passed! LLM correctly calculated 2+2=4"
      return 0
    else
      failure "Arithmetic test failed. Expected '4' in response, but got: $content"
      return 1
    fi
  else
    failure "Arithmetic request failed"
    echo "Response: $response"

    # Provide diagnostic information based on common error patterns
    if [[ "$response" == *"Invalid model name"* ]]; then
      echo ""
      echo "The model name '$TEST_MODEL' is not recognized."
      echo "Available models can be checked with: curl -s $BASE_URL/v1/models | jq"
      echo "You may need to update the TEST_MODEL variable in this script."
    elif [[ "$response" == *"authentication"* || "$response" == *"api_key"* ]]; then
      echo ""
      echo "This appears to be an authentication issue."
      echo "Check that your OpenRouter API key is correctly set in gopass at api/openrouter"
      echo "and that the environment variable is being passed to LiteLLM."
    fi

    return 1
  fi
}

# 6. Test direct model availability
test_model_availability() {
  echo -e "\n${YELLOW}Step 6: Testing direct model availability${NC}"

  # First, get the list of available models
  local models_response
  models_response=$(curl -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" -s "$BASE_URL/v1/models" 2>&1)

  if [[ "$models_response" != *"data"* ]]; then
    failure "Could not retrieve model list"
    echo "Response: $models_response"
    return 1
  fi

  # Extract the first model ID from the response
  local first_model
  first_model=$(echo "$models_response" | grep -o '"id":"[^"]*"' | head -1 | sed 's/"id":"//g' | sed 's/"//g')

  if [[ -z "$first_model" ]]; then
    info "No models found to test with"
    echo "This could be due to:"
    echo "1. OpenRouter API key not being properly set or having insufficient permissions"
    echo "2. Network connectivity issues to OpenRouter"
    echo "3. LiteLLM configuration issues"
    echo ""
    echo "Try checking the OpenRouter dashboard to verify your API key is active:"
    echo "https://openrouter.ai/keys"
    return 1
  fi

  echo "Testing with first available model: $first_model"

  # Try a completion with the first available model
  local response
  response=$(curl  -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" -s "$BASE_URL/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -d '{
      "model": "'"$first_model"'",
      "messages": [
        {"role": "user", "content": "Hello"}
      ],
      "max_tokens": 10
    }' 2>&1)

  if [[ "$response" == *"content"* ]]; then
    success "Model $first_model is working"
    echo "Response content:"
    echo "$response" | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//g' | sed 's/"//g'
    echo ""
    echo "If other tests are failing but this one works, update the TEST_MODEL variable"
    echo "in this script to use '$first_model' instead of '$TEST_MODEL'"
    return 0
  else
    failure "Model $first_model test failed"
    echo "Response: $response"
    return 1
  fi
}

# 7. Check log file for common errors
check_log_file() {
  echo -e "\n${YELLOW}Step 7: Checking LiteLLM log file for errors${NC}"

  local log_file="$HOME/.local/lite-llm/lite-llm.log"

  if [ ! -f "$log_file" ]; then
    info "Log file not found at $log_file"
    return 1
  fi

  echo "Analyzing recent log entries..."

  # Check for common error patterns
  local auth_errors=$(grep -i "auth\|unauthorized\|api key\|permission" "$log_file" | tail -10)
  local conn_errors=$(grep -i "connection\|timeout\|refused\|network" "$log_file" | tail -10)
  local config_errors=$(grep -i "config\|invalid\|error\|exception" "$log_file" | tail -10)

  if [[ -n "$auth_errors" ]]; then
    echo -e "${RED}Authentication errors found:${NC}"
    echo "$auth_errors"
    echo ""
  fi

  if [[ -n "$conn_errors" ]]; then
    echo -e "${RED}Connection errors found:${NC}"
    echo "$conn_errors"
    echo ""
  fi

  if [[ -n "$config_errors" ]]; then
    echo -e "${RED}Configuration errors found:${NC}"
    echo "$config_errors"
    echo ""
  fi

  if [[ -z "$auth_errors" && -z "$conn_errors" && -z "$config_errors" ]]; then
    success "No common errors found in log file"
  else
    info "Errors found in log file. See above for details."
    echo "For full logs: cat $log_file"
  fi
}

# Main execution
echo "🔍 LiteLLM Validation Test"
echo "=========================="

# Run all checks
service_running=false
if check_service_running; then
  service_running=true
else
  echo -e "\n${RED}Critical error: LiteLLM service is not running. Cannot continue with tests.${NC}"
  exit 1
fi

# Only continue with other tests if service is running
if [ "$service_running" = true ]; then
  check_health
  check_models
  test_completion
  test_arithmetic
  test_model_availability
  check_log_file
fi

# Summary
echo -e "\n${YELLOW}Test Summary${NC}"
echo "=========================="
echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
  echo -e "\n${GREEN}✅ All tests passed! LiteLLM is working correctly.${NC}"
  exit 0
else
  echo -e "\n${RED}❌ Some tests failed. Please check the output above.${NC}"
  echo -e "\n${YELLOW}Troubleshooting Tips:${NC}"
  echo "1. Check LiteLLM logs: cat ~/.local/lite-llm/lite-llm.log"
  echo "2. Verify OpenRouter API key: gopass show api/openrouter"
  echo "3. Check OpenRouter dashboard: https://openrouter.ai/keys"
  echo "4. Restart LiteLLM: ./install-litellms.sh --reinstall"
  echo "5. Try a different model: Edit TEST_MODEL in this script"
  echo "6. Check OpenRouter status: https://status.openrouter.ai/"
  exit 1
fi
