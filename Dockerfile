FROM centos:centos7

MAINTAINER Kedrick Cooper

LABEL Description="RUNDECK Image"

ENV HOST localhost
ENV SERVER_URL http://rundeck-rundeck-test.apps.192.0.2.201.xip.io
ENV PORT 4440
#ENV MYSQL_HOST localhost
#ENV MYSQL_DATABASE rundeck
#ENV MYSQL_USER rundeck
#ENV MYSQL_PASSWORD Ru^d3ck123$
#ENV OLDLDAP jaas-loginmodule.conf
#ENV NEWLDAP jaas-ldap.conf

######## Install rundeck and required packages ########

USER root

RUN rpm -Uvh http://repo.rundeck.org/latest.rpm

######## Install Java and Rundeck  ########

RUN yum -y install java-1.8.0-openjdk rundeck

######## Update and Clean installation  ########

RUN yum -y update && \
yum -y clean all

######## Set Rundeck Configuration  Variables #########

RUN sed -i 's,grails.serverURL\=.*,grails.serverURL\='${SERVER_URL}',g' /etc/rundeck/rundeck-config.properties && \
    echo "### Enable DB storage for Project configurations ###" >> /etc/rundeck/rundeck-config.properties && \
    echo " " >> /etc/rundeck/rundeck-config.properties && \
    echo "### Encryption for project config storage ###" >> /etc/rundeck/rundeck-config.properties && \
    echo " " >> /etc/rundeck/rundeck-config.properties && \
    echo "### Enable DB for Key Storage ###" >> /etc/rundeck/rundeck-config.properties && \
    echo "  " >> /etc/rundeck/rundeck-config.properties && \
    echo "### Encryption for Key Storage ###" >> /etc/rundeck/rundeck-config.properties && \
    echo "  " >> /etc/rundeck/rundeck-config.properties && \
    echo "### Mapped Roles ###" >> /etc/rundeck/rundeck-config.properties && \
    echo "mappedRoles.admin=admin,api_token_group,ps_devops" >> /etc/rundeck/rundeck-config.properties && \
    echo " " >> /etc/rundeck/rundeck-config.properties && \
    echo "### Email settings --EC-- ###" >> /etc/rundeck/rundeck-config.properties && \
    echo "grails.mail.host=localhost" >> /etc/rundeck/rundeck-config.properties && \
    echo "grails.mail.port=25" >> /etc/rundeck/rundeck-config.properties 

RUN sed -i 's,framework.server.hostname = .*,framework.server.hostname = '${HOST}',g' /etc/rundeck/framework.properties && \
    sed -i 's,framework.server.port = .*,framework.server.port = '${PORT}',g' /etc/rundeck/framework.properties && \
    sed -i 's,framework.server.url = .*,framework.server.url = '${SERVER_URL}',g' /etc/rundeck/framework.properties && \
    sed -i 's,framework.ssh.timeout = .*,framework.ssh.timeout = 10000,g' /etc/rundeck/framework.properties

RUN touch /etc/rundeck/jaas-ldap.conf && chown rundeck:rundeck /etc/rundeck/jaas-ldap.conf
RUN echo "multiauth {" >> /etc/rundeck/jaas-ldap.conf && \
    echo "   " >> /etc/rundeck/jaas-ldap.conf && \
    echo "com.dtolabs.rundeck.jetty.jaas.JettyCachingLdapLoginModule sufficient" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  debug=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  contextFactory=\"com.sun.jndi.ldap.LdapCtxFactory\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  providerUrl=\"ldap://ldap.dal05.softlayer.local ldap://ldap.dal01.softlayer.local\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  bindDn=\"CN=unix_is_server_auth,OU=LdapAuthAccounts,OU=ServiceAccounts,OU=Groups,OU=Accounts,DC=softlayer,DC=local\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  bindPassword=\"Y\(vuSBOkER8V=qR7\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  authenticationMethod=\"simple\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  forceBindingLogin=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  userBaseDn=\"DC=SOFTLAYER,DC=LOCAL\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  userRdnAttribute=\"sAMAccountName\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  userIdAttribute=\"sAMAccountName\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  userPasswordAttribute=\"unicodePwd\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  userObjectClass=\"user\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  roleBaseDn=\"OU=Groups,OU=Accounts,DC=SOFTLAYER,DC=LOCAL\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  roleNameAttribute=\"cn\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  roleMemberAttribute=\"member\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  roleObjectClass=\"group\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  cacheDurationMillis=\"300000\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  supplementalRoles=\"users\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  reportStatistics=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  nestedGroups=\"true\";" >> /etc/rundeck/jaas-ldap.conf && \
    echo "org.eclipse.jetty.plus.jaas.spi.PropertyFileLoginModule sufficient" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  debug=\"true\"" >> /etc/rundeck/jaas-ldap.conf && \
    echo "  file=\"/etc/rundeck/realm.properties\";" >> /etc/rundeck/jaas-ldap.conf && \
    echo "};" >> /etc/rundeck/jaas-ldap.conf   


#    sed -i 's/${OLDLDAP}/${NEWLDAP}/g' /etc/rundeck/profile



######## Change user and ownersheip and permissions ########

RUN mkdir -p /tmp/rundeck
RUN chown -R rundeck:rundeck /tmp/rundeck
RUN chown -R rundeck:rundeck /etc/rundeck
RUN chown -R rundeck:rundeck /var/rundeck
RUN chown -R rundeck:rundeck /var/lib/rundeck
RUN chown -R rundeck:rundeck /var/log/rundeck

RUN chmod a=rwx /var/log/rundeck
RUN chmod a=rwx /tmp/rundeck
RUN chmod -R a=rwx /var/rundeck
RUN chmod -R a=rwx /etc/rundeck
RUN chmod -R a=rwx /var/lib/rundeck
RUN chmod -R u=rwx /etc/init.d/rundeckd

########   Run Rundeck  ########

EXPOSE 4440

USER rundeck

CMD source /etc/rundeck/profile && ${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}
