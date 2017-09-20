class WikisController < ApplicationController
    before_action :authorize_user, expect: [:index, :show, :new, :create]

    def index
        @wikis = Wiki.all
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
    end

    def destroy
    end

    private
    def wiki_params
        params.require(:wiki).permit(:title, :body, :private)
    end

    def authorize_user
        wiki = Wiki.find(params[:id])

        unless wiki.user == current_user
            flash[:alert] = "You are not allowed to do that."
            redirect_to wiki
        end
    end
end
