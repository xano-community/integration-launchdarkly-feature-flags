function "launchdarkly_get_flag" {
  description = "Get a feature flag's current configuration from LaunchDarkly"
  input {
    text project_key { description = "LaunchDarkly project key" }
    text flag_key { description = "Feature flag key" }
    text env? { description = "Filter to a specific environment key (reduces response size)" }
  }
  stack {
    var $url { value = "https://app.launchdarkly.com/api/v2/flags/" ~ $input.project_key ~ "/" ~ $input.flag_key }

    conditional {
      if ($input.env != null) {
        var.update $url { value = $url ~ "?env=" ~ $input.env }
      }
    }

    api.request {
      url = $url
      method = "GET"
      headers = ["Authorization: " ~ $env.LAUNCHDARKLY_API_KEY]
      mock = {
        "retrieves flag successfully": { response: { status: 200, result: { key: "new-checkout-flow", name: "New Checkout Flow", kind: "boolean", on: true, variations: [{ value: true }, { value: false }], _version: 12 } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "LaunchDarkly API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "retrieves flag successfully" {
    input = { project_key: "default", flag_key: "new-checkout-flow" }
    expect.to_equal ($response.key) { value = "new-checkout-flow" }
    expect.to_be_true ($response.on)
  }
}