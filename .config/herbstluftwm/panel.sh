#!/bin/bash

# disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format: WxH+X+Y
x=${geometry[0]}
y=${geometry[1]}
if [ $monitor == 0 ]; then
  panel_width=260
else
  panel_width=${geometry[2]}
fi
panel_height=16
bgcolor='#101010'
selfg='#101010'
unselfg_empty='#333333'
unselfg_used='#999999'
selbg_act_sec='#999999'
selbg_act_pri='#66CC99'
selbg_inact_sec='#666666'
selbg_inact_pri='#6699CC'
selbg_alert='#CC6666'

####
# Try to find textwidth binary.
# In e.g. Ubuntu, this is named dzen2-textwidth.
if [ -e "$(which textwidth 2> /dev/null)" ] ; then
    textwidth="textwidth";
elif [ -e "$(which dzen2-textwidth 2> /dev/null)" ] ; then
    textwidth="dzen2-textwidth";
else
    echo "This script requires the textwidth tool of the dzen2 project."
    exit 1
fi
####
# true if we are using the svn version of dzen2
# depending on version/distribution, this seems to have version strings like
# "dzen-" or "dzen-x.x.x-svn"
if dzen2 -v 2>&1 | head -n 1 | grep -q '^dzen-\([^,]*-svn\|\),'; then
    dzen2_svn="true"
else
    dzen2_svn=""
fi

herbstclient pad $monitor $panel_height
{
    # events:
    #mpc idleloop player &
    childpid=$!
    herbstclient --idle
    kill $childpid
} 2> /dev/null | {
    TAGS=( $(herbstclient tag_status $monitor) )
    visible=true
    windowtitle=""
    while true ; do
        bordercolor="#26221C"
        separator="^bg()^fg($selbg)|"
        # draw tags
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#')
                    echo -n "^bg($selbg_act_pri)^fg($selfg)"
                    ;;
                '%')
                    echo -n "^bg($selbg_act_sec)^fg($selfg)"
                    ;;
                '-')
                    echo -n "^bg($selbg_inact_pri)^fg($selfg)"
                    ;;
                '+')
                    echo -n "^bg($selbg_inact_sec)^fg($selfg)"
                    ;;
                ':')
                    echo -n "^bg()^fg($unselfg_used)"
                    ;;
                '!')
                    echo -n "^bg($selbg_alert)^fg($selfg)"
                    ;;
                *)
                    echo -n "^bg()^fg($unselfg_empty)"
                    ;;
            esac
            if [ ! -z "$dzen2_svn" ] ; then
                echo -n "^ca(1,herbstclient focus_monitor $monitor && "'herbstclient use "'${i:1}'") '"${i:1} ^ca()"
            else
                echo -n " ${i:1} "
            fi
        done
        echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "resetting tags" >&2
                TAGS=( $(herbstclient tag_status $monitor) )
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(herbstclient list_monitors |grep ' \[FOCUS\]$'|cut -d: -f1)
                if [ -n "${cmd[1]}" ] && [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    herbstclient pad $monitor 0
                else
                    visible=true
                    herbstclient pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
        #    focus_changed|window_title_changed)
        #        windowtitle="${cmd[@]:2}"
        #        ;;
        esac
    done
} 2> /dev/null | dzen2 -w $panel_width -x $x -y $y -h $panel_height \
    -ta l -bg "$bgcolor" -fg '#666666' -fn terminus-10 -title-name 'dzen_workspace_panel'

