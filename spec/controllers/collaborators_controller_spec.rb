require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
    let(:user) { create(:user, role: "premium") }
    let(:other_user) { create(:user, role: "premium") }
    let(:standard_user) { create(:user) }
    let(:admin_user) { create(:user, role: "admin") }
    let(:wiki) { create(:wiki, private: true) }
    let(:collaborator) { Collaborator.create!(wiki: wiki, user: user) }

    context "guest user using collaborators" do
        describe "GET #index" do
            it "returns http redirect" do
                get :index, wiki_id: wiki.id, collaborator_id: collaborator.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        describe "POST #create" do
            it "returns http redirect" do
                post :create, wiki_id: wiki.id, collaborator: {wiki: wiki, user: user}
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

    context "standard user using collaborators" do
        before(:each) do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            standard_user.confirm
            sign_in standard_user
        end

        describe "GET #index" do
            it "returns http redirect" do
                get :index, wiki_id: wiki.id, collaborator_id: collaborator.id
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
end
