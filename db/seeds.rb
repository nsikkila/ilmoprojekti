# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admUser=User.create username:"administrator", firstname:"Antti", lastname:"Admin", password:"HalmeOhtu14", password_confirmation:"HalmeOhtu14", accesslevel:1
normUser=User.create username:"opettaja", firstname:"Pekka", lastname:"Perus", password:"Opettaja1", password_confirmation:"Opettaja1", accesslevel:0
mockbundle=Projectbundle.create name:"Kevään 2014 ilmoittautumiset", description:"Kaikki kevään 2014 projektiryhmät", active:true, signup_start:Date.current, signup_end:Date.tomorrow
mockproject1=Project.create name:"Ohjelmoinnin perusteet", description:"Ohjelmoinnin perusteiden projektiryhmä", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.slashdot.org"
mockproject2=Project.create name:"Ohjemistotuotantoprojekti", description:"Ohjelmistotuotannon projektiryhmä", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.dotabuff.com"
mockproject3=Project.create name:"Kotitalousprojekti", description:"Tässä ryhmässä leivotaan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.yle.fi"
mockproject4=Project.create name:"Kampaamoprojekti", description:"Tässä ryhmässä kammataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.hs.fi"
mockproject4=Project.create name:"Traktoriprojekti", description:"Tässä ryhmässä rakennetaan traktori", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.joindota.com"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
