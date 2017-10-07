require 'faker'

# Create standard users
5.times do
    new_user = User.new(
        email: Faker::Internet.unique.email,
        password: Faker::Internet.password
    )

    new_user.confirm
    new_user.save
    new_user.standard!
end

# Create premium users
5.times do
    new_user = User.new(
        email: Faker::Internet.unique.email,
        password: Faker::Internet.password
    )

    new_user.confirm
    new_user.save
    new_user.premium!
end

# Admin User
my_user = User.new({email: 'benmorrison0@gmail.com', password: 'bsm11bc16', password_confirmation: 'bsm11bc16'})
my_user.confirm
my_user.save
my_user.admin!

# Premium User
premium_user = User.new({email: 'premium@wikipages.com', password: 'password', password_confirmation: "password"})
premium_user.confirm
premium_user.save
premium_user.premium!

# Standard User
standard_user = User.new({email: 'standard@wikipages.com', password: 'password', password_confirmation: "password"})
standard_user.confirm
standard_user.save

standard_users = User.where(role: 0)
premium_users = User.where(role: 1)
premium_users << premium_user

# Create public wikis:
45.times do
    Wiki.create!(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph,
        private: false,
        user: standard_users.sample
    )
end

# Create private wikis:
45.times do
    Wiki.create!(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph,
        private: true,
        user: premium_users.sample
    )
end

# Create wikis for myself:
10.times do
    Wiki.create!(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph,
        private: [true, false].sample,
        user: my_user
    )
end

private_wikis = Wiki.where(private: true)

# Create collaborators:
30.times do
    Collaborator.create!(
        user: premium_users.sample,
        wiki: private_wikis.sample
    )
end

puts "Seeds finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
puts "#{Collaborator.count} collaborations created"
