class DestroyUrl
  include Interactor

  def call
    context.fail!(error: context.url.errors.full_messages) unless context.url.destroy
  end
end
