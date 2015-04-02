#!/usr/bin/perl

# required deb package: jp2a

#turn jpg and png files into asciifyd gifs
#
#requires ImageMagick and Ghostscript

use IO::Handle;
use LWP::Simple;

$|=1;
$asciify = 0;
$count = 0;
$debug=0;
$pid = $$;

#note- $basedir must be writable by 'proxy'
$basedir = "/var/www/images";
$baseurl = "http://127.0.0.1/images";

if ($debug == 1) { open (DEBUG, '>>/usr//squid/var/logs/ascii_debug.log'); }
autoflush DEBUG 1;

while (<>) {
        chomp $_;

        if ($_ =~ /(.*\.gif)/i) {
                $url = $1;
                if ($debug == 1) { print DEBUG "INPUT- $url\n"; }
                $file = "$basedir/$pid-$count.gif";
                getstore($url,$file);
                if ($debug == 1) { print DEBUG "fetched image- $url\n"; }
                system("/usr//bin/convert", "$file", "$basedir/$pid-$count.jpg");
                system("chmod", "a+r", "$basedir/$pid-$count.jpg");
                if ($debug == 1) { print DEBUG "converted gif to jpg- $url\n"; }
                $asciify = 1;
        }
        elsif ($_ =~ /(.*\.png)/i) {
                $url = $1;
                if ($debug == 1) { print DEBUG "INPUT- $url\n"; }
                $file = "$basedir/$pid-$count.png";
                getstore($url,$file);
                if ($debug == 1) { print DEBUG "fetched image- $url\n"; }
                system("/usr//bin/convert", "$file", "$basedir/$pid-$count.jpg");
                system("chmod", "a+r", "$basedir/$pid-$count.jpg");
                if ($debug == 1) { print DEBUG "converted png to jpg- $url\n"; }
                $asciify = 1;
        }
        elsif ($_ =~ /(.*\.jpg)/i) {
                $url = $1;
                if ($debug == 1) { print DEBUG "INPUT- $url\n"; }
                $file = "$basedir/$pid-$count.jpg";
                getstore($url,$file);
                if ($debug == 1) { print DEBUG "fetched image- $url\n"; }
                system("chmod", "a+r", "$basedir/$pid-$count.jpg");
                $asciify = 1;
        }
        else {
                print "$_\n";
                if ($debug == 1) { print DEBUG "PASS- $_\n"; }
        }
        if ($asciify == 1) {

                $size = `/usr//bin/identify $basedir/$pid-$count.jpg | cut -d" " -f 3`;
                chomp $size;
                if ($debug == 1) { print DEBUG "calculated image size- $url\n"; }
                system("/usr/bin/jp2a $basedir/$pid-$count.jpg --invert --output=$basedir/$pid-$count-ascii.txt");
                system("/usr/bin/convert -font Courier-Bold label:\@$basedir/$pid-$count-ascii.txt -size $size $basedir/$pid-$count-ascii.jpg");
                system("chmod", "a+r", "$basedir/$pid-$count-ascii.jpg");

                if ($debug == 1) { print DEBUG "OUTPUT- $url to $baseurl/$pid-$count-ascii.jpg\n"; }
                print "$baseurl/$pid-$count-ascii.jpg\n";

        }

        $asciify = 0;

        $count++;
}

