require 'rubygems'
require 'sqlite3'
#require 'mongo' //in future, for now SQLite will do (but I refuse to normalize it.)
require 'gmail'
require 'mail'
require 'mechanize'
require 'nokogiri'
require 'date'
require 'automatedjohnny/mailmodule'
require 'automatedjohnny/logmodule'
$LOAD_PATH <<  "#{File.dirname(__FILE__)}/../config"
require 'login'

class AutomatedJohnny 
  include MailModule
  include LogModule
  
#Expense Mailing Methods

  def thirtysevensignals(expense_type, amount, company, conf, account_number, tag, date)
      expense_string = "#{expense_type}, #{amount}, #{company} "
      expense_string << "Account #{account_number} " unless account_number.empty? == true 
      expense_string << "Conf #{conf} " unless conf.empty? == true 
      expense_string <<  "##{tag} date #{date}"
      mail_expense(expense_string) 
      log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end
  
  def gotoassist(expense_type, amount, company, conf, account_number, tag, date)
      expense_string = "#{expense_type}, #{amount}, #{company} "
      expense_string << "Account #{account_number} " unless account_number.empty? == true 
      expense_string << "Conf #{conf} " unless conf.empty? == true 
      expense_string <<  "##{tag} date #{date}"
      mail_expense(expense_string) 
      log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end
         
  def ups_domestic(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)  
  end
  
  def endicia_postage(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)  
  end
  
  def endicia_fee(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)      
  end

  def fedex_domestic(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)      
  end
  
  def rackspace_cloud(expense_type, amount, company, conf, account_number, tag, date, link)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string, link) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end

  
  def vitelity(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end
  
  def talentwise(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end
  
  def att(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end
  
  def maxmind(expense_type, amount, company, conf, account_number, tag, date)
    expense_string = "#{expense_type}, #{amount}, #{company} "
    expense_string << "Account #{account_number} " unless account_number.empty? == true 
    expense_string << "Conf #{conf} " unless conf.empty? == true 
    expense_string <<  "##{tag} date #{date}"
    mail_expense(expense_string) 
    log_expense(expense_type, amount, company, conf, account_number, "CPAP.com", date)
  end


end
  

