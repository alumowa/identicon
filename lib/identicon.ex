defmodule Identicon do

  def generate(input) do

    input
      |> hash_input
      |> pick_color
      |> build_grid
      |> filter_odd_squares
  end

  defp hash_input(input) do

    hex = :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  defp pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do

    %Identicon.Image{image | color: {r, g, b}}
  end

  defp build_grid(%Identicon.Image{hex: hex} = image) do

    grid = hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  defp mirror_row(row) do

    [first, second, _tail] = row
    row ++ [second, first]
  end

  defp filter_odd_squares(%Identicon.Image{grid: grid} = image) do

    grid = Enum.filter grid, fn({value, _index}) ->

      rem(value, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

end
