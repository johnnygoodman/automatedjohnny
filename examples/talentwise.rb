$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

aj = AutomatedJohnny.new 

Gmail.new( GMAIL['username'], GMAIL['password']) do |gmail|

  inbox = gmail.inbox

  inbox.emails(:unread).each do |email|

    if email.subject =~ /Fwd: TalentWise Purchase Receipt - Order #\d{8}/ || email.subject =~ /Fwd: TalentWise Purchase Receipt - Order #\d{8}/

    page = email.body.to_s
    doc = Nokogiri::HTML(page) #Turn Fedex HTML Into A Parseable Nokogiri Object
      
    ids = ["tr:nth-child(3) tr td:nth-child(1) b", "td:nth-child(3) b"]

    content = ids.map do |x|
      doc.css(x) { item.content }  #chain .match here?
    end

    conf, amount = content

    conf.to_s.match(/#(\d{8})/)
    conf = $1
    amount.to_s.match(/\$(\d{2,3}.\d{2})/)
    amount = $1

    date = email.date.strftime('%m/%d/%Y')

    aj.talentwise("Office", amount, "TalentWise.com - Background Check", conf, "", "CPAP.com", date)
    
    else
      puts "Email Marked unread: #{email.subject}" 
      email.mark(:unread)
    end
  end
end