A simple serialization library for arbitrary tables in Lua based on string.pack and string.unpack

Supports serializing and deserializing tables containing the following datatypes:
- nil
- string
- number
- boolean
- function
- table

Note that functions can't have reliance on variables outside of their immediate scope.
