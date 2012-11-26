module TVShowRenamer
  class CLI
    def self.prompt(prompt)
      print prompt
      $stdout.flush
      $stdin.gets.chomp.strip
    end

    def self.prompt_edit_value(prompt, value = nil, regex = nil)
      prompt << " (#{value})" if value
      prompt << " : "
      ok = false
      until ok
        str = self.prompt prompt
        if value && str.empty?
          ok = true
        else
          if !regex || str =~ regex
            value = str
            ok = true
          end
        end
      end
      value
    end
  end
end