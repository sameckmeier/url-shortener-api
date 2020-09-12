class CreateUrl
  include Interactor

  def call
    url = Url.new(params)

    ActiveRecord::Base.transaction do
      unless url.shortened?
        shortened_url = ShortenedUrl.current.lock!
        set_shortened(url, shortened_url)
      end

      if url.save
        context.url = url
      else
        context.fail!(error: url.errors.full_messages)
      end
    end
  end

  private

  def params
    context.url_params.merge(client_id: context.client.id)
  end

  def set_shortened(url, shortened_url)
    url.shortened = shortened_url.sequence
    shortened_url.increment_sequence
  end
end
