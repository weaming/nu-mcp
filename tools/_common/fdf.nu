# Convert table data to FDF/1 format via the fdf CLI.
# Accepts tables (lists of records) or JSON strings (e.g. `gh --json` output).
# Non-table input (error strings, single objects, formatted text) passes through unchanged.
#
# Requires the `fdf` CLI on PATH (https://github.com/weaming/ai-box/go/fdf).

export def to-fdf [] {
  let input = $in
  let type = $input | describe

  let table = if ($type | str starts-with "string") {
    # JSON string from external commands (e.g. gh --json output)
    try { $input | from json } catch { null }
  } else if ($type | str starts-with "list") or ($type | str contains "table") {
    $input
  } else {
    return $input
  }

  if $table == null { return $input }
  if ($table | is-empty) {
    # FDF cannot represent an empty table; keep JSON array form
    "[]"
  } else if ($table | describe | str contains "table") {
    $table | to json -r | ^fdf -j
  } else {
    $input
  }
}
