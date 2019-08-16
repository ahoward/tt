module TT
  Version = '1.0.0' unless const_defined?(:Version)

  class << self
    def version() TT::Version end

    def description
      'a svelt cli time-tracker for ruby'
    end

    def dependencies
      {
        'main'    => [ 'main'    , ' >= 4.8.1' ] ,
        'map'     => [ 'map'     , ' >= 5.1.0' ] ,
        'chronic' => [ 'chronic' , ' >= 0.6.6' ]
      }
    end
  end
end
