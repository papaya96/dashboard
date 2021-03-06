class Dashing.Ohheating extends Dashing.Widget
  constructor: ->
    super
    @queryState()

  @accessor 'state',
    get: -> @_state ? "Unknown"
    set: (key, value) -> 
      @_state = value

  #    jsonInner = JSON.parse @get('state')
  #     @set 'temperature', jsonInner.temperature
  #     @set 'target', jsonInner.target       

  @accessor 'temperature',
    get: -> if @_temperature then parseFloat(@_temperature).toFixed(1) else 0
    set: (key, value) -> 
      @_temperature = value

  @accessor 'target',
    get: -> if @_target then parseFloat(@_target).toFixed(1) else 0
    set: (key, value) -> 
      @_target = value

  @accessor 'target-style', ->
    $.get '/openhab/dispatch',
      widgetId: 'heatac',
      deviceId: 'heatac',
      deviceType: 'temperature'
      (data) =>
        json = JSON.parse data
        @set 'tempState', json.state
    if (@get('tempState') == 'ON')
      if @get('temperature') == @get('target')
        console.log "style: steady"
        'heating-steady'       
      else if @get('temperature') < @get('target') 
        console.log "style: on"
        'heating-on' 
      else
        console.log "style: off"
        'heating-off'
    else
      if @get('temperature') == @get('target')
        console.log "style: steady"
        'heating-steady'       
      else if @get('temperature') < @get('target') 
        console.log "style: off"
        'heating-off' 
      else
        console.log "style: on"
        'heating-on'
      
  queryState: ->
    $.get '/openhab/dispatch',
      widgetId: @get('id'),
      deviceId: @get('device'),
      deviceType: 'temperature'
      (data) =>
        json = JSON.parse data
        @set 'state', json.state

        jsonInner = JSON.parse json.state
        @set 'temperature', jsonInner.temperature
        @set 'target', jsonInner.target
        console.log 'temperature: ', jsonInner.temperature, ', target: ', jsonInner.target
        console.log json, ' Inner: ', jsonInner

  ready: ->

  onData: (data) ->
    debugger
    console.log "data",data
    json = JSON.parse data
    @set 'state', json.state
    jsonInner = JSON.parse json.state
    @set 'temperature', jsonInner.temperature
    @set 'target', jsonInner.target
  	console.log "temperature: ", @get('temperature'),", target: ", @get('target')
