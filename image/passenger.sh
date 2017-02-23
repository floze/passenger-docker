#!/bin/bash
set -e
source /pd_build/buildconfig
source /etc/environment

header "Installing Phusion Passenger..."

## Phusion Passenger requires Ruby. Install it through RVM, not APT,
## so that the -customizable variant cannot end up having Ruby installed
## from APT and Ruby installed from RVM.
if [[ ! -e /usr/bin/ruby ]]; then
	run /pd_build/ruby_support/prepare.sh
	run /usr/local/rvm/bin/rvm install ruby-2.3.1
	# Make passenger_system_ruby work.
	run create_rvm_wrapper_script ruby2.3 ruby-2.3.1 ruby
	run /pd_build/ruby_support/finalize.sh
fi

## Install Phusion Passenger.
# if [[ "$PASSENGER_ENTERPRISE" ]]; then
	# run apt-get install -y passenger-enterprise
# else
	run gem install passenger --no-document
	run ruby -S passenger-config compile-agent --auto
# fi
run cp /pd_build/config/30_presetup_nginx.sh /etc/my_init.d/
run cp /pd_build/config/nginx.conf /etc/nginx/nginx.conf
echo "passenger_root `ruby -S passenger-config --root | tail -n 1`;" > /etc/nginx/passenger.conf
run mkdir -p /etc/nginx/main.d
run cp /pd_build/config/nginx_main_d_default.conf /etc/nginx/main.d/default.conf

## Install Nginx runit service.
run mkdir /etc/service/nginx
run cp /pd_build/runit/nginx /etc/service/nginx/run
run touch /etc/service/nginx/down

run mkdir /etc/service/nginx-log-forwarder
run cp /pd_build/runit/nginx-log-forwarder /etc/service/nginx-log-forwarder/run

run sed -i 's|invoke-rc.d nginx rotate|sv 1 nginx|' /etc/logrotate.d/nginx

## Precompile Ruby extensions.
if [[ -e /usr/bin/ruby2.3 ]]; then
	run ruby2.3 -S passenger-config build-native-support
	run setuser app ruby2.3 -S passenger-config build-native-support
	echo "passenger_ruby /usr/bin/ruby2.3;" >> /etc/nginx/passenger.conf
fi
if [[ -e /usr/bin/ruby2.2 ]]; then
	run ruby2.2 -S passenger-config build-native-support
	run setuser app ruby2.2 -S passenger-config build-native-support
	echo "passenger_ruby /usr/bin/ruby2.2;" >> /etc/nginx/passenger.conf
fi
if [[ -e /usr/bin/ruby2.1 ]]; then
	run ruby2.1 -S passenger-config build-native-support
	run setuser app ruby2.1 -S passenger-config build-native-support
	echo "passenger_ruby /usr/bin/ruby2.1;" >> /etc/nginx/passenger.conf
fi
if [[ -e /usr/bin/ruby2.0 ]]; then
	run ruby2.0 -S passenger-config build-native-support
	run setuser app ruby2.0 -S passenger-config build-native-support
	echo "passenger_ruby /usr/bin/ruby2.0;" >> /etc/nginx/passenger.conf
fi
if [[ -e /usr/bin/jruby ]]; then
	run jruby --dev -S passenger-config build-native-support
	run setuser app jruby -S passenger-config build-native-support
	echo "passenger_ruby /usr/bin/jruby;" >> /etc/nginx/passenger.conf
fi
