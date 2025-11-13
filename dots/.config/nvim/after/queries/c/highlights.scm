;; vim: ft=query
;; extends

(type_definition
  declarator: (type_identifier) @type.nodefinition (#set! priority 110))

(function_definition
  declarator: (function_declarator
    declarator: (identifier) @function.definition))

(function_definition
  declarator: (pointer_declarator
    declarator: (function_declarator
      declarator: (identifier) @function.definition)))

(function_definition
  declarator: (pointer_declarator
    declarator: (pointer_declarator
      declarator: (function_declarator
        declarator: (identifier) @function.definition))))
