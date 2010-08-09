module MailModule


  def mail_expense(expense_string, link = '', confirm=1)
    options = { :address              => MAIL_XPENSER['address'],
                 :port                 => MAIL_XPENSER['port'],
                 :user_name            => MAIL_XPENSER['username'],
                 :password             => MAIL_XPENSER['password'],
                 :authentication       => 'plain',
                 :enable_starttls_auto => true  } 

     Mail.defaults do
       delivery_method :smtp, options
     end

     Mail.deliver do
            to MAIL_XPENSER['mail_to']
          from MAIL_XPENSER['mail_from']
       subject expense_string
          body ''
     end

     puts "Sent To Xpenser: #{expense_string}" unless confirm == 0 

     unless link.empty?
       Mail.deliver do
            to EMAILADDRESS['email_address']
          from MAIL_XPENSER['mail_from']
       subject expense_string
          body link
       end
     end

     puts "Invoice Download Link Mailed: #{link}" unless link.empty? 

  end

end
