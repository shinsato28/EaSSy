# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
  email: 'admin@test.com',
  password: '111111'
)

3.times do |n|
    User.create!(
      email: "test#{n + 1}@test.com",
      password: "111111",
      name: "test#{n + 1}",
      introduction: "初期ユーザー#{n + 1}です"
    )
  end

10.times do |n|
    Novel.create!(
      user_id: 1,
      title: "test1の投稿小説#{n + 1}",
      body: "投稿された小説の内容#{n + 1}\nです"
    )
  end

10.times do |n|
    Novel.create!(
      user_id: 2,
      title: "test2の投稿小説#{n + 1}",
      body: "投稿された小説の内容#{n + 1}\nです"
    )
  end

10.times do |n|
    Novel.create!(
      user_id: 3,
      title: "test3の投稿小説#{n + 1}",
      body: "投稿された小説の内容#{n + 1}\nです"
    )
  end

Tag.create!(
  name: "tag_name"
)

novels_count = Novel.all.count

novels_count.times do |n|
  TagMap.create!(
    novel_id: (n + 1),
    tag_id: 1
  )
end

novels_count.times do |n|
  NovelComment.create!(
    user_id: 1,
    novel_id: (n + 1),
    comment: "テストコメント"
  )
end