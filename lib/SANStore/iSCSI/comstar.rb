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
  def self.new_target(volume_path, volume_guid)
    
    # Create a new disk target for the ZFS volume
    SANStore::CLI::Logger.instance.log_level(:low, :create, "New SCSI block device at /dev/zvol/rdsk/#{volume_path}")
    disk_target = %x[sbdadm create-lu /dev/zvol/rdsk/#{volume_path}]

    # Get the ID of the new disk target from the output of the
    # target creation command
    id = disk_target.split(/$/)[4].split[0]
    SANStore::CLI::Logger.instance.log_level(:low, :info, "Using #{id} as the logical unit identifier")
   
    # Modify the just created logical unit to include the path of the
    # volume backing it. This makes it much easier to get rid of the
    # relevant volume later
    SANStore::CLI::Logger.instance.log_level(:low, :update, "Storing the volume GUID as the logical unit alias")
    modify_lu = %x[stmfadm modify-lu --lu-prop alias=#{File.basename(volume_path)} #{volume_guid}]

    # Link the new disk target to the iSCSI framework
    SANStore::CLI::Logger.instance.log_level(:low, :update, "Attaching logical unit #{id} into the iSCSI framework")
    vol_frame = %x[stmfadm add-view #{id}]

    # Create the target...
    SANStore::CLI::Logger.instance.log_level(:low, :create, "iSCSI block target")
    target = %x[itadm create-target]
    target_name = target.split[1]
    
    # Store the volume GUID as the alias so we can find it later
    SANStore::CLI::Logger.instance.log_level(:low, :update, "Storing the volume GUID as the iSCSI target alias")
    %x[itadm modify-target --alias #{id} #{target_name}]
    
    # Return the target name to the caller
    return target_name
  end
  
  # Delete an iSCSI target. This returns the name of the underlying ZFS store in case the
  # caller wants to delete that as well
  def self.delete_target(target_name)
    
    # Before we kill the target, get the store GUID so that we can clean up properly
    target_map = self.TargetToGUIDMap
    target_guid = target_map[target_name]
    
    # Delete the target (and force any clients off the soon to die share)
    SANStore::CLI::Logger.instance.log_level(:low, :warning, "Closing all sessions for #{target_name}")
    target = %x[itadm delete-target -f #{target_name}]
    
    # Get the maps of the LU identifers to the underlying stores
    vol_map = self.LUToVolMap
    
    # Look for the store with the GUID of the target we have just deleted
    vol_name = ""
    vol_store = ""
    vol_map.each{|key, value|
      if value[:guid] == target_guid then
        # We have found the right entry, so update the name of the
        # volume store and the name of the volume backing it
        vol_name = key
        vol_store = value[:data_file]
        break
      end
    }
    
    # Abort if we can't find what we are looking for
    if vol_name.empty? or vol_store.empty? then
      SANStore::CLI::Logger.instance.log_level(:high, :error, "Could not delete the file system for the iSCSI target. The target has been removed, but the file system is still around!")
      return ""
    end
    
    # Now unlink the SCSI logical unit, so that we can free the underlying ZFS volume
    SANStore::CLI::Logger.instance.log_level(:low, :delete, "Removing logical units associated with the deleted target")
    disk_target = %x[sbdadm delete-lu vol_name]
    
    # The file store is now ready for deletion. We will tell the caller what to remove, but we
    # don't actually do this ourselves (file systems are someone elses problem)
    return vol_store
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
  
  # Walks over the list of iSCSI targets, looking for the store GUID (stored in the target alias field). 
  # Returns a map of the target names and associated aliases
  def self.TargetToGUIDMap
    
    # Get the raw map
    SANStore::CLI::Logger.instance.log_level(:low, :info, "Finding the GUID's associated with iSCSI targets")
    raw_list = %x[stmfadm list-target -v]
    raw_map = raw_list.split(/$/)
    
    # Create a hash from this map
    map_hash = Hash.new
    map_index = nil
    map_entry = nil
    raw_index = 0
    
    while index < raw_map.length do
      # Is this line the start of a new target entry
      if raw_map[raw_index].index(/Target\:/) then
        
        # Store the old entry
        unless map_entry.nil? then
          map_hash[map_index] = map_entry
        end
        
        # Create a new map entry
        map_entry = String.new        
        map_index = raw_map[raw_index].partition(/Target\:/)[2]
        puts map_index
        
      else
        
        # Split the line to find the key and value
        entry = raw_map[raw_index].partition(/\s?\:\s/)
        
        case entry[0].strip
          when "Alias"
            map_entry = entry[2]
        end
        
      end
    end
    
    # Return the hash map
    puts map_hash
    return map_hash
  
  end
  
  # Walks over the list of Logical Units, working out where the ZFS volume
  # backing the LU is. Returns a hash, giving the correct backing store for
  # each LU
  def self.LUToVolMap
    
    # Get the raw map
    SANStore::CLI::Logger.instance.log_level(:low, :info, "Finding the backing stores for the logical units")
    raw_list = %x[stmfadm list-lu -v]
    raw_map = raw_list.split(/$/)
    
    # Create a hash from this map
    map_hash = Hash.new
    map_index = nil
    map_entry = nil
    raw_index = 0
    
    while index < raw_map.length do
      # Is this line the start of a new LU entry
      if raw_map[raw_index].index(/LU Name\:/) then
        
        # Store the old entry
        unless map_entry.nil? then
          map_hash[map_index] = map_entry
        end
        
        # Create a new map entry
        map_entry = Hash.new        
        map_index = raw_map[raw_index].partition(/LU Name\:/)[2]
        puts map_index
        
      else
        
        # Split the line to find the key and value
        entry = raw_map[raw_index].partition(/\s?\:\s/)
        
        case entry[0].strip
          when "Alias"
            map_entry[:guid] = entry[2]
          when "Data File"
            map_entry[:data_file] = entry[2]
        end
        
      end
    end
    
    # Return the hash map
    puts map_hash
    return map_hash
  
  end
  
end
  
