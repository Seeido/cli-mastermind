module StringFormatting
  refine String do
    def colorize(color)
      color_codes = {
        red: "\e[31m",
        green: "\e[32m",
        yellow: "\e[33m",
        blue: "\e[34m"
      }

      "#{color_codes[color]}#{self}\e[0m"
    end

    def underline
      "\e[4m#{self}\e[0m"
    end
  end
end
