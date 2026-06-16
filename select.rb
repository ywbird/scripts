#!/usr/bin/env ruby
require 'tempfile'
require 'optparse'

# 커맨드 라인 인수를 저장할 해시
options = {}

# OptionParser를 사용해 -p 옵션 파싱
OptionParser.new do |opts|
  opts.banner = "Usage: select.rb [options]"

  opts.on("-p", "--prompt PROMPT", "fzf에 표시할 프롬프트를 설정합니다.") do |p|
    options[:prompt] = p
  end
end.parse!

# 표준 입력(stdin)에서 데이터를 읽어 임시 파일에 저장합니다.
Tempfile.create('dmenu_input') do |tmpfile|
  tmpfile.write($stdin.read)
  tmpfile.flush # 외부 프로세스가 읽기 전에 디스크에 완전히 기록하도록 보장

  result_file = '/tmp/dmenu_result'

  # -p 옵션으로 전달받은 프롬프트가 있다면 fzf 옵션으로 추가 (홑따옴표로 감싸서 띄어쓰기 보호)
  fzf_prompt = options[:prompt] ? "--prompt='#{options[:prompt]} ' " : ""

  # alacritty 및 fzf를 실행하는 명령어 구성
  command = %Q{alacritty --class "custom.floating" -e bash -c "cat #{tmpfile.path} | fzf #{fzf_prompt}--no-info --no-preview --height 100% > #{result_file}"}
  
  # 시스템 명령어 실행
  system(command)

  # 결과 파일이 존재하면 내용을 출력하고 삭제합니다.
  if File.exist?(result_file)
    print File.read(result_file)
    File.delete(result_file)
  end
end
