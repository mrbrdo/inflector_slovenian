# encoding: utf-8
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

  Inflector.inflections do |inflect|
    inflect.plural_slo /$/i, 'a', 'i', 'ov' # strešnik, praznik, parkeljc
    
    inflect.plural_slo /a$/i, 'i', 'e', '' # ključavnica, barva
    inflect.plural_slo /([eo].)o$/i, '\1esi', '\1esa', '\1es' # drevo, kolo
    inflect.plural_slo /to$/i, 'ti', 'ta', 't' # sito, kopito
    inflect.plural_slo /je$/i, 'ji', 'ja', 'ij' # ohišje
    
    # za tele rabim se singularizacijo
    ['č', 'š', 'st', 'ut', 'os', 'smet'].each do |c|
      inflect.plural_slo(Regexp.new("#{c}$", true), "#{c}i", "#{c}i", "#{c}i")
      # smrček, bonbonček, prstek, kužek
      # kost, perut, gos, smet
      # ne dela: MOST
    end
    inflect.plural_slo /ec$/i, 'ca', 'ci', 'cev' # kozolec
    inflect.plural_slo /i(.)o$/i, 'i\1i', 'i\1a', 'i\1' # kladivo, vodilo
    ['r', 'n'].each do |c|
      inflect.plural_slo(Regexp.new("#{c}o$", true), "#{c}i", "#{c}a", "e#{c}")
      # vedro, vlakno
    end
    inflect.plural_slo /ce$/i, 'ci', 'ca', 'c' # sonce
    
    # za tele rabim se singularizacijo
    # manjšalnice
    ['č', 'ž', 't'].each do |c|
      inflect.plural_slo(Regexp.new("#{c}ek$", true), "#{c}ka", "#{c}ki", "#{c}kov")
      # smrček, bonbonček, prstek, kužek
    end

    # posebni
    inflect.plural_slo /^pes$/i, 'psa', 'psi', 'psov'
    inflect.plural_slo /^smrt$/i, 'smrti', 'smrti', 'smrti'
    
=begin
    inflect.singular /.$/, 'a'
    inflect.singular /ov$/i, ''
    inflect.singular /es$/i, 'o'
    inflect.singular /t$/i, 'to'
    inflect.singular /ij$/i, 'je'
=end
  end
end

# add helper
%w{ helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths << path
end
