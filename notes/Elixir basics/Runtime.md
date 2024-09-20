### Modules and functions\
* Each compiled module resides in a separate file with `.beam` extension.
* VM keeps track of all the modules loaded in memory.
* When module function is called, VM tries to find that loaded module. If it does not exists, it looks for the compiled module file on the disk.