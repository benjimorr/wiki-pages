class CollaboratorsController < ApplicationController
    before_action :set_current_wiki
    after_action :verify_authorized

    def new
        @wiki = Wiki.find(params[:wiki_id])
        @collaborator = Collaborator.new
        authorize @collaborator
    end

    def create
        @wiki = Wiki.find(params[:wiki_id])
        @collaborator = Collaborator.new(collaborator_params)
        authorize @collaborator

        if @collaborator.save
            flash[:notice] = "Collaborator was successfully created."
            redirect_to @wiki
        else
            flash.now[:alert] = "Error creating collaborator. Please try again."
            render :new
        end
    end

    def destroy
        @collaborator = Collaborator.find(params[:id])
        authorize @collaborator

        if @collaborator.destroy
            flash[:notice] = "#{@collaborator.user.email} was successfully removed as a collaborator."
            redirect_to @collaborator.wiki
        else
            flash.now[:alert] = "There was an error deleting the collaborator."
            redirect_to :back
        end
    end

    private
    def collaborator_params
        params.require(:collaborator).permit(:wiki_id, :user_id)
    end

    def set_current_wiki
        current_user.current_wiki = Wiki.find(params[:wiki_id])
    end
end
