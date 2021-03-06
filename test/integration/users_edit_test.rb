require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :michael
  end

  test "unsuccessful_edit" do
    log_in_as @user
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path @user, params: {user: {name: "",
                                           email: "foo@invalid",
                                           password: "passsword",
                                           passsword_confirmation: "wrongpass"}}
    assert_template "users/edit"
  end

  test "successful_edit with friendly forwarding" do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_url @user
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path @user, params: {user: {name: name,
                                           email: email,
                                           password: "password",
                                           passsword_confirmation: "password"}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
