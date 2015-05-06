
module McStuffins
  class Doc < CLI::ExitingThor

    desc 'setup', 'Create the default .mcstuffins.yaml'
    long_desc <<-SETUP

    `setup` will create the default .mcstuffins.yaml file in the executing dir. The .mcstuffins.yaml file
    contains the your default data needed for McStuffins commands like GitHub repos and auth token.

    SETUP

    def setup
      prompt = '.mcstuffins already exists. Would you like to overwrite it? [y|n]'
      if (Config.exists? && yes?(prompt)) || !Config.exists?
        Config.write_default
      end
    end

    desc 'collect COMMANDS', 'Collect data from sources'
    subcommand 'collect', McStuffins::CLI::Collect

    desc 'status COMMANDS', 'Get status from services'
    subcommand 'status', McStuffins::CLI::Status

  end
end