# Goose GitHub Action

This GitHub Action allows you to run [Goose](https://github.com/block/goose) AI assistant in your GitHub Actions workflow.

## Features

- Run Goose AI assistant directly in your GitHub workflow
- Configure the model and provider via inputs or environment variables
- Authenticates with GitHub using your workflow token
- Supports all standard Goose functionality
- Securely pass API keys for different providers
- Support for multiple providers including OpenRouter

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

### Using Instructions File

```yaml
jobs:
  goose:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      
      - name: Run Goose with Instructions File
        uses: takutakahashi/goose-action@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          instructions_file: ".github/goose/instructions.txt"
          model: "gpt-4o"
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
```

### Using OpenRouter

```yaml
jobs:
  goose:
    runs-on: ubuntu-latest
    steps:
      - name: Run Goose with OpenRouter
        uses: takutakahashi/goose-action@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: "Please analyze this repository and suggest improvements."
          model: "openai/gpt-4-turbo" # specify the OpenRouter model path
          provider: "openrouter"
          openrouter_api_key: ${{ secrets.OPENROUTER_API_KEY }}
```

### Using a Specific Image Version

```yaml
jobs:
  goose:
    runs-on: ubuntu-latest
    steps:
      - name: Run Goose with Specific Version
        uses: takutakahashi/goose-action@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: "Please analyze this repository and suggest improvements."
          image_version: "v1.0.0"  # Use a specific version
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
```

### Using with GitHub Enterprise Server

```yaml
jobs:
  goose:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      
      - name: Run Goose with GitHub Enterprise Server
        uses: takutakahashi/goose-action@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          github_host: "github.example.com"  # Your GitHub Enterprise Server hostname
          prompt: "Please analyze this repository and suggest improvements."
          model: "gpt-4o"
          openai_api_key: ${{ secrets.OPENAI_API_KEY }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github_token` | GitHub token for authentication | Yes | `${{ github.token }}` |
| `github_host` | GitHub API host for GitHub Enterprise Server | No | GitHub.com |
| `prompt` | The prompt to send to Goose | No* | - |
| `instructions_file` | Path to a file containing instructions for Goose | No* | - |
| `model` | The model to use (e.g., gpt-4o, claude-3.5-sonnet) | No | `gpt-4o` |
| `provider` | The provider to use (e.g., openai, anthropic, openrouter) | No | `openai` |
| `repo` | The repository to run the action against | No | Current repository |
| `image_version` | The version of the Docker image to use | No | `latest` |

\* Either `prompt` or `instructions_file` must be provided

### API Key Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `openai_api_key` | OpenAI API key | No* |
| `anthropic_api_key` | Anthropic API key | No* |
| `claude_api_key` | Alias for anthropic_api_key | No* |
| `google_api_key` | Google API key | No* |
| `mistral_api_key` | Mistral API key | No* |
| `groq_api_key` | Groq API key | No* |
| `openrouter_api_key` | OpenRouter API key | No* |

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
- `OPENROUTER_API_KEY`

## Securing API Keys

It's important to securely store your API keys in GitHub Secrets:

1. Go to your repository's Settings > Secrets and variables > Actions
2. Click "New repository secret"
3. Add your API key with the appropriate name (e.g., `OPENAI_API_KEY`, `OPENROUTER_API_KEY`)
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

# Run the test script with a prompt
./test-action.sh "Your prompt here"

# Or run with an instructions file
export INSTRUCTIONS_FILE=path/to/your/instructions.txt
./test-action.sh
```

By default, the test script will use the pre-built Docker image from GHCR. You can customize this behavior:

```bash
# Use a specific image version
export IMAGE_VERSION=v1.0.0
./test-action.sh "Your prompt here"

# Build and test locally instead of using pre-built image
export USE_LOCAL=true
./test-action.sh "Your prompt here"
```

For other providers:
```bash
# For OpenRouter
export PROVIDER=openrouter
export OPENROUTER_API_KEY=your_openrouter_key
export MODEL=openai/gpt-4-turbo
```

For GitHub Enterprise Server:
```bash
export GITHUB_HOST=github.example.com  # Your GitHub Enterprise Server hostname
```

## Examples

You can find examples of how to use this action in the [examples](examples/) directory:

- Basic prompt usage
- Using instructions files ([example instruction file](examples/instructions/repository-analysis.txt))
- Different providers configuration
- [GitHub Enterprise Server integration](examples/github-enterprise/workflow.yml)

## License

MIT

## Image Versioning

The Docker image used by this action is automatically built and published to GitHub Container Registry (GHCR) when changes are made to the Dockerfile, entrypoint.sh, or related files in the main branch.

Available image versions:

- `latest` - Always points to the most recent build
- `<SHA>` - Specific commit SHA (short format)
- `v1.x.x` - Semantic version tags when releases are created

You can pin to a specific version using the `image_version` input parameter to ensure reproducible builds.

## Release Process

This project uses GitHub Actions for continuous deployment and release management:

1. **Pull Request Workflow**:
   - When a PR is created, it's automatically labeled based on the changes
   - A version bump suggestion is added as a comment based on semantic versioning rules
   - Image builds are tested to ensure they complete successfully

2. **Automatic Image Building**:
   - When changes to Dockerfile, entrypoint.sh, or related files are pushed to main, a new image is automatically built and pushed to GHCR
   - The image is tagged with the commit SHA and as `latest`

3. **Release Creation**:
   - Use the "Auto Version Bump" workflow from the Actions tab to create a new version
   - Choose the version increment type (major, minor, patch)
   - A new tag will be created and pushed, which triggers the release workflow
   - The release workflow creates a GitHub Release with changelog and builds the versioned Docker image

4. **Manual Release**:
   - Alternatively, you can manually create a tag following semantic versioning (e.g., `v1.2.3`)
   - Push the tag to trigger the release workflow: `git tag v1.2.3 && git push origin v1.2.3`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.