# frozen_string_literal: true

class Ability
    include CanCan::Ability
  
    def initialize(user)
  
      user ||= User.new # guest user
  
      if user.role == 'User'
        can :manage, Order, user_id: user.id
        can :manage, Trade, user_id: user.id
        can :manage, User, id: user.id
        can :read, Security
      elsif user.role == 'Admin'  # additional permissions for administrators
          can :manage, Order
          can :manage, Trade
          can :manage, Security
          can :manage, User
      end
  
    end
  
  end
  