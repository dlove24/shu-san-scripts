### Copyright (c) 2009 Denis Defreyne, 2010-2011 David Love
###
### Permission to use, copy, modify, and/or distribute this software for 
### any purpose with or without fee is hereby granted, provided that the 
### above copyright notice and this permission notice appear in all copies.
###
### THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES 
### WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF 
### MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR 
### ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
### WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
### ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF 
### OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
###

module SANStore::CLI::Commands

  # @author Denis Defreyne
  # @author David Love
  #
  # The +help+ command show the user a brief summary of the available
  # sub-commands, and the short description of each of those commands.
  #
  # Further help is available to the user, if one of the sub-commands
  # is named as an argument to this command. In that case, the longer
  # help for the command is displayed.
  #
  # @note This class is merely a helper class: the actual text, options
  #   and other details are drawn directly from the source code of those
  #   commands. In the execution of this command, we rely on the +cri+
  #   and +cli+ libraries to do the hard work of actually processing the
  #   sub-commands.
  class Help < Cri::Command

    # The name of the sub-command (as it appears in the command line app)
    def name
      'help'
    end

    # The aliases this sub-command is known by
    def aliases
      []
    end

    # A short help text describing the purpose of this command
    def short_desc
      'Show help for a command'
    end

    # A longer description, detailing both the purpose and the
    # use of this command
    def long_desc
      'Show help for the given command, or show general help. When no ' +
      'command is given, a list of available commands is displayed, as ' +
      'well as a list of global command-line options. When a command is ' +
      'given, a command description as well as command-specific ' +
      'command-line options are shown.'
    end

    # Show the user the basic syntax of this command
    def usage
      "store help [command]"
    end

    # Execute the command
    def run(options, arguments)
      # Check arguments
      if arguments.size > 1
        $stderr.puts "usage: #{usage}"
        exit 1
      end

      if arguments.length == 0
        # Build help text
        text = ''

        # Add title
        text << "A command-line tool for managing iSCSI targets on OpenSolaris.\n"

        # Add available commands
        text << "\n"
        text << "Available commands:\n"
        text << "\n"
        @base.commands.sort.each do |command|
          text << sprintf("    %-20s %s\n", command.name, command.short_desc)
        end

        # Add global options
        text << "\n"
        text << "Global options:\n"
        text << "\n"
        @base.global_option_definitions.sort { |x,y| x[:long] <=> y[:long] }.each do |opt_def|
          text << sprintf("    -%1s --%-15s %s\n", opt_def[:short], opt_def[:long], opt_def[:desc])
        end

        # Display text
        puts text
      elsif arguments.length == 1
        command = @base.command_named(arguments[0])
        puts command.help
      end
    end

  end

end
