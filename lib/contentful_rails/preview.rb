module ContentfulRails
  module Preview
    extend ActiveSupport::Concern

    included do
      return unless ContentfulRails.configuration.enable_preview_flag

      before_action :check_preview_flag
      after_action :remove_preview_cache
      if respond_to?(:helper_method)
        helper_method :preview?
      end
    end

    # Check whether the query param 'preview' is set
    def check_preview_flag
      # If enable_preview_domain is not enabled, explicitly set use_preview_api false and return
      ContentfulModel.use_preview_api = request.query_parameters['preview'] and request.query_parameters['preview'] != "f"
    end

    # If we're in preview mode, we need to remove the preview view caches which were created.
    # this is a bit of a hack but it's probably not feasible to turn off caching in preview mode.
    def remove_preview_cache
      expire_fragment(%r{.*/preview/.*})
    end

    def preview?
      ContentfulModel.use_preview_api == true
    end
  end
end