;; leaf nodes are left intact
[
  (cell_path)
  (comment)
  (shebang)
  (unquoted)
  (val_binary)
  (val_bool)
  (val_date)
  (val_duration)
  (val_filesize)
  (val_nothing)
  (val_number)
  (val_string)
  (val_variable)
] @leaf

;; keep empty lines
(_) @allow_blank_line_before

[
  ":"
  ";"
] @append_space

;; TODO: temp solution for the whitespace issue
[
  "="
] @prepend_space

[
  "->"
  "=>"
  "alias"
  "as"
  "catch"
  "const"
  "def"
  "do"
  "else"
  "error"
  "export"
  "export-env"
  "extern"
  "for"
  "hide"
  "hide-env"
  "if"
  "in"
  "let"
  "loop"
  "make"
  "match"
  "module"
  "mut"
  "new"
  "overlay"
  "return"
  "source"
  "source-env"
  "try"
  "use"
  "where"
  "while"
] @prepend_space @append_space

(pipeline
  "|" @prepend_space @append_space @prepend_empty_softline
)

;; add spaces to left & right sides of operators
(expr_binary
  opr: _ @append_space @prepend_space
)

(expr_parenthesized
  (pipeline
    (pipe_element
      (expr_binary
        opr: _ @append_empty_softline
      )
    )
  )
)

(expr_binary
  (expr_binary
     opr: _ @append_empty_softline
  )
)

(assignment
  opr: _ @prepend_space
)

(where_command
  opr: _ @prepend_space @append_space
)

;; special flags
(overlay_use
  (short_flag)? @append_space
  (long_flag)? @append_space
)

(ctrl_error
  (short_flag)? @append_space
  (long_flag)? @append_space
)

(ctrl_do
  (short_flag)? @append_space
  (long_flag)? @append_space
)

;; indentation
[
  "["
  "("
  "...("
  "...["
  "...{"
] @append_indent_start @append_empty_softline

[
  "]"
  "}"
  ")"
] @prepend_indent_end @prepend_empty_softline

;;; change line happens after || for closure
"{" @append_indent_start
(
  "{" @append_empty_softline
  .
  (parameter_pipes)? @do_nothing
)

;; space/new-line between parameters
(parameter_pipes
  (
    (parameter) @append_space
    .
    (parameter)
  )?
) @append_space @append_spaced_softline

(parameter_bracks
  (parameter) @append_space
  .
  (parameter) @prepend_empty_softline
)

(parameter
  param_long_flag: _? @prepend_space
  .
  flag_capsule: _? @prepend_space
)

;; declarations
(decl_def
  (long_flag)? @prepend_space @append_space
  quoted_name: _? @prepend_space @append_space
  unquoted_name: _? @prepend_space @append_space
  (returns)?
  (block) @prepend_space
)

(decl_use
  module: _? @prepend_space @append_space
  import_pattern: _? @prepend_space @append_space
)

(decl_extern
  "export"?
  quoted_name: _? @prepend_space @append_space
  unquoted_name: _? @prepend_space @append_space
  (block) @prepend_space
)

(decl_module
  "export"?
  quoted_name: _? @prepend_space @append_space
  unquoted_name: _? @prepend_space @append_space
  (block)? @prepend_space
)

;; new-line
(comment) @prepend_input_softline @append_hardline

;; TODO: substantial slow down of duplicated rules
(nu_script
  (_)
  (_) @prepend_input_softline
)

(block
  (_)
  (_) @prepend_input_softline
)

(val_closure
  (_)
  (_) @prepend_input_softline
)

;; control flow
(ctrl_if
  "if" @append_space
  condition: _ @append_space
)

(ctrl_for
  "for" @append_space
  "in" @prepend_space @append_space
  body: _ @prepend_space
)

(ctrl_while
  "while" @append_space
  condition: _ @append_space
)

(ctrl_match
  "match" @append_space
  scrutinee: _? @append_space
  (match_arm)? @prepend_spaced_softline
  (default_arm)? @prepend_spaced_softline
)

;; data structures
(command_list
  [
    (cmd_identifier)
    (val_string)
  ] @append_space @prepend_spaced_softline
)

(command
  flag: _? @prepend_space
  arg_str: _? @prepend_space
  arg_spread: _? @prepend_space
  arg: _? @prepend_space
  redir: (_
    file_path: _? @prepend_space
  )? @prepend_space
)

(list_body
  entry: _ @append_space
  .
  entry: _ @prepend_spaced_softline
)

(val_list
  item: _ @append_space @prepend_spaced_softline
)

(val_table
  row: _ @prepend_spaced_softline
)

(val_record
  entry: (record_entry) @append_space @prepend_spaced_softline
)

(record_body
  entry: (record_entry) @append_space @prepend_spaced_softline
)
