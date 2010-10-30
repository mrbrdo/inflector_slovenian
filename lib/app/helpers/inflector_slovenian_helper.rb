module InflectorSlovenianHelper
  def pluralize_slo(count, singular, plural = nil)
    "#{count || 0} " + ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || ActiveSupport::Inflector.pluralize_slo(singular, count)))
  end
end
