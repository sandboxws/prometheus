import Prometheus.SMS

defmodule Dev.Hussaini do
  def test do
    new_sms |> to("+971505692149") |> from("Souq.com") |> message("عدم هو مرجع ترتيب ضمنها, شيء كل عملية السيء") |> Foobar.Messenger.deliver_now
  end
end
