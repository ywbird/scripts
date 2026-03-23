
DEVICE=$(printf "nandvig:9a4a79f7_da38_4e9e_9566_7eb97e2257a0\nIfon:b22b47bf_7a81_4b12_b494_1709b07c0903" | fuzzel -d --prompt "Pick device > ")

kdeconnect-cli -d $(echo $DEVICE | cut -d: -f2) --send-clipboard
