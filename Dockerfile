FROM ubuntu:24.04

RUN apt-get update && apt-get install -y bash

COPY myscript5.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

CMD ["/usr/local/bin/script.sh"]



