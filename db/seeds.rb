User.create! name: "Example User", email: "example@railstutorial.org",
  password: "12345678", password_confirmation: "12345678", is_admin: "true"

Settings.seed.user.number_fake_users.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create! name: name, email: email, password: password,
    password_confirmation: password, activated: true,
    activated_at: Time.zone.now
end

users = User.order(:created_at).take 6
Settings.seed.micropost.number_fake_microposts.times do
  content = Faker::Lorem.sentence 5
  users.each{|user| user.microposts.create! content: content}
end
