# ### Postgis
FROM postgres:10 AS postgis
LABEL maintainer="Stefan Kuethe <crazycapivara@gmail.com>"
ENV POSTGIS_MAJOR 2.5
ENV POSTGIS_VERSION 2.5.1+dfsg-1.pgdg90+1
RUN apt-get update \
   && apt-get install -y --no-install-recommends \
      postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
      postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
      postgis=$POSTGIS_VERSION

# ### PLPython
FROM postgis AS plpython
# ENV PLPYTHON_VERSION 10.6-1.pgdg18.04+1
RUN apt-get install -y --no-install-recommends \
  python3 postgresql-plpython3-$PG_MAJOR \
  python3-requests
 
# ### pgRouting
FROM postgis AS pgrouting
ENV PGROUTING_MAJOR 2.5
ENV PGROUTING_VERSION 2.5.2
RUN apt-get install -y --no-install-recommends \
  postgresql-$PG_MAJOR-pgrouting

# ### H3
FROM postgis AS h3
ENV BUILD_TOOLS="cmake make gcc libtool git pgxnclient postgresql-server-dev-$PG_MAJOR"
RUN apt-get install -y --no-install-recommends $BUILD_TOOLS
RUN pgxn install h3
RUN apt-get purge -y --auto-remove $BUILD_TOOLS

# ### Default 
FROM postgis
RUN rm -rf /var/lib/apt/lists/*

