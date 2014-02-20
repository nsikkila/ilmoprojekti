class EnrollmentMail < ActionMailer::Base
  default from: "donotreply@ilmoprojekti.com"

  def confirmation_email(user, hash)
  	@enrollment=user
  	@digest=hash
  	@url="http://ilmoprojekti.herokuapp.com/enrollments/edit/"+@enrollment.id.to_s+"/"+@digest
  	mail(to: @enrollment.email, subject:'Vahvistus ilmottautumisesta')
  end
end
