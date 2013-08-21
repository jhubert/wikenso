_.mixin
  sequence: (funcs...) ->
    (context) =>
      _(funcs).each (func) => func.apply(context)
