class Kaui::FunctionalTestHelper < ActionController::TestCase

  include Devise::TestHelpers
  include Kaui::KillbillTestHelper

  # Called before every single test
  setup do
    setup_functional_test
  end

  # Called after every single test
  teardown do
    teardown_functional_test
  end

  protected

  #
  # Rails helpers
  #

  def setup_functional_test
    # Create useful data to exercise the code
    setup_test_data

    @routes                        = Kaui::Engine.routes
    @request.env['devise.mapping'] = Devise.mappings[:user]

    # Login
    login_as_admin
  end

  def teardown_functional_test
    check_no_flash_error
  end

  def verify_pagination_results!(min = 0)
    assert_response 200

    body = MultiJson.decode(@response.body)
    # We could probably do better checks here since each test runs in its own tenant
    assert body['iTotalRecords'] >= min
    assert body['iTotalDisplayRecords'] >= min
    assert body['aaData'].instance_of?(Array)
  end

  def login_as_admin
    wrap_with_controller do
      get :new
      post :create, {:user => {:kb_username => USERNAME, :password => PASSWORD}}
    end
  end

  # Cheat to access a different controller
  def wrap_with_controller(new_controller = Kaui::SessionsController)
    old_controller = @controller
    @controller    = new_controller.new
    yield
    @controller = old_controller
  end
end
