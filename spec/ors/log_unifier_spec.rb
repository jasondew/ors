require "spec_helper"

module ORS
  describe LogUnifier do

    context "#unify" do

      it "should return the logs if there is only one server" do
        unifier = LogUnifier.new [["server", %(log line 1\nlog line 2\netc)]]
        unifier.unify.should == %([server] log line 1\n[server] log line 2\n[server] etc)
      end

      it "should intertwine log entires by date if there are multiple servers" do
        server_1_logs = <<-END
Started GET "/" for 10.203.228.96 at 2011-02-02 08:48:33 -0500
  Processing by ReviewsController#index as HTML
Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


Started GET "/" for 10.203.228.96 at 2011-02-02 08:58:33 -0500
  Processing by ReviewsController#index as HTML
Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)
        END

        server_2_logs = <<-END
Started GET "/" for 10.203.228.96 at 2011-02-02 08:49:33 -0500
  Processing by ReviewsController#index as HTML
Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


Started GET "/" for 10.203.228.96 at 2011-02-02 08:52:33 -0500
  Processing by ReviewsController#index as HTML
Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


Started GET "/" for 10.203.228.96 at 2011-02-03 05:00:33 -0500
  Processing by ReviewsController#index as HTML
Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)
        END

        answer = <<-END
[server1] Started GET "/" for 10.203.228.96 at 2011-02-02 08:48:33 -0500
[server1]   Processing by ReviewsController#index as HTML
[server1] Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


[server2] Started GET "/" for 10.203.228.96 at 2011-02-02 08:49:33 -0500
[server2]   Processing by ReviewsController#index as HTML
[server2] Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


[server2] Started GET "/" for 10.203.228.96 at 2011-02-02 08:52:33 -0500
[server2]   Processing by ReviewsController#index as HTML
[server2] Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


[server1] Started GET "/" for 10.203.228.96 at 2011-02-02 08:58:33 -0500
[server1]   Processing by ReviewsController#index as HTML
[server1] Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)


[server2] Started GET "/" for 10.203.228.96 at 2011-02-03 05:00:33 -0500
[server2]   Processing by ReviewsController#index as HTML
[server2] Completed 200 OK in 41ms (Views: 3.6ms | ActiveRecord: 31.6ms)
        END

        unifier = LogUnifier.new([["server1", server_1_logs], ["server2", server_2_logs]])
        unifier.unify.should == answer.chomp
      end

    end

  end
end
