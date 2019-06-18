FROM modenaf360/hadoop-base
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/bin/bash","-c","/run.sh"]

