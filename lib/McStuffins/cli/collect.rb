module McStuffins
  module CLI
    class Collect < Thor
      desc 'github', 'Gather GitHub data from specified repos or all repos'
      option :repos

      def github
        puts "Looks like you are looking for the following repos #{options[:repos]}"
      end
    end

  end
end