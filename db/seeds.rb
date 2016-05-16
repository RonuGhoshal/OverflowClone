5.times{ User.create(user_name: Faker::Internet.user_name, password: "1234" ) }
5.times{ Question.create(content: Faker::Lorem.paragraph, title: Faker::Lorem.sentence, user_id: rand(1..5))}
15.times{ Answer.create(content: Faker::Lorem.sentence, user_id: rand(1..5), question_id: rand(1..5))}
20.times{ Comment.create(content: Faker::Lorem.sentence, user_id: rand(1..5), commentable_type: ['Question, Answer'].sample, commentable_id: rand(1..5))

}
10.times{ Vote.create }

user1 = User.first
user2 = User.find(2)

user1.questions << Question.first
user1.questions << Question.find(2)
user2.questions << Question.find(3)
user2.questions << Question.find(4)

user1.votes << Vote.first
user1.votes << Vote.last
user2.votes << Vote.find(2)
user2.votes << Vote.find(3)
user2.votes << Vote.find(7)

Question.first.votes << Vote.first
Answer.first.votes << Vote.last
Comment.last.votes << Vote.find(7)
Answer.last.comments << Comment.first
Question.last.comments << Comment.last

q5 = Question.find(5)
user2.questions << q5

q5.answers << Answer.first
q5.answers << Answer.second
q5.answers << Answer.third

q5.best_answer = Answer.first

q5.comments << Comment.first
q5.comments << Comment.second
q5.comments << Comment.third

Answer.first.comments << Comment.find(4)
Answer.first.comments << Comment.find(5)
Answer.second.comments << Comment.find(6)
Answer.third.comments << Comment.find(7)