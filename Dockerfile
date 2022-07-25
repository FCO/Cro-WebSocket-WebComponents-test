FROM    rakudo-star
RUN     mkdir /app
RUN     apt-get update && apt-get install -y build-essential libssl-dev
COPY    . /app
WORKDIR /app
RUN     zef install --deps-only . --/test && raku -c -Ilib service.p6
ENV     TODO_HOST="0.0.0.0" TODO_PORT="10000"
EXPOSE  10000
CMD     raku -Ilib service.p6
