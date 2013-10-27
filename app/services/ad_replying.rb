class AdReplying
  def call(opts = {})
    email, ad, content = %w.email ad content..map do |attr|
      opts.fetch attr.to_sym
    end

    UserMailer.send_email(ad, content, email).deliver
  end
end
