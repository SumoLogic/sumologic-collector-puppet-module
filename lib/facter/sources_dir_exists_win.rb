Facter.add(:sources_dir_exists_win) do
  confine :kernel => :windows
  setcode do
    if File.directory? 'C:\\sumo'
      if (!Dir.glob('C:\\sumo\\*.json').empty?)
        result = true
      else
        result = false
      end
    else
      result = false
    end
  end
end
