# LaunchDarkly Integration for Xano

Manage feature flags directly from your Xano backend. Retrieve flag configurations and toggle flags on or off to control feature rollouts without redeploying.

## Functions

| Function | Description |
| --- | --- |
| `launchdarkly_get_flag` | Retrieves the configuration of a specific feature flag. |
| `launchdarkly_toggle_flag` | Enables or disables a feature flag. |

## Install

### Option A — Ask Claude Code

With the [Xano MCP](https://github.com/xano-labs/mcp-server) enabled in Claude Code, paste this into Claude:

> Install the integration at https://github.com/xano-community/integration-launchdarkly-feature-flags into my Xano workspace.

Claude will clone the repo and push the functions to your workspace.

### Option B — Use the Xano CLI

1. Install and authenticate the [Xano CLI](https://docs.xano.com/cli):
   ```sh
   npm install -g @xano/cli
   xano auth
   ```

2. Clone and push this integration:
   ```sh
   git clone https://github.com/xano-community/integration-launchdarkly-feature-flags.git
   cd integration-launchdarkly-feature-flags
   xano workspace:push . -w <your-workspace-id>
   ```

   Replace `<your-workspace-id>` with the ID from `xano workspace:list`.

## Configure Credentials

1. Sign up or log in at https://launchdarkly.com.
2. Go to Account Settings > Authorization and create a new API access token.
3. Copy the token value.
4. In your Xano workspace, go to Settings > Environment Variables and add LAUNCHDARKLY_API_KEY with the token value.

Environment variables used by this integration:

- `LAUNCHDARKLY_API_KEY`

See `.env.example` for a template.

## Usage

Call any function from another function, task, or API endpoint using `function.run`:

```xs
function.run "launchdarkly_get_flag" {
  input = {
    // See function signature for required parameters
  }
} as $result
```

## Function Reference

### `launchdarkly_get_flag`

Fetches the full configuration for a feature flag by its key, including its current status, variations, and targeting rules. Use this to check flag state before making decisions in your backend logic or to display flag details in an admin dashboard.

### `launchdarkly_toggle_flag`

Toggles a feature flag on or off in a specified environment using a semantic patch update. Provide the flag key and the desired boolean state. Ideal for kill switches, gradual rollouts, or enabling features in response to backend events.

## License

MIT — see [LICENSE](./LICENSE).
