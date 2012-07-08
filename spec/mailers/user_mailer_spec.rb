require "spec_helper"

describe UserMailer do
  describe "invite_to_team" do
    let(:mail) { UserMailer.invite_to_team }

    it "renders the headers" do
      mail.subject.should eq("Invite to team")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
