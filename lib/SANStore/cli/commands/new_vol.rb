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


module WhiteCloth::CLI::Commands

  # @author David Love
  #
  # The +bootstrap+ command prepared the basic WhiteCloth realms (if 
  # needed), and then links the current host to those realms. The basic
  # realms consists of
  #
  # +Realm 0+: *Namespace*. All the named realms stored in this domain.
  # 
  # +Realm 1+: *Realm Handlers*. The basic gateways needed to create/store/update
  # other realms.
  # 
  # +Realm 5+: *Realm Code*. Libraries and other code which the realm handlers
  # should use by preference when conducting operations on the realms.
  #
  # If the IP address of a server (or a server name) is given to as an argument
  # to this command, then we will use that IP address (name) for as the WhiteCloth
  # realm server to contact. Otherwise we will look for the same data from the file
  # +/etc/whitecloth.conf+: aborting if the file cannot be found.
  #
  # Once we have made contact with the server, we look at the basic realms listed
  # above, and attempt to ensure they can be found. If not, an attempt is made to
  # create the basic realms: aborting if this attempt fails.
  #
  # Finally, once everything has been set-up, we upload the core realm code (or 
  # update the existing code)
  class Bootstrap < Cri::Command

    # The name of the sub-command (as it appears in the command line app)
    def name
      'bootstrap'
    end

    # The aliases this sub-command is known by
    def aliases
      []
    end

    # A short help text describing the purpose of this command
    def short_desc
      'Create a link between this host and the whitecloth servers.'
    end

    # A longer description, detailing both the purpose and the
    # use of this command
    def long_desc
      'Look for the specified server, adding the data required to link the ' +
      'current host to that server. If the found server has not been set-up ' +
      'then this command also performs the setup of the base realms as well. '
    end

    # Show the user the basic syntax of this command
    def usage
      "whitecloth bootstrap [-s server]"
    end
    
    # Define the options for this command
    def option_definitions
      [
        { :short => 's', :long => 'server', :argument => :optional }
      ]
    end

    # Execute the command
    def run(options, arguments)
      
      # The first thing we need to do is to find the relevant server. So we 
      # check the options and see if they can help
      unless options[:server].nil? or options[:server].empty? then
        #
      else
      
        # The user has not specified a server, so we will attempt to get one
        # from the system configuration
        if File.exists?("/etc/whitecloth.conf") then
          #
        
        # Everything has failed, so we abort        
        else
          WhiteCloth::CLI::Logger.instance.log_level(:high, :error, "Cannot locate a WhiteCloth server. Either specify the server to connect to using the 'server' option, or create an appropriate configuration file.")
        end
      end  
    end

  end

end
