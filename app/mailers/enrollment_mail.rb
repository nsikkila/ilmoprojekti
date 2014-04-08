class EnrollmentMail < ActionMailer::Base
  default from: "donotreply@ilmoprojekti.com"

  def confirmation_email(user, hash, projectbundle)
    @projectbundle = projectbundle
  	@enrollment=user
  	@digest=hash
  	@url="http://ilmoprojekti.herokuapp.com/enrollments"+@enrollment.id.to_s+"/"+@digest
  	mail(to: @enrollment.email, subject:'Vahvistus ilmottautumisesta')
  end

  def result_email_for_all(enrollments)
    @mails = []
    enrollments.each do |enrs|
      result_email_for_one(enrs)
      @mails << enrs.email
    end
    mail(bcc: @mails , subject:'Ilmottautumisen tulokset')
  end

  def result_email_for_one(enrollment)
    @projs = []
    @student = enrollment.name
    enrollment.signups.each do |sign|
      if sign.status
        @projs << sign.project.name
      end
    end
  end
end
