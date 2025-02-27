#!/bin/bash
set -e

# Configuration
GITHUB_TOKEN="${INPUT_GITHUB_TOKEN}"
PROMPT="${INPUT_PROMPT}"
MODEL="${INPUT_MODEL:-gpt-4o}"
PROVIDER="${INPUT_PROVIDER:-openai}"
REPO="${INPUT_REPO:-${GITHUB_REPOSITORY}}"

# API Keys configuration
OPENAI_API_KEY="${INPUT_OPENAI_API_KEY}"
ANTHROPIC_API_KEY="${INPUT_ANTHROPIC_API_KEY:-${INPUT_CLAUDE_API_KEY}}"
GOOGLE_API_KEY="${INPUT_GOOGLE_API_KEY}"
MISTRAL_API_KEY="${INPUT_MISTRAL_API_KEY}"
GROQ_API_KEY="${INPUT_GROQ_API_KEY}"

# Log configuration (without tokens)
echo "Running Goose with configuration:"
echo "Model: $MODEL"
echo "Provider: $PROVIDER"
echo "Repository: $REPO"

# Set up GitHub authentication
echo "Setting up GitHub authentication..."
echo "$GITHUB_TOKEN" | gh auth login --with-token
if [ $? -ne 0 ]; then
  echo "::error::Failed to authenticate with GitHub"
  exit 1
fi
echo "GitHub authentication successful."

# Set up git configuration if needed
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

# Export environment variables for Goose
export GOOSE_PROVIDER="$PROVIDER"
export GOOSE_MODEL="$MODEL"

# Export API Keys based on provider
if [ -n "$OPENAI_API_KEY" ]; then
  export OPENAI_API_KEY="$OPENAI_API_KEY"
fi

if [ -n "$ANTHROPIC_API_KEY" ]; then
  export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
fi

if [ -n "$GOOGLE_API_KEY" ]; then
  export GOOGLE_API_KEY="$GOOGLE_API_KEY"
fi

if [ -n "$MISTRAL_API_KEY" ]; then
  export MISTRAL_API_KEY="$MISTRAL_API_KEY"
fi

if [ -n "$GROQ_API_KEY" ]; then
  export GROQ_API_KEY="$GROQ_API_KEY"
fi

# Check if API key is available for selected provider
check_api_key() {
  case "$PROVIDER" in
    "openai")
      if [ -z "$OPENAI_API_KEY" ]; then
        echo "::warning::No OpenAI API key provided. Make sure it's available in the environment or through GitHub secrets."
      fi
      ;;
    "anthropic"|"claude")
      if [ -z "$ANTHROPIC_API_KEY" ]; then
        echo "::warning::No Anthropic/Claude API key provided. Make sure it's available in the environment or through GitHub secrets."
      fi
      ;;
    "google")
      if [ -z "$GOOGLE_API_KEY" ]; then
        echo "::warning::No Google API key provided. Make sure it's available in the environment or through GitHub secrets."
      fi
      ;;
    "mistral")
      if [ -z "$MISTRAL_API_KEY" ]; then
        echo "::warning::No Mistral API key provided. Make sure it's available in the environment or through GitHub secrets."
      fi
      ;;
    "groq")
      if [ -z "$GROQ_API_KEY" ]; then
        echo "::warning::No Groq API key provided. Make sure it's available in the environment or through GitHub secrets."
      fi
      ;;
  esac
}

check_api_key

# Run Goose
echo "Running Goose with prompt: $PROMPT"
goose run --repo "$REPO" --prompt "$PROMPT"

echo "Goose execution completed."