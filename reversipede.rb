#!/usr/bin/env ruby

require 'rubygame'
include Rubygame

class Game

  def initialize
    @resolution = [400,400]
    @screen = Screen.new(@resolution, 0)
    @screen.title = "Reversipede"
    @event_queue = EventQueue.new
    @event_queue.enable_new_style_events
    @clock = Clock.new
    @clock.target_framerate = 30
    @scale = 16
    @grid_resolution = 20
    @player = Player.new([176, 16], @scale)
  end

  def run
    create_entities
    loop do
      handle_input
      update
      draw
      @screen.update
      @clock.tick
    end
  end

  private
  def create_entities
  end

  def draw_background
    pos  = [@scale, @scale]
    size = [@scale * @grid_resolution, @scale * @grid_resolution]
    @screen.draw_box_s(pos, size, [0x00, 0x00, 0x00])
    @screen.draw_box(pos, size, [0xff, 0xff, 0xff])
  end

  def handle_input
    @event_queue.each do |event|
      case event
      when Events::KeyPressed
        if event.key == :escape
          Rubygame.quit
          exit
        elsif event.key == :up or :down or :left or :right
          @player.on_press event.key
        end
      when Events::KeyReleased
        if event.key == :up or :down or :left or :right
          @player.on_release event.key
        end
      end
    end
  end

  def update
    @player.update
  end

  def draw
    draw_background
    @player.draw(@screen)
  end
end

module Entity

  include Sprites::Sprite

  def initialize(pos, image)
    super()
    @image = image
    @rect = @image.make_rect
    @rect.topleft = pos
  end 
end

class Player

  class Segment
    include Entity
  end

  def initialize(pos, scale)
    @sprite_head = Surface.load("assets/CentiHead.png")
    @sprite_body = Surface.load("assets/CentiBody.png")
    @length = 8
    @head = Segment.new(pos, @sprite_head)
    @segments = []
    @direction = Hash.new
    @moving = false
    @speed = 5
    @scale = scale
    for i in 1..@length do
      @segments << Segment.new([pos[0] - (@scale * i), pos[1]], @sprite_body)
    end
  end

  def on_press(args)
    @direction[args] = true
    @moving = true
  end

  def on_release(args)
    @direction[args] = false
    @moving = false
  end

  def update
    if @moving
      last_pos = @head.rect

      @head.rect.move!(0, -@speed) if @direction[:up]
      @head.rect.move!(0, @speed) if @direction[:down]
      @head.rect.move!(@speed, 0) if @direction[:right]
      @head.rect.move!(-@speed, 0) if @direction[:left]

      puts last_pos

      @segments.each do |segment|
        segment.rect = last_pos
        #segment.rect.move!(0, -@speed) if @direction[:up]
        #segment.rect.move!(0, @speed) if @direction[:down]
        #segment.rect.move!(@speed, 0) if @direction[:right]
        #segment.rect.move!(-@speed, 0) if @direction[:left]
      end
    end
    #puts "Updating! #{@moving}"
    #next_pos = @head.rect
    #puts next_pos
    #@head.rect.move!(0, -@speed) if @direction[:up]
    #@head.rect.move!(0, @speed) if @direction[:down]
    #@head.rect.move!(@speed, 0) if @direction[:right]
    #@head.rect.move!(-@speed, 0) if @direction[:left]
    #if @moving
    #  @segments.each do |segment|
    #    current_pos = segment.rect
    #    segment.rect = next_pos
    #    next_pos = current_pos
    #  end
    #end
  end

  def draw(screen)
    @head.draw(screen)
    @segments.each do |segment|
      segment.draw(screen)
    end
  end
end

game = Game.new
game.run
