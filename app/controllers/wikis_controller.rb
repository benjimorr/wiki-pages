class WikisController < ApplicationController
    after_action :verify_authorized, except: [:index]

    def index
        @wikis = policy_scope(Wiki)
        #authorize @wikis
    end

    def show
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end

    def new
        @wiki = Wiki.new
        authorize @wiki
    end

    def create
        @wiki = Wiki.new(wiki_params)
        authorize @wiki
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
        authorize @wiki
    end

    def update
        @wiki = Wiki.find(params[:id])
        authorize @wiki
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
        authorize @wiki

        if @wiki.destroy
            flash[:notice] = "#{@wiki.title} was successfully deleted."
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
end
