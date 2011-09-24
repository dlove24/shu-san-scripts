# Copyright (c) 2009 Denis Defreyne, 2010-2011 David Love
#
# Permission to use, copy, modify, and/or distribute this software for 
# any purpose with or without fee is hereby granted, provided that the 
# above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES 
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF 
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR 
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF 
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

require 'singleton'
require 'facets'

module SANStore::CLI

  # SANStore::CLI::Logger is a singleton class responsible for generating
  # feedback in the terminal.
  class Logger

    # ANSI console codes (escape sequences) for highlighting particular
    # log outputs.
    ACTION_COLORS = {
      :error          => "\e[1m" + "\e[31m", # bold + red
      :warning        => "\e[1m" + "\e[33m", # bold + yellow
      :info           => "\e[1m" + "\e[32m", # bold + green
      :create         => "\e[1m" + "\e[31m", # bold + red
      :update         => "\e[1m" + "\e[33m", # bold + yellow
      :identical      => "\e[1m" + "\e[32m", # bold + green
    }

    include Singleton

    # The log level, which can be :high, :low or :off (which will log all
    # messages, only high-priority messages, or no messages at all,
    # respectively).
    attr_accessor :level

    # Whether to use color in log messages or not
    attr_accessor :color
    alias_method :color?, :color

    def initialize
      @level = :high
      @color = true
    end

    # Logs a messsage, using appropriate colours to highlight different
    # levels.
    #
    # +level+:: The importance of this action. Can be :high or :low.
    #
    # +action+:: The kind of file action. Can be :create, :update or
    #            :identical.
    #
    # +message+:: The identifier of the item the action was performed on.
    def log_level(level, action, message)
      log(
        level,
        '%s%12s%s:  %s' % [
          color? ? ACTION_COLORS[action.to_sym] : '',
          action.capitalize,
          color? ? "\e[0m" : '',
          message.word_wrap(60).indent(15).lstrip
        ]
      )
    end

    # Logs a message.
    #
    # +level+:: The importance of this message. Can be :high or :low.
    #
    # +message+:: The message to be logged.
    #
    # +io+:: The IO instance to which the message will be written. Defaults to
    #        standard output.
    def log(level, message, io=$stdout)
      # Don't log when logging is disabled
      return if @level == :off

      # Log when level permits it
      io.puts(message) if (@level == :low or @level == level)
    end

  end

end
