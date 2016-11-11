class WitController < ApplicationController
  def test_poc
    actions = {
      send: -> (request, response) {
        puts("sending... #{response['text']}")
      },
      batteryReplacementLookup: -> (request) {
        context = request["context"]
        puts 'performing a battery lookup'
        ap request
        year = request["entities"]["year"].first["value"]
        make = request["entities"]["make"].first["value"]
        model = request["entities"]["model"].first["value"]



        # context["make"] = make
        # context["year"] = year
        # context["model"] = model

        context['retry'] = "true"

        return request['context']
      },
    }
    session = 'ryanJ'
    client = Wit.new(access_token: ENV['WIT_ACCESS_TOKEN'], actions: actions)
    client.run_actions(session, 'I need to replace my battery plz', {})
    sleep 1
    client.run_actions(session, 'GMC Envoy 2007', {})


    render nothing: true, status: 200
  end
end
