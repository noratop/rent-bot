defmodule TestQuantum.Kijiji do
    def test_q do
        IO.puts('HELLO #{Timex.now}')
        File.write("tmp/app_time.txt", "From the App #{Timex.now} \n", [:append])
    end
end
