defmodule Translator404.TranslatorChannelTest do
  use Translator404.ChannelCase

  alias Translator404.TranslatorChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{})
      |> subscribe_and_join(TranslatorChannel, "translator")
    {:ok, socket: socket}
  end

  test "message with length 280 must succeed" , %{socket: socket} do
    # this string is 280 characeters long
    message = "голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова голова "
    push(socket, "message", %{"message"=>message})
    assert_broadcast("message", %{}, 5000)
  end
  
  test "message with length > 280 must fail" , %{socket: socket} do
    # this string is 281 characters long
    message = "каждый охотник желает знать где сидит фазан без труда не выловишь и рыбку из пруда семь раз отмерь один отреж дым сигаерт с ментолом зачем ей все шелка цветные облака ну вы будете жрать или нет голубой вагон бежит качается на недельку до второго я уеду в комарово ну заяц погоди ре"
    ref = push(socket, "message", %{"message"=> message})
    assert_reply(ref, :error, %{}, 5000)
  end

  test "translated message id broadcasted to all listeners", %{socket: socket} do
    ref = push(socket, "message", %{"message" => "красный стол"})
    assert_broadcast("message",%{"eng_message" => "the red table"},5000)
  end

end
