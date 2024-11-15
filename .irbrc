require 'pathname'

module IRB
  module Color
    if self.const_defined?(:TOKEN_SEQ_EXPRS)
      TOKEN_SEQ_EXPRS.values.each do |value|
        value[0][0] = CYAN if value[0][0] == BLUE
      end
    end
  end
end

path = Pathname.new(Dir.pwd)
nearest_gemfile = path
while !path.root?
  if File.exist?(path + 'Gemfile')
    nearest_gemfile = path
    break
  else
    path = path.parent
  end
end

FG ||= "\e[38;5;255m".freeze
FG_BLACK ||= "\e[38;5;0m".freeze
FG_DARK ||= "\e[38;5;88m".freeze
BG_DARK ||= "\e[48;5;88m".freeze
BG_M ||= "\e[48;5;206m".freeze
FG_M ||= "\e[38;5;206m".freeze
FG_INV ||= "\e[38;5;160m".freeze
BG ||= "\e[48;5;160m".freeze
AG ||= (FG + BG).freeze
RST ||= "\e[m".freeze

expand = Pathname.new(Dir.pwd).relative_path_from(nearest_gemfile)
base_folder = Pathname.new(File.join(nearest_gemfile.basename, expand.to_s)).cleanpath
components = base_folder.each_filename.collect(&:to_s)
current_folder = components.join("#{FG_DARK} \u{E0B1} #{FG}")

PROMPT_NORMAL ||= "#{AG} #{current_folder}#{RST}#{BG} #{FG_INV}#{BG_DARK}\u{E0B0}#{FG} (#{RUBY_VERSION}) #{FG_DARK}#{BG}\u{E0B0}#{AG} $ #{RST}#{FG_INV}\u{E0B0}#{RST} "
PROMPT_MORE ||=   "#{AG} #{current_folder}#{RST}#{BG} #{FG_INV}#{BG_DARK}\u{E0B0}#{FG} (#{RUBY_VERSION}) #{FG_DARK}#{BG_M}\u{E0B0}#{FG}#{BG_M} \u{27A5} #{RST}#{FG_M}\u{E0B0}#{RST} "
IRB.conf[:PROMPT] ||= {}
IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: PROMPT_NORMAL,
  PROMPT_N: PROMPT_MORE,
  PROMPT_S: PROMPT_MORE,
  PROMPT_C: PROMPT_MORE,
  RETURN:   "#{FG}\e[48;5;32m ⚡ #{RST}\e[38;5;32m\u{E0B0}\e[m %s\n",
  AUTO_INDENT: true
}

IRB.conf[:PROMPT_MODE] = :CUSTOM
