class Utils
  def self.int?(val)
    return true if val.is_a?(Integer)
    val.to_s =~ /^-?[0-9]+$/
  end
end
