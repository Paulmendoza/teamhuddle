class SportEvent < ActiveRecord::Base
  self.inheritance_column = 'zoink'
  after_initialize :init

  belongs_to :event
  has_many :archived_sport_events
  has_many :sport_events

  validates :sport, :presence => true
  validates :type, :presence => true, inclusion: { in: ["dropin", "league", "tournament"] }
  
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