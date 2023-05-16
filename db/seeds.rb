# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
  email: 'admin@gmail.com',
  password: '111111'
)

3.times do |n|
    User.create!(
      email: "test#{n + 1}@gmail.com",
      password: "111111",
      name: "test#{n + 1}",
      introduction: "初期ユーザー#{n + 1}です"
    )
  end