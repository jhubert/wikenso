class WikiApp.DocumentSelection
  constructor: ->
    if window.getSelection
      sel = window.getSelection()
      if sel.getRangeAt and sel.rangeCount
        ranges = []
        i = 0
        len = sel.rangeCount

        while i < len
          ranges.push sel.getRangeAt(i)
          ++i
        @selection = ranges
    else
      @selection = document.selection.createRange()  if document.selection and document.selection.createRange

  restore: =>
    if @selection
      if window.getSelection
        sel = window.getSelection()
        sel.removeAllRanges()
        i = 0
        len = @selection.length

        while i < len
          sel.addRange @selection[i]
          ++i
      else @selection.select()  if document.selection and @selection.select
