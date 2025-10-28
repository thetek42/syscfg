;; vim: ft=query
;; extends

(function_item
  name: (identifier) @function.definition)

(struct_item
  name: (type_identifier) @type.definition)
(enum_item
  name: (type_identifier) @type.definition)
(trait_item
  name: (type_identifier) @type.definition)

(macro_definition
  name: (identifier) @macro.definition)
