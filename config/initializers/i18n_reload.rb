Rails.configuration.after_initialize do
  I18n.reload!
end