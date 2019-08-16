## tt.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "tt"
  spec.version = "1.4.2"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "tt"
  spec.description = "TT"
  spec.license = "Ruby"

  spec.files =
["Gemfile",
 "Gemfile.lock",
 "LICENSE",
 "README",
 "Rakefile",
 "bin",
 "bin/tt",
 "gemspec.gemspec",
 "lib",
 "lib/_tt.rb",
 "lib/tt",
 "lib/tt.rb",
 "lib/tt/_lib.rb"]

  spec.executables = ["tt"]
  
  spec.require_path = "lib"

  spec.test_files = nil

  
    spec.add_dependency(*["main", "~> 6.2.2"])
  
    spec.add_dependency(*["map", "~> 6.6.0"])
  
    spec.add_dependency(*["chronic", "~> 0.10.2"])
  

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "https://github.com/ahoward/tt"
end
