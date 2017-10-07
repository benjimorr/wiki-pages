class CollaboratorPolicy < ApplicationPolicy
    attr_reader :user, :collaborator

    def initialize(user, collaborator)
        @user = user
        @collaborator = collaborator
    end

    def new?
        user.admin? || (user.id == user.current_wiki.user_id && user.premium?)
    end

    def create?
        user.admin? || (user.id == user.current_wiki.user_id && user.premium?)
    end

    def destroy?
        user.admin? || (user.id == user.current_wiki.user_id && user.premium?)
    end
end
