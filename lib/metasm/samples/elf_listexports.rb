#    This file is part of Metasm, the Ruby assembly manipulation suite
#    Copyright (C) 2007 Yoann GUILLOT
#
#    Licence is LGPL, see LICENCE in the top-level directory

# 
# this script takes a list of dll filenames as arguments, and outputs each lib export
# libname, followed by the list of the exported symbol names, in a format usable
# by the Elf class autoimport functionnality (see metasm/os/linux.rb)
#

require 'metasm'

ARGV.each { |f|
	e = Metasm::ELF.decode_file(f)
	next if not e.tag['SONAME']
	puts e.tag['SONAME']
	line = ''
	e.symbols.find_all { |s|
		s.name and s.type == 'FUNC' and s.shndx != 'UNDEF' and s.bind == 'GLOBAL'
	}.map { |s| ' ' << s.name }.sort.each { |s|
		if line.length + s.length >= 160
			puts line
			line = ''
		end
		line << s
	}
	puts line if not line.empty?
}