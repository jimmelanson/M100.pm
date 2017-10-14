####################################################################################################
#
#   Created by Jim Melanson, jmelanson1965@gmail.com
#   May, 2010
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, and distribute
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
#  -The original author notice (above) shall remain intact.
#  
#  -The above author notice and this permission notice shall be included in all copies or
#   substantial portions of the Software.
#
#  -THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
#   BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
#   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
####################################################################################################
#
#	 M100.pm -> The Y2K38 Killer.
#    Max value for a Perl number is 2**53, where as a 64 bit unsigned integer max is 4294967295
#    This module will validate dates until the early morning hours of February 7th, 2106 if you
#    are on a 64 bit system, or earlier in the day on January 19th, 2038 if you are on a 32 bit
#    system.
#
###########################################################################################################
#    Basic Usage (Place this in your working space and set the path to its folder in the @INC array
#        inside a BEGIN block in your script). This first example is the most basic call. In this example
#		 the object will determine the offset from UTC for the Server the script is residing on. This
#        may or may not be what you are looking for.
#
#
#    #!/usr/bin/perl
#    BEGIN {
#        push(@INC, '/path/on/server/to/folder/containing/this/module');
#    }
#    use M100;
#    $obj = M100->new();
#    my $m100 = $obj->M100;
#    print "Content-type: text/plain\n\n";
#    print "M100 date is: ", $m100;
#    exit;
#
#
#    In this example, we explicitly set the offset for the local time from UTC.
#
#    #!/usr/bin/perl
#    BEGIN {
#        push(@INC, '/path/on/server/to/folder/containing/this/module');
#    }
#    use M100;
#    $obj = M100->new();
#    my $m100 = $obj->M100;
#    $obj->tz_modifier(-5);
#    print "Content-type: text/plain\n\n";
#    print "M100 date is: ", $m100;
#    exit;
#
#
#    To better illustrate, when I developed this module the script resided on a Server in California (-8)
#    but I was developing the program to use it for Ontario (-5). That means my times would have been
#    off by three hours (the difference between California and Ontario from UTC).
#
#	 By using the $obj->tz_modifier([value]); method I was able to compensate for this. Remember though,
#    the tz_modifier() argument is the offset from UTC and not the offset from the Server location.
#
###########################################################################################################
#
#    Explanation:
#
#	tz_modifier: Use this value set the offset in hours for the desired time zone from UTC. If you
#   do not know what this is, write a quick script to print gmtime() and localtime() and calculate the
#   difference...or instantiate this object and call the method local_offset().  This method returns
#   two arguments. The first argument is the value of the offset, the second argument is a verbose
#   message about the results of the test.
#
#   Remember, moving west (towards Canada) is a negative tz_modifier and moving east (towards Russia)
#   is a positive tz_modifier
#
#   DEPENDENCY: Time::Local is used to calculate UTC.
#
#   If this module is going to be used BEYOND 2037 on a 32 bit system or 2106 on a 64 bit system, then
#   you MUST pass the year, month, dom explicitly (however, computers will probably compensate for
#   the max sizes of signed and unsigned integers by then, I hope ...):
#
#    #!/usr/bin/perl
#    BEGIN {
#        push(@INC, '/path/on/server/to/folder/containing/this/module');
#    }
#    use M100;
#    $obj = M100->new();
#    $obj->tz_modifier(-5);
#    my $m100 = $obj->M100([year, [month, [dayofmonth]]]);
#    print "Content-type: text/plain\n\n";
#    print "M100 date is: ", $m100;
#    exit;
#
###########################################################################################################
#
#    METHODS AVAILABLE TO YOU FROM THIS OBJECT
#
#    $obj->local_offset; Read Only
#    $obj->tz_modifier; SET THE VALUE
#    $obj->error; 		Read Only
#    $obj->epoch([value]); SETS the object to a time based on seconds since the epoch.
#    $obj->compvaldate; Read only for the value currently held in the object.
#    $obj->compvaltime; Read only for the value currently held in the object.
#    $obj->printdate; 	Read only for the value currently held in the object.
#    $obj->printtime; 	Read only for the value currently held in the object. 12 Hour format, HH:MM format
#    $obj->printtime_12hour; Read only for the value currently held in the object in 12 hour format (HH:MM) with AM | PM appended.
#    $obj->printtime_long; 	Read only for the value currently held in the object. 24 hour format, HH:MM:SS format.
#    $obj->year; 		Read only for the value currently held in the object.
#    $obj->month; 		Read only for the value currently held in the object.
#    $obj->dom; 		Read only for the value currently held in the object.
#    $obj->hour; 		Read only for the value currently held in the object.
#    $obj->minute; 		Read only for the value currently held in the object.
#    $obj->second; 		Read only for the value currently held in the object.
#    $obj->utc; 		Read only for the value currently held in the object. AKA: timegm()
#    $obj->nowtime; 	Read only for the value currently held in the object.
#    $obj->weekday;     Read only for the returns a zero based list starting with Monday.
#    $obj->is_dst;      Read only for the value currently held in the object.
#
#    $obj->m100;  The Swiss Army Knife Method
#
#    	$obj->m100('201010115.162332');
#        	Re-Initializes the object with the M100 value, returns the M100 value
#
#    	$obj->m100('201010115');
#        	Re-Initializes the object with the date and the default time value. Returns the M100 value.
#
#    	$obj->m100('162332');
#        	Re-Initializes the object with the time and the default date values. Returns the M100 value.
#
#       $obj->m100([yyyy\Dmm\Ddd]) OR $obj->m100([mm\Ddd\Dyyyy])
#           Re-Initializes the object with the passed values and returns the M100 value.
#
#    	$obj->m100([year, [month, [dom, [hour, [minute, [second]]]]]]);
#        	Re-Initializes the object with the passed values and returns the M100 value.
#
#    	$obj->m100([val1, [val2, [val3]]]);
#       	#Val 1 > 24  : Re-Initialize the objec with the date values. Returns the M100 value. Time values will be taken from the current value.
#
#    	$obj->m100([val1, [val2, [val3]]]);
#       	#Val 1 <= 24 : Re-initilizes the object with the time values. Returns the M100 value. Date values will be taken from the current value.
#
#    	my $scalar = $obj->M100();
#        	#returns the M100 value. Returns will be from the paremeters currently held in the object.
#
#	$obj->m100_add([value, ['minutes', 'days', 'weeks', 'months', 'years']]);
#       #Will add the number of specified type of time periods to the currently held value. The function returns the m100() format value but
#       #does NOT modify the currently held value.
#
#	$obj->m100_subtract([value, ['days', 'weeks', 'months', 'years']]);
#       #Will subtract the number of specified type of time periods from the currently held value. The function returns the m100() format value but
#       #does NOT modify the currently held value.
#
#   $obj->m100_differenceindays([compare value 1, [optional: compare value 2]]);
#       #Will compare argument 1 against argument 2 and return the number of days in between the two values. The two values must be in m100() format.
#       #If argument 2 is ommitted, then argument 1 will be compared against the currently held time value. It is recommended you explicitly set
#       #the argument rather than rely on the default held value.
#
###########################################################################################################

package M100;
use 5.00;

sub new () {
    my $class = shift;
    my %temp = ();
    $temp{_error} = '';
    $temp{_tz_modifier} = 0;
    $temp{_tz_modifier_setvalue} = 0;
    $temp{_server_differential} = 0;
    $temp{_compvaldate} = '';
    $temp{_compvaltime} = '';
    $temp{_compvalM100} = '';
    $temp{_year} = 0;
    $temp{_month} = 0;
    $temp{_dom} = 0;
    $temp{_hour} = 0;
    $temp{_minute} = 0;
    $temp{_second} = 0;
    $temp{_printdate} = '0000.00.00';
    $temp{_printtime} = '00:00';
    $temp{_printtime_12hour} = '00:00';
    $temp{_printtime_long} = '00:00:00';
    $temp{_initialized} = 0;
    my $self = \%temp;
    bless $self, $class;
    return $self;
}

sub DESTROY {
    my $self = shift;
    foreach(keys %{$self}) {
        delete $self->{$_};
    }
    undef(%$self);
    undef $self;
}

sub local_offset { return $_[0]->_local_offset; }

sub tz_modifier {
    if($_[1]) {
        $_[0]->{_tz_modifier_setvalue} = $_[1];
		$_[0]->{_initialized} = 0;
    }
}

sub epoch {
    if($_[1] > 0) {
        $_[0]->{_epoch} = $_[1];
        $_[0]->_reset;
        $_[0]->_initialize;
    } else {
        $_[0]->_initialize unless $_[0]->{_initialized} == 1;
        return $_[0]->_calculate_epoch;
    }
}

sub error { return $_[0]->{_error}; }
sub compvaldate { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->{_compvaldate}; }
sub compvaltime { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->{_compvaltime}; }
sub printdate { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->{_year} . '.' . $_[0]->_zerofy($_[0]->{_month}) . '.' . $_[0]->_zerofy($_[0]->{_dom}); }
sub printtime { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->_zerofy($_[0]->{_hour}) . ':' . $_[0]->_zerofy($_[0]->{_minute}); }
sub printtime_long { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->_zerofy($_[0]->{_hour}) . ':' . $_[0]->_zerofy($_[0]->{_minute}) . ':' . $_[0]->_zerofy($_[0]->{_second}); }
sub year   { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_year}); }
sub month  { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_month}); }
sub dom    { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_dom}); }
sub hour   { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_hour}); }
sub minute { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_minute}); }
sub second { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_second}); }
sub nowtime { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return abs($_[0]->{_nowtime}); }
sub weekday { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->_weekday; }
sub yearday { $_[0]->_initialize unless $_[0]->{_initialized} == 1; return $_[0]->_yearday; }

sub printtime_12hour {
    $_[0]->_initialize unless $_[0]->{_initialized} == 1; 
    my $h = $_[0]->_zerofy($_[0]->{_hour});
    if($_[0]->{_hour} > 12) {
        $h = $_[0]->_zerofy(12 - $_[0]->{_hour});
    }
    my $hour12 = $h . ':' . $_[0]->_zerofy($_[0]->{_minute}) . ' ';
    $hour12 .= ($_[0]->{_hour} >= 12) ? "pm" : "am";
    return $hour12;
}

sub timestamp {
    $_[0]->_initialize unless $_[0]->{_initialized} == 1;
    my @gmtime_eval = gmtime(time + ((60*60)*$_[0]->{_tz_modifier}));
    my $timestamp = ($gmtime_eval[5] + 1900) . '-' . $_[0]->_zerofy( $gmtime_eval[4]++ ) . '-' . $_[0]->_zerofy( $gmtime_eval[3] ) . 'T' . $_[0]->_zerofy( $gmtime_eval[2] ) . ':' . $_[0]->_zerofy( $gmtime_eval[1] ) . ':' . $_[0]->_zerofy( $gmtime_eval[0] );
    if($_[0]->{_tz_modifier} < 0) {
        $timestamp .= '-';
    } else {
        $timestamp .= '+';
    }
    $timestamp .= $_[0]->_zerofy(abs($_[0]->{_tz_modifier}));
    if($_[0]->{_is_dst}) {
        $timestamp .= ' DST';
    }
    return $timestamp;
}

sub is_dst {
    $_[0]->_initialize unless $_[0]->{_initialized} == 1;
    return $_[0]->_is_dst;
}

sub m100 {
    #This is the Swiss Army Knife method.
    #
    #passed no arguments, it is asking for the currently held value for the M100
    #passed no arugments and wantarray, it is asking for (M100, DateCompval, TimeCompval)
    #
    #  y y y y 1 m m d d . h  h  m  m  s  s
    #  0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
    #
    #  $obj->M100('201010115.162332'); // Passed ONE argument 16 characters long, this sets the value in the object. Return the M100 value.
    #  $obj->M100('201010115');        // Passed ONE argument 9 characters long. Set the date in the object, return the M100 value.
    #  $obj->M100('162332');           // Passed ONE argument 6 characters long. Set the time in the object, return the M100 value.
    #  $obj->M100([year, [month, [dom, [hour, [minute, [second]]]]]]); // Passed self plus six more arguments (seven in total). Create the object values and return the M100.
    #  $obj->M100([val1, [val2, [val3]]]); // Passed self plus three more aguments, first argument greater than 24, these are date values. Create the object values and return the M100.
    #  $obj->M100([val1, [val2, [val3]]]); // Passed self plus three more aguments, first argument less than or equal to 24, these are time values. Create the object values and return the M100.
    #  my $scalar = $obj->M100();      // Asking for the M100 value
    #

    #Now we start returning values.
    if(exists $_[6]) {
        #  $obj->M100([year, [month, [dom, [hour, [minute, [second]]]]]]); // Passed self plus six more arguments (seven in total). Create the object values and return the M100.
        $_[0]->{_year} = $_[1];
        $_[0]->{_month} = $_[0]->_zerofy( $_[2] );
        $_[0]->{_dom} = $_[0]->_zerofy( $_[3] );
        $_[0]->{_hour} = $_[0]->_zerofy( $_[4] );
        $_[0]->{_minute} = $_[0]->_zerofy( $_[5] );
        $_[0]->{_second} = $_[0]->_zerofy( $_[6] );
        $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy( $_[0]->{_dom} );
        $_[0]->{_compvaltime} = $_[0]->_zerofy( $_[4] ) . $_[0]->_zerofy( $_[5] ) . $_[0]->_zerofy( $_[6] );
        $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
        $_[0]->{_is_dst} = $_[0]->_is_dst;
        $_[0]->{_initialized} = 1;
        return $_[0]->{_compvalM100};
    }
    elsif(exists $_[3]) {
        $_[0]->_initialize;
        if($_[1] > 24) {
            #  $obj->M100([val1, [val2, [val3]]]); // Passed self plus three more aguments, first argument greater than 24, these are date values. Create the object values and return the M100.
            $_[0]->{_year} = $_[1];
            $_[0]->{_month} = $_[0]->_zerofy( $_[2] );
            $_[0]->{_dom} = $_[0]->_zerofy( $_[3] );
            $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy( $_[0]->{_dom} );
            $_[0]->{_compvaltime} = $_[0]->_zerofy( $_[0]->{_hour} ) . $_[0]->_zerofy( $_[0]->{_minute} ) . $_[0]->_zerofy( $_[0]->{_second} );
            $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
            $_[0]->{_is_dst} = $_[0]->_is_dst;
            $_[0]->{_initialized} = 1;
            return $_[0]->{_compvalM100};
        } else {
            #  $obj->M100([val1, [val2, [val3]]]); // Passed self plus three more aguments, first argument less than or equal to 24, these are time values. Create the object values and return the M100.
            $_[0]->{_hour} = $_[0]->_zerofy( $_[1] );
            $_[0]->{_minute} = $_[0]->_zerofy( $_[2] );
            $_[0]->{_second} = $_[0]->_zerofy( $_[3] );
            $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy( $_[0]->{_dom} );
            $_[0]->{_compvaltime} = $_[0]->_zerofy( $_[0]->{_hour} ) . $_[0]->_zerofy( $_[0]->{_minute} ) . $_[0]->_zerofy( $_[0]->{_second} );
            $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
            $_[0]->{_is_dst} = $_[0]->_is_dst;
            $_[0]->{_initialized} = 1;
            return $_[0]->{_compvalM100};
        }    
    }
    elsif($_[1] > 0) {
        #the first argument has been passed, we have to figure out now if we are setting a value or retrieving a value. If we are setting a value, this argument will have a length of 16, 9 or 6 only.
        $_[0]->_initialize;
        if(length($_[1]) == 16) {
            my ($c_date, $c_time) = split(/\./, $_[1]);
            $_[0]->{_year} = substr($c_date, 0, 4);
            $_[0]->{_month} = substr($c_date, 5, 2);
            $_[0]->{_month} = $_[0]->_zerofy($_[0]->{_month});
            $_[0]->{_dom} = $_[0]->_zerofy(substr($c_date, 7, 2));
            $_[0]->{_hour} = $_[0]->_zerofy(substr($c_time, 0, 2));
            $_[0]->{_minute} = $_[0]->_zerofy(substr($c_time, 2, 2));
            $_[0]->{_second} = $_[0]->_zerofy(substr($c_time, 4, 2));
            $_[0]->{_compvaldate} = $c_date;
      		$_[0]->{_compvaltime} = $c_time;
            $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
            $_[0]->{_is_dst} = $_[0]->_is_dst;
            $_[0]->{_initialized} = 1;
            return $_[0]->{_compvalM100};
        }
        elsif(length($_[1]) == 10) {
            if($_[1] =~ /^\d\d\d\d\D\d\d\D\d\d$/) {
                $_[0]->{_year} = substr($_[1], 0, 4);
                $_[0]->{_month} = $_[0]->_zerofy(substr($_[1], 5, 2));
                $_[0]->{_dom} = $_[0]->_zerofy(substr($_[1], 8, 2));
                $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy($_[0]->{_dom});
                $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
                $_[0]->{_is_dst} = $_[0]->_is_dst;
                $_[0]->{_initialized} = 1;
                return $_[0]->{_compvalM100};
            }
            elsif($_[1] =~ /^\d\d\D\d\d\D\d\d\d\d$/) {
                $_[0]->{_year} = substr($_[1], 0, 2);
                $_[0]->{_month} = $_[0]->_zerofy(substr($_[1], 3, 2));
                $_[0]->{_dom} = $_[0]->_zerofy(substr($_[1], 6, 2));
                $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy($_[0]->{_dom});
                $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
                $_[0]->{_is_dst} = $_[0]->_is_dst;
                $_[0]->{_initialized} = 1;
                return $_[0]->{_compvalM100};
            }
            elsif($_[1] =~ /^\d\d\d\d\d\d\d\d\d\d/) {
                $_[0]->{_epoch} = $_[1];
                $_[0]->_reset;
                $_[0]->_initialize;
                return $_[0]->{_compvalM100};
            }
        }
        elsif(length($_[1]) == 9) {
            $_[0]->{_compvaldate} = $_[1];
            $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
            $_[0]->{_year} = substr($_[1], 0, 4);
            $_[0]->{_month} = substr($_[1], 5, 2);
            $_[0]->{_month} = $_[0]->_zerofy($_[0]->{_month});
            $_[0]->{_dom} = $_[0]->_zerofy(substr($_[1], 7, 2));
            $_[0]->{_is_dst} = $_[0]->_is_dst;
		    $_[0]->{_initialized} = 1;
            return $_[0]->{_compvalM100};
        }
        elsif(length($_[1]) == 6) {
            $_[0]->{_compvaltime} = $_[1];
            $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
            $_[0]->{_hour} = $_[0]->_zerofy(substr($_[1], 0, 2));
            $_[0]->{_minute} = $_[0]->_zerofy(substr($_[1], 2, 2));
            $_[0]->{_second} = $_[0]->_zerofy(substr($_[1], 4, 2));
		    $_[0]->{_initialized} = 1;
            return $_[0]->{_compvalM100};
        }
    } else {
        # Since no arugments for certain portions of the M100 value require that the value return the defaults, we create the defaults by
        # initializing this objects values based on what was passed previously.
        $_[0]->_initialize unless $_[0]->{_initialized} == 1;
        return $_[0]->{_compvalM100};
    }
}

sub m100_subtract {
    my $subtractvalue = $_[1];
    my $subtracttype = $_[2];
    $subtracttype ||= 'days';
    if($subtractvalue > 0) {
        if($subtracttype eq 'weeks') {
            $subtractvalue = ($subtractvalue * 7);
            $subtracttype = 'days';
        }
		my $finalyear = $_[0]->{_year};
		my $finalmonth = $_[0]->{_month};
		my $finaldom = $_[0]->{_dom};
	    my %monthdays = (1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31);
        if($subtracttype eq 'years') {
            $finalyear -= $subtractvalue;
        }
        elsif($subtracttype eq 'months') {
            if($subtractvalue > 12) {
                my $fullyears = int($subtractvalue / 12);
                $finalyear -= $fullyears;
                $subtractvalue -= ($fullyears * 12);
            }
            if($subtractvalue > $finalmonth) {
                $finalyear -= 1;
                $finalmonth = (12 + $finalmonth) - $subtractvalue;
				if($finalyear % 4 == 0) {
				    $monthdays{2} = 29;
				} else {
				    $monthdays{2} = 28;
				}
                if($finaldom > $monthdays{$finalmonth}) {
                    $finaldom = $monthdays{$finalmonth};
                }
                $subtractvalue = 0;
            }
        	elsif($subtractvalue == $finalmonth) {
                $finalyear -= 1;
                $finalmonth = 12;
				$subtractvalue = 0;
            } else {
                $finalmonth -= $subtractvalue;
                $subtractvalue = 0;
            }
        } else {
            #days
            my $iterator = 0;
			while($subtractvalue > 0) {
				if($finalyear % 4 == 0) {
				    $monthdays{2} = 29;
				} else {
				    $monthdays{2} = 28;
				}
			    if($finaldom == 1) {
			        if($finalmonth == 1) {
			            $finalyear -= 1;
			            $finalmonth = 12;
			            $finaldom = 31;
			            $subtractvalue -= 1;
			        } else {
			            $finalmonth -= 1;
			            $finaldom = $monthdays{$finalmonth};
			            $subtractvalue -= 1;
			        }
			    } else {
			        $finaldom -= 1;
			        $subtractvalue -= 1;
			    }
				$iterator++;
				if($iterator > 100000) {
				    exit;
				}
			}
        }
		if(length($finaldom) < 2) {
		    $finaldom = '0' . $finaldom;
		}
		my $retvalue = $finalyear . ($finalmonth + 100) . $finaldom . '.' . $_[0]->{_compvaltime};
		return $retvalue;
    } else {
        $_[0]->{_error} = 'Null value provided.';
        return 0;
    }
}

sub m100_add {
    my $addvalue = $_[1];
    my $addtype = $_[2];
    $addtype ||= 'days';
    if($addvalue > 0) {
        if($addtype eq 'weeks') {
            $addvalue = ($addvalue * 7);
            $addtype = 'days';
        }
		my $finalyear = abs($_[0]->{_year});
		my $finalmonth = abs($_[0]->{_month});
		my $finaldom = abs($_[0]->{_dom});
		
		my $finalhour = abs($_[0]->{_hour});
		my $finalminute = abs($_[0]->{_minute});
		my $finalsecond = abs($_[0]->{_second});

	    my %monthdays = (1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31);
        if($addtype eq 'years') {
            $finalyear += $addvalue;
        }
        elsif($addtype eq 'months') {
            if($addvalue > 12) {
                my $fullyears = int($addvalue / 12);
                $finalyear += $fullyears;
                $addvalue -= ($fullyears * 12);
            }
            if(($addvalue + $finalmonth) > 12) {
                $finalyear += 1;
                $finalmonth = ($finalmonth + $addvalue) - 12;
				if($finalyear % 4 == 0) {
				    $monthdays{2} = 29;
				} else {
				    $monthdays{2} = 28;
				}
                if($finaldom > $monthdays{$finalmonth}) {
                    $finaldom = $monthdays{$finalmonth};
                }
                $addvalue = 0;

            } else {
                $finalmonth += $addvalue;
                $addvalue = 0;
            }
        }
        elsif($addtype eq 'minutes') {
			if($addvalue > 60) {
			    exit;
			}
            $finalminute += $addvalue;
            if($finalminute > 59) {
                $finalminute = $finalminute - 60;
                $finalhour = $finalhour + 1;
                if($finalhour > 23) {
					if($finalyear % 4 == 0) {
					    $monthdays{2} = 29;
					} else {
					    $monthdays{2} = 28;
					}
				    if($finaldom == $monthdays{$finalmonth}) {
				        $finaldom = 1;
				        if($finalmonth == 12) {
				            $finalmonth = 1;
				            $finalyear += 1;
				        } else {
				            $finalmonth += 1;
				        }
				    } else {
				        $finaldom += 1;
				    }
                }
            }
        } else {
            #days
            my $iterator = 0;
			while($addvalue > 0) {
				if($finalyear % 4 == 0) {
				    $monthdays{2} = 29;
				} else {
				    $monthdays{2} = 28;
				}
			    if($finaldom == $monthdays{$finalmonth}) {
			        $finaldom = 1;
			        if($finalmonth == 12) {
			            $finalmonth = 1;
			            $finalyear += 1;
			        } else {
			            $finalmonth += 1;
			        }
			    } else {
			        $finaldom += 1;
			    }
			    $addvalue -= 1;
				$iterator++;
				if($iterator > 100000) {
				    exit;
				}
			}
        }
		if(length($finaldom) < 2) {
		    $finaldom = '0' . $finaldom;
		}
		if(length($finalhour) < 2) {
		    $finalhour = '0' . $finalhour;
		}
		if(length($finalminute) < 2) {
		    $finalminute = '0' . $finalminute;
		}
		if(length($finalsecond) < 2) {
		    $finalsecond = '0' . $finalsecond;
		}
		my $retvalue = $finalyear . ($finalmonth + 100) . $finaldom . '.' . $finalhour . $finalminute . $finalsecond;
		return $retvalue;
    } else {
        $_[0]->{_error} = 'Null value provided.';
        return 0;
    }
}

sub m100_differenceindays {
    #If one orgument is passed, we look at the argument vs the stored value. If two arguments are passed, we compare the two arguments and do change the current value
    my ($value1, $value2);
    if($_[1] > 0) {
        $value1 = $_[1];
	    if($_[2]) {
	        $value2 = $_[2];
	    } else {
	        $_[0]->_initialize unless $_[0]->{_compvalM100};
	        $value2 = $_[0]->{_compvalM100};
	    }
	    #if($value1 > $value2) {
	    #    my $temp_holder = $value1;
	    #    $value1 = $value2;
	    #    $value2 = $temp_holder;
	    #}
	    if($value1 && $value2) {
			my %monthdays_low = (1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31);
			my %monthdays_high = (1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31);
			my ($highyear, $highmonth, $highdom, $highhour, $lowyear, $lowmonth, $lowdom, $lowhour, $highisleapyear, $lowisleapyear, $returnvalue);
	        if($value1 == $value2) {
	            $returnvalue = 0;
	        }
			elsif($value1 > $value2) {
				$_[0]->_initialize;
				my $nd = $_[0]->m100($value2);
			    $lowyear = $_[0]->year;
			    $lowmonth = $_[0]->month;
			    $lowdom = $_[0]->dom;
			    $lowhour = $_[0]->hour;
				if($lowyear % 4 == 0) {
				    $lowisleapyear = 1;
				    $monthdays_low{2} = 29;
				} else {
				    $lowisleapyear = 0;
				}
				$_[0]->_initialize;
				$nd = $_[0]->m100($value1);
				$highyear = $_[0]->year;
				$highmonth = $_[0]->month;
				$highdom = $_[0]->dom;
				$highhour = $_[0]->hour;
				if($highyear % 4 == 0) {
				    $highisleapyear = 1;
				    $monthdays_high{2} = 29;
				} else {
				    $highisleapyear = 0;
				}
		
			} else {
				$_[0]->_initialize;
				my $nd = $_[0]->m100($value1);
			    $lowyear = $_[0]->year;
			    $lowmonth = $_[0]->month;
			    $lowdom = $_[0]->dom;
			    $lowhour = $_[0]->hour;
				if($lowyear % 4 == 0) {
				    $lowisleapyear = 1;
				    $monthdays_low{2} = 29;
				} else {
				    $lowisleapyear = 0;
				}
				$_[0]->_initialize;
				$nd = $_[0]->m100($value2);
				$highyear = $_[0]->year;
				$highmonth = $_[0]->month;
				$highdom = $_[0]->dom;
				$highhour = $_[0]->hour;
				if($highyear % 4 == 0) {
				    $highisleapyear = 1;
				    $monthdays_high{2} = 29;
				} else {
				    $highisleapyear = 0;
				}
			}
			if($lowyear == $highyear) {
			    if($lowmonth == $highmonth) {
			        #If the year and the month are the same, then the high day MUST be higher than the low day. This is the only condition where this MUST be true.
					$returnvalue = $highdom - $lowdom;
			    } else {
			        #Since we are in the SAME year, we count the difference between daysinmonth and lowdom (lowerdate) and add the number of days in $highdom (the later month)
			        #for example, May 5th and June 19th we would get 45 = (31 - 5) + 19;
			        $returnvalue = ($monthdays_low{$lowmonth} - $lowdom) + $highdom;
					#Now we add the number of days in the months in between the months. Since we are in the same year and month and the months are not the same, low month can not
					#be any higher than 11 and the high month can not be any lower than 2. But to keep it simple, we ONLY execute this if the difference between months is
					#more than one month. Also, to note, if it is a leap year then it is a leap year for both high and low years as this is the same year.
					#Because the high DATE month might actually be LESS than the low DATE month, we need to test to see if it is high to do the math right. This is the ONLY
					#place that a greater than-less than comparison on the months is valid
					if($highmonth > $lowmonth) {
						if( ($highmonth - $lowmonth) > 1) {
						    for( my $a = $lowmonth + 1; $a < $highmonth; $a++) {
								$returnvalue += $monthdays_low{$a};
							}
						}
					} else {
					    #same as above but reveresed
						if( ($lowmonth - $highmonth) > 1) {
						    for( my $a = $highmonth + 1; $a < $lowmonth; $a++) {
								$returnvalue += $monthdays_high{$a};
							}
						}
					}
			    }
			} else {
#print qq~
#\$highyear => $highyear<br>
#\$highmonth => $highmonth<br>
#\$highdom => $highdom<br><br>
#\$lowyear => $lowyear<br>
#\$lowmonth => $lowmonth<br>
#\$lowdom => $lowdom<br>
#~;
			    #First we will add the number of days in the years in between the high and low year IF we are more than one year apart
			    if(($highyear - $lowyear) > 1) {
			        for(my $a = $lowyear + 1; $a < $highyear; $a++) {
			            $returnvalue += 365;
			            if($a % 4 == 0) {
			                $returnvalue += 1;
			            }
			        }
			    }
			    #Since we are NOT in the same year, we count the number of days remaining in the low year AND add the number of days in the high year. We have to do this by
			    #iterating through the number of days in each month of the low year following the low month and iterating through each month in the high year prior to the
			    #high month. If these are Dec and Jan respectively, we just count the number of days remaining or up to in the months. Start with the low year months
			    if($lowmonth == 12) {
			        $returnvalue += (31 - $lowdom);
			    } else {
			        for(my $a = $lowmonth + 1; $a <= 12; $a++) {
			            $returnvalue += $monthdays_low{$a};
			        }
			        $returnvalue += ($monthdays_low{$lowmonth} - $lowdom);
			    }
			    if($highmonth == 1) {
			        $returnvalue += $highdom;
			    } else {
			        for(my $a = 1; $a < $highmonth; $a++) {
			            $returnvalue += $monthdays_high{$a};
			        }
			        $returnvalue += $highdom;
			    }
			}
			$_[0]->_initialize;

		    return $returnvalue;

		} else {
		    return '';
		}
	} else {
	    return '';
	}
}

sub m100_differenceinhms {
	#KNOWN BUG
	#COMPARING THIS TWO TIMES "201411027.080236", "201411027.081235"
	#RETURNS:
	#    Hours: 0
	#    Minutes: 10    -> Should be 09
	#    Seconds: 59

    #If one orgument is passed, we look at the argument vs the stored value. If two arguments are passed, we compare the two arguments and do change the current value
    my ($value1, $value2);
    if($_[1] > 0) {
        $value1 = $_[1];
	    if($_[2]) {
	        $value2 = $_[2];
	    } else {
	        $_[0]->_initialize unless $_[0]->{_compvalM100};
	        $value2 = $_[0]->{_compvalM100};
	    }
	    #Test and correct, we always need value2 to be later than value1
	    if($value1 > $value2) {
	        my $temp_holder = $value1;
	        $value1 = $value2;
	        $value2 = $temp_holder;
	    }
	    if($value1 && $value2) {
	        my $time_seconds = 0;
	        my $time_minutes = 0;
	        my $time_hours = 0;
			$_[0]->_initialize;
			my $v1 = $_[0]->m100($value1);
			my $year1 = $_[0]->year;
			my $month1 = $_[0]->month;
			my $dom1 = $_[0]->dom;
            my $hour1 = $_[0]->hour;
            my $minute1 = $_[0]->minute;
            my $second1 = $_[0]->second;
			$_[0]->_initialize;
			my $v2 = $_[0]->m100($value2);
			my $year2 = $_[0]->year;
			my $month2 = $_[0]->month;
			my $dom2 = $_[0]->dom;
            my $hour2 = $_[0]->hour;
            my $minute2 = $_[0]->minute;
            my $second2 = $_[0]->second;
			#Mintues and seconds are irrelevant of the hour or DOM.
            if($minute2 > $minute1) {
                $time_minutes = $minute2 - $minute1;
            }
            elsif($minute2 < $minute1) {
                $time_minutes = $minute2;
                $time_minutes += (60 - $minute1);
            } else {
                #Minutes are the same so not counted
            	1;
            }
            if($second2 > $second1) {
                $time_seconds = $second2 - $second1;
            }
            elsif($second2 < $second1) {
                $time_seconds = $second2;
                $time_seconds += (60 - $second1);
            } else {
                #Seconds are the same so not counted
            	1;
            }
            if( ($year1 == $year2) && ($month1 == $month2) && ($dom1 == $dom2) ) {
                #Two dates are the SAME DAY so hour1 can not be higher than hour2
                #second hour comes after first hour so just calculate the difference
                #M100 hours are 24 hours so math is straightforward.
                $time_hours += $hour2 - $hour1;
                if($minute2 < $minute1) {
                    #If minute2 is less than minute1, then a full hour has not completed so reduce by one hour
                    $time_hours--;
                }
                if($time_hours < 0) {
                    $time_hours = 0;
                }
            } else {
                my %dominmonth1 = (1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31);
                if($_[0]->_isaleapyear($year1)) {
                    $dominmonth1{2} = 29;
                }
                my %dominmonth2 = (1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31);
                if($_[0]->_isaleapyear($year2)) {
                    $dominmonth2{2} = 29;
                }
                if( ($year1 == $year2) && ($month1 == $month2) ) {
                    #Hours remaining in first day
                    #Hours in second day
                    #Hours in any day in betwween
            		$time_hours = 24 - $hour1;
            		$time_hours += $hour2;
            		if( ($dom2 - $dom1) > 1) {
            		    $time_hours += (($dom2 - $dom1) - 1) * 24;
            		}
	                if($minute2 < $minute1) {
	                    #If minute2 is less than minute1, then a full hour has not completed so reduce by one hour
	                    $time_hours--;
	                }
	                if($time_hours < 0) {
	                    $time_hours = 0;
	                }
                }
                elsif( ($year1 == $year2) ) {
    	            #Hours remaining in first day
    	            #Hours in second day
    	            #Days * 24 remaining in first month
    	            #Days prior to second day in second month
    	            #Days in any month in between
            		$time_hours = 24 - $hour1;
            		$time_hours += (24 * (($dominmonth1{$month1} - $dom1) - 1));
            		if( ($month2 - $month1) > 1) {
            		    for($c = ($month1 + 1); $c < $month2; $c++) {
            		        $time_hours += (24 * $dominmonth1{$c});
            		    }
            		}
                    if($dom2 > 1) {
                        $time_hours += (24 * ($dom2 - 1));
                    }
                    $time_hours += $hour2;
	                if($minute2 < $minute1) {
	                    #If minute2 is less than minute1, then a full hour has not completed so reduce by one hour
	                    $time_hours--;
	                }
	                if($time_hours < 0) {
	                    $time_hours = 0;
	                }
                } else {
            		$time_hours = (24 * (($dominmonth1{$month1} - $dom1) - 1));
					if($month1 < 12) {
            		    for(my $c = ($month1 + 1); $c <= 12; $c++) {
            		        $time_hours += (24 * $dominmonth1{$c});
            		    }
            		}
            		if( ($year2 - $year1) > 1) {
						for(my $c = ($year1 + 1); $c < $year2; $c++) {
							if($_[0]->_isaleapyear($c)) {
							    $time_hours += (366 * 24);
							} else {
							    $time_hours += (365 * 24);
							}
						}
					}
            		if($month2 > 1) {
            		    for(my $c = 1; $c < $month2; $c++) {
            		        $time_hours += (24 * $dominmonth2{$c});
            		    }
            		}
                    if($dom2 > 1) {
                        $time_hours += (24 * ($dom2 - 1));
                    }
                    $time_hours += $hour2;
                    if(abs($minute1) > 0) {
            		    $time_hours += (24 - $hour1) - 1;
            		} else {
            		    #If hour is zero AND minutes are zero, then we add a full day
            		    $time_hours += (24 - $hour1);
            		}
	                if($minute2 < $minute1) {
	                    #If minute2 is less than minute1, then a full hour has not completed so reduce by one hour
	                    $time_hours--;
	                }
	                if($time_hours < 0) {
	                    $time_hours = 0;
	                }
                }
            }
            #return wantarray ? ($time_hours,$time_minutes,$time_seconds) : qq~$time_hours,$time_minutes,$time_seconds~;
            return $_[0]->_zerofy($time_hours) . ':' . $_[0]->_zerofy($time_minutes) . ':' . $_[0]->_zerofy($time_seconds);
		} else {
		    return '';
		}
	} else {
	    return '';
	}
}

sub convert_hours_and_minutes_to_decimal {
    my $hours = $_[1];
    my $minutes = $_[2];
    my $temp = 0;
    if($hours || $minutes) {
        $temp = $hours;
        if($minutes > 0) {
            $temp += sprintf("%.2f", ($minutes / 60));
        }
    }
    return sprintf("%.2f", $temp);
}

sub reset { $_[0]->_initialize; }

sub _zerofy {
    if(abs($_[1]) < 10) {
        return '0' . abs($_[1]);
    } else {
        return $_[1];
    }
}

sub _initialize {
    $_[0]->_reset;
    #We need tz modifier before we evaluate nowtime.
    $_[0]->{_tz_modifier} = $_[0]->_local_offset;
    $_[0]->{_tz_modifier} = $_[0]->{_tz_modifier_setvalue} if $_[0]->{_tz_modifier_setvalue} ne '';
    $_[0]->_nowtime;
    my @time_eval = gmtime($_[0]->{_nowtime});
    $_[0]->{_second} = $time_eval[0];
    $_[0]->{_minute} = $time_eval[1];
    $_[0]->{_hour} = $time_eval[2];
    $_[0]->{_dom} = $time_eval[3];
    $_[0]->{_month} = $time_eval[4];
    $_[0]->{_year} = $time_eval[5];
    $_[0]->{_year} = $_[0]->_zerofy( $_[0]->{_year} + 1900 );
    $_[0]->{_month} = $_[0]->_zerofy( $_[0]->{_month} + 1 );
    $_[0]->{_dom} = $_[0]->_zerofy( $_[0]->{_dom});
    $_[0]->{_hour} = $_[0]->_zerofy( $_[0]->{_hour});
    $_[0]->{_minute} = $_[0]->_zerofy( $_[0]->{_minute});
    $_[0]->{_second} = $_[0]->_zerofy( $_[0]->{_second});
    $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy( $_[0]->{_dom} );
    $_[0]->{_compvaltime} = $_[0]->_zerofy( $_[0]->{_hour} ) . $_[0]->_zerofy( $_[0]->{_minute} ) . $_[0]->_zerofy( $_[0]->{_second} );
    $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
    $_[0]->{_is_dst} = $_[0]->_is_dst;
    if($_[0]->{_is_dst}) {
        #Because DST is in effect, we have to recalculate. Unfortunately, we can't properly asses DST until the above in this function is completed.
        #It seems wasteful, but its the only way to do it.
        if($_[0]->{_tz_modifier} > 0) {
            $_[0]->{_tz_modifier} -= 1;
        }
        elsif($_[0]->{_tz_modifier} < 0) {
            $_[0]->{_tz_modifier} += 1;
        }
        #Reinitialize _nowtime
        $_[0]->_nowtime;
        my @time_eval = gmtime($_[0]->{_nowtime});
        $_[0]->{_second} = $time_eval[0];
        $_[0]->{_minute} = $time_eval[1];
        $_[0]->{_hour} = $time_eval[2];
        $_[0]->{_dom} = $time_eval[3];
        $_[0]->{_month} = $time_eval[4];
        $_[0]->{_year} = $time_eval[5];
        $_[0]->{_year} = $_[0]->_zerofy( $_[0]->{_year} + 1900 );
        $_[0]->{_month} = $_[0]->_zerofy( $_[0]->{_month} + 1 );
        $_[0]->{_dom} = $_[0]->_zerofy( $_[0]->{_dom});
        $_[0]->{_hour} = $_[0]->_zerofy( $_[0]->{_hour});
        $_[0]->{_minute} = $_[0]->_zerofy( $_[0]->{_minute});
        $_[0]->{_second} = $_[0]->_zerofy( $_[0]->{_second});
        $_[0]->{_compvaldate} = $_[0]->{_year} . (100 + abs($_[0]->{_month})) . $_[0]->_zerofy( $_[0]->{_dom} );
        $_[0]->{_compvaltime} = $_[0]->_zerofy( $_[0]->{_hour} ) . $_[0]->_zerofy( $_[0]->{_minute} ) . $_[0]->_zerofy( $_[0]->{_second} );
        $_[0]->{_compvalM100} = $_[0]->{_compvaldate} . '.' . $_[0]->{_compvaltime};
    }
    $_[0]->{_initialized} = 1;
}

sub _reset {
    #Does not set differential or time zone
    $_[0]->{_year} = 0;
    $_[0]->{_month} = 0;
    $_[0]->{_dom} = 0;
    $_[0]->{_hour} = 0;
    $_[0]->{_minute} = 0;
    $_[0]->{_second} = 0;
    $_[0]->{_compvaldate} = 0;
    $_[0]->{_compvaltime} = 0;
    $_[0]->{_compvalM100} = 0;
    $_[0]->{_nowtime} = 0;
    $_[0]->{_is_dst} = 0;
    $_[0]->{_tz_modifier} = 0;
    $_[0]->{_error} = '';
    $_[0]->{_initialized} = 0;
}

sub _nowtime {
    if($_[0]->{_epoch} > 0) {
        $_[0]->{_nowtime} = $_[0]->{_epoch};
    } else {
        $_[0]->{_nowtime} = time;
    }
    if($_[0]->{_tz_modifier}) {
        if($_[0]->{_tz_modifier} > 0) {
            $_[0]->{_nowtime} += (abs($_[0]->{_tz_modifier}) * (60 * 60));
		}
        elsif($_[0]->{_tz_modifier} < 0) {
            $_[0]->{_nowtime} -= (abs($_[0]->{_tz_modifier}) * (60 * 60));
        }
    }
}

sub _local_offset {
    my @gmtime_value = gmtime(time);
    my @localtime_value = localtime(time);
    my $local_offset;
    my $direction;
    if( ($gmtime_value[7] == $localtime_value[7]) && ($gmtime_value[2] == $localtime_value[2]) ) {
       $local_offset = 0;
    } else {
        if($gmtime_value[7] != $localtime_value[7]) {
	        if($gmtime_value[7] > $localtime_value[7]) {
	            $local_offset = 0 - ($gmtime_value[2] + (24 - $localtime_value[2]));
	        } else {
	            $local_offset = $localtime_value[2] + (24 - $gmtime_value[2]);
	        }
	    } else {
	        $local_offset = (abs($gmtime_value[2]) - abs($localtime_value[2]));
	        if($gmtime_value[2] > $localtime_value[2]) {
	            $local_offset = 0 - $local_offset;
	        }     
	    }
    }
    return ($local_offset);
}

sub _isaleapyear {
    my $self = shift;
    my $test = shift;
    $test ||= $self->{_year};
    my $returnvalue = 0;
    if($test % 4 == 0) {
        if(int(substr($test, 2)) == 0) {
            if($test % 100 == 0) {
                if($test % 400 == 0) {
                    $returnvalue = 1;
                }
            }
        } else {
            $returnvalue = 1;
        }
    }
    return $returnvalue;
}

sub _weekday {
    #http://mathforum.org/dr.math/faq/faq.calendar.html
    #Step 1: Last 2 digits of the year
    #Step 2: Divide by 4 and drop any remainder.
    #Step 3: Add the day of the month.
    #Step 4: add the months key
    #Step 5: If the date is in January or February of a leap year, subtract 1
    #Step 6: Add the century code, for the 2000's this is 6
    #Step 7: Add the last two digits of the year
    #Step 8: Divide by 7 and take the remainder. Result is zero-based starting at Saturday.
    #
    my $retvalue = 0;
    my @month_key = (1,4,4,0,2,5,0,3,6,1,4,6);
    $retvalue = int(abs(substr($_[0]->{_year}, 2, 2)) / 4) + abs($_[0]->{_dom}) + $month_key[$_[0]->{_month} - 1] + 6 + substr($_[0]->{_year}, 2, 2);
    #Step 5:
    if($_[0]->_isaleapyear($_[0]->{_year})) {
        if($_[0]->{_month} <= 2) {
            $retvalue -= 1;
        }
    }
    $retvalue = $retvalue % 7;
    #Return a zero based list starting on Monday
    my @returnvalue = (3,4,5,6,0,1,2);
    return $returnvalue[$retvalue];
}

sub _yearday {
    my $retvalue = 0;
    if(abs($_[0]->{_month}) == 1) {
        return abs($_[0]->{_dom});
    } else {
        my @monthdays = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
        if($_[0]->_isaleapyear($_[0]->{_year})) {
            $monthdays[1] = 29;
        }
        for(my $month = 1; $month < abs($_[0]->{_month}); $month++) {
            $retvalue += $monthdays[$month - 1];
        }
        $retvalue += abs($_[0]->{_dom});
        return $retvalue;
    }
}

sub _is_dst {
    #Forces user localization over server localization
    #For more information on calculation of DST in other locations, see: https://en.wikipedia.org/wiki/Daylight_saving_time_by_country
    #$obj->IsDST();
    #$obj->IsDST([location name]);
    my $self = shift;
    my $location = shift;
    $location ||= "North America";
    if($self->{_year} && $self->{_month} && $self->{_dom}) {
        my $results = 0;
        my $start_m100;
        my $end_m100;
        if($location eq "North America") {
            #Canada and USA (except Arizona and Hawaii)
            #   Some regions in Quebec, east of 63° west longitude, most of Saskatchewan, and some areas in British Columbia and
            #   Nunavut (Southampton Island) do not observe DST. Saskatchewan, however, observes Central Time even though it is
            #   located in the Mountain Time Zone, meaning it effectively observes DST year round.
            #
            #USA
            #   Arizona (except the Navajo Nation Community) and Hawaii do not use DST.
            #
            #Start: 2nd Sunday in March ;  (Day of Month = 14 - (1+Y*5/4) Mod 7)
            #End:   1st Sunday in November; (Day of Month = 7 - (1 + 5*Y/4) Mod 7)
            $start_m100 = $self->{_year} . '103' . $self->_zerofy( $self->_nth_weekday_of_the_month(6, 2, $self->{_year}, 3) );
            $end_m100 = $self->{_year} . '111' . $self->_zerofy( $self->_nth_weekday_of_the_month(6, 1, $self->{_year}, 11) );
        }
        elsif($location eq "Mexico") {
            #Mexico
            #   Has observed DST since 1996, but Baja California has observed DST since 1942. Sonora discontinued the
            #   observance in 1997 and Quintana Roo in 2014. Locations less than 20 km from the US border use US DST.
            #Start: 1st Sunday in April ;  (Day of Month = 1 + (2+6*Y-Y/4) mod 7)
            #End:   Last Sunday in October; (Day of Month = 31 - (1 + 5*Y/4) mod 7)
            $start_m100 = $self->{_year} . '104' . $self->_zerofy( $self->_nth_weekday_of_the_month(6, 1, $self->{_year}, 4) );
            $end_m100 = $self->{_year} . '110' . $self->_zerofy( $self->_nth_weekday_of_the_month(6, 5, $self->{_year}, 10) );
        }
        elsif($location eq "Europe") {
            #Europe (not all countries, see: https://en.wikipedia.org/wiki/Daylight_saving_time_by_country)
            #Start: Last Sunday in March ;  (Day of Month = 31 - (4+ 5*Y/4 ) mod 7)
            #End:   Last Sunday in October; (Day of Month = 31 - (1 + 5*Y/4) mod 7)
            $start_m100 = $self->{_year} . '103' . $self->_zerofy( $self->_nth_weekday_of_the_month(6, 5, $self->{_year}, 3) );
            $end_m100 = $self->{_year} . '110' . $self->_zerofy( $self->_nth_weekday_of_the_month(6, 5, $self->{_year}, 10) );
        } else {
            return '';
        }
        if( ($self->{_compvaldate} >= $start_m100) && ($self->{_compvaldate} <= $end_m100) ) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return '';
    }
}


sub _nth_weekday_of_the_month {
    #$obj->nth_weekday_of_the_month([interger dow-Monday as 0], [integer nth], [year], [month]);
    #http://sqllessons.com/second_tuesday_of_the_month.html
    $_[0]->_initialize unless $_[0]->{_compvalM100};
    if( $_[1] && $_[2] ) {
        my $dow = $_[1];
        if($dow =~ /[a-zA-Z]/) {
            my $dn = uc(substr($dow, 0, 3));
            $dow = ($dn eq 'MON') ? 0 : ($dn eq 'TUE') ? 1 : ($dn eq 'WED') ? 2 : ($dn eq 'THU') ? 3 : ($dn eq 'FRI') ? 4 : ($dn eq 'SAT') ? 5 : 6;
        }
        my $first_weekday = $_[0]->_day_of_week_by_date($_[0]->{_year}, $_[0]->{_month}, 1);
        my %first_factor = (
            1 => [1, 2, 3, 4, 5, 6, 7], #Monday
            2 => [7, 1, 2, 3, 4, 5, 6], #Tuesday
            3 => [6, 7, 1, 2, 3, 4, 5], #Wendesday
            4 => [5, 6, 7, 1, 2, 3, 4], #Thursday
            5 => [4, 5, 6, 7, 1, 2, 3], #Friday
            6 => [3, 4, 5, 6, 7, 1, 2], #Saturday
            7 => [2, 3, 4, 5, 6, 7, 1], #Sunday
        );
           #FD   #M  T  W  Th F  Sa Su
        my $return_value;
        if($_[2] > 1) {
            $return_value = $first_factor{$first_weekday + 1}[$dow] + (($_[2] - 1) * 7);
            if($return_value > $_[0]->_days_in_month($_[0]->{_year}, $_[0]->{_month})) {
                $return_value = $first_factor{$first_weekday + 1}[$dow] + (($_[2] - 2) * 7);
            }
        } else {
            $return_value = $first_factor{$first_weekday + 1}[$dow];
        }
        return $return_value;
    } else {
        return '';
    }
}

sub _days_in_month {
    if($_[0]->_isaleapyear($_[1]) && ($_[2] == 2)) {
        return 29;
    } else {
        my @daysinmonth = ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
        return $daysinmonth[$_[2] - 1];
    }
}

sub _day_of_week_by_date {
    #Arithmetic formula by Kim Larson, downloaded from: http://collaboration.cmc.ec.gc.ca/science/rpn/biblio/ddj/Website/articles/DDJ/1995/9504/9504k/9504k.htm
    #and http://www.databasesql.info/article/7252333046/
    #Monday = 0
    $_[0]->_initialize unless $_[0]->{_compvalM100};
    if($_[0]->_is_julian($_[1], $_[2], $_[3])) {
        #Cannot compute weekdays in the Julian Calendar in day_of_week_by_date().
        return -1;
    } else {
        my $calc_year = $_[1];
        my $calc_month = $_[2];
        if($calc_month <= 2) {
            $calc_month += 12;
            $calc_year--;
        }
        return (($_[3] + (2 * $calc_month) + (3 * int($calc_month + 1)/5) + $calc_year + int($calc_year/4) - int($calc_year/100) + int($calc_year/400)) % 7);
    }
}

sub _is_julian {
    if($_[1] < 1582) {
        return 1;
    }
    elsif($_[1] > 1582) {
        return 0;
    } else {
        if($_[2] < 10) {
            return 1;
        }
        elsif($_[2] > 10) {
            return 0;
        } else {
            if($_[3] < 15) {
                return 1;
            } else {
                return 0;
            }
        }
    }
}

sub _calculate_epoch {
    my $epoch;
    if($_[0]->{_year} > 1970) {
        for(my $c = 1970; $c < $_[0]->{_year}; $c++) {
            if($_[0]->_isaleapyear($c)) {
                $epoch += 31622400;
            } else {
                $epoch += 31536000;
            }
        }
    }
    if(abs($_[0]->{_month}) >= 1) {
        for(my $c = 1; $c < abs($_[0]->{_month}); $c++) {
            $epoch += (86400 * $_[0]->_days_in_month($_[0]->{_year}, $c));
        }
    }
    if(abs($_[0]->{_dom}) >= 1) {
        for(my $c = 1; $c < abs($_[0]->{_dom}); $c++) {
            $epoch += 86400;
        }
    }
    if(abs($_[0]->{_hour}) >= 1) {
        $epoch += (3600 * abs($_[0]->{_hour}));
    }
    if(abs($_[0]->{_minute}) >= 1) {
        $epoch += (60 * abs($_[0]->{_minute}));
    }
    $epoch += abs($_[0]->{_second});
    return $epoch;
}



1;
