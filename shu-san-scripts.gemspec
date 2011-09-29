# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "shu-san-scripts"
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Love"]
  s.date = "2011-09-29"
  s.description = "See the README file."
  s.email = "david@homeunix.org.uk"
  s.executables = ["store"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "lib/SANStore.rb",
    "lib/SANStore/cli.rb",
    "lib/SANStore/cli/base.rb",
    "lib/SANStore/cli/commands.rb",
    "lib/SANStore/cli/commands/delete_vol.rb",
    "lib/SANStore/cli/commands/help.rb",
    "lib/SANStore/cli/commands/list_vols.rb",
    "lib/SANStore/cli/commands/new_vol.rb",
    "lib/SANStore/cli/logger.rb",
    "lib/SANStore/cri.rb",
    "lib/SANStore/cri/base.rb",
    "lib/SANStore/cri/command.rb",
    "lib/SANStore/cri/core_ext.rb",
    "lib/SANStore/cri/core_ext/string.rb",
    "lib/SANStore/cri/option_parser.rb",
    "lib/SANStore/helpers/uuid.rb",
    "lib/SANStore/iSCSI/comstar.rb",
    "lib/SANStore/zfs/zfs.rb"
  ]
  s.homepage = "http://github.com/dlove24/shu-san-scripts"
  s.licenses = ["ISC"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Scripts used to set-up and manage iSCSI targets on OpenSolaris (ZFS) systems."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cri>, ["~> 2.0.2"])
      s.add_runtime_dependency(%q<facets>, [">= 2.4"])
      s.add_runtime_dependency(%q<uuidtools>, ["~> 2.1.2"])
      s.add_runtime_dependency(%q<ansi>, [">= 1.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<vclog>, ["~> 1.8.1"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<riot>, [">= 0"])
    else
      s.add_dependency(%q<cri>, ["~> 2.0.2"])
      s.add_dependency(%q<facets>, [">= 2.4"])
      s.add_dependency(%q<uuidtools>, ["~> 2.1.2"])
      s.add_dependency(%q<ansi>, [">= 1.2"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<vclog>, ["~> 1.8.1"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<riot>, [">= 0"])
    end
  else
    s.add_dependency(%q<cri>, ["~> 2.0.2"])
    s.add_dependency(%q<facets>, [">= 2.4"])
    s.add_dependency(%q<uuidtools>, ["~> 2.1.2"])
    s.add_dependency(%q<ansi>, [">= 1.2"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<vclog>, ["~> 1.8.1"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<riot>, [">= 0"])
  end
end

