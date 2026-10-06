#!/bin/sh
set -eu

# Railway provides PORT at runtime. Locally, Tomcat keeps its normal port 8080.
if [ -n "${PORT:-}" ]; then
  sed -i "s/port=\"8080\" protocol=\"HTTP\/1.1\"/port=\"${PORT}\" protocol=\"HTTP\/1.1\"/" "$CATALINA_HOME/conf/server.xml"
fi

exec catalina.sh run
