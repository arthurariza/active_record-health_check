# ActiveRecord::HealthCheck

Validate an ActiveRecord model **and all its associations** in one call. ActiveRecord::HealthCheck walks your object graph recursively and returns a list of every validation error it finds -- even errors buried deep in nested associations.

This is useful for catching invalid records that might otherwise go unnoticed. For example, a `User` might be valid, but one of their `Post`s could have a blank title, or a `Tag` on that post could be missing its name. `health_check` will find all of those problems at once.

## Installation

Add the gem to your Gemfile:

```ruby
gem "active_record-health_check"
```

Then run:

```bash
bundle install
```

## Usage

### Rails (automatic setup)

In a Rails application, **no configuration is needed**. The gem includes a Railtie that automatically adds a `health_check` method to every ActiveRecord model.

```ruby
user = User.find(1)
user.health_check
# => []
# An empty array means everything is valid!
```

If there are validation errors, you get back an array of hashes describing each problem:

```ruby
user.health_check
# => [{ class: "Post", id: 12, error_messages: "Title can't be blank" }]
```

### Skipping associations

Sometimes you want to skip certain associations. Pass them with the `skips:` parameter:

```ruby
user.health_check(skips: [:posts])
```

This will check the user and all their associations **except** `posts`. You can pass symbols or strings:

```ruby
user.health_check(skips: ["posts", "profile"])
```

## What it checks

ActiveRecord::HealthCheck traverses all of a model's associations. Supported association types:

- `has_many`
- `has_one`
- `belongs_to`
- `has_and_belongs_to_many`
- `has_many :through`
- `has_one :through`
- Polymorphic associations (`has_many :comments, as: :commentable`)

## Return value

`health_check` returns an **array of hashes**. Each hash represents one invalid record and has three keys:

| Key               | Type    | Description                                          |
| ----------------- | ------- | ---------------------------------------------------- |
| `:class`          | String  | The class name of the invalid record (e.g. `"Post"`) |
| `:id`             | Integer | The database ID of the invalid record                |
| `:error_messages` | String  | A human-readable sentence of all validation errors   |

When everything is valid, you get an empty array (`[]`).

Here is an example with multiple errors:

```ruby
user.health_check
# => [
#   { class: "Post", id: 3, error_messages: "Title can't be blank" },
#   { class: "Tag", id: 7, error_messages: "Name can't be blank" },
#   { class: "Profile", id: 1, error_messages: "Bio can't be blank" }
# ]
```

## Requirements

- Ruby >= 3.2.0
- Rails >= 6.0

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
