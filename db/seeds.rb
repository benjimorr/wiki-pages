require 'random_data'

10.times do
    User.create!(
        email: RandomData.random_email,
        password: RandomData.random_sentence
    )
end

my_user = User.new({email: 'benmorrison0@gmail.com', password: 'bsm11bc16', password_confirmation: 'bsm11bc16'})
my_user.confirm
my_user.save

users = User.all

100.times do
    Wiki.create!(
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph,
        private: false,
        user: users.sample
    )
end

puts "Seeds finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
