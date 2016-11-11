class MessengerController < Messenger::MessengerController
  def webhook
    fb_params.entries.each do |entry|
      entry.messagings.each do |messaging|
        if messaging.callback.message?
          first_name = Messenger::Client.get_user_profile(messaging.sender_id)["first_name"]

          Messenger::Client.send(
            Messenger::Request.new(
              Messenger::Elements::Text.new(text: "Hey #{first_name}, you said: #{messaging.callback.text}"),
              messaging.sender_id
            )
          )
        end
      end
    end

    render nothing: true, status: 200
  end




end
