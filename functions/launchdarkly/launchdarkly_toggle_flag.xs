function "launchdarkly_toggle_flag" {
  description = "Enable or disable a feature flag in LaunchDarkly"
  input {
    text project_key { description = "LaunchDarkly project key" }
    text flag_key { description = "Feature flag key" }
    text environment_key { description = "Environment key (e.g. production, staging)" }
    bool enabled { description = "True to turn flag on, false to turn flag off" }
    text comment? { description = "Optional comment describing why the flag was toggled" }
  }
  stack {
    var $kind { value = "turnFlagOff" }
    conditional {
      if ($input.enabled == true) {
        var.update $kind { value = "turnFlagOn" }
      }
    }

    var $params {
      value = {
        environmentKey: $input.environment_key,
        instructions: [{ kind: $kind }]
      }
    }
    var.update $params { value = $params|set_ifnotnull:"comment":$input.comment }

    api.request {
      url = "https://app.launchdarkly.com/api/v2/flags/" ~ $input.project_key ~ "/" ~ $input.flag_key
      method = "PATCH"
      headers = ["Authorization: " ~ $env.LAUNCHDARKLY_API_KEY, "Content-Type: application/json; domain-model=launchdarkly.semanticpatch"]
      params = $params
      mock = {
        "toggles flag on": { response: { status: 200, result: { key: "new-checkout-flow", name: "New Checkout Flow", kind: "boolean", on: true, _version: 13 } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "LaunchDarkly API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "toggles flag on" {
    input = { project_key: "default", flag_key: "new-checkout-flow", environment_key: "production", enabled: true }
    expect.to_equal ($response.key) { value = "new-checkout-flow" }
    expect.to_be_true ($response.on)
  }
}