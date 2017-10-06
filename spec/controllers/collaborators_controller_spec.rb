require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
    let(:user) { create(:user, role: "premium") }
    let(:other_user) { create(:user, role: "premium") }
    let(:standard_user) { create(:user) }
    let(:admin_user) { create(:user, role: "admin") }
    let(:wiki) { create(:wiki, private: true, user: user) }
    let(:other_wiki) { create(:wiki, private: true, user: other_user) }
    let(:collaborator) { Collaborator.create!(wiki: wiki, user: other_user) }
    let(:standard_collaborator) { Collaborator.create!(wiki: wiki, user: standard_user) }
    let(:other_collaborator) { Collaborator.create!(wiki: other_wiki, user: admin_user) }

    context "guest user using collaborators" do
        describe "GET #new" do
            it "returns http redirect" do
                get :new, wiki_id: wiki.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end
    end

    context "standard user using collaborators on a private wiki they are not added to" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            standard_user.confirm
            sign_in standard_user
        end

        describe "GET #new" do
            it "returns http redirect" do
                get :new, wiki_id: wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: standard_user}
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end
    end

    context "standard user using collaborators on a private wiki they are added to" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            standard_user.confirm
            sign_in standard_user
        end

        describe "GET #new" do
            it "returns http redirect" do
                get :new, wiki_id: wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: standard_user}
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end
    end

    context "premium user using collaborators on a private wiki they own" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user.confirm
            sign_in user
        end

        describe "GET #new" do
            it "returns http success" do
                get :new, wiki_id: wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #new view" do
                get :new, wiki_id: wiki.id
                expect(response).to render_template :new
            end

            it "instantiates @collaborator" do
                get :new, wiki_id: wiki.id
                expect(assigns(:collaborator)).not_to be_nil
            end
        end

        describe "POST #create" do
            it "increases the number of Collaborator by 1" do
                expect{ post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}}.to change(Collaborator, :count).by(1)
            end

            it "assigns the new collaborator to @collaborator" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}
                expect(assigns(:collaborator)).to eq Collaborator.last
            end

            it "refreshes the wiki show view" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}
                expect(response).to redirect_to wiki
            end
        end

        describe "DELETE #destroy" do
            it "deletes the collaborator" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                count = Collaborator.where({id: wiki.id}).size
                expect(count).to eq(0)
            end

            it "redirects to the wiki show view" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                expect(response).to redirect_to wiki
            end
        end
    end

    context "premium user using collaborators on a private wiki they are added to" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            other_user.confirm
            sign_in other_user
        end

        describe "GET #new" do
            it "returns http redirect" do
                get :new, wiki_id: wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end
    end

    context "premium user using collaborators on a private wiki they are not added to" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user.confirm
            sign_in user
        end

        describe "GET #new" do
            it "returns http redirect" do
                get :new, wiki_id: other_wiki.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki_id: other_wiki.id, collaborator: {wiki: other_wiki, user: user}
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end

        describe "DELETE #destroy" do
            it "returns http redirect" do
                delete :destroy, wiki_id: other_wiki.id, id: other_collaborator.id
                expect(response).to redirect_to(request.referrer || root_path)
            end
        end
    end

    context "admin user using collaborators on any wiki" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            admin_user.confirm
            sign_in admin_user
        end

        describe "GET #new" do
            it "returns http success" do
                get :new, wiki_id: wiki.id
                expect(response).to have_http_status(:success)
            end

            it "renders the #new view" do
                get :new, wiki_id: wiki.id
                expect(response).to render_template :new
            end

            it "instantiates @collaborator" do
                get :new, wiki_id: wiki.id
                expect(assigns(:collaborator)).not_to be_nil
            end
        end

        describe "POST #create" do
            it "increases the number of Collaborator by 1" do
                expect{ post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}}.to change(Collaborator, :count).by(1)
            end

            it "assigns the new collaborator to @collaborator" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}
                expect(assigns(:collaborator)).to eq Collaborator.last
            end

            it "refreshes the wiki show view" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: other_user}
                expect(response).to redirect_to wiki
            end
        end

        describe "DELETE #destroy" do
            it "deletes the collaborator" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                count = Collaborator.where({id: wiki.id}).size
                expect(count).to eq(0)
            end

            it "redirects to the wiki show view" do
                delete :destroy, wiki_id: wiki.id, id: collaborator.id
                expect(response).to redirect_to wiki
            end
        end
    end
end
