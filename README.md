# AlfredPass
Extensive pass support for Alfred

This workflow supports several keywords:

- pass SEARCH: browse in directories, look for files. When selecting an entry, show content line by line, which can than be copied to clipboard. or you create a new password for this entry (only password! no multiline support yet) or  you delete the entry.
- psync: push your changes to your git repository associated with pass
- pgen: generate a password for a new entry. 
- pfind PATTERN: if you have [pass-index](https://github.com/sboesebeck/pass-index) installed, you can use pfind to search the content of entries really fast. If pass index is not installed, `pass grep` is used, which is quite slow compared.
