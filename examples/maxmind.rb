$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new 

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /Receipt for Your Payment to MaxMind Inc/ || email.subject =~ /Fwd: Receipt for Your Payment to MaxMind Inc/|| email.subject =~ /Fwd: Fwd: Receipt for Your Payment to MaxMind Inc/ 
            
      page = email.body.to_s
      doc = Nokogiri::HTML(page) #Turn Fedex HTML Into A Parseable Nokogiri Object

      ids = ["td td:nth-child(2) a", "div td tr:nth-child(2) td:nth-child(2)"]

      content = ids.map do |x|
       doc.css(x) { item.content }  #chain .match here?
      end

      conf, amount = content
    
      conf.to_s.match(/([0-9A-Z]{17})/)
      conf = $1
      amount.to_s.match(/(\d{2,3}.\d{2})/)
      amount = $1

      date = email.date.strftime('%m/%d/%Y')
          
      aj.maxmind("Web Software Rental", amount, "MaxMind.com - Geolocation via IP API", conf, '', "CPAP.com", date)  

    else
      puts "Email Marked unread: #{email.subject}" 
      email.mark(:unread)
    end
  end
end
