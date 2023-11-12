module APIError
  class StandardError < ::StandardError
    attr_reader :title, :detail, :status, :source

    delegate :to_s, to: :to_h

    def initialize(title: nil, detail: nil, status: nil, source: nil) # rubocop:disable Lint/MissingSuper
      @title = title || 'Something went wrong'
      @detail = detail || 'We encountered unexpected error, but our developers had been already notified about it'
      @status = status || '500'
      @source = source || {}
    end

    def to_h
      {
        title:,
        detail:,
        status:,
        source:
      }.compact_blank
    end

    def serializable_hash
      to_h
    end
  end
end
