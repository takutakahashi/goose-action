# Goose GitHub Action

This GitHub Action allows you to run [Goose](https://github.com/block/goose) AI assistant in your GitHub Actions workflow.

## Features

- Run Goose AI assistant directly in your GitHub workflow
- Configure the model and provider via inputs or environment variables
- Authenticates with GitHub using your workflow token
- Supports all standard Goose functionality
- Securely pass API keys for different providers

## Usage

### Basic Example

```yaml
jobs:
  goose:
    runs-on: ubuntu-latest
    steps:
      - name: Run Goose
        uses: takutakahashi/goose-action@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: "Please analyze this repository and suggest improvements."
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
```

### Advanced Configuration

```yaml
jobs:
  goose:
    runs-on: ubuntu-latest
    steps:
      - name: Run Goose with Custom Configuration
        uses: takutakahashi/goose-action@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: "Please analyze the code in this PR and suggest any improvements."
          model: "claude-3.5-sonnet"
          provider: "anthropic"
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          repo: "alternative/repository"
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github_token` | GitHub token for authentication | Yes | `${{ github.token }}` |
| `prompt` | The prompt to send to Goose | Yes | - |
| `model` | The model to use (e.g., gpt-4o, claude-3.5-sonnet) | No | `gpt-4o` |
| `provider` | The provider to use (e.g., openai, anthropic) | No | `openai` |
| `repo` | The repository to run the action against | No | Current repository |

### API Key Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `openai_api_key` | OpenAI API key | No* |
| `anthropic_api_key` | Anthropic API key | No* |
| `claude_api_key` | Alias for anthropic_api_key | No* |
| `google_api_key` | Google API key | No* |
| `mistral_api_key` | Mistral API key | No* |
| `groq_api_key` | Groq API key | No* |

\* Required if using the corresponding provider

## Environment Variables

You can also configure Goose using environment variables:

- `GOOSE_PROVIDER`: Sets the AI provider
- `GOOSE_MODEL`: Sets the AI model

The action will also set the following environment variables based on your inputs:
- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GOOGLE_API_KEY`
- `MISTRAL_API_KEY`
- `GROQ_API_KEY`

## Securing API Keys

It's important to securely store your API keys in GitHub Secrets:

1. Go to your repository's Settings > Secrets and variables > Actions
2. Click "New repository secret"
3. Add your API key with the appropriate name (e.g., `OPENAI_API_KEY`)
4. Reference it in your workflow as shown in the examples above

## Requirements

- GitHub Actions runner with Docker support
- Valid GitHub token with appropriate permissions
- API key for the selected provider

## Local Testing

You can test the action locally using the provided test script:

```bash
# Set required environment variables
export GITHUB_TOKEN=your_token
export OPENAI_API_KEY=your_openai_key

# Run the test script
./test-action.sh "Your prompt here"
```

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.