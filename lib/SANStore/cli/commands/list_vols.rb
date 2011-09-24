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

# Volume names are based on RFC 4122 UUIDs
require "uuidtools"

# Use the ZFS library
require "SANStore/zfs/zfs"

# Use the COMStar iSCSI library
require "SANStore/iSCSI/comstar.rb"

module SANStore::CLI::Commands

  # @author David Love
  #
  # The +list_vols+ command show the current iSCSI targets available
  # on this host 
  class ListVol < Cri::Command

    # The name of the sub-command (as it appears in the command line app)
    def name
      'list_vols'
    end

    # The aliases this sub-command is known by
    def aliases
      [
        "list_vol", "list", "ls"
      ]
    end

    # A short help text describing the purpose of this command
    def short_desc
      'Show the currently defined iSCSI targets on this host.'
    end

    # A longer description, detailing both the purpose and the
    # use of this command
    def long_desc
      'Displays a list of valid iSCSI targets, all of which ' +
      'should be available on the local network' + "\n\n"
      'NOTE: Because of the way iSCSI works, this host has no ' +
      'way of knowing what is actually '+ ANSI.bold{ "in" } + ' the volume. So even ' +
      'if a target is defined, this host has no way of knowing if ' +
      'a given initiator can actually ' + ANSI.bold{ "use" } +
      'the contents of this volume. If something appears to be '
      'wrong, check the set-up of the host to make sure it can '
      'actually connect to the targets defined here.' 
    end

    # Show the user the basic syntax of this command
    def usage
      "store list_vols"
    end
    
    # Define the options for this command
    def option_definitions
      [
      ]
    end

    # Execute the command
    def run(options, arguments)

      # Get the list of defined volumes
      volumes = COMStar.list_vols
      
      # Show the list to the caller
      text = String.new
      volumes.each{|target|
        text << << sprintf("%-40s ", target[:name])
        
        if target[:state] == "online" then
          text << << sprintf("%-10s\n", ANSI.green{ target[:state] })
        else
          text << << sprintf("%-10s\n", ANSI.black{ target[:state] })
        end
        
        if target[:sessions].to_i > 0 then
          text << << sprintf("%-10s\n", ANSI.white{ target[:sessions] })
        else
          text << << sprintf("%-10s\n", ANSI.black{ target[:sessions] })
        end
      }
    end

  end

end
