#!/usr/bin/env ruby

require 'rubygame'
include Rubygame

class Game

  def initialize
    @screen = Screen.new([400,400], 0)
    @screen.title = "Reversipede"
    @event_queue = EventQueue.new
    @event_queue.enable_new_style_events
  end

  def start
    while(!@game_quitting)
      self.tick
    end
  end

  def tick
    handle_input
  end

  private
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
end

game = Game.new
game.start
