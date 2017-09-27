require 'faker'

10.times do
    User.create!(
        email: Faker::Internet.unique.email,
        password: Faker::Internet.password
    )
end

my_user = User.new({email: 'benmorrison0@gmail.com', password: 'bsm11bc16', password_confirmation: 'bsm11bc16'})
my_user.confirm
my_user.save

users = User.all

100.times do
    Wiki.create!(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph,
        private: [true, false].sample,
        user: users.sample
    )
end

puts "Seeds finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
