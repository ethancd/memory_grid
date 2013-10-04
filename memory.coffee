window.Program = do ->

  start = -> game = new Game 5, 3

  class Game
    constructor: (@width, @height) ->
      @trial = 1
      @cellCount = (@height - 2) or 1
      do @populateGrid
      do @go

    populateGrid: ->
      $("#grid").css({
        "width": "#{@width * 50}px",
        "height": "#{@height * 50}px"
      })
      $("header").css({
        "width": "#{@width * 50 + 300}px"
      })

      $("#grid").html("")
      for i in [0...@width]
        for j in [0...@height]
           $("#grid").append "<div class='cell' id='r#{i}c#{j}'></div>"

    go: ->
      @correctCount = 0
      @passive = 1000 + 100 * @cellCount
      @active = 500 * @width + 500 * @cellCount
      @remaining = @active / 100

      $("time#remaining").html((@remaining/10).toFixed(1) + " s")   
      $("#timer").css("color", "#000")
      $(".cell").removeClass("chosen")

      do @disableMouse
      do @pickCells
      @lightCells true

      current = @trial
      setTimeout ( => 
        @lightCells false
        do @enableMouse

        @timer = setInterval ( =>
          @remaining -= 1
          console.log @remaining
          $("time#remaining").html((@remaining/10).toFixed(1) + " s")
          $("#timer").css("color", "#c00") if @remaining <= 10  
          ), 100

        setTimeout ( =>
          @respond false, current
          ), (@active + 50)
        ), @passive

    disableMouse: -> $(".cell").off "click"
    enableMouse: -> 
      t = @
      $(".cell").on "click", (event) -> 
        unless $(this).hasClass("chosen")
          if $(this).attr("id") in t.cells
            $(this).addClass("chosen")
            t.correctCount += 1
            if t.correctCount is t.cellCount
              t.respond true
          else
            t.respond false

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

    respond: (succeeded, trial) ->
      if arguments.length is 1 or trial is @trial
        $("time#remaining").html("0.0 s") if arguments.length is 2
        @flash succeeded
        clearInterval(@timer)
        if succeeded 
          $("#max").html(@cellCount) if @cellCount > parseInt($("#max").html())
          bonus = 10 * @height * (@cellCount + (Math.ceil(@remaining * 10)/10))
          $("#score").html(bonus + parseInt $("#score").html())
          if @cellCount > (@width * @height / 4)
            @cellCount = @width
            @height += 1
            @width = Math.floor(@height * 1.6)
            $("#success strong").html("Level Up!")
            setTimeout ( => do @populateGrid ), 1000
          else
            @cellCount += 1
        else
          @lightCells true

        @trial += 1
        setTimeout ( => do @go), 1000

    flash: (succeeded) ->
      if succeeded
        message = "Nice!"
        $("#timer").css("color", "#090")
      else
        message = "Try Again!"
        $("#timer").css("color", "#c00")

      $("#success strong").addClass("#{succeeded}").html("#{message}")
      setTimeout ( -> $("#success strong").removeClass("#{succeeded}").html("") ), 1000
  {start: start}













