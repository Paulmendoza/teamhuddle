class SportEvent < ActiveRecord::Base
  self.inheritance_column = 'zoink'
  after_initialize :init
  
  belongs_to :event, :dependent => :delete
  has_many :archived_sport_events
  has_many :sport_event_instances, :dependent => :delete_all

  validates :sport, :presence => true
  validates :type, :presence => true, inclusion: { in: ["dropin", "league", "tournament"] }
  validates :schedule, :presence => true
  
  serialize :schedule, IceCube::Schedule
  
  validate :non_terminating_schedule, :schedule_has_no_occurrences, :start_time_greater_than_or_equal_end_time
  
  # IceCube schedule validations
  def non_terminating_schedule
    errors.add(:non_terminating, "Schedule must terminate") if schedule.present? && !schedule.terminating?
  end
  
  def schedule_has_no_occurrences
    if schedule.present? && (schedule.remaining_occurrences.count < 1)
      errors.add(:no_occurrences, "The way you configured your schedule, no occurences were made. (Maybe start date was greater than end date?)") 
    end
  end
  
  def start_time_greater_than_or_equal_end_time
    if schedule.present? && (schedule.start_time >= schedule.end_time)
      errors.add(:start_time_greater_or_equal, "The start time can't be more than or equal to the end time") 
    end
  end
  
  def as_json(options={})
   options[:except] ||= [:event_id]
   super(options)
  end
  
  # exposes event fields and associated objects
  delegate :name, :to => :event
  delegate :comments, :to => :event

  def location
    self.event.location
  end

  def organization
    self.event.organization
  end

  def createvent (name, locaiton_id, organization_id)
    @event = Event.new
    @event.name = name
    @event.location_id = location_id
    @event.organization_id = organization_id

    if @event.save
      self.event_id = @event.id
      return @event.event_id
    else
      return -1
    end
  end
  # end

  private
  def init
  end

end

<<-DOC

_table: sport_events
  _columns:
  event_id
  sport
  type
  skill_level
  price_per_one
  price_per_group
  spots
  spots_filled
  gender
  notes
  format

created by: paul
last edit: paul

DOC