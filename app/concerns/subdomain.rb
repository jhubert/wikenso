module Subdomain
  extend ActiveSupport::Concern

  included do
    def subdomain?
      request.subdomain =~ /.+/
    end
  end

  module ClassMethods
    def require_inclusion_of_subdomain(options={})
      before_filter do
        return if request.subdomain.blank?
        # Need a `call` because the list might keep changing
        return if options[:in].call.include?(request.subdomain)
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end