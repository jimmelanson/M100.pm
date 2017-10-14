To use this module, drop it in the same directory as your script. You can also point to a new directory for the module using:

BEGIN {
    push @INC, qq~/full/system/path/to/directory/with/module~;
}

--OR --

You can put the module in one of the @INC search paths and then just add:

use local::lib;
