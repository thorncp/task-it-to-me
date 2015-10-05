class Task < Struct.new(:name, :position)
  GRACE_PERIOD = 12*3600

  attr_accessor :finished_at

  def visible?
    not_finished? || finished_recently?
  end

  def finish
    self.finished_at = Time.now
  end

  def to_hash
    {
      name: name,
      finished_at: finished_at
    }
  end

  def self.load(data)
    task = new(data['name'])
    task.finished_at = data['finished_at']
    task
  end

  private

  def not_finished?
    !finished_at
  end

  def finished_recently?
    finished_at >= Time.now - GRACE_PERIOD
  end
end
