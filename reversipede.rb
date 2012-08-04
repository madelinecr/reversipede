#!/usr/bin/env ruby

require 'rubygame'
include Rubygame

screen = Screen.new([400,400], 0)
screen.title = "Reversipede"

event_queue = EventQueue.new
event_queue.enable_new_style_events

while(event = event_queue.wait)
  p event
  case event
  when Events::KeyReleased
    if event.key == :escape
      break
    end
  end
end

class Game

  def initialize
    @screen = Screen.new([400,400], 0)
    screen.title = "Reversipede"
    @event_queue = EventQueue.new
    @event_queue.enable_new_style_events
  end

  def handle_input
    event = event_queue.wait
    p event
    case event
    when Events::KeyReleased
      if event.key == :escape
        break
      end
    end
  end


end
