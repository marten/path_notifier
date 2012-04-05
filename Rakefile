require 'bundler/setup'
Bundler.require(:default)

require_relative "lib/path_notifier"

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("path_notifier_dev")
end

desc "Create mongodb indexes"
task "create_indexes" do
  PathNotifier::Models.constants.each do |model_sym|
    model = PathNotifier::Models.const_get(model_sym)
    begin
      model.create_indexes
      puts "Created indexes for #{model_sym}"
    rescue NoMethodError => e
      puts "Skipping #{model_sym} because it does not appear to be a Mongoid document"
    end
  end
end
