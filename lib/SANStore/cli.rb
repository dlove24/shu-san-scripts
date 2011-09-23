### Copyright (c) 2009 Denis Defreyne, 2010-2011 David Love
###
### Permission to use, copy, modify, and/or distribute this software for 
### any purpose with or without fee is hereby granted, provided that the 
### above copyright notice and this permission notice appear in all copies.
###
### THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES 
### WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF 
### MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR 
### ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
### WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
### ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF 
### OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
###

require 'rubygems'

# Load command line handling library
require 'cri'

# Install module for command line
# interface
module SANStore:CLI
end

# Load the command line handling modules
require 'SANStore/cli/logger'
require 'SANStore/cli/commands'
require 'SANStore/cli/base'
