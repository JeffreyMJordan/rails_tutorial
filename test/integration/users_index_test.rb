require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @malory = users(:malory)
  end

  test "tests pagination" do 
    log_in_as(@user)
    get users_path 
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user| 
      assert_select "a[href=?]", user_path(user), text: user.name unless user==@malory
    end
  end

  test "doesn't show unactivated user" do 
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select "a[href=?]", user_path(@malory), false
  end
end
