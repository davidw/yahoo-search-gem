# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{yahoo-search}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Hodel"]
  s.cert_chain = nil
  s.date = %q{2006-11-27}
  s.description = %q{An interface to Yahoo's Search services.}
  s.email = %q{drbrain@segment7.net}
  s.files = ["History.txt", "LICENSE.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/yahoo/local_search.rb", "lib/yahoo/search.rb", "lib/yahoo/web_search.rb", "test/test_local_search.rb", "test/test_web_search.rb"]
  s.homepage = %q{http://dev.robotcoop.com/Libraries/yahoo-search}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{rctools}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A Ruby Yahoo Search API Implementation}
  s.test_files = ["test/test_local_search.rb", "test/test_web_search.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hoe>, [">= 1.1.4"])
      s.add_runtime_dependency(%q<yahoo>, [">= 1.1.1"])
    else
      s.add_dependency(%q<hoe>, [">= 1.1.4"])
      s.add_dependency(%q<yahoo>, [">= 1.1.1"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.1.4"])
    s.add_dependency(%q<yahoo>, [">= 1.1.1"])
  end
end

