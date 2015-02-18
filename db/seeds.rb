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

1000.times do
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

User.all.each do |u|
  rand(10).times do
    puts "Inserting posts for #{u.email}"
    u.posts << Post.create(content: Faker::Lorem.paragraph, created_at: (rand(24*14)).hours.ago)
  end
end

Post.all.each do |p|
  rand(5).times do
    user = User.order('RANDOM()').first
    puts "Inserting comment to post with id: #{p.id} by user: #{user.email}"
    Comment.create(content: Faker::Lorem.sentence, post: p, user: user)
  end
end 

5000.times do
  comment_count = Comment.count 

  # comment model has order in default_scope, RANDOM() won't work
  likeable = rand > 0.3 ? Post.order('RANDOM()').first : Comment.find(1+rand(comment_count))
  user = User.order('RANDOM()').first

  begin
    Like.create(likeable: likeable, user: user)
    puts "#{user.email} likes #{likeable.class} with id #{likeable.id}"
  rescue
    puts "#{user.email} already liked #{likeable.class} with id #{likeable.id}"
  end
end
