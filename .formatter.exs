# Used by "mix format" and to export configuration.
export_locals_without_parens = []

[
  inputs: ["{mix,.formatter,.credo}.exs", "{config,lib,test,web}/**/*.{ex,exs}"],
  locals_without_parens: export_locals_without_parens,
  export: [locals_without_parens: export_locals_without_parens]
]
