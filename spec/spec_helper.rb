# frozen_string_literal: true

require "model_health_check"
require "active_record"
require "sqlite3"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.timestamps
  end

  create_table :posts, force: true do |t|
    t.belongs_to :user
    t.string :title
    t.timestamps
  end

  create_table :profiles, force: true do |t|
    t.belongs_to :user
    t.string :bio
    t.timestamps
  end

  create_table :tags, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :posts_tags, id: false, force: true do |t|
    t.belongs_to :post
    t.belongs_to :tag
  end

  create_table :addresses, force: true do |t|
    t.belongs_to :profile
    t.string :city
    t.string :country
    t.timestamps
  end
end

class User < ActiveRecord::Base
  has_many :posts
  has_one :profile
  has_many :tags, through: :posts
  has_one :address, through: :profile

  validates :name, :email, presence: true
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :title, presence: true
end

class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :address

  validates :bio, presence: true
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts

  validates :name, presence: true
end

class Address < ActiveRecord::Base
  belongs_to :profile

  validates :city, :country, presence: true
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run

      raise ActiveRecord::Rollback
    end
  end
end
