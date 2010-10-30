module ActiveSupport
  module Inflector
    class Inflections

      def plurals_slo
        @plurals_slo ||= []
      end
      
      def plural_slo(rule, replacement_2, replacement_3_4, replacement_5)
        @uncountables.delete(rule) if rule.is_a?(String)
        @uncountables.delete(replacement_2)
        @uncountables.delete(replacement_3_4)
        @uncountables.delete(replacement_5)
        plurals_slo.insert(0, [rule, replacement_2, replacement_3_4, replacement_5])
      end

      def clear_with_slo
        @plurals_slo = [] if scope == 'plurals_slo' || scope == :all
        clear_without_slo
      end
      
      alias_method_chain :clear, :slo
    end

    def pluralize_slo(word, number = 5)
      result = word.to_s.dup

      if word.empty? || inflections.uncountables.include?(result.downcase) || number == 1
        result
      else
        all_plurals = inflections.plurals_slo + inflections.plurals
        all_plurals.each do |arr|
          rule = arr[0]
          replacement = if arr.length < 4 || number == 2
            arr[1]
          elsif number > 2 && number < 5
            arr[2]
          else
            arr[3]
          end
          break if result.gsub!(rule, replacement)
        end
        result
      end
    end
  end
end
