# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = FactoryGirl.create(:user_admin, email: 'user_admin@example.org')
FactoryGirl.create(:user, email: 'user_guest@example.org')
property = FactoryGirl.create(:property, user: admin)
property2 = FactoryGirl.create(:property, user: admin)
FactoryGirl.create_list(:property_visit, 10, visitable_id: property.id)
FactoryGirl.create_list(:property_visit, 5, visitable_id: property2.id)
FactoryGirl.create_list(:user_visit, 5, visitable_id: admin.id)
