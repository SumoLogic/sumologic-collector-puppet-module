Facter.add(:sources_file_exists) do
  confine :kernel => :linux
  setcode do
   if File.exist? '/usr/local/sumo/sources.json'
     result = true
   else
     result = false
   end
  end
end
