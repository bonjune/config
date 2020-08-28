*editing.txt*   Nvim


		  VIM REFERENCE MANUAL    by Bram Moolenaar


Editing files						*edit-files*

                                      Type |gO| to see the table of contents.

==============================================================================
1. Introduction						*edit-intro*

Editing a file with Vim means:

1. reading the file into a buffer
2. changing the buffer with editor commands
3. writing the buffer into a file

							*current-file*
As long as you don't write the buffer, the original file remains unchanged.
If you start editing a file (read a file into the buffer), the file name is
remembered as the "current file name".  This is also known as the name of the
current buffer.  It can be used with "%" on the command line |:_%|.

							*alternate-file*
If there already was a current file name, then that one becomes the alternate
file name.  It can be used with "#" on the command line |:_#| and you can use
the |CTRL-^| command to toggle between the current and the alternate file.
However, the alternate file name is not changed when |:keepalt| is used.
An alternate file name is remembered for each window.

							*:keepalt* *:keepa*
:keepalt {cmd}		Execute {cmd} while keeping the current alternate file
			name.  Note that commands invoked indirectly (e.g.,
			with a function) may still set the alternate file
			name.

All file names are remembered in the buffer list.  When you enter a file name,
for editing (e.g., with ":e filename") or writing (e.g., with ":w filename"),
the file name is added to the list.  You can use the buffer list to remember
which files you edited and to quickly switch from one file to another (e.g.,
to copy text) with the |CTRL-^| command.  First type the number of the file
and then hit CTRL-^.


CTRL-G		or				*CTRL-G* *:f* *:fi* *:file*
:f[ile]			Prints the current file name (as typed, unless ":cd"
			was used), the cursor position (unless the 'ruler'
			option is set), and the file status (readonly,
			modified, read errors, new file).  See the 'shortmess'
			option about how to make this message shorter.

:f[ile]!		like |:file|, but don't truncate the name even when
			'shortmess' indicates this.

{count}CTRL-G		Like CTRL-G, but prints the current file name with
			full path.  If the count is higher than 1 the current
			buffer number is also given.

					*g_CTRL-G* *word-count* *byte-count*
g CTRL-G		Prints the current position of the cursor in five
			ways: Column, Line, Word, Character and Byte.  If the
			number of Characters and Bytes is the same then the
			Character position is omitted.
			If there are characters in the line that take more
			than one position on the screen (<Tab> or special
			character), both the "real" column and the screen
			column are shown, separated with a dash.
			Also see the 'ruler' option and the |wordcount()|
			function.

							*v_g_CTRL-G*
{Visual}g CTRL-G	Similar to "g CTRL-G", but Word, Character, Line, and
			Byte counts for the visually selected region are
			displayed.
			In Blockwise mode, Column count is also shown.  (For
			{Visual} see |Visual-mode|.)

							*:file_f*
:f[ile][!] {name}	Sets the current file name to {name}.  The optional !
			avoids truncating the message, as with |:file|.
			If the buffer did have a name, that name becomes the
			|alternate-file| name.  An unlisted buffer is created
			to hold the old name.
							*:0file*
:0f[ile][!]		Remove the name of the current buffer.  The optional !
			avoids truncating the message, as with |:file|.

:buffers
:files
:ls			List all the currently known file names.  See
			'windows.txt' |:files| |:buffers| |:ls|.

Vim will remember the full path name of a file name that you enter.  In most
cases when the file name is displayed only the name you typed is shown, but
the full path name is being used if you used the ":cd" command |:cd|.

							*home-replace*
If the environment variable $HOME is set, and the file name starts with that
string, it is often displayed with HOME replaced with "~".  This was done to
keep file names short.  When reading or writing files the full name is still
used, the "~" is only used when displaying file names.  When replacing the
file name would result in just "~", "~/" is used instead (to avoid confusion
between options set to $HOME with 'backupext' set to "~").

When writing the buffer, the default is to use the current file name.  Thus
when you give the "ZZ" or ":wq" command, the original file will be
overwritten.  If you do not want this, the buffer can be written into another
file by giving a file name argument to the ":write" command.  For example: >

	vim testfile
	[change the buffer with editor commands]
	:w newfile
	:q

This will create a file "newfile", that is a modified copy of "testfile".
The file "testfile" will remain unchanged.  Anyway, if the 'backup' option is
set, Vim renames or copies the original file before it will be overwritten.
You can use this file if you discover that you need the original file.  See
also the 'patchmode' option.  The name of the backup file is normally the same
as the original file with 'backupext' appended.  The default "~" is a bit
strange to avoid accidentally overwriting existing files.  If you prefer ".bak"
change the 'backupext' option.  The backup file can be placed in another
directory by setting 'backupdir'.

When you started editing without giving a file name, "No File" is displayed in
messages.  If the ":write" command is used with a file name argument, the file
name for the current file is set to that file name.  This only happens when
the 'F' flag is included in 'cpoptions' (by default it is included) |cpo-F|.
This is useful when entering text in an empty buffer and then writing it to a
file.  If 'cpoptions' contains the 'f' flag (by default it is NOT included)
|cpo-f| the file name is set for the ":read file" command.  This is useful
when starting Vim without an argument and then doing ":read file" to start
editing a file.
When the file name was set and 'filetype' is empty the filetype detection
autocommands will be triggered.
							*not-edited*
Because the file name was set without really starting to edit that file, you
are protected from overwriting that file.  This is done by setting the
"notedited" flag.  You can see if this flag is set with the CTRL-G or ":file"
command.  It will include "[Not edited]" when the "notedited" flag is set.
When writing the buffer to the current file name (with ":w!"), the "notedited"
flag is reset.

							*abandon*
Vim remembers whether you have changed the buffer.  You are protected from
losing the changes you made.  If you try to quit without writing, or want to
start editing another file, Vim will refuse this.  In order to overrule this
protection, add a '!' to the command.  The changes will then be lost.  For
example: ":q" will not work if the buffer was changed, but ":q!" will.  To see
whether the buffer was changed use the "CTRL-G" command.  The message includes
the string "[Modified]" if the buffer has been changed, or "+" if the 'm' flag
is in 'shortmess'.

If you want to automatically save the changes without asking, switch on the
'autowriteall' option.  'autowrite' is the associated Vi-compatible option
that does not work for all commands.

If you want to keep the changed buffer without saving it, switch on the
'hidden' option.  See |hidden-buffer|.  Some commands work like this even when
'hidden' is not set, check the help for the command.

==============================================================================
2. Editing a file					*edit-a-file*

							*:e* *:edit* *reload*
:e[dit] [++opt] [+cmd]	Edit the current file.  This is useful to re-edit the
			current file, when it has been changed outside of Vim.
			This fails when changes have been made to the current
			buffer and 'autowriteall' isn't set or the file can't
			be written.
			Also see |++opt| and |+cmd|.

							*:edit!* *discard*
:e[dit]! [++opt] [+cmd]
			Edit the current file always.  Discard any changes to
			the current buffer.  This is useful if you want to
			start all over again.
			Also see |++opt| and |+cmd|.

							*:edit_f*
:e[dit] [++opt] [+cmd] {file}
			Edit {file}.
			This fails when changes have been made to the current
			buffer, unless 'hidden' is set or 'autowriteall' is
			set and the file can be written.
			Also see |++opt| and |+cmd|.

							*:edit!_f*
:e[dit]! [++opt] [+cmd] {file}
			Edit {file} always.  Discard any changes to the
			current buffer.
			Also see |++opt| and |+cmd|.

:e[dit] [++opt] [+cmd] #[count]
			Edit the [count]th buffer (as shown by |:files|).
			This command does the same as [count] CTRL-^.  But ":e
			#" doesn't work if the alternate buffer doesn't have a
			file name, while CTRL-^ still works then.
			Also see |++opt| and |+cmd|.

							*:ene* *:enew*
:ene[w]			Edit a new, unnamed buffer.  This fails when changes
			have been made to the current buffer, unless 'hidden'
			is set or 'autowriteall' is set and the file can be
			written.
			If 'fileformats' is not empty, the first format given
			will be used for the new buffer.  If 'fileformats' is
			empty, the 'fileformat' of the current buffer is used.

							*:ene!* *:enew!*
:ene[w]!		Edit a new, unnamed buffer.  Discard any changes to
			the current buffer.
			Set 'fileformat' like |:enew|.

							*:fin* *:find*
:fin[d][!] [++opt] [+cmd] {file}
			Find {file} in 'path' and then |:edit| it.

:{count}fin[d][!] [++opt] [+cmd] {file}
			Just like ":find", but use the {count} match in
			'path'.  Thus ":2find file" will find the second
			"file" found in 'path'.  When there are fewer matches
			for the file in 'path' than asked for, you get an
			error message.

							*:ex*
:ex [++opt] [+cmd] [file]
			Same as |:edit|.

							*:vi* *:visual*
:vi[sual][!] [++opt] [+cmd] [file]
			When used in Ex mode: Leave |Ex-mode|, go back to
			Normal mode.  Otherwise same as |:edit|.

							*:vie* *:view*
:vie[w][!] [++opt] [+cmd] file
			When used in Ex mode: Leave |Ex-mode|, go back to
			Normal mode.  Otherwise same as |:edit|, but set
			'readonly' option for this buffer.

							*CTRL-^* *CTRL-6*
CTRL-^			Edit the alternate file.  Mostly the alternate file is
			the previously edited file.  This is a quick way to
			toggle between two files.  It is equivalent to ":e #",
			except that it also works when there is no file name.

			If the 'autowrite' or 'autowriteall' option is on and
			the buffer was changed, write it.
			Mostly the ^ character is positioned on the 6 key,
			pressing CTRL and 6 then gets you what we call CTRL-^.
			But on some non-US keyboards CTRL-^ is produced in
			another way.

{count}CTRL-^		Edit [count]th file in the buffer list (equivalent to
			":e #[count]").  This is a quick way to switch between
			files.
			See |CTRL-^| above for further details.

							*gf* *E446* *E447*
[count]gf		Edit the file whose name is under or after the cursor.
			Mnemonic: "goto file".
			Uses the 'isfname' option to find out which characters
			are supposed to be in a file name.  Trailing
			punctuation characters ".,:;!" are ignored. Escaped
			spaces "\ " are reduced to a single space.
			Uses the 'path' option as a list of directory names to
			look for the file.  See the 'path' option for details
			about relative directories and wildcards.
			Uses the 'suffixesadd' option to check for file names
			with a suffix added.
			If the file can't be found, 'includeexpr' is used to
			modify the name and another attempt is done.
			If a [count] is given, the count'th file that is found
			in the 'path' is edited.
			This command fails if Vim refuses to |abandon| the
			current file.
			If you want to edit the file in a new window use
			|CTRL-W_CTRL-F|.
			If you do want to edit a new file, use: >
				:e <cfile>
<			To make gf always work like that: >
				:map gf :e <cfile><CR>
<			If the name is a hypertext link, that looks like
			"type://machine/path", you need the |netrw| plugin.
			For Unix the '~' character is expanded, like in
			"~user/file".  Environment variables are expanded too
			|expand-env|.

							*v_gf*
{Visual}[count]gf	Same as "gf", but the highlighted text is used as the
			name of the file to edit.  'isfname' is ignored.
			Leading blanks are skipped, otherwise all blanks and
			special characters are included in the file name.
			(For {Visual} see |Visual-mode|.)

							*gF*
[count]gF		Same as "gf", except if a number follows the file
			name, then the cursor is positioned on that line in
			the file. The file name and the number must be
			separated by a non-filename (see 'isfname') and
			non-numeric character. White space between the
			filename, the separator and the number are ignored.
			Examples:
				eval.c:10 ~
				eval.c @ 20 ~
				eval.c (30) ~
				eval.c 40 ~

							*v_gF*
{Visual}[count]gF	Same as "v_gf".

These commands are used to start editing a single file.  This means that the
file is read into the buffer and the current file name is set.  The file that
is opened depends on the current directory, see |:cd|.

See |read-messages| for an explanation of the message that is given after the
file has been read.

You can use the ":e!" command if you messed up the buffer and want to start
all over again.  The ":e" command is only useful if you have changed the
current file name.

							*:filename* *{file}*
Besides the things mentioned here, more special items for where a filename is
expected are mentioned at |cmdline-special|.

Note for systems other than Unix: When using a command that accepts a single
file name (like ":edit file") spaces in the file name are allowed, but
trailing spaces are ignored.  This is useful on systems that regularly embed
spaces in file names (like MS-Windows).  Example: The command ":e   Long File
Name " will edit the file "Long File Name".  When using a command that accepts
more than one file name (like ":next file1 file2") embedded spaces must be
escaped with a backslash.

						*wildcard* *wildcards*
Wildcards in {file} are expanded, but as with file completion, 'wildignore'
and 'suffixes' apply.  Which wildcards are supported depends on the system.
These are the common ones:
	?	matches one character
	*	matches anything, including nothing
	**	matches anything, including nothing, recurses into directories
	[abc]	match 'a', 'b' or 'c'

To avoid the special meaning of the wildcards prepend a backslash.  However,
on MS-Windows the backslash is a path separator and "path\[abc]" is still seen
as a wildcard when "[" is in the 'isfname' option.  A simple way to avoid this
is to use "path\[[]abc]", this matches the file "path\[abc]".

					*starstar-wildcard*
Expanding "**" is possible on Unix, Win32, Mac OS/X and a few other systems.
This allows searching a directory tree.  This goes up to 100 directories deep.
Note there are some commands where this works slightly differently, see
|file-searching|.
Example: >
	:n **/*.txt
Finds files:
	aaa.txt ~
	subdir/bbb.txt ~
	a/b/c/d/ccc.txt ~
When non-wildcard characters are used right before or after "**" these are
only matched in the top directory.  They are not used for directories further
down in the tree. For example: >
	:n /usr/inc**/types.h
Finds files:
	/usr/include/types.h ~
	/usr/include/sys/types.h ~
	/usr/inc/old/types.h ~
Note that the path with "/sys" is included because it does not need to match
"/inc".  Thus it's like matching "/usr/inc*/*/*...", not
"/usr/inc*/inc*/inc*".

					*backtick-expansion* *`-expansion*
On Unix and a few other systems you can also use backticks for the file name
argument, for example: >
	:next `find . -name ver\\*.c -print`
	:view `ls -t *.patch  \| head -n1`
Vim will run the command in backticks using the 'shell' and use the standard
output as argument for the given Vim command (error messages from the shell
command will be discarded).
To see what shell command Vim is running, set the 'verbose' option to 4. When
the shell command returns a non-zero exit code, an error message will be
displayed and the Vim command will be aborted. To avoid this make the shell
always return zero like so: >
       :next `find . -name ver\\*.c -print \|\| true`

The backslashes before the star are required to prevent the shell from
expanding "ver*.c" prior to execution of the find program.  The backslash
before the shell pipe symbol "|" prevents Vim from parsing it as command
termination.
This also works for most other systems, with the restriction that the
backticks must be around the whole item.  It is not possible to have text
directly before the first or just after the last backtick.

							*`=*
You can have the backticks expanded as a Vim expression, instead of as an
external command, by putting an equal sign right after the first backtick,
e.g.: >
	:e `=tempname()`
The expression can contain just about anything, thus this can also be used to
avoid the special meaning of '"', '|', '%' and '#'.  However, 'wildignore'
does apply like to other wildcards.

Environment variables in the expression are expanded when evaluating the
expression, thus this works: >
	:e `=$HOME . '/.vimrc'`
This does not work, $HOME is inside a string and used literally: >
	:e `='$HOME' . '/.vimrc'`

If the expression returns a string then names are to be separated with line
breaks.  When the result is a |List| then each item is used as a name.  Line
breaks also separate names.
Note that such expressions are only supported in places where a filename is
expected as an argument to an Ex-command.

							*++opt* *[++opt]*
The [++opt] argument can be used to force the value of 'fileformat',
'fileencoding' or 'binary' to a value for one command, and to specify the
behavior for bad characters.  The form is: >
	++{optname}
Or: >
	++{optname}={value}

Where {optname} is one of:	    *++ff* *++enc* *++bin* *++nobin* *++edit*
    ff     or  fileformat   overrides 'fileformat'
    enc    or  encoding	    overrides 'fileencoding'
    bin    or  binary	    sets 'binary'
    nobin  or  nobinary	    resets 'binary'
    bad			    specifies behavior for bad characters
    edit		    for |:read| only: keep option values as if editing
			    a file

{value} cannot contain white space.  It can be any valid value for these
options.  Examples: >
	:e ++ff=unix
This edits the same file again with 'fileformat' set to "unix". >

	:w ++enc=latin1 newfile
This writes the current buffer to "newfile" in latin1 format.

There may be several ++opt arguments, separated by white space.  They must all
appear before any |+cmd| argument.

								*++bad*
The argument of "++bad=" specifies what happens with characters that can't be
converted and illegal bytes.  It can be one of three things:
    ++bad=X      A single-byte character that replaces each bad character.
    ++bad=keep   Keep bad characters without conversion.  Note that this may
		 result in illegal bytes in your text!
    ++bad=drop   Remove the bad characters.

The default is like "++bad=?": Replace each bad character with a question
mark.  In some places an inverted question mark is used (0xBF).

Note that not all commands use the ++bad argument, even though they do not
give an error when you add it.  E.g. |:write|.

Note that when reading, the 'fileformat' and 'fileencoding' options will be
set to the used format.  When writing this doesn't happen, thus a next write
will use the old value of the option.  Same for the 'binary' option.


							*+cmd* *[+cmd]*
The [+cmd] argument can be used to position the cursor in the newly opened
file, or execute any other command:
	+		Start at the last line.
	+{num}		Start at line {num}.
	+/{pat}		Start at first line containing {pat}.
	+{command}	Execute {command} after opening the new file.
			{command} is any Ex command.
To include a white space in the {pat} or {command}, precede it with a
backslash.  Double the number of backslashes. >
	:edit  +/The\ book	     file
	:edit  +/dir\ dirname\\      file
	:edit  +set\ dir=c:\\\\temp  file
Note that in the last example the number of backslashes is halved twice: Once
for the "+cmd" argument and once for the ":set" command.

							*file-formats*
The 'fileformat' option sets the <EOL> style for a file:
'fileformat'    characters	   name				~
  "dos"		<CR><NL> or <NL>   DOS format		*DOS-format*
  "unix"	<NL>		   Unix format		*Unix-format*
  "mac"		<CR>		   Mac format		*Mac-format*

When reading a file, the mentioned characters are interpreted as the <EOL>.
In DOS format (default for Windows), <CR><NL> and <NL> are both interpreted as
the <EOL>. Note that when writing the file in DOS format, <CR> characters will
be added for each single <NL>.  Also see |file-read|.

When writing a file, the mentioned characters are used for <EOL>.  For DOS
format <CR><NL> is used.  Also see |DOS-format-write|.

You can read a file in DOS format and write it in Unix format.  This will
replace all <CR><NL> pairs by <NL> (assuming 'fileformats' includes "dos"): >
	:e file
	:set fileformat=unix
	:w
If you read a file in Unix format and write with DOS format, all <NL>
characters will be replaced with <CR><NL> (assuming 'fileformats' includes
"unix"): >
	:e file
	:set fileformat=dos
	:w

If you start editing a new file and the 'fileformats' option is not empty
(which is the default), Vim will try to detect whether the lines in the file
are separated by the specified formats.  When set to "unix,dos", Vim will
check for lines with a single <NL> (as used on Unix) or by a <CR><NL> pair
(Windows).  Only when ALL lines end in <CR><NL>, 'fileformat' is set to "dos",
otherwise it is set to "unix".  When 'fileformats' includes "mac", and no <NL>
characters are found in the file, 'fileformat' is set to "mac".

If the 'fileformat' option is set to "dos" on non-Windows systems the message
"[dos format]" is shown to remind you that something unusual is happening.  On
Windows systems you get the message "[unix format]" if 'fileformat' is set to
"unix".  On all systems but the Macintosh you get the message "[mac format]"
if 'fileformat' is set to "mac".

If the 'fileformats' option is empty and DOS format is used, but while reading
a file some lines did not end in <CR><NL>, "[CR missing]" will be included in
the file message.
If the 'fileformats' option is empty and Mac format is used, but while reading
a file a <NL> was found, "[NL missing]" will be included in the file message.

If the new file does not exist, the 'fileformat' of the current buffer is used
when 'fileformats' is empty.  Otherwise the first format from 'fileformats' is
used for the new file.

Before editing binary, executable or Vim script files you should set the
'binary' option.  A simple way to do this is by starting Vim with the "-b"
option.  This will avoid the use of 'fileformat'.  Without this you risk that
single <NL> characters are unexpectedly replaced with <CR><NL>.

==============================================================================
3. The argument list				*argument-list* *arglist*

If you give more than one file name when starting Vim, this list is remembered
as the argument list.  You can jump to each file in this list.

Do not confuse this with the buffer list, which you can see with the
|:buffers| command.  The argument list was already present in Vi, the buffer
list is new in Vim.  Every file name in the argument list will also be present
in the buffer list (unless it was deleted with |:bdel| or |:bwipe|).  But it's
common that names in the buffer list are not in the argument list.

This subject is introduced in section |07.2| of the user manual.

There is one global argument list, which is used for all windows by default.
It is possible to create a new argument list local to a window, see
|:arglocal|.

You can use the argument list with the following commands, and with the
expression functions |argc()| and |argv()|.  These all work on the argument
list of the current window.

							*:ar* *:arg* *:args*
:ar[gs]			Print the argument list, with the current file in
			square brackets.

:ar[gs] [++opt] [+cmd] {arglist}			*:args_f*
			Define {arglist} as the new argument list and edit
			the first one.  This fails when changes have been made
			and Vim does not want to |abandon| the current buffer.
			Also see |++opt| and |+cmd|.

:ar[gs]! [++opt] [+cmd] {arglist}			*:args_f!*
			Define {arglist} as the new argument list and edit
			the first one.  Discard any changes to the current
			buffer.
			Also see |++opt| and |+cmd|.

:[count]arge[dit][!] [++opt] [+cmd] {name} ..		*:arge* *:argedit*
			Add {name}s to the argument list and edit it.
			When {name} already exists in the argument list, this
			entry is edited.
			This is like using |:argadd| and then |:edit|.
			Spaces in filenames have to be escaped with "\".
			[count] is used like with |:argadd|.
			If the current file cannot be |abandon|ed {name}s will
			still be added to the argument list, but won't be
			edited. No check for duplicates is done.
			Also see |++opt| and |+cmd|.

:[count]arga[dd] {name} ..			*:arga* *:argadd* *E479*
:[count]arga[dd]
			Add the {name}s to the argument list.  When {name} is
			omitted add the current buffer name to the argument
			list.
			If [count] is omitted, the {name}s are added just
			after the current entry in the argument list.
			Otherwise they are added after the [count]'th file.
			If the argument list is "a b c", and "b" is the
			current argument, then these commands result in:
				command		new argument list ~
				:argadd x	a b x c
				:0argadd x	x a b c
				:1argadd x	a x b c
				:$argadd x	a b c x
			And after the last one:
				:+2argadd y	a b c x y
			There is no check for duplicates, it is possible to
			add a file to the argument list twice.
			The currently edited file is not changed.
			Note: you can also use this method: >
				:args ## x
<			This will add the "x" item and sort the new list.

:argd[elete] {pattern} ..			*:argd* *:argdelete* *E480*
			Delete files from the argument list that match the
			{pattern}s.  {pattern} is used like a file pattern,
			see |file-pattern|.  "%" can be used to delete the
			current entry.
			This command keeps the currently edited file, also
			when it's deleted from the argument list.
			Example: >
				:argdel *.obj

:[range]argd[elete]	Delete the {range} files from the argument list.
			Example: >
				:10,$argdel
<			Deletes arguments 10 and further, keeping 1-9. >
				:$argd
<			Deletes just the last one. >
				:argd
				:.argd
<			Deletes the current argument. >
				:%argd
<			Removes all the files from the arglist.
			When the last number in the range is too high, up to
			the last argument is deleted.

							*:argu* *:argument*
:[count]argu[ment] [count] [++opt] [+cmd]
			Edit file [count] in the argument list.  When [count]
			is omitted the current entry is used.  This fails
			when changes have been made and Vim does not want to
			|abandon| the current buffer.
			Also see |++opt| and |+cmd|.

:[count]argu[ment]! [count] [++opt] [+cmd]
			Edit file [count] in the argument list, discard any
			changes to the current buffer.  When [count] is
			omitted the current entry is used.
			Also see |++opt| and |+cmd|.

:[count]n[ext] [++opt] [+cmd]			*:n* *:ne* *:next* *E165* *E163*
			Edit [count] next file.  This fails when changes have
			been made and Vim does not want to |abandon| the
			current buffer.  Also see |++opt| and |+cmd|.

:[count]n[ext]! [++opt] [+cmd]
			Edit [count] next file, discard any changes to the
			buffer.  Also see |++opt| and |+cmd|.

:n[ext] [++opt] [+cmd] {arglist}			*:next_f*
			Same as |:args_f|.

:n[ext]! [++opt] [+cmd] {arglist}
			Same as |:args_f!|.

:[count]N[ext] [count] [++opt] [+cmd]			*:Next* *:N* *E164*
			Edit [count] previous file in argument list.  This
			fails when changes have been made and Vim does not
			want to |abandon| the current buffer.
			Also see |++opt| and |+cmd|.

:[count]N[ext]! [count] [++opt] [+cmd]
			Edit [count] previous file in argument list.  Discard
			any changes to the buffer.  Also see |++opt| and
			|+cmd|.

:[count]prev[ious] [count] [++opt] [+cmd]		*:prev* *:previous*
			Same as :Next.  Also see |++opt| and |+cmd|.

							*:rew* *:rewind*
:rew[ind] [++opt] [+cmd]
			Start editing the first file in the argument list.
			This fails when changes have been made and Vim does
			not want to |abandon| the current buffer.
			Also see |++opt| and |+cmd|.

:rew[ind]! [++opt] [+cmd]
			Start editing the first file in the argument list.
			Discard any changes to the buffer.  Also see |++opt|
			and |+cmd|.

							*:fir* *:first*
:fir[st][!] [++opt] [+cmd]
			Other name for ":rewind".

							*:la* *:last*
:la[st] [++opt] [+cmd]
			Start editing the last file in the argument list.
			This fails when changes have been made and Vim does
			not want to |abandon| the current buffer.
			Also see |++opt| and |+cmd|.

:la[st]! [++opt] [+cmd]
			Start editing the last file in the argument list.
			Discard any changes to the buffer.  Also see |++opt|
			and |+cmd|.

							*:wn* *:wnext*
:[count]wn[ext] [++opt]
			Write current file and start editing the [count]
			next file.  Also see |++opt| and |+cmd|.

:[count]wn[ext] [++opt] {file}
			Write current file to {file} and start editing the
			[count] next file, unless {file} already exists and
			the 'writeany' option is off.  Also see |++opt| and
			|+cmd|.

:[count]wn[ext]! [++opt] {file}
			Write current file to {file} and start editing the
			[count] next file.  Also see |++opt| and |+cmd|.

:[count]wN[ext][!] [++opt] [file]		*:wN* *:wNext*
:[count]wp[revious][!] [++opt] [file]		*:wp* *:wprevious*
			Same as :wnext, but go to previous file instead of
			next.

The [count] in the commands above defaults to one.  For some commands it is
possible to use two counts.  The last one (rightmost one) is used.

If no [+cmd] argument is present, the cursor is positioned at the last known
cursor position for the file.  If 'startofline' is set, the cursor will be
positioned at the first non-blank in the line, otherwise the last know column
is used.  If there is no last known cursor position the cursor will be in the
first line (the last line in Ex mode).

							*{arglist}*
The wildcards in the argument list are expanded and the file names are sorted.
Thus you can use the command "vim *.c" to edit all the C files.  From within
Vim the command ":n *.c" does the same.

White space is used to separate file names.  Put a backslash before a space or
tab to include it in a file name.  E.g., to edit the single file "foo bar": >
	:next foo\ bar

On Unix and a few other systems you can also use backticks, for example: >
	:next `find . -name \\*.c -print`
The backslashes before the star are required to prevent "*.c" to be expanded
by the shell before executing the find program.

							*arglist-position*
When there is an argument list you can see which file you are editing in the
title of the window (if there is one and 'title' is on) and with the file
message you get with the "CTRL-G" command.  You will see something like
	(file 4 of 11)
If 'shortmess' contains 'f' it will be
	(4 of 11)
If you are not really editing the file at the current position in the argument
list it will be
	(file (4) of 11)
This means that you are position 4 in the argument list, but not editing the
fourth file in the argument list.  This happens when you do ":e file".


LOCAL ARGUMENT LIST

							*:arglocal*
:argl[ocal]		Make a local copy of the global argument list.
			Doesn't start editing another file.

:argl[ocal][!] [++opt] [+cmd] {arglist}
			Define a new argument list, which is local to the
			current window.  Works like |:args_f| otherwise.

							*:argglobal*
:argg[lobal]		Use the global argument list for the current window.
			Doesn't start editing another file.

:argg[lobal][!] [++opt] [+cmd] {arglist}
			Use the global argument list for the current window.
			Define a new global argument list like |:args_f|.
			All windows using the global argument list will see
			this new list.

There can be several argument lists.  They can be shared between windows.
When they are shared, changing the argument list in one window will also
change it in the other window.

When a window is split the new window inherits the argument list from the
current window.  The two windows then share this list, until one of them uses
|:arglocal| or |:argglobal| to use another argument list.


USING THE ARGUMENT LIST

						*:argdo*
:[range]argdo[!] {cmd}	Execute {cmd} for each file in the argument list or,
			if [range] is specified, only for arguments in that
			range.  It works like doing this: >
				:rewind
				:{cmd}
				:next
				:{cmd}
				etc.
<			When the current file can't be |abandon|ed and the [!]
			is not present, the command fails.
			When an error is detected on one file, further files
			in the argument list will not be visited.
			The last file in the argument list (or where an error
			occurred) becomes the current file.
			{cmd} can contain '|' to concatenate several commands.
			{cmd} must not change the argument list.
			Note: While this command is executing, the Syntax
			autocommand event is disabled by adding it to
			'eventignore'.  This considerably speeds up editing
			each file.
			Also see |:windo|, |:tabdo|, |:bufdo|, |:cdo|, |:ldo|,
			|:cfdo| and |:lfdo|.

Example: >
	:args *.c
	:argdo set ff=unix | update
This sets the 'fileformat' option to "unix" and writes the file if it is now
changed.  This is done for all *.c files.

Example: >
	:args *.[ch]
	:argdo %s/\<my_foo\>/My_Foo/ge | update
This changes the word "my_foo" to "My_Foo" in all *.c and *.h files.  The "e"
flag is used for the ":substitute" command to avoid an error for files where
"my_foo" isn't used.  ":update" writes the file only if changes were made.

==============================================================================
4. Writing					*writing* *save-file*

Note: When the 'write' option is off, you are not able to write any file.

							*:w* *:write*
					*E502* *E503* *E504* *E505*
					*E512* *E514* *E667* *E796* *E949*
:w[rite] [++opt]	Write the whole buffer to the current file.  This is
			the normal way to save changes to a file.  It fails
			when the 'readonly' option is set or when there is
			another reason why the file can't be written.
			For ++opt see |++opt|, but only ++bin, ++nobin, ++ff
			and ++enc are effective.

:w[rite]! [++opt]	Like ":write", but forcefully write when 'readonly' is
			set or there is another reason why writing was
			refused.
			Note: This may change the permission and ownership of
			the file and break (symbolic) links.  Add the 'W' flag
			to 'cpoptions' to avoid this.

:[range]w[rite][!] [++opt]
			Write the specified lines to the current file.  This
			is unusual, because the file will not contain all
			lines in the buffer.

							*:w_f* *:write_f*
:[range]w[rite] [++opt]	{file}
			Write the specified lines to {file}, unless it
			already exists and the 'writeany' option is off.

							*:w!*
:[range]w[rite]! [++opt] {file}
			Write the specified lines to {file}.  Overwrite an
			existing file.

						*:w_a* *:write_a* *E494*
:[range]w[rite][!] [++opt] >>
			Append the specified lines to the current file.

:[range]w[rite][!] [++opt] >> {file}
			Append the specified lines to {file}.  '!' forces the
			write even if file does not exist.

							*:w_c* *:write_c*
:[range]w[rite] [++opt] !{cmd}
			Execute {cmd} with [range] lines as standard input
			(note the space in front of the '!').  {cmd} is
			executed like with ":!{cmd}", any '!' is replaced with
			the previous command |:!|.

The default [range] for the ":w" command is the whole buffer (1,$).  If you
write the whole buffer, it is no longer considered changed.  When you
write it to a different file with ":w somefile" it depends on the "+" flag in
'cpoptions'.  When included, the write command will reset the 'modified' flag,
even though the buffer itself may still be different from its file.

If a file name is given with ":w" it becomes the alternate file.  This can be
used, for example, when the write fails and you want to try again later with
":w #".  This can be switched off by removing the 'A' flag from the
'cpoptions' option.

Note that the 'fsync' option matters here.  If it's set it may make writes
slower (but safer).

							*:sav* *:saveas*
:sav[eas][!] [++opt] {file}
			Save the current buffer under the name {file} and set
			the filename of the current buffer to {file}.  The
			previous name is used for the alternate file name.
			The [!] is needed to overwrite an existing file.
			When 'filetype' is empty filetype detection is done
			with the new name, before the file is written.
			When the write was successful 'readonly' is reset.

							*:up* *:update*
:[range]up[date][!] [++opt] [>>] [file]
			Like ":write", but only write when the buffer has been
			modified.


WRITING WITH MULTIPLE BUFFERS				*buffer-write*

							*:wa* *:wall*
:wa[ll]			Write all changed buffers.  Buffers without a file
			name cause an error message.  Buffers which are
			readonly are not written.

:wa[ll]!		Write all changed buffers, even the ones that are
			readonly.  Buffers without a file name are not
			written and cause an error message.


Vim will warn you if you try to overwrite a file that has been changed
elsewhere.  See |timestamp|.

			    *backup* *E207* *E506* *E507* *E508* *E509* *E510*
If you write to an existing file (but do not append) while the 'backup',
'writebackup' or 'patchmode' option is on, a backup of the original file is
made.  The file is either copied or renamed (see 'backupcopy').  After the
file has been successfully written and when the 'writebackup' option is on and
the 'backup' option is off, the backup file is deleted.  When the 'patchmode'
option is on the backup file may be renamed.

							*backup-table*
'backup' 'writebackup'	action	~
   off	     off	no backup made
   off	     on		backup current file, deleted afterwards (default)
   on	     off	delete old backup, backup current file
   on	     on		delete old backup, backup current file

When the 'backupskip' pattern matches with the name of the file which is
written, no backup file is made.  The values of 'backup' and 'writebackup' are
ignored then.

When the 'backup' option is on, an old backup file (with the same name as the
new backup file) will be deleted.  If 'backup' is not set, but 'writebackup'
is set, an existing backup file will not be deleted.  The backup file that is
made while the file is being written will have a different name.

On some filesystems it's possible that in a crash you lose both the backup and
the newly written file (it might be there but contain bogus data).  In that
case try recovery, because the swap file is synced to disk and might still be
there. |:recover|

The directories given with the 'backupdir' option are used to put the backup
file in.  (default: same directory as the written file).

Whether the backup is a new file, which is a copy of the original file, or the
original file renamed depends on the 'backupcopy' option.  See there for an
explanation of when the copy is made and when the file is renamed.

If the creation of a backup file fails, the write is not done.  If you want
to write anyway add a '!' to the command.

							*write-permissions*
When writing a new file the permissions are read-write.  For unix the mask is
0666 with additionally umask applied.  When writing a file that was read Vim
will preserve the permissions, but clear the s-bit.

							*write-readonly*
When the 'cpoptions' option contains 'W', Vim will refuse to overwrite a
readonly file.  When 'W' is not present, ":w!" will overwrite a readonly file,
if the system allows it (the directory must be writable).

							*write-fail*
If the writing of the new file fails, you have to be careful not to lose
your changes AND the original file.  If there is no backup file and writing
the new file failed, you have already lost the original file!  DON'T EXIT VIM
UNTIL YOU WRITE OUT THE FILE!  If a backup was made, it is put back in place
of the original file (if possible).  If you exit Vim, and lose the changes
you made, the original file will mostly still be there.  If putting back the
original file fails, there will be an error message telling you that you
lost the original file.

						*DOS-format-write*
If the 'fileformat' is "dos", <CR> <NL> is used for <EOL>.  This is default
for Windows. On other systems the message "[dos format]" is shown to
remind you that an unusual <EOL> was used.
						*Unix-format-write*
If the 'fileformat' is "unix", <NL> is used for <EOL>.  On Windows
the message "[unix format]" is shown.
						*Mac-format-write*
If the 'fileformat' is "mac", <CR> is used for <EOL>.  On non-Mac systems the
message "[mac format]" is shown.

See also |file-formats| and the 'fileformat' and 'fileformats' options.

						*ACL*
ACL stands for Access Control List.  It is an advanced way to control access
rights for a file.  It is used on new MS-Windows and Unix systems, but only
when the filesystem supports it.
   Vim attempts to preserve the ACL info when writing a file.  The backup file
will get the ACL info of the original file.
   The ACL info is also used to check if a file is read-only (when opening the
file).

						*read-only-share*
When MS-Windows shares a drive on the network it can be marked as read-only.
This means that even if the file read-only attribute is absent, and the ACL
settings on NT network shared drives allow writing to the file, you can still
not write to the file.  Vim on Win32 platforms will detect read-only network
drives and will mark the file as read-only.  You will not be able to override
it with |:write|.

						*write-device*
When the file name is actually a device name, Vim will not make a backup (that
would be impossible).  You need to use "!", since the device already exists.
Example for Unix: >
	:w! /dev/lpt0
and Windows: >
	:w! lpt0
For Unix a device is detected when the name doesn't refer to a normal file or
a directory.  A fifo or named pipe also looks like a device to Vim.
For Windows the device is detected by its name:
	CON
	CLOCK$
	NUL
	PRN
	COMn	n=1,2,3... etc
	LPTn	n=1,2,3... etc
The names can be in upper- or lowercase.

==============================================================================
5. Writing and quitting					*write-quit*

							*:q* *:quit*
:q[uit]			Quit the current window.  Quit Vim if this is the last
			window.  This fails when changes have been made and
			Vim refuses to |abandon| the current buffer, and when
			the last file in the argument list has not been
			edited.
			If there are other tab pages and quitting the last
			window in the current tab page the current tab page is
			closed |tab-page|.
			Triggers the |QuitPre| autocommand event.
			See |CTRL-W_q| for quitting another window.

:conf[irm] q[uit]	Quit, but give prompt when changes have been made, or
			the last file in the argument list has not been
			edited.  See |:confirm| and 'confirm'.

:q[uit]!		Quit without writing, also when the current buffer has
			changes.  The buffer is unloaded, also when it has
			'hidden' set.
			If this is the last window and there is a modified
			hidden buffer, the current buffer is abandoned and the
			first changed hidden buffer becomes the current
			buffer.
			Use ":qall!" to exit always.

:cq[uit]		Quit always, without writing, and return an error
			code.  See |:cq|.

							*:wq*
:wq [++opt]		Write the current file and quit.  Writing fails when
			the file is read-only or the buffer does not have a
			name.  Quitting fails when the last file in the
			argument list has not been edited.

:wq! [++opt]		Write the current file and quit.  Writing fails when
			the current buffer does not have a name.

:wq [++opt] {file}	Write to {file} and quit.  Quitting fails when the
			last file in the argument list has not been edited.

:wq! [++opt] {file}	Write to {file} and quit.

:[range]wq[!] [++opt] [file]
			Same as above, but only write the lines in [range].

							*:x* *:xit*
:[range]x[it][!] [++opt] [file]
			Like ":wq", but write only when changes have been
			made.
			When 'hidden' is set and there are more windows, the
			current buffer becomes hidden, after writing the file.

							*:exi* *:exit*
:[range]exi[t][!] [++opt] [file]
			Same as :xit.

							*ZZ*
ZZ			Write current file, if modified, and quit (same as
			":x").  (Note: If there are several windows for the
			current file, the file is written if it was modified
			and the window is closed).

							*ZQ*
ZQ			Quit without checking for changes (same as ":q!").

MULTIPLE WINDOWS AND BUFFERS				*window-exit*

							*:qa* *:qall*
:qa[ll]		Exit Vim, unless there are some buffers which have been
		changed.  (Use ":bmod" to go to the next modified buffer).
		When 'autowriteall' is set all changed buffers will be
		written, like |:wqall|.

:conf[irm] qa[ll]
		Exit Vim.  Bring up a prompt when some buffers have been
		changed.  See |:confirm|.

:qa[ll]!	Exit Vim.  Any changes to buffers are lost.
		Also see |:cquit|, it does the same but exits with a non-zero
		value.

							*:quita* *:quitall*
:quita[ll][!]	Same as ":qall".

:wqa[ll] [++opt]				*:wqa* *:wqall* *:xa* *:xall*
:xa[ll]		Write all changed buffers and exit Vim.  If there are buffers
		without a file name, which are readonly or which cannot be
		written for another reason, Vim will not quit.

:conf[irm] wqa[ll] [++opt]
:conf[irm] xa[ll]
		Write all changed buffers and exit Vim.  Bring up a prompt
		when some buffers are readonly or cannot be written for
		another reason.  See |:confirm|.

:wqa[ll]! [++opt]
:xa[ll]!	Write all changed buffers, even the ones that are readonly,
		and exit Vim.  If there are buffers without a file name or
		which cannot be written for another reason, Vim will not quit.

==============================================================================
6. Dialogs						*edit-dialogs*

							*:confirm* *:conf*
:conf[irm] {command}	Execute {command}, and use a dialog when an
			operation has to be confirmed.  Can be used on the
			|:q|, |:qa| and |:w| commands (the latter to override
			a read-only setting), and any other command that can
			fail in such a way, such as |:only|, |:buffer|,
			|:bdelete|, etc.

Examples: >
  :confirm w foo
<	Will ask for confirmation when "foo" already exists. >
  :confirm q
<	Will ask for confirmation when there are changes. >
  :confirm qa
<	If any modified, unsaved buffers exist, you will be prompted to save
	or abandon each one.  There are also choices to "save all" or "abandon
	all".

If you want to always use ":confirm", set the 'confirm' option.

			*:browse* *:bro* *E338* *E614* *E615* *E616*
:bro[wse] {command}	Open a file selection dialog for an argument to
			{command}.  At present this works for |:e|, |:w|,
			|:wall|, |:wq|, |:wqall|, |:x|, |:xall|, |:exit|,
			|:view|, |:sview|, |:r|, |:saveas|, |:sp|, |:mkexrc|,
			|:mkvimrc|, |:mksession|, |:mkview|, |:split|,
			|:vsplit|, |:tabe|, |:tabnew|, |:cfile|, |:cgetfile|,
			|:caddfile|, |:lfile|, |:lgetfile|, |:laddfile|,
			|:diffsplit|, |:diffpatch|, |:pedit|, |:redir|,
			|:source|, |:update|, |:visual|, |:vsplit|,
			and |:qall| if 'confirm' is set.
			{only in Win32 GUI}
			When ":browse" is not possible you get an error
			message.  If {command} doesn't support browsing, the
			{command} is executed without a dialog.
			":browse set" works like |:options|.
			See also |:oldfiles| for ":browse oldfiles".

The syntax is best shown via some examples: >
	:browse e $vim/foo
<		Open the browser in the $vim/foo directory, and edit the
		file chosen. >
	:browse e
<		Open the browser in the directory specified with 'browsedir',
		and edit the file chosen. >
	:browse w
<		Open the browser in the directory of the current buffer,
		with the current buffer filename as default, and save the
		buffer under the filename chosen. >
	:browse w C:/bar
<		Open the browser in the C:/bar directory, with the current
		buffer filename as default, and save the buffer under the
		filename chosen.
Also see the |'browsedir'| option.
For versions of Vim where browsing is not supported, the command is executed
unmodified.

							*browsefilter*
For Windows you can modify the filters that are used in the browse dialog.  By
setting the g:browsefilter or b:browsefilter variables, you can change the
filters globally or locally to the buffer.  The variable is set to a string in
the format "{filter label}\t{pattern};{pattern}\n" where {filter label} is the
text that appears in the "Files of Type" comboBox, and {pattern} is the
pattern which filters the filenames.  Several patterns can be given, separated
by ';'.

For example, to have only Vim files in the dialog, you could use the following
command: >

     let g:browsefilter = "Vim Scripts\t*.vim\nVim Startup Files\t*vimrc\n"

You can override the filter setting on a per-buffer basis by setting the
b:browsefilter variable.  You would most likely set b:browsefilter in a
filetype plugin, so that the browse dialog would contain entries related to
the type of file you are currently editing.  Disadvantage: This makes it
difficult to start editing a file of a different type.  To overcome this, you
may want to add "All Files\t*.*\n" as the final filter, so that the user can
still access any desired file.

To avoid setting browsefilter when Vim does not actually support it, you can
use has("browsefilter"): >

	if has("browsefilter")
	   let g:browsefilter = "whatever"
	endif

==============================================================================
7. The current directory				*current-directory*

You can use |:cd|, |:tcd| and |:lcd| to change to another directory, so you
will not have to type that directory name in front of the file names.  It also
makes a difference for executing external commands, e.g. ":!ls" or ":te ls".

There are three current-directory "scopes": global, tab and window.  The
window-local working directory takes precedence over the tab-local
working directory, which in turn takes precedence over the global
working directory.  If a local working directory (tab or window) does not
exist, the next-higher scope in the hierarchy applies.

							*:cd* *E747* *E472*
:cd[!]			On non-Unix systems: Print the current directory
			name.  On Unix systems: Change the current directory
			to the home directory.  Use |:pwd| to print the
			current directory on all systems.

:cd[!] {path}		Change the current directory to {path}.
			If {path} is relative, it is searched for in the
			directories listed in |'cdpath'|.
			Does not change the meaning of an already opened file,
			because its full path name is remembered.  Files from
			the |arglist| may change though!
			On Windows this also changes the active drive.
			To change to the directory of the current file: >
				:cd %:h
<
							*:cd-* *E186*
:cd[!] -		Change to the previous current directory (before the
			previous ":cd {path}" command).

							*:chd* *:chdir*
:chd[ir][!] [path]	Same as |:cd|.

					*:tc* *:tcd* *E5000* *E5001* *E5002*
:tc[d][!] {path}        Like |:cd|, but set the current directory for the
			current tab and window.  The current directory for
			other tabs and windows is not changed.

							*:tcd-*
:tcd[!] -		Change to the previous current directory (before the
			previous ":tcd {path}" command).

							*:tch* *:tchdir*
:tch[dir][!]		Same as |:tcd|.

							*:lc* *:lcd*
:lc[d][!] {path}	Like |:cd|, but only set the current directory for the
			current window.  The current directory for other
			windows or tabs is not changed.

							*:lch* *:lchdir*
:lch[dir][!]		Same as |:lcd|.

							*:lcd-* 
:lcd[!] -		Change to the previous current directory (before the
			previous ":lcd {path}" command).

							*:pw* *:pwd* *E187*
:pw[d]			Print the current directory name.
			Also see |getcwd()|.

So long as no |:tcd| or |:lcd| command has been used, all windows share the
same "current directory".  Using a command to jump to another window doesn't
change anything for the current directory.

When |:lcd| has been used for a window, the specified directory becomes the
current directory for that window.  Windows where the |:lcd| command has not
been used stick to the global or tab-local directory.  When jumping to another
window the current directory will become the last specified local current
directory.  If none was specified, the global or tab-local directory is used.

When changing tabs the same behaviour applies.  If the current tab has no
local working directory the global working directory is used.  When a |:cd|
command is used, the current window and tab will lose their local current
directories and will use the global current directory from now on.  When
a |:tcd| command is used, only the current window will lose its local working
directory.

After using |:cd| the full path name will be used for reading and writing
files.  On some networked file systems this may cause problems.  The result of
using the full path name is that the file names currently in use will remain
referring to the same file.  Example: If you have a file a:test and a
directory a:vim the commands ":e test" ":cd vim" ":w" will overwrite the file
a:test and not write a:vim/test.  But if you do ":w test" the file a:vim/test
will be written, because you gave a new file name and did not refer to a
filename before the ":cd".

==============================================================================
8. Editing binary files					*edit-binary*

Although Vim was made to edit text files, it is possible to edit binary
files.  The |-b| Vim argument (b for binary) makes Vim do file I/O in binary
mode, and sets some options for editing binary files ('binary' on, 'textwidth'
to 0, 'modeline' off, 'expandtab' off).  Setting the 'binary' option has the
same effect.  Don't forget to do this before reading the file.

There are a few things to remember when editing binary files:
- When editing executable files the number of characters must not change.
  Use only the "R" or "r" command to change text.  Do not delete characters
  with "x" or by backspacing.
- Set the 'textwidth' option to 0.  Otherwise lines will unexpectedly be
  split in two.
- When there are not many <EOL>s, the lines will become very long.  If you
  want to edit a line that does not fit on the screen reset the 'wrap' option.
  Horizontal scrolling is used then.  If a line becomes too long (see |limits|)
  you cannot edit that line.  The line will be split when reading the file.
  It is also possible that you get an "out of memory" error when reading the
  file.
- Make sure the 'binary' option is set BEFORE loading the
  file.  Otherwise both <CR> <NL> and <NL> are considered to end a line
  and when the file is written the <NL> will be replaced with <CR> <NL>.
- <Nul> characters are shown on the screen as ^@.  You can enter them with
  "CTRL-V CTRL-@" or "CTRL-V 000".
- To insert a <NL> character in the file split a line.  When writing the
  buffer to a file a <NL> will be written for the <EOL>.
- Vim normally appends an <EOL> at the end of the file if there is none.
  Setting the 'binary' option prevents this.  If you want to add the final
  <EOL>, set the 'endofline' option.  You can also read the value of this
  option to see if there was an <EOL> for the last line (you cannot see this
  in the text).

==============================================================================
9. Encryption						*encryption*

					                *:X* *E817* *E818* *E819* *E820*
Support for editing encrypted files has been removed.
	https://github.com/neovim/neovim/issues/694
	https://github.com/neovim/neovim/issues/701

==============================================================================
10. Timestamps					*timestamp* *timestamps*

Vim remembers the modification timestamp, mode and size of a file when you
begin editing it.  This is used to avoid that you have two different versions
of the same file (without you knowing this).

After a shell command is run (|:!cmd| |suspend| |:read!| |K|) timestamps,
file modes and file sizes are compared for all buffers in a window.   Vim will
run any associated |FileChangedShell| autocommands or display a warning for
any files that have changed.  In the GUI this happens when Vim regains input
focus.

							*E321* *E462*
If you want to automatically reload a file when it has been changed outside of
Vim, set the 'autoread' option.  This doesn't work at the moment you write the
file though, only when the file wasn't changed inside of Vim.

If you do not want to be asked or automatically reload the file, you can use
this: >
	set buftype=nofile

Or, when starting gvim from a shell: >
	gvim file.log -c "set buftype=nofile"

Note that if a FileChangedShell autocommand is defined you will not get a
warning message or prompt.  The autocommand is expected to handle this.

There is no warning for a directory (e.g., with |netrw-browse|).  But you do
get warned if you started editing a new file and it was created as a directory
later.

When Vim notices the timestamp of a file has changed, and the file is being
edited in a buffer but has not changed, Vim checks if the contents of the file
is equal.  This is done by reading the file again (into a hidden buffer, which
is immediately deleted again) and comparing the text.  If the text is equal,
you will get no warning.

If you don't get warned often enough you can use the following command.

							*:checkt* *:checktime*
:checkt[ime]		Check if any buffers were changed outside of Vim.
			This checks and warns you if you would end up with two
			versions of a file.
			If this is called from an autocommand, a ":global"
			command or is not typed the actual check is postponed
			until a moment the side effects (reloading the file)
			would be harmless.
			Each loaded buffer is checked for its associated file
			being changed.  If the file was changed Vim will take
			action.  If there are no changes in the buffer and
			'autoread' is set, the buffer is reloaded.  Otherwise,
			you are offered the choice of reloading the file.  If
			the file was deleted you get an error message.
			If the file previously didn't exist you get a warning
			if it exists now.
			Once a file has been checked the timestamp is reset,
			you will not be warned again.

:[N]checkt[ime] {filename}
:[N]checkt[ime] [N]
			Check the timestamp of a specific buffer.  The buffer
			may be specified by name, number or with a pattern.


							*E813* *E814*
Vim will reload the buffer if you chose to.  If a window is visible that
contains this buffer, the reloading will happen in the context of this window.
Otherwise a special window is used, so that most autocommands will work.  You
can't close this window.  A few other restrictions apply.  Best is to make
sure nothing happens outside of the current buffer.  E.g., setting
window-local options may end up in the wrong window.  Splitting the window,
doing something there and closing it should be OK (if there are no side
effects from other autocommands).  Closing unrelated windows and buffers will
get you into trouble.

Before writing a file the timestamp is checked.  If it has changed, Vim will
ask if you really want to overwrite the file:

	WARNING: The file has been changed since reading it!!!
	Do you really want to write to it (y/n)?

If you hit 'y' Vim will continue writing the file.  If you hit 'n' the write is
aborted.  If you used ":wq" or "ZZ" Vim will not exit, you will get another
chance to write the file.

The message would normally mean that somebody has written to the file after
the edit session started.  This could be another person, in which case you
probably want to check if your changes to the file and the changes from the
other person should be merged.  Write the file under another name and check for
differences (the "diff" program can be used for this).

It is also possible that you modified the file yourself, from another edit
session or with another command (e.g., a filter command).  Then you will know
which version of the file you want to keep.

There is one situation where you get the message while there is nothing wrong:
On a Win32 system on the day daylight saving time starts.  There is something
in the Win32 libraries that confuses Vim about the hour time difference.  The
problem goes away the next day.

==============================================================================
11. File Searching					*file-searching*

The file searching is currently used for the 'path', 'cdpath' and 'tags'
options, for |finddir()| and |findfile()|.  Other commands use |wildcards|
which is slightly different.

There are three different types of searching:

1) Downward search:					*starstar*
   Downward search uses the wildcards '*', '**' and possibly others
   supported by your operating system.  '*' and '**' are handled inside Vim,
   so they work on all operating systems.  Note that "**" only acts as a
   special wildcard when it is at the start of a name.

   The usage of '*' is quite simple: It matches 0 or more characters.  In a
   search pattern this would be ".*".  Note that the "." is not used for file
   searching.

   '**' is more sophisticated:
      - It ONLY matches directories.
      - It matches up to 30 directories deep by default, so you can use it to
	search an entire directory tree
      - The maximum number of levels matched can be given by appending a number
	to '**'.
	Thus '/usr/**2' can match: >
		/usr
		/usr/include
		/usr/include/sys
		/usr/include/g++
		/usr/lib
		/usr/lib/X11
		....
<	It does NOT match '/usr/include/g++/std' as this would be three
	levels.
	The allowed number range is 0 ('**0' is removed) to 100
	If the given number is smaller than 0 it defaults to 30, if it's
	bigger than 100 then 100 is used.  The system also has a limit on the
	path length, usually 256 or 1024 bytes.
      - '**' can only be at the end of the path or be followed by a path
	separator or by a number and a path separator.

   You can combine '*' and '**' in any order: >
	/usr/**/sys/*
	/usr/*tory/sys/**
	/usr/**2/sys/*

2) Upward search:
   Here you can give a directory and then search the directory tree upward for
   a file.  You could give stop-directories to limit the upward search.  The
   stop-directories are appended to the path (for the 'path' option) or to
   the filename (for the 'tags' option) with a ';'.  If you want several
   stop-directories separate them with ';'.  If you want no stop-directory
   ("search upward till the root directory) just use ';'. >
	/usr/include/sys;/usr
<   will search in: >
	   /usr/include/sys
	   /usr/include
	   /usr
<
   If you use a relative path the upward search is started in Vim's current
   directory or in the directory of the current file (if the relative path
   starts with './' and 'd' is not included in 'cpoptions').

   If Vim's current path is /u/user_x/work/release and you do >
	:set path=include;/u/user_x
<  and then search for a file with |gf| the file is searched in: >
	/u/user_x/work/release/include
	/u/user_x/work/include
	/u/user_x/include

3) Combined up/downward search:
   If Vim's current path is /u/user_x/work/release and you do >
	set path=**;/u/user_x
<  and then search for a file with |gf| the file is searched in: >
	/u/user_x/work/release/**
	/u/user_x/work/**
	/u/user_x/**
<
   BE CAREFUL!  This might consume a lot of time, as the search of
   '/u/user_x/**' includes '/u/user_x/work/**' and
   '/u/user_x/work/release/**'.  So '/u/user_x/work/release/**' is searched
   three times and '/u/user_x/work/**' is searched twice.

   In the above example you might want to set path to: >
	:set path=**,/u/user_x/**
<  This searches:
	/u/user_x/work/release/** ~
	/u/user_x/** ~
   This searches the same directories, but in a different order.

   Note that completion for ":find", ":sfind", and ":tabfind" commands do not
   currently work with 'path' items that contain a URL or use the double star
   with depth limiter (/usr/**2) or upward search (;) notations.

 vim:tw=78:ts=8:noet:ft=help:norl:
