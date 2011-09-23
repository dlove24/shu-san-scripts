# Copyright (c) 2011 David Love
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
#
# @author David Love
#

module WhiteCloth::CLI::Commands

  # @author David Love
  #
  # Displays a summary of the realm data found in the configured WhiteCloth
  # server.
  class Show < Cri::Command
    
    # The name of the sub-command (as it appears in the command line app)
    def name
      'show-status'
    end

    # The aliases this sub-command is known by
    def aliases
      []
    end

    # A short help text describing the purpose of this command
    def short_desc
      'Create or update information from the network'
    end

    # A longer description, detailing both the purpose and the
    # use of this command
    def long_desc
      "Displays the current state of the evironemnt " +
      "to update the host files (held in the 'hosts' directory). Existing " +
      "information will be updated, and missing information inserted.\n"
    end
    
    # Show the user the basic syntax of this command
    def usage
      "bootstrap show-status"
    end

    # Define the options for this command
    def option_definitions
      []
    end

    # Execute the command
    def run(options, arguments)

      # Load the list of groups
      group_list = YAML::load( File.open("config/groups.yaml"))
      
      # Load the list of networks
      network_list = YAML::load( File.open("config/networks.yaml"))

      # Update the information in each group-network directory
      gn_name_list = Array.new

      network_list.each{|network|
        puts network[1]
        
        net_block = network[1]['ip4-address-block'].to_s

        # Scan this network
        # parser = Nmap::Parser.parsescan("nmap", "-sVC " + net_block)

        puts parser
      }

    end
  
  end

end
