#
# Executes commands at login post-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!


# don't display system info if elevating to root
if [[ $USER == "root" ]]; then
    return 0
fi

# print uptime in days
echo ""
() {
    local updays=$(awk -v upsec=$(cat /proc/uptime | cut -d '.' -f 1) 'BEGIN { rounded = sprintf("%.0f", upsec/86400); print rounded }')
    print "Uptime: $updays days"
}

# print cpu load average
() {
    local cpuload="$(cat /proc/loadavg | cut -d ' ' -f 1-3)"
    print "CPU Load: $cpuload"
}

# print memory usage
() {
    print "Memory:"
    local memtotal=$(cat /proc/meminfo | grep "MemTotal" | tr -s ' ' | cut -d ' ' -f 2)
    local memfree=$(cat /proc/meminfo | grep "MemFree" | tr -s ' ' | cut -d ' ' -f 2)
    local membuffers=$(cat /proc/meminfo | grep "Buffers" | tr -s ' ' | cut -d ' ' -f 2)
    local memcached=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f 2)
    local memused=$(($memtotal - $memfree - $membuffers - $memcached))
    local mempct=$(echo "scale=0; $memused*100/$memtotal" | bc)
    if [ $mempct -ge 90 ]; then
        print -P "   Real: $(numfmt --to=iec --from-unit=K $memused)/$(numfmt --to=iec --from-unit=K $memtotal) (%B%F{red}$mempct%%%f%b)"
    else
        print "   Real: $(numfmt --to=iec --from-unit=K $memused)/$(numfmt --to=iec --from-unit=K $memtotal) ($mempct%)"
    fi
    local swaptotal=$(cat /proc/meminfo | grep "SwapTotal" | tr -s ' ' | cut -d ' ' -f 2)
    local swapfree=$(cat /proc/meminfo | grep "SwapFree" | tr -s ' ' | cut -d ' ' -f 2)
    local swapused=$(($swaptotal - $swapfree))
    local swappct=$(echo "scale=0; $swapused*100/$swaptotal" | bc)
    if [ $swappct -ge 90 ]; then
        print -P "   Swap: $(numfmt --to=iec --from-unit=K $swapused)/$(numfmt --to=iec --from-unit=K $swaptotal) (%B%F{red}$swappct%%%f%b)"
    else
        print "   Swap: $(numfmt --to=iec --from-unit=K $swapused)/$(numfmt --to=iec --from-unit=K $swaptotal) ($swappct%)"
    fi
}

# print disk space usage
() {
    print "Disk Usage:"
    IFS=$'\n'
    for line in `df -h -t xfs -t nfs4 | tail -n +2 | tr -s ' '`; do
        local diskname=$(echo $line | cut -d ' ' -f 6)
        #local diskused=$(echo $line | cut -d ' ' -f 3)
        #local disktotal=$(echo $line | cut -d ' ' -f 2)
        local diskpct=$(echo $line | cut -d ' ' -f 5)
        if (( ${diskpct: : -1} >= 80 )); then
            #print -P "   $diskname: $diskused/$disktotal (%B%F{red}$diskpct%%f%b)"
            print -P "   $diskname: %B%F{red}$diskpct%%f%b"
        else
            #print "   $diskname: $diskused/$disktotal ($diskpct)"
            print "   $diskname: $diskpct"
        fi
    done
}
