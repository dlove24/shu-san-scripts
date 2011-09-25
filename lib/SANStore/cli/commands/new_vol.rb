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

# Use the Socket API to get the first IPv4 address
require "socket"

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
  class NewVol < Cri::Command

    # The name of the sub-command (as it appears in the command line app)
    def name
      'new_vol'
    end

    # The aliases this sub-command is known by
    def aliases
      [
        "new", "add", "add_vol"
      ]
    end

    # A short help text describing the purpose of this command
    def short_desc
      'Create a new iSCSI volume in the SAN volume store.'
    end

    # A longer description, detailing both the purpose and the
    # use of this command
    def long_desc
      'By default, this command creates a 20G ZFS volume, and marks it for ' +
      'sharing as an iSCSI target on the local network.' + "\n\n" +
      'Warning: By default this commands sets up the iSCSI target with NO ' +
      'security. This is fine for testing and use in the labs, but obviously ' +
      'is not ideal if you care about the data stored on this new volume...'
    end

    # Show the user the basic syntax of this command
    def usage
      "store new_volume [--volume-store ZFS_PATH][--name GUID] [--size INTEGER]"
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

      # Look at the options, and if we don't find any (or some are
      # missing), set them to the default values
      if options[:volume_store].nil? or options[:volume_store].empty? then
        volume_store = "store/volumes"
        options[:volume_store] = volume_store
      end
      
      if options[:name].nil? or options[:name].empty? then
        name = UUIDTools::UUID.timestamp_create
        options[:name] = name.to_s
      end
      
      if options[:size].nil? or options[:size].empty? then
        size = "20G" 
        options[:size] = size
      end
      
      SANStore::CLI::Logger.instance.log_level(:low, :info, "Using #{options[:name]} as the volume identifier")

      # Ask for a new volume
      ZFS.new_volume(options[:volume_store] + "/" + options[:name], options[:size]) 

      # Set the volume up as an iSCSI target
      target_name = COMStar.new_target(options[:volume_store] + "/" + options[:name], options[:name])

      # Tell the caller what the new volume name is
      text = "\n"
      text << "A new iSCSI target has been created with the following properties\n"
      text << "\n" 
      text << sprintf("    %-25s %s\n", ANSI.red{ "Name:" }, target_name.wrap_and_indent(78, 20).lstrip)
      text << sprintf("    %-25s %s\n", ANSI.red{ "IPv4 Address:" }, Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3])
      text << "\n" 

      puts text
    end

  end

end
