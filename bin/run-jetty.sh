#!/bin/sh

set -x

export JAVA_HOME=/opt/jre-home
export PATH=$PATH:$JAVA_HOME/bin

if [ -e "/opt/shibboleth-idp/ext-conf/idp-secrets.properties" ]; then
  export IDP_BACKCHANNEL_KEYSTORE_PASSWORD=`gawk 'match($0,/^idp\.backchannel\.keyStorePassword=\s?(.*)\s?$/, a) {print a[1]}' /opt/shibboleth-idp/ext-conf/idp-secrets.properties`
  export IDP_BROWSER_KEYSTORE_PASSWORD=`gawk 'match($0,/^idp\.browser\.keyStorePassword=\s?(.*)\s?$/, a) {print a[1]}' /opt/shibboleth-idp/ext-conf/idp-secrets.properties`
fi

export JETTY_ARGS="$JETTY_ARGS jetty.sslContext.keyStorePassword=$IDP_BROWSER_KEYSTORE_PASSWORD idp.backchannel.keyStorePassword=$IDP_BACKCHANNEL_KEYSTORE_PASSWORD"
sed -i "s/^-Xmx.*$/-Xmx$JETTY_MAX_HEAP/g" /opt/shib-jetty-base/start.d/start.ini

exec /opt/jetty-home/bin/jetty.sh run
