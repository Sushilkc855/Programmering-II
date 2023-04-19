defmodule Adventofcode do
  def test do
    file_path = "lib/data.txt"
    data = parsefile(file_path)
    dosum(data, [], 0)
  end


  def parsefile(file_path) do
    case File.read(file_path) do
      {:ok, contents} -> String.split(contents, ["\r\n"])

      {:error, reason} ->
        IO.puts "Error reading file: #{reason}"
    end
  end

  def dosum([], biggest, temp) do
    Enum.reduce(biggest,0, &+/2)
  end
  def dosum([elem | list], biggest, temp)do
    if (elem=="") do
      if (length(biggest) < 3) do
        biggest = [temp|biggest]
        temp = 0;
        dosum(list, biggest, temp)
      else
        biggest = checkbiggest(biggest, [], temp)
        temp = 0;
        dosum(list, biggest, temp)
      end
    else
      element = String.to_integer(elem)
      temp = temp + element
      dosum(list, biggest, temp)
    end
  end

  def checkbiggest([], newlist, _) do
    newlist
  end
  def checkbiggest([el|biggest], newlist, temp) do
    if (el < temp) do
      newlist= [temp|newlist]
      temp = el
      checkbiggest(biggest,newlist, temp)
    else
      newlist = [el|newlist]
      checkbiggest(biggest, newlist, temp)
    end
  end

end
