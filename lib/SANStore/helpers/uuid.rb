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

require "uuidtools"

# Extendes the {UUIDTools::UUID} class, adding the ability to
# generate sequential UUID's
class UUIDTools::UUID
  
  # Increments the internal UUID representation, returning a
  # new UUID that is different from, but greater, than the 
  # current sequence number
  def next
    next_uuid = self.to_i
    next_uuid += 1
    
    # Return the newly created UUID
    return UUIDTools::UUID::parse_int(next_uuid)
  end
  
end
