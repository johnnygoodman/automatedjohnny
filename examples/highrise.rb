$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new 

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /\[Invoice\] Highrise Monthly Subscription #[0-9]{7}/ || email.subject =~ /Fwd: \[Invoice\] Highrise Monthly Subscription #[0-9]{7}/
      
      #this is a perfect place for Enumeration. Come back after shrinking the automatedjohnny class
      email.body.to_s.match(/Amount PAID: \$([0-9]{2}|[0-9]{3})\.00/)
      amount = $1      
      email.body.to_s.match(/Transaction ID: ([0-9]{7})/)
      conf = $1
      email.body.to_s.match(/([0-9]{4}-[0-9]{2}-[0-9]{2})/)
      date = $1
      date = Date.parse($1).strftime('%m/%d/%Y')
      
      aj.thirtysevensignals("Web Software Rental", amount, "37Signals.com - Highrise Contact Management", conf, '', "CPAP.com", date)  
    else
      puts "Email Marked unread: #{email.subject}" 
      email.mark(:unread)
    end
  end
end
