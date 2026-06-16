#!/usr/bin/env ruby

class Node
  attr_accessor :indent, :text, :count, :children, :is_bullet, :has_count

  def initialize(indent, text, count, is_bullet, has_count)
    @indent = indent
    @text = text
    @count = count
    @children = []
    @is_bullet = is_bullet
    @has_count = has_count
  end

  # 자식 노드 중에 하이픈(-)으로 시작하는 리스트 항목이 있는지 확인
  def has_bullet_children?
    @children.any?(&:is_bullet)
  end

  # 계층 구조별 카운트 계산 메커니즘
  def calculate_count
    children_sum = @children.map(&:calculate_count).sum

    if @is_bullet
      if has_bullet_children?
        # 실제 하위 리스트 항목이 있다면 합산 (Roll-up)
        @count = children_sum
      else
        # 하위 리스트 항목이 없는 완전히 말단(Leaf) 노드라면 본인의 원래 값을 유지
        @count = @has_count ? @count : children_sum
      end
    else
      # 하이픈이 없는 일반 텍스트 줄은 상위 집계에 영향을 주지 않음
      @count
    end
  end

  # 마크다운 텍스트 복원 및 포맷팅 (대괄호 -> 소괄호 수정)
  def to_s
    if @is_bullet
      if has_bullet_children? || @has_count || @count > 0
        "#{" " * @indent}#{@text} (#{@count})"
      else
        "#{" " * @indent}#{@text}"
      end
    else
      if @has_count
        "#{" " * @indent}#{@text} (#{@count})"
      else
        "#{" " * @indent}#{@text}"
      end
    end
  end
end

def print_tree(node)
  puts node.to_s if node.indent >= 0
  node.children.each { |child| print_tree(child) }
end

# 가상의 최상위 루트 노드 생성
root = Node.new(-1, "", 0, true, false)
stack = [root]

STDIN.readlines.each do |line|
  next if line.strip.empty?

  # 들여쓰기 공백 수 계산 및 하이픈 시작 여부 판별
  indent = line.match(/^\s*/)[0].length
  stripped = line.strip
  is_bullet = stripped.start_with?('-')

  # [변경 포인트] 줄 끝에 소괄호 (숫자)가 있는지 확인하는 정규표현식
  if match = stripped.match(/^(.*?)\s*\((\d+)\)$/)
    text = match[1]
    count = match[2].to_i
    has_count = true
  else
    text = stripped
    count = 0
    has_count = false
  end

  node = Node.new(indent, text, count, is_bullet, has_count)

  if is_bullet
    while stack.last.indent >= indent
      stack.pop
    end
  else
    while stack.last.indent > indent
      stack.pop
    end
  end

  # 부모 노드의 자식으로 등록
  stack.last.children << node
  
  # 하이픈(-)으로 시작하는 줄만 다음 노드들의 부모가 될 자격(Stack push)을 얻음
  stack.push(node) if is_bullet
end

# 집계 및 출력 실행
root.calculate_count
print_tree(root)
