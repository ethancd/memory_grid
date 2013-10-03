window.Game = do ->

  start = (height) ->
    width = nextFib(height)
    game = new Game width, height
    do game.go

  nextFib = (number) ->
    n = 1
    fibs = [1,1]
    while number >= fibs[n]
      fibs.push(fibs[n] + fibs[n-1])
      n += 1

    fibs[n]

  disableMouse = -> $(".cell").off "click"
  enableMouse = -> 
    $(".cell").on "click", (event) -> 
      $(this).addClass("chosen")

      if $(this).attr("id") in @cells
        @correctCount += 1
        if @correctCount is @cellCount
          @respond true
      else
        @respond false

  class Game
    constructor: (@width, @height) ->
      @cellCount = @width
      @delay = 400 * @cellCount
      do @populateGrid

    populateGrid: ->
      $("#grid").html("")
      for i in [0...@width]
        for j in [0...@height]
           $("#grid").append "<div class='cell' id='r#{i}c#{j}'</div>"

    # go: ->
    #   do @display #turns off mousepower, highlights @n squares, waits x seconds,
      #turns off highlighting, turns on mousepower
      #if click not highlighted block, go BAD, display all blocks, do display with same n
      #if click all right blocks, go GOOD, increase @bC; if @bC > @width, h = w, w = nextfib(h)
        #do display
      #, timeStep

    go: ->
      @correctCount = 0
      do disableMouse
      do @pickCells
      @lightCells true

      setTimeout ( -> 
        @lightCells false
        do enableMouse
        setTimeout ( ->
          do @respond false
          ), 1000 * @height
        ), @delay

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
      if succeeded 
        #@flash "good"
        $("#max").html(@cellCount)
        $("#score").html(@cellCount + parseInt $("#score").html())
        @cellCount += 1
        if @cellCount > @width
          [@height, @width] = [@width, nextFib @width]
          do @populateGrid
      #else
        #@flash "bad"
      
      do @go











  
