# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

crumb :root do
  link 'ホーム', root_path
end

crumb :posts_index do
  link '事故画一覧', posts_path
  parent :root
end

crumb :post_new do
  link '事故画投稿'
  parent :posts_index
end

crumb :post_show do |post|
  link "#{post.user.name} さんの事故画", post_path(post)
  parent :posts_index
end

crumb :post_edit do |post|
  link '事故画編集'
  parent :post_show, post
end

crumb :users_index do
  link 'ユーザー一覧', users_path
  parent :root
end

crumb :user_new do
  link '会員登録'
  parent :root
end

crumb :user_show do |user|
  link "#{user.name} さんの詳細", user_path(user)
  parent :users_index
end

crumb :profile_show do |user|
  link "#{user.name} さんのプロフィール", profile_path(user)
  parent :root
end

crumb :profile_edit do |user|
  link 'プロフィール編集'
  parent :profile_show, user
end

crumb :like_posts_index do
  link 'いいね一覧'
  parent :root
end

crumb :login do
  link 'ログイン'
  parent :root
end

crumb :password_reset do
  link 'パスワード再設定申請'
  parent :login
end
