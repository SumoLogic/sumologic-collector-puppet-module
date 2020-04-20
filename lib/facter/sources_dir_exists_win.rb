Facter.add(:sources_dir_exists_win) do
  confine :kernel => :windows
  setcode do
    if File.directory? 'C:\\sumo'
      if (!Dir.glob('C:\\sumo\\*.json').empty?)
        true
      else
        false
      end
    else
      false
    end
  end
end
