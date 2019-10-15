AttributeNormalizer.configure do |config|
  config.normalizers[:titleize] = lambda do |value, _options|
    value.is_a?(String) ? value.titleize : value
  end
end
