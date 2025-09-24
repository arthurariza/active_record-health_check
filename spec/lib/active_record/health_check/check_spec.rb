# frozen_string_literal: true

require "./lib/active_record/health_check/check"

RSpec.describe ActiveRecord::HealthCheck::Check do
  describe "#call" do
    let(:user) { User.create!(name: "User One", email: "user_one@gmail.com") }
    let(:post) { Post.create!(title: "Title", user: user) }
    let(:profile) { Profile.create!(bio: "Bio", user: user) }
    let(:ruby_tag) { Tag.create!(name: "Ruby") }
    let(:rails_tag) { Tag.create!(name: "Rails") }
    let(:address) { Address.create!(city: "Tokyo", country: "Japan", profile: profile) }
    let(:profile_comment) { Comment.create!(comment: "Comment", commentable: profile) }
    let(:post_comment) { Comment.create!(comment: "Comment", commentable: post) }

    context "when original model is invalid" do
      it "returns an array of hashes with the original model errors" do
        user.update_columns(name: nil, email: nil)

        expect(described_class.new(user).check).to eq(
          [{ class: "User", id: user.id, error_messages: "Name can't be blank and Email can't be blank" }]
        )
      end
    end

    context "when has_many association is invalid" do
      it "returns an array of hashes with the has_many association errors" do
        post.update_columns(title: nil)

        expect(described_class.new(user).check).to eq(
          [{ class: "Post", id: post.id, error_messages: "Title can't be blank" }]
        )
      end
    end

    context "when has_one association is invalid" do
      it "returns an array of hashes with the has_one association errors" do
        profile.update_columns(bio: nil)

        expect(described_class.new(user).check).to eq(
          [{ class: "Profile", id: profile.id, error_messages: "Bio can't be blank" }]
        )
      end
    end

    context "when has_and_belongs_to_many association is invalid" do
      it "returns an array of hashes with the has_and_belongs_to_many association errors" do
        post.tags << rails_tag
        post.tags << ruby_tag

        rails_tag.update_columns(name: nil)
        ruby_tag.update_columns(name: nil)

        expect(described_class.new(user).check).to eq(
          [{ class: "Tag", id: rails_tag.id, error_messages: "Name can't be blank" },
           { class: "Tag", id: ruby_tag.id, error_messages: "Name can't be blank" }]
        )
      end
    end

    context "when has_one trough association is invalid" do
      it "returns an array of hashes with the has_one association errors" do
        address.update_columns(country: nil)

        expect(described_class.new(user).check).to eq(
          [{ class: "Address", id: address.id, error_messages: "Country can't be blank" }]
        )
      end
    end

    context "when has_many association trough is invalid" do
      it "returns an array of hashes with the has_many association errors" do
        post.tags << rails_tag
        post.tags << ruby_tag

        rails_tag.update_columns(name: nil)
        ruby_tag.update_columns(name: nil)

        expect(described_class.new(user).check).to eq(
          [{ class: "Tag", id: rails_tag.id, error_messages: "Name can't be blank" },
           { class: "Tag", id: ruby_tag.id, error_messages: "Name can't be blank" }]
        )
      end
    end

    context "when belongs_to association is invalid" do
      it "returns an array of hashes with the belongs_to association errors" do
        post.user.update_columns(email: nil)

        expect(described_class.new(post).check).to eq(
          [{ class: "User", id: user.id,
             error_messages: "Email can't be blank" }]
        )
      end
    end

    context "when polymorphic has_one association is invalid" do
      it "returns an array of hashes with the has_one association errors" do
        profile_comment.update_columns(comment: nil)

        expect(described_class.new(profile).check).to eq(
          [{ class: "Comment", id: profile_comment.id, error_messages: "Comment can't be blank" }]
        )
      end
    end

    context "when polymorphic has_many association is invalid" do
      it "returns an array of hashes with the has_many association errors" do
        post_comment.update_columns(comment: nil)

        expect(described_class.new(post).check).to eq(
          [{ class: "Comment", id: post_comment.id, error_messages: "Comment can't be blank" }]
        )
      end
    end

    context "when skips is specified" do
      it "returns an array of hashes without the skipped associations" do
        profile.update_columns(bio: nil)
        post.update_columns(title: nil)

        expect(described_class.new(user, skips: [:profile]).check).to eq(
          [{ class: "Post", error_messages: "Title can't be blank", id: post.id }]
        )
      end

      it "works with an array strings or symbols" do
        profile.update_columns(bio: nil)
        post.update_columns(title: nil)

        expect(described_class.new(user, skips: [:profile]).check).to eq(
          [{ class: "Post", error_messages: "Title can't be blank", id: post.id }]
        )

        expect(described_class.new(user, skips: ["profile"]).check).to eq(
          [{ class: "Post", error_messages: "Title can't be blank", id: post.id }]
        )
      end
    end
  end
end
