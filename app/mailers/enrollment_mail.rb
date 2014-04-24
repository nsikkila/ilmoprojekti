class EnrollmentMail < ActionMailer::Base
  default from: "ilmoprojekti@gmail.com"

  def confirmation_email(user, hash, projectbundle)
    @projectbundle = projectbundle
    @enrollment=user
    @digest=hash
    @url="http://ilmoprojekti.herokuapp.com/enrollments/"+@enrollment.id.to_s+"/"+@digest
    mail(to: @enrollment.email, subject: 'Vahvistus ilmottautumisesta')
  end

  def result_email_for_all(enrollments)

    #  enrollments.to_a
    if enrollments.is_a? Enrollment
      @mails = enrollments.email
      result_email_for_one(enrollments)
    elsif enrollments.count == 1
      @mails = enrollments.first.email
      result_email_for_one(enrollments.first)
    else

      @mails = []
      enrollments.each do |enrs|
        result_email_for_one(enrs)
        @mails << enrs.email
      end
    end
    mail(bcc: @mails, subject: 'Ilmottautumisen tulokset')
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
