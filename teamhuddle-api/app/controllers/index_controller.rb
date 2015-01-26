class IndexController < ApplicationController
  before_action :authenticate_user!, :only => [:dropin_finder]
  layout 'client'

  def dropin_finder

  end
end