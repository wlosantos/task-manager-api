require 'rails_helper'

RSpec.describe Authenticable, type: :controller do

  controller(ApplicationController) do
    include Authenticable
  end

end
