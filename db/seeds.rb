# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

150.times do
  email = Faker::Internet.email
  puts "Inserting #{email}"
  User.create!(email: email, password: "supersecret", password_confirmation: "supersecret")
end

user_count = User.count

1000.times do
  user_1 = User.find(1+rand(user_count))
   
  begin
    begin
      user_2 = User.find(1+rand(user_count))
    end while user_1 == user_2

    puts "Adding friends #{user_1.email} - #{user_2.email}"
    Friendship.create!(user_1: user_1, user_2: user_2, user_1_status: 'active', user_2_status: 'active')
  rescue Exception => e
    puts e
    retry
  end
end

User.all.each do |u|
  rand(10).times do
    puts "Inserting posts for #{u.email}"
    u.posts << Post.create(content: Faker::Lorem.paragraph, created_at: (rand(24*14)).hours.ago)
  end
end

Post.all.each do |p|
  rand(5).times do
    user = User.find(1+rand(user_count))
    puts "Inserting comment to post with id: #{p.id} by user: #{user.email}"
    Comment.create(content: Faker::Lorem.sentence, post: p, user: user)
  end
end 

5000.times do
  comment_count = Comment.count 

  # comment model has order in default_scope, RANDOM() won't work
  likeable = rand > 0.3 ? Post.order('RANDOM()').first : Comment.find(1+rand(comment_count))
  user = User.find(1+rand(user_count))

  begin
    Like.create(likeable: likeable, user: user)
    puts "#{user.email} likes #{likeable.class} with id #{likeable.id}"
  rescue
    puts "#{user.email} already liked #{likeable.class} with id #{likeable.id}"
  end
end

Profile.all.each do |p|
  puts "Updating #{p.user.email}'s profile"
  p.about_me = Faker::Lorem.paragraph
  p.gender = [ "Male", "Female" ].sample
  p.age = (14..60).to_a.sample
  p.city = Faker::Address.city
  p.country = Faker::Address.country
  p.work = Faker::Company.name
  p.website = Faker::Internet.domain_name
  p.save!
end
