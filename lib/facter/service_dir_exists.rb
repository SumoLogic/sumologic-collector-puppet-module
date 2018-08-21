Facter.add(:sources_dir_exists) do
  confine :kernel => :linux
  setcode do
    File.directory? '/usr/local/sumo' && !Dir.glob('/usr/local/sumo/*.json').empty?
  end
end
