class EnrollmentMail < ActionMailer::Base
  default from: "donotreply@ilmoprojekti.com"

  def confirmation_email(user, hash)
  	@student=user
  	@digest=hash
  	@url="http://ilmoprojekti.herokuapp.com/enrollments/"+@student.id.to_s+"/"+@digest
  	mail(to: @user.email, subject:'Vahvistus ilmottautumisesta')
  end
end
