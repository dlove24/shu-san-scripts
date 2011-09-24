# Copyright (c) 2010-2011 David Love
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

# @author David Love

# Defines a class capable of creating iSCSI shares using the new
# COMStar framework. This classes uses the various command line tools, 
# not the C API.
class COMStar
  
  # Create a new, ready to use, iSCSI target. Functionally this is command
  # is equivalent to the old "shareiscsi=on" ZFS volume property.
  def self.new_target(volume_path)
    
    # Create a new disk target for the ZFS volume
    disk_target = %x[sbdadm create-lu /dev/zvol/rdsk/#{volume_path}]

    # Get the GUID of the new disk target from the output of the
    # target creation command
    guid = disk_target.split(/$/)[4].split[0]
    
    # Link the new disk target to the iSCSI framework
    vol_frame = %x[stmfadm add-view #{guid}]

    # Finally create the target...
    target = %x[itadm create-target]

    #... and return the name to the caller
    target_name = target.split[1]
  end

end
  
