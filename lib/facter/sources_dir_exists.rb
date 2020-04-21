Facter.add(:sources_dir_exists) do
  confine :kernel => :linux
  setcode do
    if File.directory? '/usr/local/sumo'
      if !(Dir.glob('/usr/local/sumo/*.json').empty?)
        true
      else
        false
      end
    else
      false
    end
  end
end
