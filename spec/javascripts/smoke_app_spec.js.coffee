describe "SmokeApp", ->

  beforeEach ->
    window.SmokeApp = {}

  it "sets up the environment", ->
    expect(window.SmokeApp).toEqual(jasmine.any(Object))
