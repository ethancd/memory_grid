window.Game = do ->

  start = (height) ->
    width = nextFib(height)
    game = new Game parseInt(width), parseInt(height)

  nextFib = (number) ->
    n = 1
    fibs = [1,1]
    while number >= fibs[n]
      fibs.push(fibs[n] + fibs[n-1])
      n += 1

    fibs[n]

  class Game
    constructor: (@width, @height) ->
      @cellCount = (@height - 2) or 1
      @delay = 400 * @cellCount
      do @populateGrid
      do @go

    populateGrid: ->
      window.less.modifyVars({
        "@grid-width": "#{@width * 40}px",
        "@grid-height": "#{@height * 40}px"
        })
      $("#grid").html("")
      for i in [0...@width]
        for j in [0...@height]
           $("#grid").append "<div class='cell' id='r#{i}c#{j}'</div>"

    go: ->
      @correctCount = 0
      do @disableMouse
      do @pickCells
      @lightCells true

      that = @
      setTimeout ( -> 
        that.lightCells false
        do that.enableMouse
        # setTimeout ( ->
        #   that.respond false
        #   ), (1000 * that.height)
        ), @delay

    disableMouse: -> $(".cell").off "click"
    enableMouse: -> 
      that = @
      $(".cell").on "click", (event) -> 
        $(this).addClass("chosen")

        if $(this).attr("id") in that.cells
          that.correctCount += 1
          console.log that.correctCount is that.cellCount
          if that.correctCount is that.cellCount
            that.respond true
        else
          that.respond false

    pickCells: ->
      @cells = []
      for i in [0...@cellCount]
        cell = do @pickCell
        @cells.push cell

    pickCell: ->
      while !cell? or cell in @cells 
        x = Math.floor(do Math.random * @width)
        y = Math.floor(do Math.random * @height)
        cell = "r#{x}c#{y}"

      cell

    lightCells: (bool) -> 
      $("##{cell}").toggleClass("chosen", bool) for cell in @cells

    respond: (succeeded) ->
      $(".cell").removeClass("chosen")
      if succeeded 
        #@flash "good"
        $("#max").html(@cellCount)
        $("#score").html(@cellCount + parseInt $("#score").html())
        if @cellCount >= @width
          @cellCount = @height
          [@height, @width] = [@width, nextFib @width]
          do @populateGrid
        else
          @cellCount += 1
      #else
        #@flash "bad"
      
      do @go

  {start: start}