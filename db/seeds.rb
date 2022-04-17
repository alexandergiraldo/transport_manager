# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

account = Account.where(name: 'FGR').first_or_create
user = User.where(email: 'alexgr200@gmail.com', full_name: 'Alexander Giraldo', account_id: account.id, role: 1).first_or_create(password: 'testing')
user.accounts << account
