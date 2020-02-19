use Mix.Config

# This configuration section uses the default values in mix.exs;
# uncomment and put your overrides here. You will especially 
# want to set your own value(s) for upload_field_sets. 
# See https://docs.sypht.com/#section/Introduction for details.
# config :sypht_client,
#   auth_url: "https://login.sypht.com/oauth/token",
#   auth_ttl: 84_600_000,
#   auth_retry_on: [500],
#   auth_initial_backoff: 200,
#   auth_retry_until: 30_000,
#   auth_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
#   auth_error_prefix: "SyphtAuth failed:",
#   upload_url: "https://api.sypht.com/fileupload",
#   upload_field_sets: ["sypht.generic"],
#   upload_retry_on: [500, 501, 502, 503],
#   upload_initial_backoff: 200,
#   upload_retry_until: 60_000,
#   upload_http_options: [ssl: [{:versions, [:"tlsv1.2"]}]],
#   upload_error_prefix: "SyphtUpload failed:",
#   result_url: "https://api.sypht.com/result/final",
#   result_retry_on: [202, 500, 501, 502, 503, 504],
#   result_initial_backoff: 200,
#   result_retry_until: 300_000,
#   result_http_options: [
#     timeout: 20_000,
#     recv_timeout: 150_000,
#     ssl: [{:versions, [:"tlsv1.2"]}]
#   ],
#   result_error_prefix: "SyphtResult failed:"
