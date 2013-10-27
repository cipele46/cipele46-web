class AdReplying
  def call!(opts = {})
    email, ad, content = %w.email ad content..map do |attr|
      opts.fetch attr.to_sym
    end

    reply  = ad.replies.build
    reply.email = email
    reply.content = content
    reply.save!
    reply
  end
end
