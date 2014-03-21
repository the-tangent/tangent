class FakeClock
  def set_time(string)
    @time = Time.parse(string)
  end

  def now
    (@time || Time.at(0).utc)
  end
end
