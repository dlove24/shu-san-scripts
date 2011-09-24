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

# @author David Love
#
# The +Commands+ module acts as the gathering place for all the sub-commands 
# which the +store+ command can deal with. Each sub-command defines both 
# the command action, options, and associated help text.
#
# All commands should live under +lib/SANStore/cli/commands+, with the 
# file-name named after the sub-command defined within it. 

module SANStore::CLI::Commands
end

require 'SANStore/cli/commands/help'

require 'SANStore/cli/commands/new_vol'
#require 'SANStore/cli/commands/list_vols'
