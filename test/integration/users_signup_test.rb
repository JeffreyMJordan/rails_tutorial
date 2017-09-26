require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "displays errors correctly" do 
    get signup_path
    post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup info creates a user" do 
    get signup_path 
    assert_difference 'User.count', 1 do 
      post users_path params:{user: {name: "Example User", 
                                    email: "user@example.com",
                                    password: "password",
                                    password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash[:success]
    assert is_logged_in?
  end


end































