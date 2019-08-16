require_relative '_tt.rb'

TT.require_all!

module TT
  def TT.home
    home =
      catch :home do
        ["HOME", "USERPROFILE"].each do |key|
          throw(:home, ENV[key]) if ENV[key]
        end
        if ENV["HOMEDRIVE"] and ENV["HOMEPATH"]
          throw(:home, "#{ ENV['HOMEDRIVE'] }:#{ ENV['HOMEPATH'] }")
        end
        File.expand_path("~") rescue(File::ALT_SEPARATOR ? "C:/" : "/")
      end
    File.expand_path(home)
  end
end

class Date
  def self.from value
    ( Time.parse(value.to_s) || Date.parse(value.to_s) ).to_date
  end

  def to_date
    self
  end
end


class Time
  Beginning = Time.at(0)

  End = Time.at((2**31)-1)

  Now = Time.now

  Null = Time.at(0).instance_eval do
    def to_s() "" end
    def inspect() "" end
    self
  end

  def to_s(n=0) iso8601(n) end
  alias_method 'inspect', 'to_s'

  ### hack to fix Time.parse bug
  Parse = Time.method 'parse'
  def self.parse string
    if string =~ %r'^\d\d\d\d-\d\d-\d\dT\d\d:?$'
      string = string.sub(%r/:$/,'') + ':00'
    end
    if string =~ %r/\ban\b/
      string = string.sub(%r/\ban\b/, '1')
    end
    if string =~ %r'^\d\d\d\d-\d\d-\d\d'
      Parse.call string
    else
      Chronic.parse string, :context => :past
    end
  end

  def to_date
    Date.new year, month, day
  end

  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      tz = "Z"
      # from the tidy Tobias Peters <t-peters@gmx.de> Thanks!
      unless self.utc?
        utc_same_instant = self.dup.utc
        utc_same_writing = Time.utc(year,month,day,hour,min,sec,usec)
        difference_to_utc = utc_same_writing - utc_same_instant
        if (difference_to_utc < 0) 
          difference_sign = '-'
          absolute_difference = -difference_to_utc
        else
          difference_sign = '+'
          absolute_difference = difference_to_utc
        end
        difference_minutes = (absolute_difference/60).round
        tz = "%s%02d:%02d" % [ difference_sign, difference_minutes / 60, difference_minutes % 60]
      end
      standard = self.strftime( "%Y-%m-%dT%H:%M:%S" )
      standard += ".%02d" % [usec] #if usec.nonzero?
      standard += "%s" % [tz]
      if to_yaml_properties.empty?
        out.scalar( taguri, standard, :plain )
      else
       out.map( taguri, to_yaml_style ) do |map|
         map.add( 'at', standard )
         to_yaml_properties.each do |m|
           map.add( m, instance_variable_get( m ) )
         end
       end
      end
    end
  end
end

Tt=TT
