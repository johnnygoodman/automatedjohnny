$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

# Update to check against the listed invoices on the email. Don't parse: http://grab.by/5Hqv

aj = AutomatedJohnny.new 

account_array = Array.new
invoice_array = Array.new
amount_array = Array.new
tag_array = Array.new
date_array = Array.new

cpapdotcom_array = CPAPDOTCOM_ARRAY
hms_array = HMS_ARRAY
hmsd_array = HMSD_ARRAY

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|
    
    if email.subject == "Your UPS Invoice is Ready" || email.subject == "Fwd: Your UPS Invoice is Ready"
          
      agent = Mechanize.new
      page = agent.get 'https://www.ups-ebill.ups.com/ebilling/'
      form = page.forms.first
      form.j_username = UPS['username']
      form.j_password = UPS['password']
      page = agent.submit form
          
      page = agent.get('https://www.ups-ebill.ups.com/ebilling/dashBoard.do?reportId=dashboardIncentiveRpt')
      invoice_page = agent.click(page.link_with(:text => /Invoice/))
      form = invoice_page.forms.first
      
      from_date = email.date-3
      from_date = from_date.strftime('%m/%d/%Y')
      
      to_date = email.date+2
      to_date = to_date.strftime('%m/%d/%Y')
      
      form.fromStatementDate = from_date
      form.toStatementDate =  to_date
      form.invStatus = 'None'
      result_page = agent.submit form

      result_page.search(".colortb:nth-child(2)").each do |item| #Scrape Account Numbers
        account_array << item.text.strip!
      end

      result_page.search(".colortb a").each do |item| #Scrape Invoice Number
        invoice_array << item.text.strip!
      end

      result_page.search(".colortb:nth-child(5)").each do |item| #Scrape Billed Amounts
        amount_array << item.text.strip.to_s.gsub(/[^\d\.]/, '')
      end

      result_page.search(".colortb:nth-child(1)").each do |item| #Scrape Billed Amounts
        date_array << item.text.strip!
      end

      account_array.each do |account| #Generate Tags

        case cpapdotcom_array.member?(account)
          when true  : tag_array << "CPAP.com"
        end

        case hms_array.member?(account)
          when true  : tag_array << "HMS"
        end

        case hmsd_array.member?(account)
          when true  : tag_array << "HMSD"
        end

      end                     
      
    ups_array = account_array.zip(invoice_array, amount_array, tag_array, date_array)

    ups_array.each do |account_number, conf, amount, tag, date|
      aj.ups_domestic("Freight", amount, "UPS", conf, account_number, tag, date)
    end
      
    else
            puts "Email Marked unread: #{email.subject}"  
            email.mark(:unread)     
    end
  end
end