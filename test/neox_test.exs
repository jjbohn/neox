defmodule NeoxTest do
  import Neox.Query
  use ExUnit.Case

  test "the truth" do
    create(john: %User{name: "john"})
    |> flush

    # filter = [john: %User{name: "john"}]
    # match(filter)

    filter = %User{name: "john"}
    match(john: filter)

    john = match(john: %User{name: "john"})
           |> return(:john)

    match(john: %User{name: "john"})
    |> delete(:john)

    # assert john == %User{name: "john"}

    # create(%{john: %User{name: "john"}})
    # |> create(%{marie: %User{name: "marie"}})
    # |> return(:john)

    # create(%{marie: %{User{name: "John"}}})
    # |> return(:marie)

    # match({john: %{User{name: "John"}}, marie: %{User{name: "Marie"}}})
    # |> create_unique(:john, -%{Married}->, :marie)

    # match({me: %{User}})
    # |> return
  end
end
