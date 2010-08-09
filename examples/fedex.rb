$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'


aj = AutomatedJohnny.new 
agent = Mechanize.new

conf = ""
amount = ""

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /FedEx Billing Online Payment Reference # [0-9]{8}/ || email.subject =~ /Fwd: FedEx Billing Online Payment Reference # [0-9]{8}/
      
      page = agent.get 'https://www.fedex.com/fcl/?appName=fclfio&locale=us_en&step3URL=https%3A%2F%2Fwww.fedex.com%2FFedExMMA%2Fjsp%2FFioStep3.jsp&returnurl=https%3A%2F%2Fwww.fedex.com%2FFedExMMA%2Fjsp%2FRegistrationRouter.jsp&programIndicator='
      form = page.forms.second
      form.username = FEDEX['username']
      form.password = FEDEX['password']
      page = agent.submit form

      page = agent.click(page.link_with(:href => /\/FedExMMA\/open.do/))

      page.search(".rowstripodd td:nth-child(2) a").each do |item| 
        conf = item.text.strip!
      end

      page.search(".rowstripodd td:nth-child(7)").each do |item| 
        amount = item.text.strip!
      end   
         
      date = email.date.strftime('%m/%d/%Y')   
         
      aj.fedex_domestic("Freight", amount, "Fedex.com - Shipments", conf, "", "CPAP.com", date)
   
    elsif email.subject =~ /FedEx Billing Online - Invoice\(s\) Ready for Payment/ || email.subject =~ /Fwd: FedEx Billing Online - Invoice\(s\) Ready for Payment/
        puts "Marked a 'Ready For Payment' Fedex email read"
    else
      puts "Email Marked unread: #{email.subject}"  
      email.mark(:unread)     
      
    end
  end
end

