class WikisController < ApplicationController
    before_action :authorize_user, only: [:edit, :update, :destroy]

    def index
        @wikis = Wiki.visible_to_user(current_user).all
    end

    def show
        @wiki = Wiki.find(params[:id])
    end

    def new
        @wiki = Wiki.new
    end

    def create
        @wiki = Wiki.new(wiki_params)
        @wiki.user = current_user

        if @wiki.save
            flash[:notice] = "Wiki was successfully created."
            redirect_to @wiki
        else
            flash.now[:alert] = "Error creating wiki. Please try again."
            render :new
        end
    end

    def edit
        @wiki = Wiki.find(params[:id])
    end

    def update
        @wiki = Wiki.find(params[:id])

        @wiki.assign_attributes(wiki_params)

        if @wiki.save
            flash[:notice] = "Wiki was successfully updated."
            redirect_to @wiki
        else
            flash.now[:alert] = "Error updating wiki. Please try again."
            render :edit
        end
    end

    def destroy
        @wiki = Wiki.find(params[:id])

        if @wiki.destroy
            flash[:notice] = "Wiki was successfully deleted."
            redirect_to action: :index
        else
            flash.now[:alert] = "There was an error deleting the wiki."
            render :show
        end
    end

    private
    def wiki_params
        params.require(:wiki).permit(:title, :body, :private)
    end

    def authorize_user
        wiki = Wiki.find(params[:id])

        unless current_user == wiki.user
            flash[:alert] = "You are not allowed to do that."
            redirect_to wiki
        end
    end
end
