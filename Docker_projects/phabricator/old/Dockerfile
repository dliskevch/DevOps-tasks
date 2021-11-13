FROM centos:7
RUN yum update -y && yum install\
    git -y \
    httpd \
    sed -y 
RUN sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
RUN sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && yum install php55w php55w-mysqli php55w-mbstring php55w-gd php55w-curl php55w-cli php55w-common php55w-process -y && mkdir /var/www/html/phabricator
# RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
# RUN yum install php55w php55w-mysqli php55w-mbstring php55w-gd php55w-curl php55w-cli php55w-common php55w-process -y
# RUN mkdir /var/www/html/phabricator
WORKDIR /var/www/html/phabricator
RUN git clone https://github.com/phacility/libphutil.git && git clone https://github.com/phacility/arcanist.git && git clone https://github.com/phacility/phabricator.git && chown -R apache: /var/www/html/phabricator
# RUN git clone https://github.com/phacility/arcanist.git
# RUN git clone https://github.com/phacility/phabricator.git
# RUN chown -R apache: /var/www/html/phabricator
COPY phabricator.conf /etc/httpd/conf.d/
COPY local.json /var/www/html/phabricator/phabricator/conf/local/
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80/tcp