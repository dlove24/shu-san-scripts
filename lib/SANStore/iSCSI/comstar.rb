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
    SANStore::CLI::Logger.instance.log_level(:low, :create, "New SCSI block device at /dev/zvol/rdsk/#{volume_path}")
    disk_target = %x[sbdadm create-lu /dev/zvol/rdsk/#{volume_path}]

    # Get the GUID of the new disk target from the output of the
    # target creation command
    guid = disk_target.split(/$/)[4].split[0]
    SANStore::CLI::Logger.instance.log_level(:low, :info, "Using #{guid} as the logical unit identifier")
   
    # Modify the just created logical unit to include the path of the
    # volume backing it. This makes it much easier to get rid of the
    # relevant volume later
    SANStore::CLI::Logger.instance.log_level(:low, :update, "Storing the volume GUID as the logical unit alias")
    modify_lu = %x[stmfadm modify-lu --lu-prop alias=#{File.basename(volume_path)} #{guid}]

    # Link the new disk target to the iSCSI framework
    SANStore::CLI::Logger.instance.log_level(:low, :update, "Attaching logical unit #{guid} into the iSCSI framework")
    vol_frame = %x[stmfadm add-view #{guid}]

    # Finally create the target...
    SANStore::CLI::Logger.instance.log_level(:low, :create, "iSCSI block target")
    target = %x[itadm create-target]

    #... and return the name to the caller
    target_name = target.split[1]
  end
  
  # Delete an iSCSI target
  def self.delete_target(target_name)
    
    # Delete the target (and force any clients off the soon to die share)
    SANStore::CLI::Logger.instance.log_level(:low, :warning, "Closing all sessions for #{target_name}")
    target = %x[itadm delete-target -f #{target_name}]
    
    # Create a new disk target for the ZFS volume
    SANStore::CLI::Logger.instance.log_level(:low, :create, "New SCSI block device at /dev/zvol/rdsk/#{volume_path}")
    disk_target = %x[sbdadm create-lu /dev/zvol/rdsk/#{volume_path}]

    # Get the GUID of the new disk target from the output of the
    # target creation command
    guid = disk_target.split(/$/)[4].split[0]
    SANStore::CLI::Logger.instance.log_level(:low, :info, "Using #{guid} as the block device identifier")
    
    # Link the new disk target to the iSCSI framework
    SANStore::CLI::Logger.instance.log_level(:low, :update, "Attaching #{guid} into the iSCSI framework")
    vol_frame = %x[stmfadm add-view #{guid}]

    

    #... and return the name to the caller
    target_name = target.split[1]
  end
  
  # List the current iSCSI targets defined on this host
  def self.list_vols
    raw_list = %x[itadm list-target]
    
    # Create a hash for the final list of targets
    target_list = Array.new
    
    # Run through the raw list of targets
    target_array = raw_list.split(/$/)
    target_array.delete_at(0)
    
    target_array.each{|row|
      row_fragments = row.split
      row_hash = Hash.new
      
      row_hash[:name] = row_fragments[0]
      row_hash[:state] = row_fragments[1]
      row_hash[:sessions] = row_fragments[2]
     
      target_list << row_hash
    }
    
    # return the list to the caller
    return target_list
  end

end
  
