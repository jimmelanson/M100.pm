#!/usr/bin/perl

#BEGIN {
#    $| = 1;
#    open(STDERR, ">&STDOUT");
#    print "Content-type: text/html\n\n<pre>\n";
#}


#	Requirements:		UNIX Server, Perl5+, CGI.pm
#	Created:		September 22nd, 2000
#	Author: 		Jim Melanson

use CGI;
use M100;

my $q = CGI->new;

my $print_tv = $q->param('timevalue');
my $m100 = M100->new;
$m100->tz_modifier('-5');
$print_tv ||= $m100->printdate;


%qs = ();
my @qs_pairs = split(/\&/, $ENV{'QUERY_STRING'});
foreach my $qs_pair (@qs_pairs) {
    my($qs_key, $qs_value) = split(/\=/, $qs_pair);
    $qs{$qs_key} = $qs_value;
}
undef @qs_pairs;
delete $qs{pid};

my @weekdayname = ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

my $ScriptURL = qq~https://$ENV{'SERVER_NAME'}$ENV{'SCRIPT_NAME'}~;

print "Content-cache: no-cache\nContent-type: text/html\n\n";
print qq~<!DOCTYPE html>
<html>
<head>
  <title>Perl Demo: M100.pm</title>
  <link rel="stylesheet" type="text/css" href="https://www.jimmelanson.ca/css/flexbox.css">
  <link rel="stylesheet" type="text/css" href="https://www.jimmelanson.ca/css/programming_blog.css">
</head>
<body>
<div class="main-page">
  <header>
    <div class="header-container">
      <label class="item-title">
        Perl Demo: M100.pm
      </label>
      <label class="item-user">
        from Ninja Kitty
      </label>
    </div>
  </header>
  <br /><br />
  <div class="indexpage-container1">
    <div class="indexpage-container1-stuff">
      <div>

        Enter a date in any of these formats:
        <br /><br />
        
        yyyy.mm.dd, yyyymmdd, epoch time (10 digits)
        <br />Time zone results based on Toronto, ON (Same as New York, NY)

        <br /><br />
        <form method="post" action="$ScriptURL?pid=$$" >
        <input type="text" name="timevalue" class="admin-input-text" value="$print_tv" style="width:100px;">
        <br /><br />
        <input type="submit" value="Submit" class="admin-button-normal" />
        </form>
        <br /><br />
~;
#Now I am printing out all the files that were uploaded.

if($print_tv) {
    my $original_m100 = $m100->m100($print_tv);
    print qq~
        <div>
        <table class="admin-table">
          <tr>
            <td colspan="2" style="text-align:left;font-family:consolas,courier new;font-weight:bold;">use M100;<br />\$obj = M100->new;<br />\$obj->tz_modifier(-5);<br />\$obj->m100("$print_tv");</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">This is all it takes to initialize the object, then pass the date. I'd normally pass it as a variable. I printed it out just for clarity. This demo is using the localtime of the server as the time, but you can specify the time as well.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->local_offset</td>
            <td style="text-align:left;">~, $m100->local_offset, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Difference between the server and UTC.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->epoch</td>
            <td style="text-align:left;">~, $m100->epoch, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">The current epoch time as calculated from the modified time in the object. You can also pass an epoch time to the object with this method.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->nowtime</td>
            <td style="text-align:left;">~, $m100->nowtime, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">The current UNIX timestamp modified by tz_modifier() and is_dst()</td.
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->timestamp</td>
            <td style="text-align:left;">~, $m100->timestamp, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Classic timestamp format. NOTE: This always uses the current time (modified by tz_modifier) and not the date or time passed to the object.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->m100</td>
            <td style="text-align:left;">~, $m100->m100, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">This is the value used for comparisons, stores date time as human readable: <tt>yyyy1mmdd.hhmmss</tt></td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->weekday</td>
            <td style="text-align:left;">~, $m100->weekday, ' (', $weekdayname[$m100->weekday], qq~)</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Returns a 0 based list starting with Monday.
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->is_dst</td>
            <td style="text-align:left;">~, $m100->is_dst;
                if($m100->is_dst == 1) {
                    print qq~ &there4; tz_modifier evaluates as ~, $m100->{_tz_modifier};
                }
            print qq~
            </td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">You can calculate DST for North America, Mexico, and Europe. It is calculated based on <tt>y/m/d</tt> and not the unreliable (for DST) <tt>localtime()</tt> array.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->compvaldate</td>
            <td style="text-align:left;">~, $m100->compvaldate, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Nine digit date representation, ideal for comparisons.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->compvaltime</td>
            <td style="text-align:left;">~, $m100->compvaltime, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Six digit time representation, ideal for comparisons.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->printdate</td>
            <td style="text-align:left;">~, $m100->printdate, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Defaults to international format (ISO8601) but you can change that.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->printtime</td>
            <td style="text-align:left;">~, $m100->printtime, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->convert_hours_and_minutes_to_decimal(\$obj->hour, \$obj->minute)</td>
            <td style="text-align:left;">~, $m100->convert_hours_and_minutes_to_decimal($m100->hour, $m100->minute), qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->printtime_12hour</td>
            <td style="text-align:left;">~, $m100->printtime_12hour, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->printtime_long</td>
            <td style="text-align:left;">~, $m100->printtime_long, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Time with seconds showing</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->year</td>
            <td style="text-align:left;">~, $m100->year, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->month</td>
            <td style="text-align:left;">~, $m100->month, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->dom</td>
            <td style="text-align:left;">~, $m100->dom, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->hour</td>
            <td style="text-align:left;">~, $m100->hour, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->minute</td>
            <td style="text-align:left;">~, $m100->minute, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->second</td>
            <td style="text-align:left;">~, $m100->second, qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">&nbsp;</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->m100_add(4, 'months')</td>
            <td style="text-align:left;">~, $m100->m100_add(4, 'months'), qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Add four months</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->m100_subtract(180, 'days')</td>
            <td style="text-align:left;">~, $m100->m100_subtract(180, 'days'), qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">Subtract 180 days</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->m100_differenceindays('201710101.000001', \$obj->m100)</td>
            <td style="text-align:left;">~, $m100->m100_differenceindays('201710101.000001', $print_tv), qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">\$obj->m100 is returning the 16 character value $original_m100 for the date you entered above.</td>
          </tr>
          <tr><td colspan="2" style="background-color:#f5f5f5;font-size:1px;">&nbsp;</td>
          <tr>
            <td style="text-align:left;font-family:consolas,courier new;font-weight:bold;">\$obj->m100_differenceinhms('201710101.000001', \$obj->m100)</td>
            <td style="text-align:left;">~, $m100->m100_differenceinhms('201710101.000001', $print_tv), qq~</td>
          </tr>
          <tr>
            <td colspan="2" style="text-align:left;">\$obj->m100 is returning the 16 character value $original_m100 for the date you entered above.</td>
          </tr>
          </table>
        </div>
    ~;
}
print qq~
      </div>
    </div>
  </div>
  <br /><br /><br /><br />
  <div class="footer-container">
      <label class="footer-normal">&copy; 2017 Ninja Kitty</label>
  </div>
</div>
</body>
</html>
~;
exit;


