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

# Defines a class capable of manipulating ZFS volumes. This classes uses
# the standard command line tools (+zfs+ and +zpool+), not the C API.
class ZFS
  
  # Create a new volume, at the specified location and of the specified
  # size.
  #
  # NOTE: This command currently only supports the creation of sparse
  # volumes. If you really need pre-allocated volumes for some reason,
  # this command needs to be extended
  def self.new_volume(volume_path, volume_size)
    
    # Create the volume
    cmd = %x[zfs create -s -V #{volume_size} #{volume_path}]
    
    # Mark it as an iSCSI target
    cmd = %x[zfs set shareiscsi=on #{volume_path}]
  end

end
  
