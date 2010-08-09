$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require 'automatedjohnny'

# Update script to check against the db or xpenser to determine if the invoice its grabbed is existing or new

aj = AutomatedJohnny.new 

agent = Mechanize.new
page = agent.get 'https://manage.rackspacecloud.com/pages/Login.jsp'
form = page.forms.first
form.username = RACKSPACE_CLOUD['username']
form.password = RACKSPACE_CLOUD['password']
page = agent.submit form

rackspace_hash = Hash.new

page = agent.get('https://manage.rackspacecloud.com/CurrentInvoice.do?accountID=375211')

#enumerable 

ids = ['.invoice-date','.invoice-id','.amount-due']

item = ids.map do |id|
    page.search(id)
end

date, conf, amount = item

date = Date.parse("#{date.text}").strftime('%m/%d/%Y')
conf = conf.text
amount = amount.text.gsub!(/\$/,'')

link = "https://manage.rackspacecloud.com#{page.link_with(:text => 'Download PDF').href}"

aj.rackspace_cloud("Web Hosting", amount, "Rackspace.com - Cloud Hosting", conf, "", "CPAP.com", date, link)
    
    
