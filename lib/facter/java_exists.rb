Facter.add(:java_exists) do
  setcode do
    begin
       java_version = Facter::Core::Execution.execute('java -version 2>&1 | head -n 1 | cut -f2 -d \'"\'| cut -f1 -d \'.\'')
      if java_version.to_i == 10
        true
      else
        java_maj_version = Facter::Core::Execution.execute('java -version 2>&1 | head -n 1 | cut -f2 -d \'"\'| cut -c 3')
        if java_maj_version.to_i > 7
          true
        else
          false
        end
      end
    rescue Facter::Core::Execution::ExecutionFailure
      false
    end
 end
end