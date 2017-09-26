require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @user
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end

  test "index as non-admin" do
    log_in_as(@other_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "Should redirect destroy when not loggen in" do 
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy requests when user isn't an admin" do 
    log_in_as(@other_user)
    delete user_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'Should redirect when not logged in' do 
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'Should redirect update when not logged in' do 
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'Should redirect when logged in as other user' do 
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.admin?
  end

end
