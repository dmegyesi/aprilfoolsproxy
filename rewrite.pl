#!/usr/bin/perl
use Switch;
$|=1;
$count = 0;
$pid = $$;
while (<>) {
        chomp $_;
        $random = int(rand(9)+1);
        #$random = 9;
        switch($random) {
                case 1  { $effect1 = "-flip"; $effect2 = " "; $effect3 = " "; }
                case 2  { $effect1 = "-distort"; $effect2 = "ScaleRotateTranslate"; $effect3 = "45"; }
                case 3  { $effect1 = "-wave"; $effect2 = "64x256"; $effect3 = " "; }
                case 4  { $effect1 = "-vignette"; $effect2 = "64"; $effect3 = " "; }
                case 5  { $effect1 = "-transverse"; $effect2 = " "; $effect3 = " "; }
                case 6  { $effect1 = "-solarize"; $effect2 = "25%"; $effect3 = " "; }
                case 7  { $effect1 = "-swirl"; $effect2 = "150%"; $effect3 = " "; }
                case 8  { $effect1 = "-shear"; $effect2 = "25%"; $effect3 = " "; }
                else    { $effect1 = "-monochrome"; $effect2 = " "; $effect3 = " "; }
        }

        if ($_ =~ /(.*\.jpg)/i) {
                $url = $1;
                system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.jpg", "$url");
                $img = "/var/www/images/$pid-$count.jpg";
                system("/usr/bin/mogrify", "$effect1", "$effect2", "$effect3", "$img");
                print "http://127.0.0.1/images/$pid-$count.jpg\n";
        }
        #elsif ($_ =~ /(.*\.gif)/i) {
        #        $url = $1;
        #        system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.gif", "$url");
        #        $img = "/var/www/images/$pid-$count.gif";
        #        system("/usr/bin/mogrify", "$effect1", "$effect2", "$effect3", "$img");
        #        print "http://127.0.0.1/images/$pid-$count.gif\n";
		#
		#}
        elsif ($_ =~ /(.*\.png)/i) {
                $url = $1;
                system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.png", "$url");
                $img = "/var/www/images/$pid-$count.png";
                system("/usr/bin/mogrify", "$effect1", "$effect2", "$effect3", "$img");
                print "http://127.0.0.1/images/$pid-$count.png\n";

        }
        else {
                print "$_\n";;
        }
        $count++;
}
