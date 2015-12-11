module Sufia
  module WorksControllerBehavior
    extend ActiveSupport::Concern
    include Sufia::Controller
    include CurationConcerns::CurationConcernController

    included do
      include Sufia::Breadcrumbs
      before_action :has_access?, except: :show
      before_action :build_breadcrumbs, only: [:edit, :show]
      set_curation_concern_type GenericWork
      layout "sufia-one-column"
    end

    def new
      # TODO: move this to curation_concerns
      @form = form_class.new(curation_concern, current_ability)
      curation_concern.depositor = (current_user.user_key)
      super
    end

    protected

      def show_presenter
        Sufia::WorkShowPresenter
      end
  end
end