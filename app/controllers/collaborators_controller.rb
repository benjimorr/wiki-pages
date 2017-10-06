class CollaboratorsController < ApplicationController
    after_action :verify_authorized

    def new
        @collaborator = Collaborator.new
        authorize @collaborator
    end

    def create
        @collaborator = Collaborator.new(collaborator_params)
        authorize @collaborator

        if @collaborator.save
            flash[:notice] = "Collaborator was successfully created."
            redirect_to @collaborator.wiki
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
        params.require(:collaborator).permit(:wiki, :user)
    end
end
