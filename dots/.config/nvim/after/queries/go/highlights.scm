;; vim: ft=query
;; extends

(function_declaration
  name: (identifier) @function.definition)
(method_declaration
  name: (field_identifier) @function.definition)
