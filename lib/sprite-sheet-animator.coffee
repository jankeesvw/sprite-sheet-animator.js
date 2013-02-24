# ## Usage
#
# This script can be used to animate sprite sheets created with EaselJS [Zoë](http://www.createjs.com/#!/Zoe).
#
# Step one is to include the image as you would normally do:
#
#      <img alt="Twelve Twenty logo"
#         src="assets/logo.png"
#         height="163"
#         width="141"
#      >
#
# You can then add some special attributes to enable the SpriteSheetAnimator behavior:
#
# These attributes are available:
#
# * `json`: (required) path to the JSON file generated by Zoë
# * `autostart`: (optional) if set to true, the animation will animate once loaded
# * `rollover`: (optional) animate on rollover (default: false)
# * `trigger`: (optional) jQuery selector that triggers rollover
#
# Your image should can look like this:
#
#      <img alt="Twelve Twenty logo"
#         src="assets/logo.png"
#         height="163"
#         width="141"
#         data-rollover="true"
#         data-animate="true"
#         data-autostart="true"
#         data-trigger="#trigger"
#         data-json="assets/logo-animation.json"
#      >

## Source code Explained:
class SpriteSheetAnimator
  constructor: (@asset) ->
    # Read atributes of image tag
    @json = @asset.data('json')
    @rollover = @asset.data('rollover')
    @autostart = @asset.data('autostart')
    @trigger = @asset.data('trigger')

    # Create canvas object
    @canvas = ($ "<canvas></canvas>").insertBefore(@asset)
    # hide original image
    @asset.hide()

    # Copy with and height of image
    @canvas.attr('width', @asset.attr('width'))
    @canvas.attr('height', @asset.attr('height'))

    # Create stage
    @stage = new Stage @canvas.get(0)

    # Load JSON file
    $.ajax
      url: @json,
      dataType: 'json',
      success: @jsonLoaded

  jsonLoaded: (data) =>
    Ticker.addListener @stage

    # create sprite sheet object
    @spriteSheet = new SpriteSheet data

    @assetAnimation = new BitmapAnimation @spriteSheet
    @assetAnimation.x = @width
    @stage.addChild @assetAnimation

    # if autoplay is set, start playing
    if @autostart
      @assetAnimation.play()
    else
      @assetAnimation.gotoAndStop(@assetAnimation.spriteSheet._numFrames - 1)

    # when animation is done, stop on last frame
    @assetAnimation.onAnimationEnd = =>
      @assetAnimation.gotoAndStop(@assetAnimation.spriteSheet._numFrames - 1)

    # enable rollover behavior
    if @rollover
      el = @canvas
      # get trigger if needed (provided in image tag)
      el = ($ @trigger) if @trigger

      el.mouseenter (e) => @assetAnimation.gotoAndPlay(0)

window.initializeSpriteAnimations = =>
  # Check if browser has canvas support
  if Modernizr.canvas
    # Set animations to 30 frames per second
    Ticker.setFPS 30

    # initialize SpriteSheetAnimator for all assets with the `data-animate` attribute
    new SpriteSheetAnimator ($ asset) for asset in ($ "[data-animate='true']")


($ document).ready -> window.initializeSpriteAnimations()

# support for Rails Turbo links
$(window).bind 'page:change', -> window.initializeSpriteAnimations()
