require 'rails_helper'

RSpec.describe SendCsszRequestJob, type: :job do

  describe "#perform_later" do
    it "queues a cssz request" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SendCsszRequestJob.perform_later(1, {})
      }.to have_enqueued_job
    end
  end

end
