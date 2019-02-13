FROM postgres:10

LABEL maintainer="Stefan Kuethe <crazycapivara@gmail.com>"

ENV POSTGIS_MAJOR 2.5
ENV POSTGIS_VERSION 2.5.1+dfsg-1.pgdg90+1

ENV PGROUTING_MAJOR 2.5
ENV PGROUTING_VERSION 2.5.2

# ENV PLPYTHON_VERSION 10.6-1.pgdg18.04+1

ENV BUILD_TOOLS="cmake make gcc libtool git pgxnclient postgresql-server-dev-$PG_MAJOR"
ENV LANGUAGE_EXTENSION_R="postgresql-$PG_MAJOR-plr"

RUN apt-get update \
   && apt-get install -y --no-install-recommends \
      postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
      postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
      postgis=$POSTGIS_VERSION \
      python3 postgresql-plpython3-$PG_MAJOR \
      python3-requests \
      postgresql-$PG_MAJOR-pgrouting \
      $LANGUAGE_EXTENSION_R \
      $BUILD_TOOLS

RUN pgxn install h3

RUN apt-get purge -y --auto-remove $BUILD_TOOLS \
   && rm -rf /var/lib/apt/lists/*

