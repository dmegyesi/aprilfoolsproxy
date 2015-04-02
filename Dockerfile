FROM debian:squeeze
ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Daniel Megyesi <daniel.megyesi@liligo.com>

RUN apt-get -q update && apt-get -qy --no-install-recommends install perl squid apache2 imagemagick wget libwww-perl jp2a supervisor && \
    apt-get clean && apt-get autoclean

RUN sed -i "s/^#http_access allow localnet/http_access allow localnet/" /etc/squid/squid.conf
RUN sed -i "s/^http_port 3128/http_port 3128 transparent/" /etc/squid/squid.conf

COPY squid_config_extra.txt /tmp/squid_config_extra.txt
RUN cat /tmp/squid_config_extra.txt >> /etc/squid/squid.conf

RUN echo "*/10 * * * * proxy rm /var/www/images/*" >> /etc/crontab

RUN mkdir -p /var/www/images && \
    chown -R www-data:www-data /var/www/images && \
    chmod 775 /var/www/images

RUN mkdir -p /usr/local/squid/var/cache_liligo && \
    chown proxy:proxy /usr/local/squid/var/cache_liligo

RUN usermod -aG www-data proxy && \
    usermod -aG proxy www-data
	
RUN wget https://pbs.twimg.com/profile_images/378800000472707746/f27856ed3dcd6d7d71707692ee901970_400x400.jpeg -O /usr/local/bin/jeremie.jpg

COPY rewrite.pl /usr/local/bin/rewrite.pl
COPY tourette.pl /usr/local/bin/tourette.pl
COPY ascii.pl /usr/local/bin/ascii.pl
COPY watermark.pl /usr/local/bin/watermark.pl

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create swap directories so supervisor can start the process
RUN /usr/sbin/squid -z

VOLUME /var/www/images

EXPOSE 3128

CMD ["/usr/bin/supervisord", "-n"]
