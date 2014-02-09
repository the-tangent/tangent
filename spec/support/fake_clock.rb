class FakeClock
  def set_time(string)
    @time = Time.parse(string)
  end
  
  def now
    @time || Time.new
  end
end