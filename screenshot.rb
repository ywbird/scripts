#!/usr/bin/env ruby

require "fileutils"

img = File.join(
  `xdg-user-dir PICTURES`.strip,
  "Captures",
  "#{Time.now.strftime('%Y%m%d%H%M%S')}.png"
)

FileUtils.mkdir_p(File.dirname(img))

whole = ARGV.include?("--whole")

wm = File.read("/tmp/protocol").strip

case wm
when "x11"
  if whole
    system("scrot", img)
  else
    system("scrot", "-s", img)
  end

  system("xclip", "-i", "-sel", "clip", "-t", "image/png", img)

when "wayland"
  if whole
    system("grim", img)
  else
    geometry = `slurp -d`.strip
    system("grim", "-g", geometry, img)
  end

  sleep 0.5

  system("notify-send", "Took screenshot.", img)

  File.open(img, "rb") do |f|
    IO.popen("wl-copy", "wb") do |wl|
      IO.copy_stream(f, wl)
    end
  end
else
  warn "Unknown protocol: #{wm}"
  exit 1
end
