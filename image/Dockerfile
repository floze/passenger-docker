FROM floze/raspbian-baseimage:0.9.19
MAINTAINER floze <gammafloze@gmail.com>

ADD . /pd_build
RUN /pd_build/install.sh
CMD ["/sbin/my_init"]
EXPOSE 80 443
