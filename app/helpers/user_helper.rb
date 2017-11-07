module UserHelper
  def time_zones_for_select
    time_zones = ActiveSupport::TimeZone.all.map {|tz| ["#{tz.name} (#{tz.utc_offset / 3600})", tz.name] }
    time_zones.unshift ['-', '']
    time_zones
  end
end
