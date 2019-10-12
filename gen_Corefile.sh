#!/bin/bash
echo ". {" > Corefile
echo "  forward . 208.67.222.222:443 208.67.222.222:5353 208.67.220.220:443 208.67.220.220:5353 127.0.0.1:5301 127.0.0.1:5302 127.0.0.1:5303  {" >> Corefile
china=`curl https://cdn.jsdelivr.net/gh/felixonmars/dnsmasq-china-list/accelerated-domains.china.conf -s | while read line; do awk -F '/' '{print $2}' | grep -v '#' ; done |  paste -sd " " -`
apple=`curl https://cdn.jsdelivr.net/gh/felixonmars/dnsmasq-china-list/apple.china.conf -s | while read line; do awk -F '/' '{print $2}' | grep -v '#' ; done |  paste -sd " " -`
google=`curl https://cdn.jsdelivr.net/gh/felixonmars/dnsmasq-china-list/google.china.conf -s | while read line; do awk -F '/' '{print $2}' | grep -v '#' ; done |  paste -sd " " -`
echo "  except $china $apple $google" >> Corefile
echo "  }" >> Corefile
echo "  proxy . 116.228.111.118 180.168.255.18" >> Corefile
echo "  log" >> Corefile
echo "  cache" >> Corefile
echo "  health" >> Corefile
echo "}" >> Corefile
echo ".:5301 {" >> Corefile
echo "   forward . tls://9.9.9.9 tls://9.9.9.10 {" >> Corefile
echo "       tls_servername dns.quad9.net" >> Corefile
echo "   }" >> Corefile
echo "   cache" >> Corefile
echo "}" >> Corefile
echo ".:5302 {" >> Corefile
echo "    forward . tls://1.1.1.1 tls://1.0.0.1 {" >> Corefile
echo "        tls_servername cloudflare-dns.com" >> Corefile
echo "    }" >> Corefile
echo "    cache" >> Corefile
echo "}" >> Corefile
echo ".:5303 {" >> Corefile
echo "    forward . tls://8.8.8.8 tls://8.8.4.4 {" >> Corefile
echo "        tls_servername dns.google" >> Corefile
echo "    }" >> Corefile
echo "    cache" >> Corefile
echo "}" >> Corefile
