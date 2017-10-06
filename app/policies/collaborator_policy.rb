class CollaboratorPolicy < ApplicationPolicy
    attr_reader :user, :collaborator

    def initialize(user, collaborator)
        @user = user
        @collaborator = collaborator
    end

    def new?
        user.admin? || user.id == collaborator.wiki.user_id
    end

    def create?
        user.admin? || user.id == collaborator.wiki.user_id
    end

    def destroy?
        user.admin? || user.id == collaborator.wiki.user_id
    end
end
