module TT
  def TT.version
    '1.4.2'
  end

  def TT.description
    'TT'
  end

  def TT.dependencies
    {
      'main'    => [ 'main'    , '~> 6.2.2' ] ,
      'map'     => [ 'map'     , '~> 6.6.0' ] ,
      'chronic' => [ 'chronic' , '~> 0.10.2' ]
    }
  end

  def TT.stdlibs
    [
      'yaml',
      'yaml/store',
      'time',
      'date',
      'pathname',
      'tempfile',
      'fileutils',
      'enumerator'
    ]
  end

  def TT.libs
    []
  end

  def TT.libdir(*args, &block)
    @libdir ||= (
      path = File.expand_path(__FILE__)
      dirname = File.dirname(path)
      basename = File.basename(path)

      basename.sub!(/^_/,'')
      basename.sub!(/\.rb$/,'')

      File.join(dirname, basename)
    )
    args.empty? ? @libdir : File.join(@libdir, *args)
  ensure
    if block
      begin
        $LOAD_PATH.unshift(@libdir)
        block.call()
      ensure
        $LOAD_PATH.shift()
      end
    end
  end

  def TT.load(*libs)
    libs = libs.join(' ').scan(/[^\s+]+/)
    TT.libdir{ libs.each{|lib| Kernel.load(lib) } }
  end

  def TT.require_all!
    TT.stdlibs.each do |lib|
      require(lib)
    end

    require 'rubygems'

    dependencies.each do |lib, dependency|
      gem(*dependency)
      require(lib)
    end

    libs.each do |lib|
      TT.libdir{ require(lib) }
    end
  end
end
