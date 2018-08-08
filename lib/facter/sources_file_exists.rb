Facter.add(:sources_file_exists) do
  confine :kernel => :linux
  setcode do
    if File.exist? "/usr/local/sumo/sources.json"
      result = true
      result
    else
      result = false
      result
    end
  end
end
