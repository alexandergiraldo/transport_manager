class FeatureFlag
  def self.enabled?(feature_flag_name)
    FEATURE_FLAGS[feature_flag_name.to_sym]
  end
end
