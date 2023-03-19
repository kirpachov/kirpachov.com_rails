# frozen_string_literal: true

module V1
  class ProjectsController < ApplicationController
    skip_before_action :authenticate_user, only: %i[index show]

    def index
      items = ::ListProjects.run!(index_params).paginate(page: params[:page] || 1, per_page: params[:per_page] || 15)

      render json: {
        items: items,
        metadata: json_metadata(items)
      }
    end

    private

    def index_params
      {
        filters: params[:filters] || {},
        current_user: current_user,
        public_only: params[:public_only] == false ? false : true,
      }
    end
  end
end
