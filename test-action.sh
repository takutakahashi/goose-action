#!/bin/bash
# test-action.sh - Test the Goose GitHub Action locally

# Required environment variables
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN environment variable is required"
  echo "Please set it with: export GITHUB_TOKEN=your_token"
  exit 1
fi

# Check if we have either prompt or instructions file
if [ -z "$1" ] && [ -z "$INSTRUCTIONS_FILE" ]; then
  echo "Usage: ./test-action.sh \"Your prompt here\""
  echo "   or: INSTRUCTIONS_FILE=path/to/instructions.txt ./test-action.sh"
  exit 1
fi

# Default values
MODEL=${MODEL:-gpt-4o}
PROVIDER=${PROVIDER:-openai}
REPO=${REPO:-$(git config --get remote.origin.url | sed 's/.*github.com[\/:]\(.*\)\.git/\1/')}
PROMPT=${1:-""}
INSTRUCTIONS_FILE=${INSTRUCTIONS_FILE:-""}
GITHUB_HOST=${GITHUB_HOST:-""}
IMAGE_VERSION=${IMAGE_VERSION:-"latest"}
USE_LOCAL=${USE_LOCAL:-false}

# API Keys
OPENAI_API_KEY=${OPENAI_API_KEY:-""}
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY:-""}
CLAUDE_API_KEY=${CLAUDE_API_KEY:-""}
GOOGLE_API_KEY=${GOOGLE_API_KEY:-""}
MISTRAL_API_KEY=${MISTRAL_API_KEY:-""}
GROQ_API_KEY=${GROQ_API_KEY:-""}
OPENROUTER_API_KEY=${OPENROUTER_API_KEY:-""}

# Check if API key is available for selected provider
check_api_key() {
  case "$PROVIDER" in
    "openai")
      if [ -z "$OPENAI_API_KEY" ]; then
        echo "Warning: No OpenAI API key provided in OPENAI_API_KEY environment variable."
        echo "The action may fail if the key isn't available in the container environment."
      fi
      ;;
    "anthropic"|"claude")
      if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$CLAUDE_API_KEY" ]; then
        echo "Warning: No Anthropic/Claude API key provided in ANTHROPIC_API_KEY or CLAUDE_API_KEY environment variables."
        echo "The action may fail if the key isn't available in the container environment."
      fi
      ;;
    "google")
      if [ -z "$GOOGLE_API_KEY" ]; then
        echo "Warning: No Google API key provided in GOOGLE_API_KEY environment variable."
        echo "The action may fail if the key isn't available in the container environment."
      fi
      ;;
    "mistral")
      if [ -z "$MISTRAL_API_KEY" ]; then
        echo "Warning: No Mistral API key provided in MISTRAL_API_KEY environment variable."
        echo "The action may fail if the key isn't available in the container environment."
      fi
      ;;
    "groq")
      if [ -z "$GROQ_API_KEY" ]; then
        echo "Warning: No Groq API key provided in GROQ_API_KEY environment variable."
        echo "The action may fail if the key isn't available in the container environment."
      fi
      ;;
    "openrouter")
      if [ -z "$OPENROUTER_API_KEY" ]; then
        echo "Warning: No OpenRouter API key provided in OPENROUTER_API_KEY environment variable."
        echo "The action may fail if the key isn't available in the container environment."
      fi
      ;;
  esac
}

# Print configuration
echo "Testing Goose Action with:"
echo "Model: $MODEL"
echo "Provider: $PROVIDER"
echo "Repository: $REPO"
if [ -n "$GITHUB_HOST" ]; then
  echo "GitHub Enterprise Server: $GITHUB_HOST"
fi
if [ -n "$PROMPT" ]; then
  echo "Prompt: $PROMPT"
fi
if [ -n "$INSTRUCTIONS_FILE" ]; then
  echo "Instructions file: $INSTRUCTIONS_FILE"
  
  # Check if instructions file exists
  if [ ! -f "$INSTRUCTIONS_FILE" ]; then
    echo "Error: Instructions file '$INSTRUCTIONS_FILE' not found."
    exit 1
  fi
fi
check_api_key
echo ""

# Determine which image to use
if [ "$USE_LOCAL" = "true" ]; then
  # Build the Docker image locally
  echo "Building local Docker image..."
  docker build -t goose-action-test .
  DOCKER_IMAGE="goose-action-test"
else
  # Use pre-built image
  echo "Using pre-built Docker image: ghcr.io/takutakahashi/goose-action:$IMAGE_VERSION"
  DOCKER_IMAGE="ghcr.io/takutakahashi/goose-action:$IMAGE_VERSION"
  
  # Pull the image
  docker pull $DOCKER_IMAGE
fi

# Run the container
echo "Running container..."
docker run --rm \
  -e INPUT_GITHUB_TOKEN="$GITHUB_TOKEN" \
  -e INPUT_GITHUB_HOST="$GITHUB_HOST" \
  -e INPUT_PROMPT="$PROMPT" \
  -e INPUT_INSTRUCTIONS_FILE="$INSTRUCTIONS_FILE" \
  -e INPUT_MODEL="$MODEL" \
  -e INPUT_PROVIDER="$PROVIDER" \
  -e INPUT_REPO="$REPO" \
  -e INPUT_OPENAI_API_KEY="$OPENAI_API_KEY" \
  -e INPUT_ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
  -e INPUT_CLAUDE_API_KEY="$CLAUDE_API_KEY" \
  -e INPUT_GOOGLE_API_KEY="$GOOGLE_API_KEY" \
  -e INPUT_MISTRAL_API_KEY="$MISTRAL_API_KEY" \
  -e INPUT_GROQ_API_KEY="$GROQ_API_KEY" \
  -e INPUT_OPENROUTER_API_KEY="$OPENROUTER_API_KEY" \
  -e GITHUB_REPOSITORY="$REPO" \
  $([ -n "$INSTRUCTIONS_FILE" ] && echo "-v $(realpath $INSTRUCTIONS_FILE):$INSTRUCTIONS_FILE") \
  $DOCKER_IMAGE

echo "Test completed."