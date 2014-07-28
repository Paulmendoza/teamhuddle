class RecurringEvent < ActiveRecord::Base
  
  belong_to :event

  validates :date_start, 
    :presence => true,
    numericality:
        { only_integer: true, greater_than: 0, less_than: self.date_end }
  validates :date_end,
    :presence => true,
    numericality:
        { only_integer: true }
  validates :time_start,
    :presence => true,
    numericality:
        { only_integer: true }
  validates :time_end,
    numericality:
        { only_integer: true },
    allow_nil: true

end
