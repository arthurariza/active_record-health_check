# frozen_string_literal: true

RSpec.describe ActiveRecord::HealthCheck::Concern do
  before do
    User.include(described_class) unless User.include?(described_class)
  end

  describe "#health_check" do
    let(:user) { User.create!(name: "User One", email: "user_one@gmail.com") }
    let(:post) { Post.create!(title: "Title", user: user) }
    let(:profile) { Profile.create!(bio: "Bio", user: user) }

    context "when model and associations are valid" do
      it "returns an empty array" do
        expect(user.health_check).to eq([])
      end
    end

    context "when an association is invalid" do
      it "returns errors for the invalid association" do
        post.update_columns(title: nil)

        expect(user.health_check).to eq(
          [{ class: "Post", id: post.id, error_messages: "Title can't be blank" }]
        )
      end
    end

    context "when skips is specified" do
      it "skips the specified associations" do
        profile.update_columns(bio: nil)
        post.update_columns(title: nil)

        expect(user.health_check(skips: [:profile])).to eq(
          [{ class: "Post", id: post.id, error_messages: "Title can't be blank" }]
        )
      end
    end
  end
end
