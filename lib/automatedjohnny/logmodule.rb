module LogModule
  
              
  def log_expense(expense_type = '', amount = '', company = '', conf = '', account_number = '', tag ='', date_of_expense = '', link ='')
    db = SQLite3::Database.new("/Users/johnnygoodman/Dropbox/www/AutomatedJohnny/db/automatedjohnny.db")
    
    sql = "INSERT INTO ExpenseLogTbl
           (DateOfExpense, ExpenseType, Company, Amount, Conf, AccountNumber, Tag, Link)
           VALUES
           ('#{date_of_expense}', '#{expense_type}', '#{company}', '#{amount}', '#{conf}', '#{account_number}', '#{tag}', '#{link}')"
    puts sql 
    
    db.execute(sql)
                 
    db.execute("select * from ExpenseLogTbl ORDER BY ExpenseID DESC LIMIT 1").each do |row|
        p row
    end
    
  end
  
end