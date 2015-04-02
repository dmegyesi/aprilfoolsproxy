#!/usr/bin/perl

# required deb package: libwww-perl

#turn jpg and png files into animated gifs
#
#requires ImageMagick and Ghostscript

use IO::Handle;
use LWP::Simple;

$|=1;
$animate = 0;
$count = 0;
$debug=0;
$pid = $$;

#note- $basedir must be writable by 'proxy'
$basedir = "/var/www/images";
$baseurl = "http://127.0.0.1/images";
@dirty_words = ('promise','Iwillwork','notwastingmytime','csocso now?','coffee break?','kayakrulz','howdoiturnthisoff');
$dirty_word = $dirty_words[int rand($#dirty_words + 1)];

if ($debug == 1) { open (DEBUG, '>>/usr/local/squid/var/logs/tourette_debug.log'); }
autoflush DEBUG 1;

while (<>) {
        chomp $_;

        if ($_ =~ /(.*\.jpg)/i) {
                $url = $1;
                if ($debug == 1) { print DEBUG "INPUT- $url\n"; }
                $file = "$basedir/$pid-$count.jpg";
                getstore($url,$file);
                if ($debug == 1) { print DEBUG "fetched image- $url\n"; }
                system("/usr/bin/convert", "$file", "$basedir/$pid-$count.gif");
                system("chmod", "a+r", "$basedir/$pid-$count.gif");
                if ($debug == 1) { print DEBUG "converted jpg to gif- $url\n"; }
                $animate = 1;
        }
        elsif ($_ =~ /(.*\.png)/i) {
                $url = $1;
                if ($debug == 1) { print DEBUG "INPUT- $url\n"; }
                $file = "$basedir/$pid-$count.png";
                getstore($url,$file);
                if ($debug == 1) { print DEBUG "fetched image- $url\n"; }
                system("/usr/bin/convert", "$file", "$basedir/$pid-$count.gif");
                system("chmod", "a+r", "$basedir/$pid-$count.gif");
                if ($debug == 1) { print DEBUG "converted png to gif- $url\n"; }
                $animate = 1;
        }
        elsif ($_ =~ /(.*\.gif)/i) {
                $url = $1;
                if ($debug == 1) { print DEBUG "INPUT- $url\n"; }
                $file = "$basedir/$pid-$count.gif";
                getstore($url,$file);
                if ($debug == 1) { print DEBUG "fetched image- $url\n"; }
                system("chmod", "a+r", "$basedir/$pid-$count.gif");
                $animate = 1;
        }
        else {
                print "$_\n";
                if ($debug == 1) { print DEBUG "PASS- $_\n"; }
        }

        if ($animate == 1) {

                $size = `/usr/bin/identify $basedir/$pid-$count.gif | cut -d" " -f 3`;
                chomp $size;
                if ($debug == 1) { print DEBUG "calculated image size- $url\n"; }
                system("/usr/bin/convert -background black -fill white -gravity center -size $size label:'$dirty_word' $basedir/$pid-$count-text.gif");
                system("chmod", "a+r", "$basedir/$pid-$count-text.gif");
                if ($debug == 1) { print DEBUG "created alternate image- $url\n"; }

                system("/usr/bin/convert -delay 50 -size $size -page +0+0 $basedir/$pid-$count.gif -page +0+0 $basedir/$pid-$count-text.gif -loop 0 $basedir/$pid-$count-animation.gif");
                system("chmod", "a+r", "$basedir/$pid-$count-animation.gif");
                if ($debug == 1) { print DEBUG "created animated gif- $url\n"; }
                if ($debug == 1) { print DEBUG "OUTPUT- $url to $baseurl/$pid-$count-animation.gif\n"; }
                print "$baseurl/$pid-$count-animation.gif\n";
        }

        $animate = 0;

        $count++;
}

