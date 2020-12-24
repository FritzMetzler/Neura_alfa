defmodule Lexer do
  def scan_words(words) do
    Enum.flat_map(words, &lex_raw_tokens/1)
  end

  def get_constant(program) do
    case Regex.run(~r/^\d+/, program) do
      [value] ->
        {{:constant, String.to_integer(value)}, String.trim_leading(program, value)}

      program ->
        {:error, "Token not valid: #{program}"}
    end
  end

  @spec lex_raw_tokens(any) :: [
          :close_brace
          | :close_paren
          | :error
          | :int_keyword
          | :main_keyword
          | :open_brace
          | :open_paren
          | :return_keyword
          | :semicolon
          | :adding
          | :sustraction
          | {:constant, integer}
        ]
  def lex_raw_tokens(program) when program != "" do
    {token, rest} =
      case program do
        "{" <> rest ->
          {:open_brace, rest}

        "}" <> rest ->
          {:close_brace, rest}

        "(" <> rest ->
          {:open_paren, rest}

        ")" <> rest ->
          {:close_paren, rest}

        ";" <> rest ->
          {:semicolon, rest}

        #"+" <> rest ->
        #  {:adding, rest}

        #"-" <> rest ->
        #  {:sustract, rest}

        #"*" <> rest ->
        #  {:multi, rest}

        "return" <> rest ->
          if "return"<>rest == "return" do
            {:return_keyword, rest}
          else
            {:error, "misspeled in 'return'"}

          end
        "int" <> rest ->
          {:int_keyword, rest}

        "main" <> rest ->
          {:main_keyword, rest}

        rest ->
          get_constant(rest)
      end

    if token != :error do
      remaining_tokens = lex_raw_tokens(rest)
      [token | remaining_tokens]
    else
      [:error]
    end
  end

  def lex_raw_tokens(_program) do
    []
  end
end
