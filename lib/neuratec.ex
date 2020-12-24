defmodule Neuratec do
  @moduledoc """
  Documentation for `Neuratec`.
  """

  @commands %{
    "help" => "Prints this help",
    "tk"   => "Prints the tokens of the program",
    "tree" => "Prints the Ast - Tree",
    "pasm" => "Print the asm code",
    "deb"  => "print all outs of the process"
  }
   def main(args) do
    args
    |> parse_args
    |> process_args
  end

  def parse_args(args) do
    OptionParser.parse(args, switches:
    [help: :boolean,
     tk: :boolean,
     tree: :boolean,
     pasm: :boolean,
     deb: :boolean]
     )
  end

  defp process_args({[help: true], _, _}) do
    print_help_message()
  end

  defp process_args({[deb: true], [file_name], _}) do
    deb_file(file_name)
  end

  defp process_args({[tk: true],[file_name], _}) do
    print_tokens(file_name)
  end

  defp process_args({[tree: true],[file_name], _}) do
    print_ast_tree(file_name)
  end

  defp process_args({[pasm: true],[file_name], _}) do
    print_asm_code(file_name)
  end

  defp process_args({_, [file_name], _}) do
    compile_file(file_name)
  end

  defp compile_file(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly_path = String.replace_trailing(file_path, ".c", ".s")

    File.read!(file_path)
    |> Sanitizer.sanitize_source()
    #|> IO.inspect(label: "\nSalida sanitizante")
    |> Lexer.scan_words()
    #|> IO.inspect(label: "\nSalida lexer")
    |> Parser.parse_program()
    #|> IO.inspect(label: "\nSalida parser")
    |> CodeGeneratorDiscrete.generate_code()
    |> Linker.generate_binary(assembly_path)
    IO.puts("end :D")
  end

  defp deb_file(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly_path = String.replace_trailing(file_path, ".c", ".s")

    File.read!(file_path)
    |> Sanitizer.sanitize_source()
    |> IO.inspect(label: "\nSalida sanitizante")
    |> Lexer.scan_words()
    |> IO.inspect(label: "\nSalida lexer")
    |> Parser.parse_program()
    |> IO.inspect(label: "\nSalida parser")
    |> CodeGenerator.generate_code()
    |> Linker.generate_binary(assembly_path)
    |> IO.inspect(label: "\nSalida linker")
    IO.puts("end :D")
  end

  defp print_tokens(file_path) do
    IO.puts("Compiling file: " <> file_path)
    File.read!(file_path)
    |> Sanitizer.sanitize_source()
    |> Lexer.scan_words()
    |> IO.inspect(label: "\nTokens List:")
    IO.puts("end :D")
  end

  defp print_ast_tree(file_path) do
    IO.puts("Compiling file: " <> file_path)
    File.read!(file_path)
    |> Sanitizer.sanitize_source()
    |> Lexer.scan_words()
    |> Parser.parse_program()
    |> IO.inspect(label: "\nArbol:")
    IO.puts("end :D")
  end

  defp print_asm_code(file_path) do
    IO.puts("Compiling file: " <> file_path)
    File.read!(file_path)
    |> Sanitizer.sanitize_source()
    |> Lexer.scan_words()
    |> Parser.parse_program()
    |> CodeGenerator.generate_code()
    IO.puts("end :D")

  end

  defp print_help_message do
    IO.puts("\n./neuratec --'command' file_name \n")

    IO.puts("\nThe compiler supports following options:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)
  end



end
