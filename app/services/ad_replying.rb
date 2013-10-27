class AdReplying
  def call!(opts = {})
    user, ad, content = %w.user ad content..map do |attr|
      opts.fetch attr.to_sym
    end

    reply  = ad.replies.build
    reply.user = user
    reply.content = content
    reply.save!
    reply
  end
end
