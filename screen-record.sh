#!/usr/bin/env bash

# execute = "[ ! -z \"$(pidof wl-screenrec)\" ] && killall wl-screenrec || wl-screenrec -g \"$(slurp -d)\" -f ~/Videos/Recordings/screen-$(date \"+%Y%m%d%H%M%S\").mp4"
WM=$(cat /tmp/protocol)

REC_NOW=$(sed '1q;d' ~/prg/scripts/screen-record_current)

function record {
case "${REC_NOW}" in
  "TRUE")
    REC_PID=$(sed '2q;d' ~/prg/scripts/screen-record_current)
    REC_FILE=$(sed '3q;d' ~/prg/scripts/screen-record_current)
    kill $REC_PID

    echo "FALSE" > ~/prg/scripts/screen-record_current

    notify-send "Screen recording has ended." " - File: '${REC_FILE}'"
    ;;
  "FALSE")
    REC_TYPE=$(sed '1q;d' ~/prg/scripts/screen-record_cfg)
    REC_CONF=$(sed '2q;d' ~/prg/scripts/screen-record_cfg)
    REC_FILE=screen-$(date "+%Y%m%d%H%M%S").mp4
    REC_FULL_FILE=~/Videos/Recordings/$REC_FILE

    case $WM in
      "x11")
          x11_record
        ;;
      "wayland")
          wayland_record
        ;;
    esac

    ;;
  *)
    ~/prg/scripts/screen-record-config.sh 
    ~/prg/scripts/screen-record.sh 
    ;;
esac
}

function x11_record {
    case "${REC_TYPE}" in
      "WHOLE")
          ffmpeg -y -f x11grab \
            -s $(xdpyinfo | grep dimensions | awk '{print $2}') \
            -r 60 -i :0.0 -f pulse -i default -c:v libx264 \
            -preset fast -crf 18 -c:a aac $REC_FULL_FILE &

          REC_PID=$!

          echo "TRUE" > ~/prg/scripts/screen-record_current
          echo "${REC_PID}" >> ~/prg/scripts/screen-record_current
          echo "${REC_FILE}" >> ~/prg/scripts/screen-record_current

          notify-send "Screen recording has started." "$(echo -e " - Output: '${REC_CONF}'\n - File: '${REC_FILE}'")"
        ;;
      "RECT")
          read -r X Y W H G ID <<< $slop
          REC_CONF=$(sed '2q;d' ~/prg/scripts/screen-record_cfg)
          read -r W H X Y <<< $(echo $REC_CONF | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/\1 \2 \3 \4/')

          SOUND_INPUT=$(pactl list short sources | grep monitor | head -n1 | awk '{printf $2}')

          # With MIC
          # ffmpeg -y -f x11grab \
          #   -s "$W"x"$H" -i :0.0+$X,$Y \
          #   -r 60 -f pulse -i default -c:v libx264 \
          #   -preset fast -crf 18 -c:a aac $REC_FULL_FILE &
          ffmpeg -y -f x11grab \
            -s "$W"x"$H" -i :0.0+$X,$Y \
            -f pulse -i $SOUND_INPUT \
            -r 60 -c:v libx264 -preset fast -crf 18 \
            -c:a aac $REC_FULL_FILE &

          REC_PID=$!

          echo "TRUE" > ~/prg/scripts/screen-record_current
          echo "${REC_PID}" >> ~/prg/scripts/screen-record_current
          echo "${REC_FILE}" >> ~/prg/scripts/screen-record_current

          notify-send "Screen recording has started." "$(echo -e " - Rect: '${REC_CONF}'\n - File: '${REC_FILE}'")"
        ;;
    esac
}

function wayland_record {
    case "${REC_TYPE}" in
      "WHOLE")
        wl-screenrec -o ${REC_CONF} \
          --audio --audio-device alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
          -f $REC_FULL_FILE &

        REC_PID=$!

        echo "TRUE" > ~/prg/scripts/screen-record_current
        echo "${REC_PID}" >> ~/prg/scripts/screen-record_current
        echo "${REC_FILE}" >> ~/prg/scripts/screen-record_current

        notify-send "Screen recording has started." "$(echo -e " - Output: '${REC_CONF}'\n - File: '${REC_FILE}'")"
        ;;
      "RECT")
        wl-screenrec -g "${REC_CONF}" \
          --audio --audio-device alsa_output.pci-0000_00_1f.3.analog-stereo.monitor \
          -f $REC_FULL_FILE &

        REC_PID=$!

        echo "TRUE" > ~/prg/scripts/screen-record_current
        echo "${REC_PID}" >> ~/prg/scripts/screen-record_current
        echo "${REC_FILE}" >> ~/prg/scripts/screen-record_current

        notify-send "Screen recording has started." "$(echo -e " - Rect: '${REC_CONF}'\n - File: '${REC_FILE}'")"
        ;;
    esac
}


record

printf 1 >> ~/prg/scripts/screen-record_current
