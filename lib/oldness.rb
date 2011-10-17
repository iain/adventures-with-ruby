require 'date'

class Oldness

  def self.old?(date, deprecated)
    !deprecated && date <= (Date.today - 500)
  end

end
