#!/usr/bin/perl
use Switch;
$|=1;
$count = 0;
$pid = $$;
while (<>) {
        chomp $_;

        if ($_ =~ /(.*\.jpg)/i) {
                $url = $1;
                system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.jpg", "$url");
                $img = "/var/www/images/$pid-$count.jpg";
                system("/usr/bin/composite", "-dissolve", "50%", "-gravity", "center", "/tmp/jeremie.jpg", "$img", "$img");
                print "http://127.0.0.1/images/$pid-$count.jpg\n";
        }
        elsif ($_ =~ /(.*\.png)/i) {
                $url = $1;
                system("/usr/bin/wget", "-q", "-O","/var/www/images/$pid-$count.png", "$url");
                $img = "/var/www/images/$pid-$count.png";
                system("/usr/bin/composite", "-dissolve", "50%", "-gravity", "center", "/tmp/jeremie.jpg", "$img", "$img");
                print "http://127.0.0.1/images/$pid-$count.png\n";

        }
        else {
                print "$_\n";;
        }
        $count++;
}

