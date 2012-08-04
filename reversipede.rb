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
    @player = Player.new([1, 1], [0xff, 0xff, 0xff])
  end

  def start
    create_grid
    while(!@game_quitting)
      tick
    end
  end

  private
  def tick
    handle_input
    draw
    @screen.update
  end

  def handle_input
    event = @event_queue.wait
    p event
    case event
    when Events::KeyPressed
      if event.key == :escape
        @game_quitting = true
      elsif event.key == :up or :down or :left or :right
        @player.move event.key
      end
    end
  end

  def create_grid
    @tiles = []
    for x in 1..@grid_resolution do
      for y in 1..@grid_resolution do
        @tiles << Tile.new([x, y], [0x0c*x, 0xff, 0x0c*y])
      end
    end
    puts @tiles
  end

  def draw
    @tiles.each do |tile|
      tile_position = tile.pos.collect {|pos| (pos * @scale) }
      tile_size     = tile.pos.collect {|pos| (pos * @scale) + @scale }
      @screen.draw_box_s(tile_position, tile_size, tile.color)
    end
    player_position = @player.pos.collect {|pos| (pos * @scale) }
    player_size     = @player.pos.collect {|pos| (pos * @scale) + @scale }
    @screen.draw_box_s(player_position, player_size, @player.color)
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

class Player < Tile

  def move(args)
    case args
    when :up
      @pos[1] -= 1
    when :down
      @pos[1] += 1
    when :left
      @pos[0] -= 1
    when :right
      @pos[0] += 1
    end
  end
end

game = Game.new
game.start
