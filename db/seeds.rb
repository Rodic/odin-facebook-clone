# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(email: 'alec.rodic@gmail.com', password: "supersecret", password_confirmation: "supersecret")

99.times do
  email = Faker::Internet.email
  puts "Inserting #{email}"
  User.create!(email: email, password: "supersecret", password_confirmation: "supersecret")
end

3000.times do
  user_1 = User.order('RANDOM()').first
   
  begin
    begin
      user_2 = User.order('RANDOM()').first
    end while user_1 == user_2

    puts "Adding friends #{user_1.email} - #{user_2.email}"
    Friendship.create!(user_1: user_1, user_2: user_2, user_1_status: 'active', user_2_status: 'active')
  rescue Exception => e
    puts e
    retry
  end
end
