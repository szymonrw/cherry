fs = require 'fs'

in_pattern = (pattern) ->
  new RegExp "^#{pattern.replace /\*./g, (match) -> "([^#{match[1]}./]+)\\#{match[1]}"}$"

out_pattern = (pattern) ->
  count = 1
  pattern.replace /\*/g, (match) -> "$#{count++}"

expand = (recipes) ->
  for recipe in recipes
    recipe.in_pattern  = in_pattern recipe.in
    recipe.out_pattern = out_pattern recipe.out
  recipes

scan_dir = (path) ->
  files = fs.readdirSync path
  paths = ((path + '/' + name).replace('./', '') for name in files)
  paths.concat(scan_dir path for path in paths when fs.statSync(path).isDirectory() ...)

module.exports =
  in_pattern:  in_pattern
  out_pattern: out_pattern
  expand:      expand
  scan_dir:    scan_dir