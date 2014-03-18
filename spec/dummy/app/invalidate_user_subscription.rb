class InvalidateUserSubscription < Hare::Subscription
  subscribe queue: "agrian.invalidate_user" do |data|
    raise "CRAP"
    User.where(auth_token: data[:auth_token]).first.destroy
  end
end
