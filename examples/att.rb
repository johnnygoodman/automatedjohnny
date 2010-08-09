$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new 

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /AT&T AutoPay Payment Confirmation/ || email.subject =~ /Fwd: AT&T AutoPay Payment Confirmation/ 
      
      #this is a perfect place for Enumeration. Come back after shrinking the automatedjohnny class
      email.body.to_s.match(/Amount: \$(\d{2,3}\.\d{2})/)
      amount = $1      
      email.body.to_s.match(/Confirmation number: ([0-9A-Z]{15})/)
      conf = $1
      email.body.to_s.match(/Date: ([0-9]{2}\/[0-9]{2}\/[0-9]{4})/)
      date = $1
      date = Date.parse($1).strftime('%m/%d/%Y')
      
      aj.att("Phones", amount, "ATT.com - iPhone Voice and Data", conf, '', "CPAP.com", date)  
    else
      puts "Email Marked unread: #{email.subject}" 
      email.mark(:unread)
    end
  end
end
