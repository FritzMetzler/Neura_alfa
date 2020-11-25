defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  setup_all do
    {:ok,
     tokens:  [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 2},
       :semicolon,
       :close_brace
     ],

     tokens_0: [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 0},
      :semicolon,
      :close_brace
    ],
    tokens_100: [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 100},
      :semicolon,
      :close_brace
      ],
    invtokens_paren:
          [
            :int_keyword,
            :main_keyword,
            :open_paren,
            :open_brace,
            :return_keyword,
            {:constant, 0},
            :semicolon,
            :close_brace
          ],
    invtokens_m_retval:
       [
        :int_keyword,
        :main_keyword,
        :open_paren,
        :close_paren,
        :open_brace,
        :return_keyword,
        :semicolon,
        :close_brace
       ],
    invtokens_m_brace:  [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,

       ],
    invtokens_m_semicolon: [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 0},
      :close_brace
           ],
    invtokens_m_space:
      [
        :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :identifier,
       :close_brace
       ],

    invtoken_upcase:
           [
            :int_keyword,
            :main_keyword,
            :open_paren,
            :close_paren,
            :open_brace,
            :identifier,
            {:constant, 0},
            :close_brace
           ],
    tokens_se: [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,
      :close_brace
    ],

    tokens_nl: [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      {:constant, 2},
      :semicolon,
      :close_brace
    ]

    }

  end

  # tests to pass
  test "return 2", state do
    code = """
      int main() {
        return 2;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "return 0", state do
    code = """
      int main() {
        return 0;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 6, fn _ -> {:constant, 0} end)
    assert Lexer.scan_words(s_code) == expected_result
  end

  test "multi_digit", state do
    code = """
      int main() {
        return 100;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 6, fn _ -> {:constant, 100} end)
    assert Lexer.scan_words(s_code) == expected_result
  end

  test "new_lines", state do
    code = """
    int
    main
    (
    )
    {
    return
    2
    ;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "no_newlines", state do
    code = """
    int main(){return 2;}
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "spaces", state do
    code = """
    int   main    (  )  {   return  2 ; }
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "elements separated just by spaces", state do
    assert Lexer.scan_words(["int", "main(){return", "2;}"]) == state[:tokens]
  end

  test "function name separated of function body", state do
    assert Lexer.scan_words(["int", "main()", "{return", "2;}"]) == state[:tokens]
  end

  test "everything is separated", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "2", ";", "}"]) ==
             state[:tokens]
  end


  test "nueva funcionalidad", state do

    assert 3==3
  end


  # tests to fail
  test "wrong case", state do
    code = """
    int main() {
      RETURN 2;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 5, fn _ -> :error end)
    assert Lexer.scan_words(s_code) == expected_result
  end


  ########### - INTENTO - ######################
  # Realiza un intento en el que se utilizan tabuladores
  test "tab_mechanics", state do
    code = """
    int main ( )
    {
        return      2
            ;     }
    """

    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) == state[:tokens]
  end


  #######################################################

  ########### - INTENTO A FALLAR - ######################
  # Existe un ":" en lugar de un ";"
  test "missclick_point", state do
    code = """
    int main() {
      return 2:
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 2, fn _ -> :error end)
    assert Lexer.scan_words(s_code) == expected_result
  end


  # Error de falta de una "i" en la palabra declarada
  test "Funcion retorna int pero boolean fue detectado", state do
    code = """
    int main ( )
    {return 2.0;}
    """

    s_code = Sanitizer.sanitize_source(code)
    expected_result = List.update_at(state[:tokens], 6, fn _ -> {:constant, 0} end)
    assert Lexer.scan_words(s_code) == expected_result  end

  # Realiza un intento en el que se utilizan tabuladores
  test "error_nt", state do
    code = """
    nt main ( )
    {
        return      2
            ;     }
    """

    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) == state[:tokens]
  end
  #########################################################33





end
