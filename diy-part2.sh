#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 调整内核参数
echo 'net.netfilter.nf_conntrack_max=65535' >> package/base-files/files/etc/sysctl.conf
echo 'fs.nr_open = 10000000' >> package/base-files/files/etc/sysctl.conf
echo 'fs.file-max = 1048576' >> package/base-files/files/etc/sysctl.conf
echo 'ulimit -u 65535' >> package/base-files/files/etc/profile
echo 'ulimit -HSn 65535' >> package/base-files/files/etc/profile

# themes添加（svn co 命令意思：指定版本如https://github）
#git clone https://github.com/Leo-Jo-My/luci-theme-Butterfly package/luci-theme-Butterfly
#git clone https://github.com/Leo-Jo-My/luci-theme-Butterfly-dark package/luci-theme-Butterfly-dark
#git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
#git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
#git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
#git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd

# Modify hostname
#sed -i 's/OpenWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# Modify the version number
#sed -i "s/OpenWrt /MuaChow build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 添加核心温度的显示
#sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

#添加额外非必须软件包
#adguardhome广告拦截很强大
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

#bypass科学学习
#git clone https://github.com/garypang13/luci-app-bypass package/luci-app-bypass

#OpenClash小猫咪
#git clone https://github.com/vernesong/OpenClash.git package/OpenClash

#添加smartdns
#git clone https://github.com/pymumu/openwrt-smartdns package/smartdns
#git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

#添加chinadns-ng防污染分配合ssp还行
#git clone -b luci https://github.com/pexcn/openwrt-chinadns-ng.git package/luci-app-chinadns-ng

#git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

# 设置启动项
sed -i '/exit 0/d' package/base-files/files/etc/rc.local
cat << 'EOF' >> package/base-files/files/etc/rc.local
# 系统优化配置
sysctl -w net.ipv4.icmp_echo_ignore_all=1
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_tw_recycle=1
sysctl -w net.ipv4.tcp_fack=0
sysctl -w net.ipv4.tcp_sack=1
sysctl -w net.ipv4.tcp_dsack=1
sysctl -w net.ipv4.tcp_timestamps=0
sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sysctl -w net.ipv4.tcp_window_scaling=0
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w net.ipv4.tcp_fin_timeout=3
sysctl -w net.ipv4.tcp_keepalive_time=600
sysctl -w net.ipv4.tcpsyn_retries=1
sysctl -w net.ipv4.tcp_synack_retries=1
sysctl -w net.ipv4.tcp_keepalive_probes=3
sysctl -w net.ipv4.tcp_keepalive_intvl=15
sysctl -w net.ipv4.tcp_retries1=3
sysctl -w net.ipv4.tcp_retries2=3
sysctl -w net.ipv4.tcp_orphan_retries=3
sysctl -w net.ipv4.tcp_max_orphans=40960
sysctl -w net.ipv4.tcp_syn_retries=2
sysctl -w net.ipv4.tcp_max_tw_buckets=50000
sysctl -w net.ipv4.ip_local_port_range="1024 65535"

sysctl -w net.netfilter.nf_conntrack_max=65535
sysctl -w net.netfilter.nf_conntrack_expect_max=65535
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_close=3
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_close_wait=3
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_fin_wait=10
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_syn_recv=10
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_syn_sent=10
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=10
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_last_ack=10
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_max_retrans=10

sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0

sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0

sysctl -w net.ipv4.tcp_orphan_retries=0
sysctl -w net.ipv4.tcp_max_orphans=10
sysctl -w net.ipv4.tcp_wmem="8192 20480 51200"
sysctl -w net.ipv4.tcp_rmem="8192 20480 51200"
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.ipv4.tcp_ecn=0

# CPU性能模式
echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq)
echo $max_freq > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq

exit 0
EOF
