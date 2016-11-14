class MessengerController < Messenger::MessengerController
  def webhook
    fb_params.entries.each do |entry|
      entry.messagings.each do |messaging|
        if messaging.callback.message?
          first_name = Messenger::Client.get_user_profile(messaging.sender_id)["first_name"]
          puts("Message from Facebook:  #{messaging.callback.text}")

          wit_client(messaging.sender_id).run_actions(messaging.sender_id, messaging.callback.text, {})
        end
      end
    end
    
  ensure
    # catch all so facebook doesn't stop sending us messages...
    render nothing: true, status: 200
  end

  
private
  
  def wit_client(session_id)
    Wit.new(access_token: ENV['WIT_ACCESS_TOKEN'], actions: wit_actions(session_id))
  end

  def wit_actions(session_id)
    {
      send: -> (request, response) {
        puts("Sending to facebook:  #{response['text']}")
        
        Messenger::Client.send(
          Messenger::Request.new(
            Messenger::Elements::Text.new(text: "#{response['text']}"),
            session_id
          )
        )
      },
      batteryReplacementLookup: -> (request) {
        context = request["context"]
        puts 'Performing a battery lookup'
        year = request["entities"]["year"].first["value"]
        make = request["entities"]["make"].first["value"]
        model = request["entities"]["model"].first["value"]
        
        context["make"] = make
        context["year"] = year
        context["model"] = model

        return request['context']
      },
      batteryReplacementLink: -> (request) {
        puts("batteryReplacementLink: web_url button being sent...")

        buttons = Messenger::Templates::Buttons.new(
          text: 'Some Cool Text',
          buttons: [
            Messenger::Elements::Button.new(
              type: 'web_url',
              title: 'Book roadside request',
              value: 'https://forms.ama.ab.ca/automotive/roadside-assistance-online'
            )
          ]
        )

        Messenger::Client.send(
          Messenger::Request.new(buttons, session_id)
        )
        
        
        return request['context']
      },
    }
  end


end
