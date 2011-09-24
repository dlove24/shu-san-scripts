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

# @author Denis Defreyne
# @author David Love
#
# The +CLI+ module acts as the gathering place for all the gloabl options
# and the sub-commands which the +SANStore+ command can deal with. 
# Sub-commands are themselves defined in the {SANStore::CLI::Commands} 
# module 
module SANStore::CLI

  # @author Denis Defreyne
  # @author David Love
  #
  # Details the global options applicable to all commands, and the code necessary
  # to process those options. Each sub-command also needs to be registered with 
  # this class for it to work: strange things will happen if the sub-command is
  # not set-up here!
  #
  # When creating a new sub-command, the constructor for that sub-command needs
  # to be added to the {Base#initialize} function of *this* class as well. Be sure to 
  # also add the path to the file where the sub-command is defined to the file 
  # +lib/SANStore/cli/commands.rb+, otherwise you will get warnings of unknown
  # classes.
  class Base < Cri::Base

    # Instantiates the sub-commands by creating a single reference to each
    # known sub-command.
    # 
    # @note This means that if your sub-command is not in this constructor
    #   it *will not* be found, and *will not* appear as a valid sub-command.
    #   If something is missing from the 'help' command, check this method! 
    def initialize
      super('SANStore')

      # Add help command
      self.help_command = SANStore::CLI::Commands::Help.new
      add_command(self.help_command)

      # Add other commands
      add_command(SANStore::CLI::Commands::DeleteVol.new)
      add_command(SANStore::CLI::Commands::ListVols.new)
      add_command(SANStore::CLI::Commands::NewVol.new)
    end

    # Returns the list of global option definitionss.
    def global_option_definitions
      [
        {
          :long => 'help', :short => 'h', :argument => :forbidden,
          :desc => 'show this help message and quit'
        },
        {
          :long => 'no-color', :short => 'C', :argument => :forbidden,
          :desc => 'disable color'
        },
        {
          :long => 'version', :short => 'v', :argument => :forbidden,
          :desc => 'show version information and quit'
        },
        {
          :long => 'verbose', :short => 'V', :argument => :forbidden,
          :desc => 'make store command output more detailed'
        }
      ]
    end

    # Process the global options, and set/change the application state from them
    def handle_option(option)
      # Handle version option
      if option == :version
        puts "SANStore Bootstrap Client #{SANStore::VERSION} (c) 2011 David Love."
        puts "Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) running on #{RUBY_PLATFORM}"
        exit 0
      # Handle verbose option
      elsif option == :verbose
        SANStore::CLI::Logger.instance.level = :low
      # Handle no-color option
      elsif option == :'no-color'
        SANStore::CLI::Logger.instance.color = false
      # Handle help option
      elsif option == :help
        show_help
        exit 0
      end
    end

  end

end
