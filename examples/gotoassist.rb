$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /Your GoToAssist Express Receipt/ || email.subject =~ /Fwd: Your GoToAssist Express Receipt/ || email.subject =~ /Fwd: Fwd: Your GoToAssist Express Receipt/
          agent = Mechanize.new
          
          #Change this to an in email scrape.
          page = agent.get 'https://secure.gotoassist.com/CitrixOnline/en/US/direct/col?cmd=COLMyAccount'
          form = page.forms.first
          form.emailAddress = GOTOASSIST['username']
          form.password = GOTOASSIST['password']
          page = agent.submit form

          page = agent.get('https://secure.gotoassist.com/CitrixOnline/en/US/direct/col?cmd=COLMyAccount')
          link = page.search('#billingData:nth-child(1) a')
          invoice_page = agent.click(page.link_with(:text => link.text))

          contents = ['.date','tr:nth-child(1) .blueCellData'].map do |x|
              invoice_page.search(x).text
          end

          date = Date.parse(contents[0]).strftime('%m/%d/%Y')
          amount = contents[1].gsub(/\$/,'')

          aj.gotoassist("Office", amount, "GoToAssist.com - Remote Desktop Software", "", "", "CPAPDropShip.com", date)

    else
      puts "Email Marked unread: #{email.subject}"  
      email.mark(:unread)     
    end
  
  end

end