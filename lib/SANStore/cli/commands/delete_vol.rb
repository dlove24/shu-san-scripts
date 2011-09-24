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

# Use the ANSI library to report the status to the user
require "ansi/code"

# Use the ZFS library
require "SANStore/zfs/zfs"

# Use the COMStar iSCSI library
require "SANStore/iSCSI/comstar.rb"

module SANStore::CLI::Commands

  # @author David Love
  #
  # The +new_vol+ command adds a new ZFS volume to the specified volume
  # store, and sets it up as an iSCSI target. Defaults are supplied to
  # all arguments, but can be overridden by the user for slightly
  # customised set-up of the volume store. However, the user interface
  # should be kept as simple as possible. 
  class DeleteVol < Cri::Command

    # The name of the sub-command (as it appears in the command line app)
    def name
      'delete_vol'
    end

    # The aliases this sub-command is known by
    def aliases
      [
        "rm", "delete", "rm_vol"
      ]
    end

    # A short help text describing the purpose of this command
    def short_desc
      'Remove the specified target from the iSCSI volume store.'
    end

    # A longer description, detailing both the purpose and the
    # use of this command
    def long_desc
      'This command deletes the specified target from the pool, and ' +
      'unlinks the volume store backing the target. Since the underlying ' +
      'volume store is destroyed, this action is ' + ANSI.bold{ "irreversible" } +
      'and so this command should be used with ' + ANSI.bold{ "great" } + 'care.' +
      "\n\n" +
      'NOTE: Any clients attached to the volume will have their ' +
      'iSCSI session forcibly closed. This may result in the premature ' +
      'death of the client if care is not taken.'
    end

    # Show the user the basic syntax of this command
    def usage
      "store delete_vol SHARE_NAME"
    end
    
    # Define the options for this command
    def option_definitions
      [
        { :short => 'v', :long => 'volume_store', :argument => :optional,
          :desc => 'specifify the ZFS root of the new iSCSI volume. Defaults to "store/volumes".'
        },
        { :short => 'n', :long => 'name', :argument => :optional,
          :desc => 'the name of the new volume. This must be a valid ZFS volume name, and defaults to ' +
            'an RFC 4122 GUID.'
        },
        { :short => 's', :long => 'size', :argument => :optional,
          :desc => 'the size of the new iSCSI volume. Note that while ZFS allows you to change the size ' +
            'of the new volume relatively easily, because the iSCSI initiator sees this volume as a raw ' +
            'device changing the size later may be very easy or very difficult depending on the initiators ' +
            'operating system (and the specific file system being used). In other words, choose with care: ' +
            'by default this command uses a size of 20G, which should be enough for most tasks in the labs.'  
        },
      ]
    end

    # Execute the command
    def run(options, arguments)

      # Check that we have been given a name
      if arguments.size > 1
        SANStore::CLI::Logger.instance.log_level(:high, :error, "You must specify the name of the target to remove")
        exit 1
      end

      # Delete the iSCSI target
      SANStore::CLI::Logger.instance.log_level(:high, :delete, "Removing target #{arguments[0]}")
      COMStar.delete_target(arguments[0])
      
      # Remove the underlying ZFS store
      # ZFS.delete_volume(options[:volume_store] + "/" + options[:name], options[:size])    
    end

  end

end
