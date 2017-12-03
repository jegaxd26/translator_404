# Translator404

Tested on :
Erlang/OTP 20 [erts-9.1]
Elixir 1.5.2

Cli testing performed with https://github.com/websockets/wscat

Usage :
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

The socket will be accessible via ws://localhost:4000/socket/websocket

Connect to socket :  
`{"topic":"translator","event":"phx_join","payload":{},"ref":"1"}`  
Communicate with socket :  
`{"topic":"translator","event":"message","payload":{"message":"кот"},"ref":"2"}`  
