require 'date'

class Oldness

  def self.old?(date)
    date <= (Date.today - 500)
  end

end
