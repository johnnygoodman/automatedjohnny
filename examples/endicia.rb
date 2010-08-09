$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new 

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|
    
    if email.subject == "Thank you for your postage purchase" || email.subject == "Fwd: Thank you for your postage purchase"         
      body_text = email.body.to_s      
      body_text.match(/Purchase Amount: \$  ([0-9]{3}|[0-9]{2})\.([0-9]{2})/)
      amount = "#{$1}.#{$2}"
      conf = body_text.scan(/Confirmation Number: ([0-9]{6})/)[0].to_s.to_i.to_s
      date = email.date.strftime('%m/%d/%Y')
      aj.endicia_postage("Freight", amount, "Endicia.com - US Mail Shipments", conf, "", "CPAP.com", date)
         
    elsif email.subject == "Endicia Service Fee Receipt" || email.subject == "Fwd: Endicia Service Fee Receipt"
      body_text = email.body.to_s  
      body_text.match(/service fee of \$ ([0-9]{2}|[0-9]{3})\.([0-9]{2})/)
      amount = "#{$1}.#{$2}"
      conf = body_text.scan(/Your transaction confirmation number is: ([0-9]{6})?/)[0].to_s      
      date = email.date.strftime('%m/%d/%Y')
      aj.endicia_fee("Freight", amount, "Endicia Service Fee", conf, "", "CPAP.com", date)

    elsif email.subject == "Endicia Postage Refund Information" || email.subject == "Fwd: Endicia Postage Refund Information"        

      #mark as read, take no action

    else
      puts "Email Marked unread: #{email.subject}"  
      email.mark(:unread)     
    end
  end
end
