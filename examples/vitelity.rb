$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new 

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /Vitelity LLC Payment Receipt/ || email.subject =~ /Fwd: Vitelity LLC Payment Receipt/
       body_text = email.body.to_s      
       body_text.match(/\$(100) has been successfully processed and applied to your account 'usexpediters'/)
       amount = $1
       date = email.date.strftime('%m/%d/%Y')
       aj.vitelity("Phones", amount, "Vitelity.com - DID Numbers", "", "", "CPAP.com", date)
    else
      puts "Email Marked unread: #{email.subject}" 
      email.mark(:unread)
    end
  end
end
