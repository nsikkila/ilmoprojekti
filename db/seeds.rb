# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admUser=User.create username:"isojehu", firstname:"Antti", lastname:"Admin", password:"Isojehu1", password_confirmation:"Isojehu1", accesslevel:1, disabled:false
normUser=User.create username:"pikkujehu", firstname:"Pekka", lastname:"Perus", password:"Pikkujehu1", password_confirmation:"Pikkujehu1", accesslevel:0, disabled:false
disabledUser=User.create username:"disabled", firstname:"Herra", lastname:"Estetty", password:"Disabled1", password_confirmation:"Disabled1", accesslevel:0, disabled:true
mockbundle=Projectbundle.create name:"Kevään 2014 ilmoittautumiset", description:"Kaikki kevään 2014 projektiryhmät", active:true, signup_start:Date.current, signup_end:Date.tomorrow, verified:false
mockproject1=Project.create name:"Ohjelmoinnin perusteet", description:"Ohjelmoinnin perusteiden projektiryhmä", maxstudents:10, user_id:normUser.id, projectbundle_id:1, website: "http://www.slashdot.org"
mockproject2=Project.create name:"Ohjemistotuotantoprojekti", description:"Ohjelmistotuotannon projektiryhmä", maxstudents:5, user_id:normUser.id, projectbundle_id:1, website: "http://www.dotabuff.com"
mockproject3=Project.create name:"Kotitalousprojekti", description:"Tässä ryhmässä leivotaan", maxstudents:20, user_id:normUser.id, projectbundle_id:1, website: "http://www.yle.fi"
mockproject4=Project.create name:"Kampaamoprojekti", description:"Tässä ryhmässä kammataan", maxstudents:5, user_id:normUser.id, projectbundle_id:1, website: "http://www.hs.fi"
mockproject4=Project.create name:"Traktoriprojekti", description:"Tässä ryhmässä rakennetaan traktori", maxstudents:10, user_id:normUser.id, projectbundle_id:1, website: "http://www.joindota.com"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"
mockproject4=Project.create name:"Lumenluontiprojekti", description:"Tässä ryhmässä kolataan", maxstudents:15, user_id:normUser.id, projectbundle_id:1, website: "http://www.radiohelsinki.fi"

