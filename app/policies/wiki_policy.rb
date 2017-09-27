class WikiPolicy < ApplicationPolicy
    attr_reader :user, :wiki

    def initialize(user, wiki)
        @user = user
        @wiki = wiki
    end

    def show?
        if wiki.private
            user.admin? || user.premium?
        else
            user.present?
        end
    end

    def update?
        if wiki.private
            user.admin? || user.premium? || user.id == wiki.user_id
        else
            user.present?
        end
    end

    def destroy?
        user.admin? || user.id == wiki.user_id
    end

    class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
            @user = user
            @scope = scope
        end

        def resolve
            if user.admin? || user.premium?
                scope.all
            else
                scope.where(private: false)
            end
        end
    end
end
