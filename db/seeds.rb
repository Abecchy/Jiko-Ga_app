# Userモデル5件
5.times do |n|
  User.create!(
    name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end

# Postモデル20件
20.times do |n|
  user = User.offset( rand(User.count) ).first
  Post.create!(
    title: Faker::Games::Pokemon.unique.name,
    body: "#{Faker::Games::Pokemon.move} を繰り出した！",
    user_id: user.id
  )
end
