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
    @player = Player.new([1, 1], [0xff, 0xff, 0xff])
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
    @tiles = []
    for x in 1..@grid_resolution do
      for y in 1..@grid_resolution do
        @tiles << Tile.new([x, y], [0x0c*x, 0xff, 0x0c*y])
      end
    end
    @tiles << @player
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
    @tiles.each do |tile|
      tile.update
    end
  end

  def draw
    @tiles.each do |tile|
      pos  = tile.scaled_pos(@scale)
      size = tile.scaled_size(@scale) 
      @screen.draw_box_s(pos, size, tile.color)
    end
  end
end

class Tile

  attr_accessor :pos, :color

  def initialize(pos, color)
    @pos = pos
    @color = color
  end

  def scaled_pos(scale)
    pos.collect {|pos| (pos * scale) }
  end

  def scaled_size(scale)
    pos.collect {|pos| (pos * scale) + scale }
  end

  def update
  end
end

class Player < Tile

  def initialize(pos, color)
    super
    @moving = { }
  end

  def on_press(args)
    @moving[args] = true
  end

  def on_release(args)
    @moving[args] = false
  end

  def update
    @pos[1] -= 1 if @moving[:up]
    @pos[1] += 1 if @moving[:down]
    @pos[0] -= 1 if @moving[:left]
    @pos[0] += 1 if @moving[:right]
  end
end

game = Game.new
game.run
