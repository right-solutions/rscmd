module Admin
  class SubscriptionsController < Admin::ResourceController

  	private

    def set_navs
      set_nav("admin/subscriptions")
    end

  end
end
