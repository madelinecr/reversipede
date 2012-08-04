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
    @scale = 16
    @grid_resolution = 20
  end

  def start
    create_grid
    while(!@game_quitting)
      tick
    end
  end

  private
  def create_grid
    @tiles = []
    for x in 1..@grid_resolution do
      for y in 1..@grid_resolution do
        @tiles << Tile.new([x, y], [0x05*x, 0xff, 0x05*y])
      end
    end
    puts @tiles
  end

  def draw_grid
    @tiles.each do |tile|
      tile_position = tile.pos.collect {|pos| pos * @scale }
      tile_size     = tile.pos.collect {|pos| (pos * @scale) + @scale }
      @screen.draw_box_s(tile_position, tile_size, tile.color)
    end
  end

  def tick
    handle_input
    draw_grid
    #draw_box
    @screen.update
  end

  def handle_input
    event = @event_queue.wait
    p event
    case event
    when Events::KeyReleased
      if event.key == :escape
        @game_quitting = true
      end
    end
  end

  def draw_box
    @screen.draw_box_s([10,30], @resolution, [0xc0, 0xff, 0xc0])
  end
end

class Tile

  attr_accessor :pos, :color

  def initialize(pos, color)
    @pos = pos
    @color = color
  end
end

game = Game.new
game.start
