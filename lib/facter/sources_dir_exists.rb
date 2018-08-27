Facter.add(:sources_dir_exists) do
  confine :kernel => :linux
  setcode do
    if File.directory? '/usr/local/sumo'
      if !(Dir.glob('/usr/local/sumo/*.json').empty?)
        result = true
      else
        result = false
      end
    else
      result = false
    end
  end
end
