_.mixin
  sequence: (funcs...) ->
    _(funcs).each (func) -> func.apply(this)
